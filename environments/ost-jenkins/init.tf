provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "JSM-AH1-L"
  password    = "${var.ost-password}"
  auth_url    = "https://ost-ah1.service.dsn.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_compute_secgroup_v2" "jenkins-web" {
  name        = "jenkins-web"
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

#resource "openstack_compute_keypair_v2" "jenkins" {
#  name       = "jenkins"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClk2d4WxqTh7/P6MkDF5Ytyqe4kpJ4BK44J64xI9hINVwE+Bb2Dujej5FSmtZHwYirNX4JxUoCkwIuTphpo6zeqzOxq/Wz6bXm6CCoZ2b+MUTDrsCeBg7vpCeLcCa4DvdTU6ejXr3eqfWCY8NSIOIOdNFL/vw3nbdSpM7hb0DYcihtI8BDY5FJAV2iBCV31Eiq5/gXGBI0pDzpSPqz3euau9eDtjBkZGwq4VXkWSsYFYkTZzu4/ejA+B4yZo459e7gFOKe4a2L1wJ23HDBceUH6Y3ieeFiF9VQ0u/egTCEYkmL8p//u2nuU3ifEcAL15P9BLlBmrZjg725TZlocH0v"
#}

resource "openstack_compute_instance_v2" "jenkins" {
  name            = "jenkins-pro"
  image_name     = "TID-RH7-3NIC.20171101"
  flavor_name     = "TID-04CPU-08GB-20GB"
  key_pair        = "passmanager"
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
  name = "jenkins_lib"
  size = 10
}

resource "openstack_compute_volume_attach_v2" "jenkins-lib" {
  volume_id = "${openstack_blockstorage_volume_v2.jenkins-lib.id}"
  device = "/dev/vdb"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-docker" {
  volume_id = "${openstack_blockstorage_volume_v2.jenkins-docker.id}"
  device = "/dev/vdc"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
}

resource "openstack_networking_floatingip_v2" "jenkins" {
  pool = "ext_mgmt"
}

resource "openstack_compute_floatingip_associate_v2" "jenkins" {
  floating_ip = "${openstack_networking_floatingip_v2.jenkins.address}"
  instance_id = "${openstack_compute_instance_v2.jenkins.id}"
  fixed_ip    = "${openstack_compute_instance_v2.jenkins.network.0.fixed_ip_v4}"

  provisioner "local-exec" {
    command = "ansible-playbook -e DOCKER_MGMT=${openstack_compute_instance_v2.jenkins.network.0.fixed_ip_v4} -e ansible_host=${openstack_networking_floatingip_v2.jenkins.address} play.yml"
  }
}
