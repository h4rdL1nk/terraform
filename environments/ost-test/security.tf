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
