provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_compute_secgroup_v2" "lb" {
  name        = "lb"
  description = "Load Balancers secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80 
    to_port     = 80 
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

resource "openstack_compute_secgroup_v2" "api" {
  name        = "api"
  description = "API secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

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

resource "openstack_compute_secgroup_v2" "abs-feeder" {
  name        = "abs-feeder"
  description = "ABS Feeders secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 30000
    to_port     = 30000
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "invoker" {
  name        = "invoker"
  description = "Invokers secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "roamingfeeder" {
  name        = "roamingfeeder"
  description = "RoamingFeeder secgroup"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

resource "openstack_compute_instance_v2" "lb-instances" {
  name            = "jsm-fe-lb-${count.index + 1}"
  image_id        = "25ab3c9f-f484-4a76-a249-95bc5063cead"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test-keypair"
  count           = 2
  security_groups = ["${openstack_compute_secgroup_v2.lb.name}"]

  metadata {
    environment = "test"
    application = "nginx"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_PUFE_E_LB_R_PRI"
  }

  network {
    name = "RMN_PUFE_INT_PRI"
  }

}

resource "openstack_compute_instance_v2" "api-instances" {
  name            = "jsm-be-lb-${count.index + 1}"
  image_id        = "181f23d2-1335-43a3-9244-3fb4f453b8a3"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test-keypair"
  count           = 2 
  security_groups = ["${openstack_compute_secgroup_v2.api.name}"]

  metadata {
    environment = "test"
    application = "api"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_PUFE_E_LB_R_PRI_2"
  }

  network {
    name = "RMN_PUFE_INT_PRI"
  }

}




resource "openstack_compute_instance_v2" "mongodb-instances" {
  name            = "jsm-be-mdb-${count.index + 1}"
  image_id        = "9844660d-0229-40a5-b91e-a90ac68d3414"
  flavor_name     = "TID-01CPU-02GB-20GB" 
  key_pair        = "test-keypair"
  count           = 2
  security_groups = ["${openstack_compute_secgroup_v2.mongo-db.name}"]
  #user_data = ${file("common_userdata.sh")}

  metadata {
    environment = "test"
    application = "mongodb"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_BE_E"
    fixed_ip_v4 = "172.20.234.${count.index + 40}"
  } 

}

resource "openstack_compute_instance_v2" "abs-feeder-instances" {
  name            = "jsm-be-absfeeder-${count.index + 1}"
  image_id        = "b6e6f3a7-9fc5-4758-8d18-443a5dfad8ab"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test-keypair"
  count           = 2 
  security_groups = ["${openstack_compute_secgroup_v2.abs-feeder.name}"]

  metadata {
    environment = "test"
    application = "absfeeder"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_PRFE_E_LB_R_PRI"
  }

  network {
    name = "RMN_PRFE_INT_PRI"
  }

}

resource "openstack_compute_instance_v2" "invoker-instances" {
  name            = "jsm-be-invoker-${count.index + 1}"
  image_id        = "b6e6f3a7-9fc5-4758-8d18-443a5dfad8ab"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test-keypair"
  count           = 2 
  security_groups = ["${openstack_compute_secgroup_v2.invoker.name}"]

  metadata {
    environment = "test"
    application = "invoker"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_PUFE_E_LB_R_PRI_2"
  }

  network {
    name = "RMN_PUFE_INT_PRI"
  }

}

resource "openstack_compute_instance_v2" "roaming-feeder-instances" {
  name            = "jsm-fe-roamingfeeder-${count.index + 1}"
  image_id        = "b6e6f3a7-9fc5-4758-8d18-443a5dfad8ab"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test-keypair"
  count           = 2
  security_groups = ["${openstack_compute_secgroup_v2.roamingfeeder.name}"]

  metadata {
    environment = "test"
    application = "roamingfeeder"
  }

  network {
    name = "ONM_VMS"
  }

  network {
    name = "RMN_PUFE_E_LB_R_PRI_2"
  }

  network {
    name = "RMN_PUFE_INT_PRI_2"
  }

}



