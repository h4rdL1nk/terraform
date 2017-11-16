variable "ost-password" {}

variable "network" {
    type = "map"
    default = {
        "cidr" = "172.18.0.0/24"
    }
}
