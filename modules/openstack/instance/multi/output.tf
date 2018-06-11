output "instance-ids" {
  value = ["${openstack_compute_instance_v2.main.*.id}"]
}

output "instance-names" {
  value = ["${openstack_compute_instance_v2.main.*.name}"]
}
