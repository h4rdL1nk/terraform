
output "iam_instance_profile_arn" {
  value = "${aws_iam_instance_profile.instance-profile.arn}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.role.arn}"
}
