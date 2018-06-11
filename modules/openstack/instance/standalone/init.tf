resource "openstack_compute_instance_v2" "standalone" {
  name            = "${var.name}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.key_pair}"
  security_groups = ["${var.security-groups}"]

  metadata {
    environment = "${var.environment}"
    application = "${var.app-tag}"
  }

  network {
    name = "DOCKER_MGMT"
  }
}

resource "openstack_blockstorage_volume_v2" "standalone" {
  name = "${element(openstack_compute_instance_v2.standalone.*.name,length(openstack_compute_instance_v2.standalone.*.name)-1)}"
  size = "${var.environment == "production" ? 10 : 30}"
}

resource "openstack_compute_volume_attach_v2" "standalone" {
  instance_id = "${element(openstack_compute_instance_v2.standalone.*.id,length(openstack_compute_instance_v2.standalone.*.id)-1)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.standalone.*.id,length(openstack_blockstorage_volume_v2.standalone.*.id)-1)}"

  //device      = "/dev/vdb"
}

resource "openstack_networking_floatingip_v2" "standalone" {
  pool = "${var.ip-pool}"
}

resource "openstack_compute_floatingip_associate_v2" "standalone" {
  floating_ip = "${element(openstack_networking_floatingip_v2.standalone.*.address,length(openstack_networking_floatingip_v2.standalone.*.address)-1)}"
  instance_id = "${element(openstack_compute_instance_v2.standalone.*.id,length(openstack_compute_instance_v2.standalone.*.id)-1)}"
  fixed_ip    = "${element(openstack_compute_instance_v2.standalone.*.network.0.fixed_ip_v4,length(openstack_compute_instance_v2.standalone.*.id)-1)}"
}
