resource "aws_iam_policy" "policy" {
  name        = "${var.type}-policy"
  path        = "/"

  policy = "${file("${path.module}/iam/policy/${var.type}-policy.json")}" 
}

resource "aws_iam_role" "role" {
  name = "${var.type}-role"
  description = "ECS role for cluster instances"
  assume_role_policy = "${file("${path.module}/iam/trust/${var.type}-role.json")}" 
}

resource "aws_iam_instance_profile" "instance-profile" {
  name  = "instance_profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_policy_attachment" "role-policy-attachment" {
  name       = "role-policy-attachment"
  roles      = ["${aws_iam_role.role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

