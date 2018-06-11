provider "openstack" {
  user_name   = "${var.ost-user}"
  password    = "${var.ost-password}"
  tenant_name = "jetsetme-test"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

module "main-network" {
  source          = "../../modules/openstack/networking"
  name            = "terraform"
  cidr            = "192.168.100.0/24"
  external-net-id = "7dd8d467-9668-4e5a-8983-3620bd594e37"
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

/*
module "frontend-instance" {
  source          = "../../modules/openstack/instance/standalone"
  name            = "webserver"
  image_name      = "${lookup(var.docker-pool-instances,"image")}"
  flavor_name     = "${lookup(var.docker-pool-instances,"flavor")}"
  key_pair        = "${module.openstack-keypair.key_name}"
  environment     = "${var.env}"
  app-tag         = "apache"
  security-groups = ["${module.ssh-security-group.sg-name}", "${module.web-security-group.sg-name}"]
  ip-pool         = "${var.management-ip-pool}"
}

module "backend-instance" {
  source          = "../../modules/openstack/instance/standalone"
  name            = "database"
  image_name      = "${lookup(var.docker-pool-instances,"image")}"
  flavor_name     = "${lookup(var.docker-pool-instances,"flavor")}"
  key_pair        = "${module.openstack-keypair.key_name}"
  environment     = "${var.env}"
  app-tag         = "mongodb"
  security-groups = ["${module.ssh-security-group.sg-name}"]
  ip-pool         = "${var.management-ip-pool}"
}
*/

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
  network         = "${module.main-network.network-name}"
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

