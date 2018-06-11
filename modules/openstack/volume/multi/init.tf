resource "openstack_blockstorage_volume_v2" "multi" {
  count = "${var.number}"
  name  = "${var.name_prefix}-${element(var.instance_names,count.index)}"
  size  = "${var.size}"
}

resource "openstack_compute_volume_attach_v2" "multi" {
  count       = "${var.number}"
  instance_id = "${element(var.instance_ids,count.index)}}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.multi.*.id,count.index)}"

  //device      = "/dev/vdb"
}
