output "network-name" {
  value = "${openstack_networking_network_v2.main.name}"
}

output "subnet-ids" {
  value = ["${openstack_networking_subnet_v2.main.*.id}"]
}
