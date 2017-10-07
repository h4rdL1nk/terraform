resource "aws_ecs_task_definition" "default" {
  count = "${length(var.ecs_services)}"
  family = "TSK-${element(var.ecs_services,count.index)}"
  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "environment": [{
      "name": "SECRET",
      "value": "KEY"
    }],
    "essential": true,
    "image": "mongo:latest",
    "memory": 250,
    "memoryReservation": 128,
    "name": "mongodb"
  }
]
DEFINITION
}

resource "aws_ecs_service" "default" {
  count = "${length(var.ecs_services)}"
  name          = "SVC-${element(var.ecs_services,count.index)}"
  cluster       = "${var.ecs_cluster_id}"
  desired_count = 2

  task_definition = "${aws_ecs_task_definition.default.0.arn}"
}
