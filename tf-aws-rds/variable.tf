variable "identifier" {
  description = "DB instance identifier (lowercase, used in resource names)"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "parameter_group_family" {
  description = "DB parameter group family, e.g. mysql8.0"
  type        = string
  default     = "mysql8.0"
}

variable "major_engine_version" {
  description = "Major engine version for the option group, e.g. 8.0"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max storage in GiB for autoscaling (0 or null disables it)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type: gp2, gp3, io1, io2"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Encrypt storage at rest"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password (write-only, not stored in state)"
  type        = string
  sensitive   = true
}

variable "password_version" {
  description = "Increase this number to rotate the write-only password"
  type        = number
  default     = 1
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_subnet_group_name" {
  description = "Existing DB subnet group name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs attached to the DB instance"
  type        = list(string)
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC), e.g. Mon:00:00-Mon:03:00"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "Preferred backup window (UTC), e.g. 03:00-06:00"
  type        = string
  default     = "03:00-06:00"
}

variable "backup_retention_period" {
  description = "Days to keep automated backups (0 disables them)"
  type        = number
  default     = 7
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Log types to export to CloudWatch, e.g. [\"general\", \"error\"]"
  type        = list(string)
  default     = ["general"]
}

variable "create_cloudwatch_log_group" {
  description = "Create CloudWatch log groups for the exported logs"
  type        = bool
  default     = true
}

variable "cloudwatch_log_retention_days" {
  description = "Retention in days for the CloudWatch log groups"
  type        = number
  default     = 14
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot on delete"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention in days (7 or 731)"
  type        = number
  default     = 7
}

variable "create_monitoring_role" {
  description = "Create an IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 disables it)"
  type        = number
  default     = 60
}

variable "parameters" {
  description = "DB parameter group settings"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = [
    { name = "character_set_client", value = "utf8mb4" },
    { name = "character_set_server", value = "utf8mb4" }
  ]
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_tags" {
  description = "Extra tags for the DB instance"
  type        = map(string)
  default     = {}
}

variable "db_option_group_tags" {
  description = "Extra tags for the option group"
  type        = map(string)
  default     = {}
}

variable "db_parameter_group_tags" {
  description = "Extra tags for the parameter group"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_log_group_tags" {
  description = "Extra tags for the CloudWatch log groups"
  type        = map(string)
  default     = {}
}