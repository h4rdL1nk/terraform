

variable "environment" {
  type = "string"
  default = "testing"
}

variable "vpc_cidr" {
  type = "string"
  default = "10.172.48.0/21"
}

variable "aws_region" {
  type = "string"
  default = "eu-west-1"
}

variable "credentials" {
  type = "map"
  default = {
    access_key = ""
    secret_key = ""
  }
}

variable "ecs_services" {
  type = "list"
  default = [
    "test|httpd"
  ]
}