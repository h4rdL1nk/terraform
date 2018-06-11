resource "aws_autoscaling_policy" "main-cluster-instance-up" {
  name                   = "AG-${aws_autoscaling_group.main.name}-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${lookup(var.autoscaling,"cooldown")}"
  autoscaling_group_name = "${aws_autoscaling_group.main.name}"
}

resource "aws_autoscaling_policy" "main-cluster-instance-down" {
  name                   = "AG-${aws_autoscaling_group.main.name}-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${lookup(var.autoscaling,"cooldown")}"
  autoscaling_group_name = "${aws_autoscaling_group.main.name}"
}

resource "aws_cloudwatch_metric_alarm" "main-cluster-memory-up" {
  alarm_name          = "${aws_ecs_cluster.main.name}-memory-up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }

  alarm_description = "Alarma de utilizacion de memoria del cluster ${aws_ecs_cluster.main.name}"
  alarm_actions     = ["${aws_autoscaling_policy.main-cluster-instance-up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "main-cluster-memory-down" {
  alarm_name          = "${aws_ecs_cluster.main.name}-memory-down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
  }

  alarm_description = "Alarma de utilizacion de memoria del cluster ${aws_ecs_cluster.main.name}"
  alarm_actions     = ["${aws_autoscaling_policy.main-cluster-instance-down.arn}"]
}

