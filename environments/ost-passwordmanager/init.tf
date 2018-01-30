provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "JSM-AH1-L"
  password    = "${var.ost-password}"
  auth_url    = "https://ost-ah1.service.dsn.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}

resource "openstack_compute_secgroup_v2" "passmanager" {
  name        = "passmanager"
  description = "Password manager instance and containers access"

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

resource "openstack_compute_keypair_v2" "passmanager" {
  name       = "passmanager"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClk2d4WxqTh7/P6MkDF5Ytyqe4kpJ4BK44J64xI9hINVwE+Bb2Dujej5FSmtZHwYirNX4JxUoCkwIuTphpo6zeqzOxq/Wz6bXm6CCoZ2b+MUTDrsCeBg7vpCeLcCa4DvdTU6ejXr3eqfWCY8NSIOIOdNFL/vw3nbdSpM7hb0DYcihtI8BDY5FJAV2iBCV31Eiq5/gXGBI0pDzpSPqz3euau9eDtjBkZGwq4VXkWSsYFYkTZzu4/ejA+B4yZo459e7gFOKe4a2L1wJ23HDBceUH6Y3ieeFiF9VQ0u/egTCEYkmL8p//u2nuU3ifEcAL15P9BLlBmrZjg725TZlocH0v"
}

resource "openstack_compute_instance_v2" "passmanager" {
  name            = "passmanager"
  #image_id        = "ba8a2f31-8e6c-4b15-a4f4-3398e7202623"
  image_name     = "TID-RH7-3NIC.20171101"
  flavor_name     = "TID-01CPU-04GB-20GB"
  key_pair        = "${openstack_compute_keypair_v2.passmanager.name}"
  security_groups = ["${openstack_compute_secgroup_v2.passmanager.name}"]

  metadata {
    environment = "production"
    application = "passmanager"
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

resource "openstack_blockstorage_volume_v2" "passmanager" {
  name = "passmanager_vol0"
  size = 10
}

resource "openstack_compute_volume_attach_v2" "passmanager" {
  volume_id = "${openstack_blockstorage_volume_v2.passmanager.id}"
  device = "/dev/vdb"
  instance_id = "${openstack_compute_instance_v2.passmanager.id}"
}

resource "openstack_networking_floatingip_v2" "passmanager" {
  pool = "ext_mgmt"
}

resource "openstack_compute_floatingip_associate_v2" "passmanager" {
  floating_ip = "${openstack_networking_floatingip_v2.passmanager.address}"
  instance_id = "${openstack_compute_instance_v2.passmanager.id}"
  fixed_ip    = "${openstack_compute_instance_v2.passmanager.network.0.fixed_ip_v4}"
}
