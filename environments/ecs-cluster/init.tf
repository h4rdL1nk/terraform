
provider "aws" {
  access_key = "${lookup(var.credentials,"access_key")}"
  secret_key = "${lookup(var.credentials,"secret_key")}" 
  region     = "${var.aws_region}"
}

module "base-network" {
  source = "../../modules/base-network"
  environment = "${var.environment}"
  department = "${var.department}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "iam-role" {
  source = "../../modules/iam-role"
  type = "ecs"
}

module "cluster-instances" {
  source  = "../../modules/cluster-instances"
  environment = "${var.environment}"
  aws_security_group = "${module.base-network.aws_security_group_id}"
  aws_subnet_ids = "${module.base-network.aws_subnet_ids}"
  aws_region = "${var.aws_region}"
  aws_iam_instance_profile = "${module.iam-role.aws_iam_instance_profile}"
}

