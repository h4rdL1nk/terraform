// BEGIN INSTANCES PROVISION BASED ON COUNT VALUES
resource "openstack_compute_instance_v2" "docker-pool" {
  name            = "docker-pool-${count.index}"
  count           = "${lookup(var.docker-pool-instances,"number")}"
  image_name      = "TID-RH7-3NIC.20171101"
  flavor_name     = "${lookup(var.docker-pool-instances,"flavor")}"
  key_pair        = "test"
  security_groups = ["${openstack_compute_secgroup_v2.webserver.name}", "${openstack_compute_secgroup_v2.ssh.name}"]

  metadata {
    environment = "test"
    application = "docker"
  }

  network {
    name = "DOCKER_MGMT"
  }
}

resource "openstack_blockstorage_volume_v2" "opt" {
  name  = "${element(openstack_compute_instance_v2.docker-pool.*.name,count.index)}"
  size  = "${var.env == "production" ? 10 : 30}"
  count = "${lookup(var.docker-pool-instances,"number")}"
}

resource "openstack_compute_volume_attach_v2" "opt" {
  volume_id   = "${element(openstack_blockstorage_volume_v2.opt.*.id,count.index)}"
  device      = "/dev/vdb"
  instance_id = "${element(openstack_compute_instance_v2.docker-pool.*.id,count.index)}"
  count       = "${lookup(var.docker-pool-instances,"number")}"
}

resource "openstack_networking_floatingip_v2" "test" {
  pool  = "ext_mgmt"
  count = "${lookup(var.docker-pool-instances,"number")}"
}

resource "openstack_compute_floatingip_associate_v2" "test" {
  floating_ip = "${element(openstack_networking_floatingip_v2.test.*.address,count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.docker-pool.*.id,count.index)}"
  fixed_ip    = "${element(openstack_compute_instance_v2.docker-pool.*.network.0.fixed_ip_v4,count.index)}"
  count       = "${lookup(var.docker-pool-instances,"number")}"

  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook -e DOCKER_MGMT=${element(openstack_compute_instance_v2.docker-pool.*.network.0.fixed_ip_v4,count.index)} -e ansible_host=${element(openstack_networking_floatingip_v2.test.*.address,count.index)} -e ansible_user=cloud-user play.yml
    EOF
  }
}

// END INSTANCES PROVISION BASED ON COUNT VALUES

