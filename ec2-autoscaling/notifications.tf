
# SNS Notifications 

resource "aws_sns_topic" "this" {

  name = local.sns_topic_name
  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = toset(var.sns_subscription_emails)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_autoscaling_notification" "this" {

  group_names   = [aws_autoscaling_group.this.name]
  notifications = var.sns_notification_types
  topic_arn     = aws_sns_topic.this.arn
}
