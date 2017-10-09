
resource "aws_alb_target_group" "default" {
  count    = "${length(var.ecs_services)}"
  name     = "TG-${split('|',element(var.ecs_services,count.index))}-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${var.ec2_alb_arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.0.arn}"
    type             = "forward"
  }

  depends_on = [
	"aws_alb_target_group.default"
  ] 
}

resource "aws_ecs_task_definition" "default" {
  count = "${length(var.ecs_services)}"
  family = "TSK-${split('|',element(var.ecs_services,count.index))}"
  container_definitions = <<DEFINITION
[
  {
    "name": "default",
    "cpu": 128,
    "environment": [{
      "name": "SECRET",
      "value": "KEY"
    }],
    "essential": true,
    "image": "${split('|',element(var.ecs_services,count.index))}",
    "memory": 250,
    "memoryReservation": 128,
    "portMappings": [
      {
        "containerPort": 80
      }
     ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "default" {
  count = "${length(var.ecs_services)}"
  name          = "SVC-${split('|',element(var.ecs_services,count.index))}"
  cluster       = "${var.ecs_cluster_id}"
  desired_count = 2
  iam_role = "${var.iam_role_arn}"
  deployment_maximum_percent = 150
  deployment_minimum_healthy_percent = 100 
  task_definition = "${element(aws_ecs_task_definition.default.*.arn,count.index)}"

  load_balancer {  
  	target_group_arn = "${element(aws_alb_target_group.default.*.arn,count.index)}"
  	container_name = "default"
  	container_port = 80
  }

  depends_on = [
	"aws_alb_listener.front_end",
	"aws_ecs_task_definition.default"
  ]
}
