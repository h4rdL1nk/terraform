output "server-ip" {
  value = "${openstack_networking_floatingip_v2.jenkins.address}"
}

output "networks" {
  value = "${openstack_compute_instance_v2.jenkins.network}"
}
