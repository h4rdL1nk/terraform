resource "openstack_compute_keypair_v2" "main" {
  name       = "${var.name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFNX+IDFYG+s3BHxkVwtBmW3GtXNVNQK39UJXOLpQQ+xkruaxL+/+gIXXaHdUm2v9rFumPtd2cSXKVM1xN0gKZAo6hmdHKNnkTUbinkVOw4N+Knm6+UF8ChbtZCCtPtPA1aF7HehgIBtBEUyffxk7aX308tgp1Z3yu9IzomXyMEeL/x+BYhtfNbgJ+HbFIDwSIIvqNQso2Dx25FFShPT+4DmkbTwXSOAmcZNarb0yVg1CkPvj4uWreWjLY4ZJmUuLamMkenzYiD0whtqOqhgT77HCLc1HKJJ+jmowSBxXpuphbePs1bSCxcratKIdPLds4LfRm5+XYjPFDw/VUOC+Z"
}
