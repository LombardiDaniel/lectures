variable "api_key" {
  type        = string
  description = "MGC_API_KEY"
}

variable "machine_type" {
  type    = string
  default = "BV1-1-10"
}

variable "vpc_id" {
  type = string
}

variable "experiment_name" {
  type = string
}

variable "tcp_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

variable "udp_ports" {
  type    = list(number)
  default = []
}

variable "ssh_pub_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_priv_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519"
}

variable "block_storage_size" {
  type    = number
  default = 100
}

variable "block_storage_type" {
  type        = string
  default     = "cloud_nvme1k"
  description = "one of the following: cloud_nvme1k, cloud_nvme5k, cloud_nvme10k, cloud_nvme15k, cloud_nvme20k"
}
