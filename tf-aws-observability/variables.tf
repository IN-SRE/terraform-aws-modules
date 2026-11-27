variable "name" {
  description = "Prefix for resource names. Use lowercase letters, numbers, and hyphens (it is part of the S3 bucket name)."
  type        = string
  default     = "aws-cw-obs"
}

variable "sns_topic_arn" {
  description = "ARN of your existing SNS topic for alarm notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

# ALB
variable "enable_alb_alarms" {
  description = "Create ALB alarms"
  type        = bool
  default     = true
}

variable "alb_arn_suffix" {
  description = "ALB arn_suffix (e.g. app/my-alb/50dc6c495c0c9188)"
  type        = string
  default     = null
}

variable "alb_target_group_arn_suffix" {
  description = "Target group arn_suffix (e.g. targetgroup/my-tg/73e2d6bc24d8a067)"
  type        = string
  default     = null
}

variable "alb_5xx_threshold" {
  description = "Alarm when ALB 5XX count is above this value"
  type        = number
  default     = 5
}

variable "alb_5xx_evaluation_periods" {
  description = "Number of periods to evaluate for the ALB 5XX alarm"
  type        = number
  default     = 3
}

variable "alb_5xx_period" {
  description = "Period in seconds for the ALB 5XX alarm"
  type        = number
  default     = 120
}

# ASG
variable "enable_asg_alarms" {
  description = "Create the ASG scale-out policy and CPU alarm"
  type        = bool
  default     = true
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  type        = string
  default     = "asg"
}

variable "asg_scale_out_adjustment" {
  description = "Instances to add when the scale-out policy runs"
  type        = number
  default     = 4
}

variable "asg_scale_out_cooldown" {
  description = "Cooldown in seconds after a scale-out"
  type        = number
  default     = 300
}

variable "asg_cpu_threshold" {
  description = "Alarm when average CPU is at or above this percentage"
  type        = number
  default     = 80
}

variable "asg_cpu_evaluation_periods" {
  description = "Number of periods to evaluate for the CPU alarm"
  type        = number
  default     = 2
}

variable "asg_cpu_period" {
  description = "Period in seconds for the CPU alarm"
  type        = number
  default     = 120
}

# CIS
variable "enable_cis_alarms" {
  description = "Create CIS benchmark log metric filters and alarms"
  type        = bool
  default     = true
}

variable "cis_log_group_name" {
  description = "CloudWatch log group that receives CloudTrail events"
  type        = string
  default     = "/cis/cloudtrail"
}

variable "cis_log_retention_days" {
  description = "Retention in days for the CIS log group"
  type        = number
  default     = 90
}

variable "cis_disabled_controls" {
  description = "CIS control names to skip, e.g. [\"VPCChanges\"]. Names are listed in cis.tf."
  type        = list(string)
  default     = ["DisableOrDeleteCMK", "VPCChanges"]
}

# Synthetics
variable "enable_synthetics" {
  description = "Create the CloudWatch Synthetics canary, its IAM role, results bucket, and alarm"
  type        = bool
  default     = true
}

variable "canary_name" {
  description = "Canary name (max 21 characters, lowercase letters, numbers, hyphens, underscores)"
  type        = string
  default     = "sswebsite2"
}

variable "canary_zip_file" {
  description = "Path to the canary zip file on the machine running Terraform"
  type        = string
  default     = "sswebsite2/sswebsite2v1.zip"
}

variable "canary_handler" {
  description = "Canary handler, e.g. sswebsite2.handler"
  type        = string
  default     = "sswebsite2.handler"
}

variable "canary_runtime_version" {
  description = "Synthetics runtime version"
  type        = string
  default     = "syn-nodejs-puppeteer-13.1"
}

variable "canary_schedule" {
  description = "Canary schedule expression"
  type        = string
  default     = "rate(1 minute)"
}

variable "canary_memory_in_mb" {
  description = "Canary memory in MB"
  type        = number
  default     = 960
}

variable "canary_timeout_in_seconds" {
  description = "Canary timeout in seconds"
  type        = number
  default     = 60
}

variable "canary_success_threshold" {
  description = "Alarm when canary SuccessPercent is below this value"
  type        = number
  default     = 80
}
variable "canary_success_evaluation_periods" {
  type = number
  default = 5
}

variable "canary_success_period" {
  type = number
  default = 300
}