variable "name" {
  description = "Base name for the ALB and target groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target groups"
  type        = string
}

variable "subnets" {
  description = "Subnet IDs for the ALB (at least 2 AZs)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Existing security group IDs attached to the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Create an internal ALB instead of an internet-facing one"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "drop_invalid_header_fields" {
  description = "Drop HTTP headers with invalid names"
  type        = bool
  default     = true
}

variable "target_groups" {
  description = "Map of target groups. Key is used in the name and referenced by listeners and rules. 'targets' registers instances/IPs/Lambdas (leave empty if an ASG, ECS, or EKS registers them)."
  type = map(object({
    port                  = number
    protocol              = optional(string, "HTTP")
    target_type           = optional(string, "instance")
    deregistration_delay  = optional(number, 30)
    health_check_path     = optional(string, "/health")
    health_check_matcher  = optional(string, "200-399")
    health_check_interval = optional(number, 30)
    health_check_timeout  = optional(number, 5)
    healthy_threshold     = optional(number, 3)
    unhealthy_threshold   = optional(number, 3)
    targets = optional(list(object({
      id   = string
      port = optional(number)
    })), [])
  }))
  default = {}
}

variable "listeners" {
  description = "Map of listeners. Key is referenced by listener_rules. default_action_type is 'forward' (needs target_group_key) or 'redirect' (needs redirect_* values)."
  type = map(object({
    port                 = number
    protocol             = optional(string, "HTTP")
    certificate_arn      = optional(string)
    ssl_policy           = optional(string)
    default_action_type  = optional(string, "forward")
    target_group_key     = optional(string)
    redirect_port        = optional(string)
    redirect_protocol    = optional(string)
    redirect_status_code = optional(string, "HTTP_301")
  }))
  default = {}
}

variable "listener_rules" {
  description = "Map of listener rules. listener_key must match a key in listeners, target_group_key must match a key in target_groups. Priority must be unique per listener (1-50000)."
  type = map(object({
    listener_key     = string
    priority         = number
    target_group_key = string
    path_patterns    = optional(list(string), [])
    host_headers     = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}