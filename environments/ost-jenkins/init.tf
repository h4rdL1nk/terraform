provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "JSM-AH1-L"
  password    = "${var.ost-password}"
  auth_url    = "https://ost-ah1.service.dsn.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_compute_secgroup_v2" "jenkins-web" {
  name        = "jenkins-web-access"
  description = "Jenkins instance web access"

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

resource "openstack_compute_keypair_v2" "jenkins" {
  name       = "jenkins-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFNX+IDFYG+s3BHxkVwtBmW3GtXNVNQK39UJXOLpQQ+xkruaxL+/+gIXXaHdUm2v9rFumPtd2cSXKVM1xN0gKZAo6hmdHKNnkTUbinkVOw4N+Knm6+UF8ChbtZCCtPtPA1aF7HehgIBtBEUyffxk7aX308tgp1Z3yu9IzomXyMEeL/x+BYhtfNbgJ+HbFIDwSIIvqNQso2Dx25FFShPT+4DmkbTwXSOAmcZNarb0yVg1CkPvj4uWreWjLY4ZJmUuLamMkenzYiD0whtqOqhgT77HCLc1HKJJ+jmowSBxXpuphbePs1bSCxcratKIdPLds4LfRm5+XYjPFDw/VUOC+Z"
}

resource "openstack_compute_instance_v2" "jenkins" {
  name       = "jenkins-pro-test"
  image_name = "TID-RH75.20180601"

  //flavor_name     = "TID-06CPU-32GB-20GB"
  flavor_name     = "TID-01CPU-04GB-20GB"
  key_pair        = "${openstack_compute_keypair_v2.jenkins.name}"
  security_groups = ["${openstack_compute_secgroup_v2.jenkins-web.name}"]

  metadata {
    environment = "production"
    application = "jenkins"
  }

  network {
    name = "DOCKER_MGMT"
  }

  network {
    name = "DOCKER_INET"
  }

  network {
    name = "DOCKER_BACKEND"
  }
}

resource "openstack_blockstorage_volume_v2" "jenkins-lib" {
  name = "jenkins_lib"
  size = 60
}

resource "openstack_blockstorage_volume_v2" "jenkins-docker" {
  name = "jenkins_docker-pool"
  size = 40
}

resource "openstack_compute_volume_attach_v2" "jenkins-lib" {
  volume_id   = "${openstack_blockstorage_volume_v2.jenkins-lib.id}"
  device      = "/dev/vdb"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-docker" {
  volume_id   = "${openstack_blockstorage_volume_v2.jenkins-docker.id}"
  device      = "/dev/vdc"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
}

resource "openstack_networking_floatingip_v2" "jenkins" {
  pool = "ext_mgmt"
}

resource "openstack_compute_floatingip_associate_v2" "jenkins" {
  floating_ip = "${openstack_networking_floatingip_v2.jenkins.address}"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
  fixed_ip    = "${openstack_compute_instance_v2.jenkins.network.0.fixed_ip_v4}"

  //provisioner "local-exec" {
  //  command = "ansible-playbook -e DOCKER_MGMT=${openstack_compute_instance_v2.jenkins.network.0.fixed_ip_v4} -e ansible_host=${openstack_networking_floatingip_v2.jenkins.address} play.yml"
  //}
}
