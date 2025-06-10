output "vpc_id" {
  value = var.vpc_id != "" ? var.vpc_id : mgc_network_vpcs.swarm_vpc[0].id
}

output "sec_group_id" {
  value = mgc_network_security_groups.experiment_sec_group.id
}

output "pub_ip" {
  value = mgc_network_public_ips.pub_ip.public_ip
}

output "pub_ip_id" {
  value = mgc_network_public_ips.pub_ip.id
}
