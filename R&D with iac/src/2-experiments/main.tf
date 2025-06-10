terraform {
  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "0.33.0"
    }
  }
}

module "network" {
  source = "./modules/network"

  experiment_name   = var.experiment_name
  api_key           = var.api_key
  vpc_id            = var.vpc_id
  allowed_tcp_ports = var.tcp_ports
  allowed_udp_ports = var.udp_ports
}

resource "mgc_ssh_keys" "cluster_ssh_key" {
  name = "${var.experiment_name}-ssh-key"
  key  = file(var.ssh_pub_key_path)
}

resource "mgc_virtual_machine_instances" "vm" {
  name         = "${var.experiment_name}-vm"
  machine_type = var.machine_type
  image        = "cloud-ubuntu-22.04 LTS"
  ssh_key_name = mgc_ssh_keys.cluster_ssh_key.name
}

resource "mgc_network_security_groups_attach" "security_group_attach" {
  interface_id      = mgc_virtual_machine_instances.vm.network_interfaces[0].id
  security_group_id = module.network.sec_group_id
}

resource "mgc_network_public_ips_attach" "pub_ip_attachs" {
  interface_id = mgc_virtual_machine_instances.vm.network_interfaces[0].id
  public_ip_id = module.network.pub_ip_id
}

resource "mgc_block_storage_volumes" "block_volume" {
  name = "${var.experiment_name}-volume"
  size = var.block_storage_size
  type = var.block_storage_type
}

resource "mgc_block_storage_volume_attachment" "attach_block_volume" {
  block_storage_id   = mgc_block_storage_volumes.block_volume.id
  virtual_machine_id = mgc_virtual_machine_instances.vm.id
}

resource "null_resource" "block_storage_configuration" {
  depends_on = [mgc_block_storage_volume_attachment.attach_block_volume, mgc_network_security_groups_attach.security_group_attach, mgc_network_public_ips_attach.pub_ip_attachs]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_priv_key_path)
    host        = module.network.pub_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 -F /dev/vdb",
      "sudo mkdir /mnt/block_disk",
      "sudo mount /dev/vdb /mnt/block_disk",
      "sudo chmod 777 /mnt/block_disk"
    ]
  }
}

resource "null_resource" "vm_configuration" {
  depends_on = [null_resource.block_storage_configuration]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_priv_key_path)
    host        = module.network.pub_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install bpytop -y",
      "curl -fsSL https://get.docker.com | bash",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${file("./docker/docker-compose.yml")}' > docker-compose.yml",
      "echo '${file("./docker/clickhouse.xml")}' > clickhouse.xml",
      "echo '${file("./docker/.env")}' > .env",
      "sed -i 's/BUCKET_NAME_SED_FLAG/${aws_s3_bucket.clickhouse_spec_tests.bucket}/g' docker-compose.yml",
      "docker compose up -d"
    ]
  }
}
