variable "ost-password" {}

variable "env" {
  type    = "string"
  default = "production"
}

variable "docker-pool-instances" {
  type = "map"

  default = {
    number = 2
    flavor = "TID-01CPU-01GB-20GB"
  }
}
