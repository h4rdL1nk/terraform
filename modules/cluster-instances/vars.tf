
variable "environment" {}
variable "aws_region" {}
variable "aws_security_group" {}
variable "aws_subnet_ids" { type = "list" }
variable "aws_iam_instance_profile" {}

variable "tz" {
  type = "string"
  default = "Europe/Madrid"
}

variable "ecs_amis" {
  type = "map"
  default = {
    eu-west-1 = "ami-809f84e6",
    eu-west-2 = "ami-ff15039b",
    eu-central-1 = "ami-a3a006cc"
  }
}

variable "instance_types" {
  type = "map"
  default = {
     test = "t2.micro",
     pre = "t2.micro",
     pro = "t2.medium"
  }
}

#Cluster
variable "autoscaling" {
  type = "map"
  default = {
    desired_instances = 2,
    min_instances     = 2,
    max_instances     = 5,
    cooldown          = 300
  }
}

