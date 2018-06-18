//Empty password variable requested as user input
variable "ost-password" {}

variable "ost-user" {}

variable "subnets" {
  type = "map"

  default = {
    number = 2
    bits   = 3
  }
}

variable "default-nameservers" {
  type = "list"

  default = [
    "10.95.121.180",
    "10.95.48.36",
  ]
}

//Management IP pool
variable "management-ip-pool" {
  type    = "string"
  default = "ext_mgmt"
}

//Environment needed for estrablishing platform size
variable "env" {
  type    = "string"
  default = "production"
}

//Docker instances parameters
variable "docker-pool-instances" {
  type = "map"

  default = {
    name    = "docker-pool"
    number  = 3
    flavor  = "TID-01CPU-01GB-20GB"
    image   = "TID-RH75.20180601"
    app-tag = "docker"
  }
}
