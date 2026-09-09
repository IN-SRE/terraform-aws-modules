
# SNS Notifications 

resource "aws_sns_topic" "this" {
  count = length(var.sns_subscription_emails) > 0 ? 1 : 0

  name = local.sns_topic_name
  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = toset(var.sns_subscription_emails)

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_autoscaling_notification" "this" {
  count = length(var.sns_subscription_emails) > 0 ? 1 : 0
  group_names   = [aws_autoscaling_group.this.name]
  notifications = var.sns_notification_types
  topic_arn     = aws_sns_topic.this[0].arn
}
