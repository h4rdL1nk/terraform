resource "openstack_networking_network_v2" "main" {
  name           = "net-${var.name}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "main" {
  count      = "${lookup(var.subnets,"number")}"
  name       = "subnet-${openstack_networking_network_v2.main.name}-${count.index}"
  network_id = "${openstack_networking_network_v2.main.id}"
  cidr       = "${cidrsubnet("${var.cidr}","${lookup(var.subnets,"bits")}",count.index)}"
  ip_version = 4
}
