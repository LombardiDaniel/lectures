provider "mgc" {
  region  = "br-se1"
  api_key = var.api_key
}

terraform {
  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "0.33.0"
    }
  }
}

resource "mgc_ssh_keys" "cluster_ssh_key" {
  name = "${var.project_name}-ssh-key"
  key  = var.ssh_pub_key
}

resource "mgc_network_security_groups" "sec_group" {
  name = "${var.project_name}-sec-group"
}

resource "mgc_network_security_groups_rules" "rules" {
  for_each          = { for idx, vm in var.tcp_ports : tostring(idx) => vm }
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_max    = each.value
  port_range_min    = each.value
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}

resource "mgc_network_public_ips" "pub_ip" {
  description = "${var.project_name}-pub_ip"
  vpc_id      = var.vpc_id
}

resource "mgc_virtual_machine_instances" "vm" {
  name         = "${var.project_name}-swarm-manager-${count.index}"
  machine_type = var.machine_type
  image        = "cloud-ubuntu-22.04 LTS"
  ssh_key_name = mgc_ssh_keys.cluster_ssh_key.name
}

resource "mgc_network_security_groups_attach" "ssh_security_group_attach" {
  for_each          = { for idx, vm in concat(mgc_virtual_machine_instances.manager_nodes_vms, mgc_virtual_machine_instances.worker_nodes_vms) : tostring(idx) => vm }
  interface_id      = each.value.network_interfaces[0].id
  security_group_id = module.network.ssh_sec_group_id
}

resource "mgc_network_public_ips_attach" "pub_ip_attachs" {
  public_ip_id = mgc_network_public_ips.pub_ip.id
  interface_id = mgc_virtual_machine_instances.vm.network_interfaces[0].id
}
