provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

module "openstack-keypair" {
  source = "../../modules/openstack/keypair"
  name   = "${var.env}"
}

module "security-group" {
  source = "../../modules/openstack/security-group"
}

module "openstack-instance" {
  source          = "../../modules/openstack/instance"
  name            = "${lookup(var.docker-pool-instances,"name")}"
  number          = "${lookup(var.docker-pool-instances,"number")}"
  image_name      = "${lookup(var.docker-pool-instances,"image")}"
  flavor_name     = "${lookup(var.docker-pool-instances,"flavor")}"
  key_pair        = "${module.openstack-keypair.key_name}"
  environment     = "${var.env}"
  app-tag         = "${lookup(var.docker-pool-instances,"app-tag")}"
  security-groups = ["${module.security-group.ssh-sg-name}"]
  ip-pool         = "${var.management-ip-pool}"
}
