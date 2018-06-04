//Empty password variable requested as user input
variable "ost-password" {}

//Environment needed for estrablishing platform size
variable "env" {
  type    = "string"
  default = "production"
}

//Docker instances parameters
variable "docker-pool-instances" {
  type = "map"

  default = {
    number = 2
    flavor = "TID-01CPU-01GB-20GB"
  }
}
