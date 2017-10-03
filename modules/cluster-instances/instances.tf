
resource "aws_ecs_cluster" "main" {
  name = "CL-${var.environment}"
}

resource "aws_launch_configuration" "main" {
  name          = "LC-${var.environment}-default"
  image_id      = "${lookup(var.ecs_amis,var.aws_region)}"
  instance_type = "${lookup(var.instance_types,var.environment)}"
  key_name = "KP-${var.environment}-default"
  security_groups = ["${var.aws_security_group}"]
  iam_instance_profile = "${var.aws_iam_instance_profile}"
  user_data =<<EOF
#!/bin/bash

#Configuracion cluster
echo ECS_CLUSTER=CL-${var.environment} >>/etc/ecs/ecs.config
echo ECS_LOGLEVEL=debug >>/etc/ecs/ecs.config

#Ajuste zona horaria
rm /etc/localtime && ln -s /usr/share/zoneinfo/${var.tz}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                 = "AG-${var.environment}-default"
  launch_configuration = "${aws_launch_configuration.main.name}"
  desired_capacity     = "${lookup(var.autoscaling,"desired_instances")}"
  min_size             = "${lookup(var.autoscaling,"min_instances")}" 
  max_size             = "${lookup(var.autoscaling,"max_instances")}"
  vpc_zone_identifier = ["${var.aws_subnet_ids}"]

  termination_policies = [
    "OldestLaunchConfiguration",
    "OldestInstance" 
  ] 

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "AG-${var.environment}-default-instance"
    propagate_at_launch = true 
  }

  tag {
    key                 = "env"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}

