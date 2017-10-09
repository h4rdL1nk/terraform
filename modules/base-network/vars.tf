
variable "environment" {}
variable "vpc_cidr" {}

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

