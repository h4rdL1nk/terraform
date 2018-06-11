resource "openstack_networking_router_v2" "management" {
  name                = "router-management"
  admin_state_up      = "true"
  external_network_id = "${var.external-net-id}"
}

resource "openstack_networking_network_v2" "management" {
  name           = "net-${var.name}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "management" {
  count      = "${lookup(var.subnets,"number")}"
  name       = "subnet-${openstack_networking_network_v2.management.name}-${count.index}"
  network_id = "${openstack_networking_network_v2.management.id}"
  cidr       = "${cidrsubnet("${var.cidr}","${lookup(var.subnets,"bits")}",count.index)}"
  ip_version = 4
}

resource "openstack_networking_router_interface_v2" "management" {
  count     = "${lookup(var.subnets,"number")}"
  router_id = "${openstack_networking_router_v2.management.id}"
  subnet_id = "${element(openstack_networking_subnet_v2.management.*.id,count.index)}"
}
