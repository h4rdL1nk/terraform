output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "aws_subnet_ids" {
  value = ["${aws_subnet.main.*.id}"]
}

output "aws_security_group_id" {
  value = "${aws_security_group.cluster_internal.id}"
}
