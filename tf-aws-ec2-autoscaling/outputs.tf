
# Launch Template

output "launch_template_id" {
  description = "ID of the launch template."
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "ARN of the launch template."
  value       = aws_launch_template.this.arn
}

output "launch_template_latest_version" {
  description = "Latest version number of the launch template."
  value       = aws_launch_template.this.latest_version
}


# Autoscaling Group

output "autoscaling_group_id" {
  description = "ID of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.arn
}


# IAM role


output "iam_role_arn" {
  description = "ARN of the IAM role created for EC2 instances (null if create_iam_instance_profile is false)."
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile used by the launch template."
  value       = local.instance_profile_arn
}

# Notifications

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for ASG notifications (null if disabled)."
  value       = length(aws_sns_topic.this) > 0 ? aws_sns_topic.this[0].arn : null
}

# Scaling Policies

output "target_tracking_policy_arns" {
  description = "Map of target tracking scaling policy names to ARNs."
  value       = { for k, v in aws_autoscaling_policy.target_tracking : k => v.arn }
}
