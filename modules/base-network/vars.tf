
variable "environment" {}
variable "vpc_cidr" {}

#Network
/*
variable "vpc_cidr" {
  type = "map"
  default = {
    bpo = "10.0.0.0/16",
    inftel = "10.172.48.0/21"
  }
}
*/

variable "subnets" {
  type = "map"
  default = {
    number = 3,
    bits = 3  
  }
}

variable "az_letters" {
  type = "list"
  default = [
    "a",
    "b",
    "c"
  ]
}

