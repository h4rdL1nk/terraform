variable "subnets" {
  type = "map"

  default = {
    number = 2
    bits   = 3
  }
}

variable "cidr" {}

variable "name" {}
