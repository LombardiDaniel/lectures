# terraform apply -var "container_name=YetAnotherName"
# terraform apply -var-file=.tfvars

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
