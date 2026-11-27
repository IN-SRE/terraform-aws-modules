resource "aws_cloudwatch_log_group" "cis" {
  count = var.enable_cis_alarms ? 1 : 0

  name              = var.cis_log_group_name
  retention_in_days = var.cis_log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_metric_filter" "cis" {
  for_each = local.cis_enabled_controls

  name           = "${var.name}-cis-${each.key}"
  log_group_name = aws_cloudwatch_log_group.cis[0].name
  pattern        = each.value.pattern

  metric_transformation {
    name      = "CIS-${each.key}"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cis" {
  for_each = local.cis_enabled_controls

  alarm_name          = "${var.name}-cis-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CIS-${each.key}"
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_description   = "CIS ${each.value.cis}: ${each.value.description}"
  alarm_actions       = [var.sns_topic_arn]

  tags = var.tags
}