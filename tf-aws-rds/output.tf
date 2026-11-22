output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "Connection endpoint (address:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the initial database"
  value       = aws_db_instance.this.db_name
}

output "parameter_group_name" {
  description = "Name of the DB parameter group"
  value       = aws_db_parameter_group.this.name
}

output "option_group_name" {
  description = "Name of the DB option group"
  value       = aws_db_option_group.this.name
}

output "monitoring_role_arn" {
  description = "ARN of the enhanced monitoring role (null if not created)"
  value       = var.create_monitoring_role ? aws_iam_role.monitoring[0].arn : null
}

output "cloudwatch_log_group_names" {
  description = "CloudWatch log group names, keyed by log type"
  value       = { for k, g in aws_cloudwatch_log_group.this : k => g.name }
}