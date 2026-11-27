resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  count = var.enable_alb_alarms ? 1 : 0

  alarm_name          = "${var.name}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alb_5xx_evaluation_periods
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_5xx_period
  statistic           = "Average"
  threshold           = var.alb_5xx_threshold
  alarm_description   = "ALB HTTP 5XX errors are above ${var.alb_5xx_threshold} for the interval"
  actions_enabled     = true
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  dimensions = {
    // TargetGroup  = var.alb_target_group_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }

  tags = var.tags
}