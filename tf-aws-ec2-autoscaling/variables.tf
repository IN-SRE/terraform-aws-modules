

variable "project" {
  description = "Project or application name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}

# Launch Template

variable "ami_id" {
  description = "AMI ID to use for the launch template."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "SSH key pair name to associate with instances. Leave null to omit key-based access."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the launch template."
  type        = list(string)
}

variable "user_data_path" {
  description = "Path to the user_data script that will be base64-encoded and passed to the launch template."
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "map of block device mappings for the launch template."
  type = map(object({
    device_name           = string
    volume_size           = number
    volume_type           = optional(string, "gp3")
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool, true)
  }))
  default = {
    root = {
      device_name           = "/dev/xvda"
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }}
  
}

variable "ebs_optimized" {
  description = "Whether instances launched via the template are EBS-optimized."
  type        = bool
  default     = true
}

variable "monitoring_enabled" {
  description = "Enable detailed (CloudWatch) monitoring on instances."
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "Enable EC2 termination protection."
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "Disable the ability to stop the instance via the API."
  type        = bool
  default     = false
}


variable "metadata_http_tokens" {
  description = "Whether IMDSv2 tokens are required ('required') or optional ('optional')."
  type        = string
  default     = "required"
}


variable "metadata_endpoint_enabled" {
  description = "Whether the instance metadata endpoint is enabled."
  type        = string
  default     = "enabled"
}


# Autoscaling Group

variable "vpc_zone_identifiers" {
  description = "List of subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the ASG."
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the ASG."
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG."
  type        = number
}

variable "health_check_type" {
  description = "Type of health check to perform. Valid values: EC2, ELB."
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time (seconds) after instance launch before health checks start."
  type        = number
  default     = 300
}

variable "force_delete" {
  description = "Allow the ASG to be deleted without waiting for instances to terminate."
  type        = bool
  default     = false
}

variable "min_healthy_percentage" {
  description = "Minimum percentage of healthy instances to maintain during instance refresh/replacement."
  type        = number
  default     = 90
}

variable "max_healthy_percentage" {
  description = "Maximum percentage of healthy instances allowed during instance refresh/replacement."
  type        = number
  default     = 120
}

variable "asg_delete_timeout" {
  description = "Timeout for ASG deletion."
  type        = string
  default     = "15m"
}



# IAM role for instances


variable "create_iam_instance_profile" {
  description = "Whether to create an IAM role and instance profile for the EC2 instances."
  type        = bool
  default     = true
}

variable "iam_instance_profile_arn" {
  description = "ARN of an existing IAM instance profile to use instead of creating one. Only used when create_iam_instance_profile is false."
  type        = string
  default     = null
}

variable "iam_role_managed_policy_arns" {
  description = "List of managed IAM policy ARNs to attach to the EC2 instance role."
  type        = map(string)
  default     = {
   ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
   cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the permissions boundary policy to attach to the IAM role, if any."
  type        = string
  default     = null
}

# SNS Notifications (optional)

variable "sns_notification_types" {
  description = "List of ASG notification types to publish to SNS."
  type        = list(string)
  default = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}

variable "sns_subscription_emails" {
  description = "List of email addresses to subscribe to the SNS notification topic."
  type        = list(string)
  default     = []
}


# Scheduled Actions

variable "scheduled_actions" {
  description = "Map of scheduled scaling actions to create."
  type = map(object({
    min_size         = number
    max_size         = number
    desired_capacity = number
    start_time       = optional(string)
    end_time         = optional(string)
    recurrence       = optional(string)
    time_zone        = optional(string)
  }))
  default = {}
}


# Target Tracking Scaling Policies

variable "target_tracking_policies" {
  description = "Map of target tracking scaling policies (e.g. CPU or ALB request count based scaling)."
  type = map(object({
    predefined_metric_type    = string
    resource_label            = optional(string)
    target_value              = number
    disable_scale_in          = optional(bool, false)
    estimated_instance_warmup = optional(number)
  }))
  default = {}
}
