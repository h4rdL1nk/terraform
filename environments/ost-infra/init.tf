provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
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

  rule {
    from_port   = 27017
    to_port     = 27017
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "mongodb-instances" {
  name            = "jsm-be-mdb-${count.index + 1}"
  image_id        = "9844660d-0229-40a5-b91e-a90ac68d3414"
  flavor_name     = "TID-01CPU-02GB-20GB" 
  key_pair        = "test-keypair"
  count           = 2 
  security_groups = ["${openstack_compute_secgroup_v2.mongo-db.name}"]

  metadata {
    environment = "test"
    application = "mongodb"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_BE_E"
    fixed_ip_v4 = "172.20.234.${count.index + 100}"
  }

  network {
    name = "RMN_BE_E"
    fixed_ip_v4 = "172.20.234.${count.index + 110}"
  }

  network {
    name = "RMN_BE_E"
    fixed_ip_v4 = "172.20.234.${count.index + 120}"
  }

}

