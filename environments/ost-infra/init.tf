provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_networking_network_v2" "jsm-test" {
  name           = "jsm-test"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.jsm-test.id}"
  cidr       = "${lookup(var.network, "cidr")}"
  ip_version = 4
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "d4e4b5d9-bd6c-4be7-8bbb-a38665903925"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

resource "openstack_compute_secgroup_v2" "mongo-db" {
  name        = "mongo-db"
  description = "MongoDB replicasets secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "mongodb-instances" {
  name            = "mongodb-instance-${count.index + 1}"
  image_id        = "9844660d-0229-40a5-b91e-a90ac68d3414"
  flavor_id       = "102" 
  key_pair        = "test-keypair"
  count           = 2
  security_groups = ["${openstack_compute_secgroup_v2.mongo-db.name}"]

  metadata {
    environment = "test"
    application = "mongodb"
  }

  network {
    name = "${openstack_networking_network_v2.jsm-test.name}"
  }
}

