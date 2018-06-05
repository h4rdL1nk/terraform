resource "openstack_compute_instance_v2" "main" {
  count           = "${var.number}"
  name            = "${var.name}-${count.index}"
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

resource "openstack_blockstorage_volume_v2" "main" {
  count = "${var.number}"
  name  = "${element(openstack_compute_instance_v2.main.*.name,count.index)}"
  size  = "${var.environment == "production" ? 10 : 30}"
}

resource "openstack_compute_volume_attach_v2" "main" {
  count       = "${var.number}"
  instance_id = "${element(openstack_compute_instance_v2.main.*.id,count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.main.*.id,count.index)}"
  device      = "/dev/vdb"
}

resource "openstack_networking_floatingip_v2" "main" {
  count = "${var.number}"
  pool  = "${var.ip-pool}"
}

resource "openstack_compute_floatingip_associate_v2" "main" {
  count       = "${var.number}"
  floating_ip = "${element(openstack_networking_floatingip_v2.main.*.address,count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.main.*.id,count.index)}"
  fixed_ip    = "${element(openstack_compute_instance_v2.main.*.network.0.fixed_ip_v4,count.index)}"

  /*provisioner "local-exec" {
    command = <<EOF
      ansible-playbook -e DOCKER_MGMT=${element(openstack_compute_instance_v2.main.*.network.0.fixed_ip_v4,count.index)} -e ansible_host=${element(openstack_networking_floatingip_v2.main.*.address,count.index)} -e ansible_user=cloud-user play.yml
    EOF
  }*/
}
