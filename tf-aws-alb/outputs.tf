output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Route 53 zone ID of the ALB (for alias records)"
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "Target group ARNs, keyed by target group key"
  value       = { for k, tg in aws_lb_target_group.this : k => tg.arn }
}

output "listener_arns" {
  description = "Listener ARNs, keyed by listener key"
  value       = { for k, l in aws_lb_listener.this : k => l.arn }
}

output "listener_rule_arns" {
  description = "Listener rule ARNs, keyed by rule key"
  value       = { for k, r in aws_lb_listener_rule.this : k => r.arn }
}

output "target_groups" {
  value = aws_lb_target_group.this
}

output "lb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}


output "target_group_arn_suffix" {
  value = {for k, v in aws_lb_target_group.this : k => v.arn_suffix }
}