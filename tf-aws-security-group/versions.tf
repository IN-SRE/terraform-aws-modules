terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # aws_vpc_security_group_ingress_rule / egress_rule need 5.x
    }
  }
}
