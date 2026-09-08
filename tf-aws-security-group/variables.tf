variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "use_name_prefix" {
  description = "Use var.name as a prefix instead of the exact name. Useful if the SG gets replaced often and you don't want naming collisions on apply"
  type        = bool
  default     = false
}

variable "description" {
  description = "Security group description"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC to put the security group in"
  type        = string
}

variable "ingress_rules" {
  description = "Map of inbound rules,Leave empty for no inbound rules"

  type = map(object({
    ip_protocol                  = optional(string, "tcp")
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string) 
    description                  = optional(string)

  }))
  default = {}
}

variable "egress_rules" {
  description = "if Leave empty engress rule then AWS defaults to allow-all-outbound."
  type = map(object({
    ip_protocol                  = optional(string, "tcp")
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    description                  = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to the SG itself and every rule (rule-level tags in ingress_rules/egress_rules get merged on top)"
  type        = map(string)
  default     = {}
}
