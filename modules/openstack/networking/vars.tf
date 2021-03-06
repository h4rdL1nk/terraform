variable "subnets" {
  type = "map"

  default = {
    number = 2
    bits   = 3
  }
}

variable "cidr" {}

variable "name" {}

variable "external-net-id" {}

variable "dns-nameservers" {
  type = "list"
}
