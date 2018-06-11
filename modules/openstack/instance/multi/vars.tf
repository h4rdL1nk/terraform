variable "name" {}
variable "number" {}
variable "image_name" {}
variable "flavor_name" {}
variable "key_pair" {}
variable "environment" {}
variable "ip-pool" {}

variable "security-groups" {
  type = "list"
}

variable "app-tag" {}

variable "devices" {
  type = "list"

  default = [
    "/dev/vdb",
    "/dev/vdc",
    "/dev/vdd",
  ]
}

variable "network" {}
