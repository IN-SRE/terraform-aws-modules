output "alb_5xx_alarm_name" {
  description = "ALB 5XX alarm name (null if disabled)"
  value       = one(aws_cloudwatch_metric_alarm.alb_5xx[*].alarm_name)
}

output "asg_scale_out_policy_arn" {
  description = "ARN of the ASG scale-out policy (null if disabled)"
  value       = one(aws_autoscaling_policy.scale_out[*].arn)
}

output "asg_high_cpu_alarm_name" {
  description = "ASG high CPU alarm name (null if disabled)"
  value       = one(aws_cloudwatch_metric_alarm.asg_high_cpu[*].alarm_name)
}

output "cis_log_group_name" {
  description = "CloudWatch log group for CIS metric filters (null if disabled)"
  value       = one(aws_cloudwatch_log_group.cis[*].name)
}

output "cis_alarm_names" {
  description = "CIS alarm names, keyed by control name"
  value       = { for k, a in aws_cloudwatch_metric_alarm.cis : k => a.alarm_name }
}

output "canary_name" {
  description = "Canary name (null if disabled)"
  value       = one(aws_synthetics_canary.this[*].name)
}

output "canary_bucket_name" {
  description = "S3 bucket for canary results (null if disabled)"
  value       = one(aws_s3_bucket.canary[*].id)
}

output "canary_alarm_name" {
  description = "Canary success alarm name (null if disabled)"
  value       = one(aws_cloudwatch_metric_alarm.canary_success[*].alarm_name)
}