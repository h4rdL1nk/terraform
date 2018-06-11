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
