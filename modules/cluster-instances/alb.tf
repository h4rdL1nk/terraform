
resource "aws_alb" "main" {
  name            = "ALB-${var.environment}"
  internal        = false
  security_groups = ["${var.aws_security_group}"]
  subnets         = ["${var.aws_subnet_ids}"]
  enable_deletion_protection = false

  tags {
    Name = "ALB-${var.environment}",
    env = "${var.environment}"
  }
}

