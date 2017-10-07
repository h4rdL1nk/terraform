output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.main.id}"
}

output "ec2_alb_arn" {
  value = "${aws_alb.main.arn}"
}
