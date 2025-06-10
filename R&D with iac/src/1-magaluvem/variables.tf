variable "api_key" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "BV1-1-10"
}

variable "vpc_id" {
  type = string
}

variable "project_name" {
  type    = string
  default = "test"
}

variable "tcp_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

variable "ssh_pub_key" {
  type = string
}
