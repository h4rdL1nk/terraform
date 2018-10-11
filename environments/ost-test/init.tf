module "mgmt-network" {
  source          = "../../modules/openstack/networking"
  name            = "terraform-mgmt"
  cidr            = "192.168.2.0/24"
  external-net-id = "7dd8d467-9668-4e5a-8983-3620bd594e37"
  subnets         = "${var.subnets}"
  dns-nameservers = ["${var.default-nameservers}"]
}

module "inet-network" {
  source          = "../../modules/openstack/networking"
  name            = "terraform-inet"
  cidr            = "192.168.3.0/24"
  external-net-id = "72ee3aab-e02a-4572-af36-f5e36a475430"
  subnets         = "${var.subnets}"
  dns-nameservers = ["${var.default-nameservers}"]
}

module "openstack-keypair" {
  source = "../../modules/openstack/keypair"
  name   = "${var.env}"
}

module "ssh-security-group" {
  source = "../../modules/openstack/security-group/ssh"
}

module "web-security-group" {
  source = "../../modules/openstack/security-group/web"
}

module "docker-pool-instances" {
  source          = "../../modules/openstack/instance/multi"
  name            = "${lookup(var.docker-pool-instances,"name")}"
  number          = "${lookup(var.docker-pool-instances,"number")}"
  image_name      = "${lookup(var.docker-pool-instances,"image")}"
  flavor_name     = "${lookup(var.docker-pool-instances,"flavor")}"
  key_pair        = "${module.openstack-keypair.key_name}"
  environment     = "${var.env}"
  app-tag         = "${lookup(var.docker-pool-instances,"app-tag")}"
  security-groups = ["${module.ssh-security-group.sg-name}"]
  mgmt-network    = "${module.mgmt-network.network-name}"
  inet-network    = "${module.inet-network.network-name}"
  ip-pool         = "${var.management-ip-pool}"
}

//Addition of extra volume for each instance created
/*module "extra-volumes" {
  source         = "../../modules/openstack/volume/multi"
  number         = "${lookup(var.docker-pool-instances,"number")}"
  name_prefix    = "extra"
  size           = 10
  instance_ids   = "${module.docker-pool-instances.instance-ids}"
  instance_names = "${module.docker-pool-instances.instance-names}"
}*/

