output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Name of the security group (only useful if use_name_prefix = false)"
  value       = aws_security_group.this.name
}

output "ingress_rule_ids" {
  description = "rule key -> aws_vpc_security_group_ingress_rule id, in case something downstream needs to reference one specific rule"
  value       = { for k, v in aws_vpc_security_group_ingress_rule.this : k => v.security_group_rule_id }
}

output "egress_rule_ids" {
  description = "rule key -> aws_vpc_security_group_egress_rule id"
  value       = { for k, v in aws_vpc_security_group_egress_rule.this : k => v.security_group_rule_id }
}
