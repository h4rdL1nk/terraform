resource "aws_alb_target_group" "default" {
  count    = "${length(var.ecs_services)}"
  name     = "TG-${element(var.ecs_services,count.index)}-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "detault" {
  load_balancer_arn = "${var.ec2_alb_arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.0.arn}"
    type             = "forward"
  }
}

