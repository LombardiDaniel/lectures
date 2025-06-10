output "ssh" {
  value = "ssh ubuntu@${mgc_network_public_ips.pub_ip.public_ip}"
}

