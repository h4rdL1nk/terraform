variable "ost-password" {}

variable "docker-pool-instances" {
  type = "map"

  default = {
    number = 2
    flavor = "TID-01CPU-01GB-20GB"
  }
}
