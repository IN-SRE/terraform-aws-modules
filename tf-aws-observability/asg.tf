resource "aws_autoscaling_policy" "scale_out" {
  count = var.enable_asg_alarms ? 1 : 0

  name                   = "${var.name}-high-cpu"
  scaling_adjustment     = var.asg_scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.asg_scale_out_cooldown
  autoscaling_group_name = var.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  count = var.enable_asg_alarms ? 1 : 0

  alarm_name          = "${var.name}-asg-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.asg_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.asg_cpu_period
  statistic           = "Average"
  threshold           = var.asg_cpu_threshold
  alarm_description   = "EC2 CPU utilization is at or above ${var.asg_cpu_threshold}%"
  alarm_actions       = [aws_autoscaling_policy.scale_out[0].arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  tags = var.tags
}