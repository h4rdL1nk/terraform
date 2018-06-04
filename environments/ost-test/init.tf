provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_compute_secgroup_v2" "webserver" {
  name        = "webserver"
  description = "Webserver basic rules"

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

  rule {
    from_port   = 8080
    to_port     = 8080
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 8443
    to_port     = 8443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "SSH access rules"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_keypair_v2" "test" {
  name       = "test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFNX+IDFYG+s3BHxkVwtBmW3GtXNVNQK39UJXOLpQQ+xkruaxL+/+gIXXaHdUm2v9rFumPtd2cSXKVM1xN0gKZAo6hmdHKNnkTUbinkVOw4N+Knm6+UF8ChbtZCCtPtPA1aF7HehgIBtBEUyffxk7aX308tgp1Z3yu9IzomXyMEeL/x+BYhtfNbgJ+HbFIDwSIIvqNQso2Dx25FFShPT+4DmkbTwXSOAmcZNarb0yVg1CkPvj4uWreWjLY4ZJmUuLamMkenzYiD0whtqOqhgT77HCLc1HKJJ+jmowSBxXpuphbePs1bSCxcratKIdPLds4LfRm5+XYjPFDw/VUOC+Z"
}

resource "openstack_compute_instance_v2" "docker-pool" {
  name            = "docker-pool-${count.index}"
  count           = 2
  image_name      = "TID-RH7-3NIC.20171101"
  flavor_name     = "TID-01CPU-01GB-20GB"
  key_pair        = "test"
  security_groups = ["${openstack_compute_secgroup_v2.webserver.name}", "${openstack_compute_secgroup_v2.ssh.name}"]

  metadata {
    environment = "test"
    application = "test"
  }

  network {
    name = "DOCKER_MGMT"
  }
}

resource "openstack_blockstorage_volume_v2" "opt" {
  name  = "${element(openstack_compute_instance_v2.docker-pool.*.name,count.index)}"
  size  = 10
  count = 2
}

resource "openstack_compute_volume_attach_v2" "opt" {
  volume_id   = "${element(openstack_blockstorage_volume_v2.opt.*.id,count.index)}"
  device      = "/dev/vdb"
  instance_id = "${element(openstack_compute_instance_v2.docker-pool.*.id,count.index)}"
  count       = 2
}

resource "openstack_networking_floatingip_v2" "test" {
  pool  = "ext_mgmt"
  count = 2
}

resource "openstack_compute_floatingip_associate_v2" "test" {
  floating_ip = "${element(openstack_networking_floatingip_v2.test.*.address,count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.docker-pool.*.id,count.index)}"
  fixed_ip    = "${element(openstack_compute_instance_v2.docker-pool.*.network.0.fixed_ip_v4,count.index)}"
  count       = 2

  /*provisioner "local-exec" {
    command = "ansible-playbook -e DOCKER_MGMT=${element(openstack_compute_instance_v2.docker-pool.*.network.0.fixed_id_v4,count.index)} -e ansible_host=${element(openstack_networking_floatingip_v2.test.*.address,count.index)} play.yml"
  }*/
}
