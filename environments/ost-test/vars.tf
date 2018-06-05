//Empty password variable requested as user input
variable "ost-password" {}

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
    number  = 2
    flavor  = "TID-01CPU-01GB-20GB"
    image   = "TID-RH7-3NIC.20171101"
    app-tag = "docker"
  }
}
