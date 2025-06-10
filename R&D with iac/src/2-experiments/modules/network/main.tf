terraform {
  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "0.33.0"
    }
  }
}

resource "mgc_network_vpcs" "swarm_vpc" {
  count = var.vpc_id == "" ? 1 : 0
  name  = "${var.experiment_name}-vpc"
}

resource "mgc_network_public_ips" "pub_ip" {
  description = "${var.experiment_name}-pub_ip"
  vpc_id      = var.vpc_id
}

resource "mgc_network_security_groups" "experiment_sec_group" {
  name = "${var.experiment_name}-sec-group"
}

resource "mgc_network_security_groups_rules" "allow_tcp" {
  for_each          = toset([for port in var.allowed_tcp_ports : tostring(port)])
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_max    = each.key
  port_range_min    = each.key
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.experiment_sec_group.id
}

resource "mgc_network_security_groups_rules" "allow_udp" {
  for_each          = toset([for port in var.allowed_udp_ports : tostring(port)])
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_max    = each.key
  port_range_min    = each.key
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.experiment_sec_group.id
}
