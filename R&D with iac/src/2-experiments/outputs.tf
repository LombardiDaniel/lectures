output "vm_ip" {
  value = module.network.pub_ip
}

output "ssh" {
  value = "ssh ubuntu@${module.network.pub_ip}"
}
