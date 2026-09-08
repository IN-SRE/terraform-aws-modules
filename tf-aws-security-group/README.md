# security-group

One module, any security group. Instead of maintaining separate sg-web / sg-db / sg-bastion modules that all do the same three things (create SG, attach ingress, attach egress), you call this one module repeatedly and just change the "ingress_rules" / "egress_rules" maps.


## Usage

```hcl
module "app_sg" {
  source = "./tf-aws-security-group"

  name        = "app"
  description = "app servers"
  vpc_id      = "vpc-0123456789"

  ingress_rules = {
    https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "prod"
  }
}
```

## A couple of things worth knowing

- Leave `egress_rules = {}` and the SG keeps AWS's default of allow-all-outbound. The second you add even one egress rule, only that traffic is allowed out - everything else gets blocked. Bit by this once, so it's called out in main.tf too.

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| name | SG name | string | n/a |
| name_prefix | Use name as prefix instead of exact name | bool | false |
| description | SG description | string | "Managed by Terraform" |
| vpc_id | VPC id | string | n/a |
| ingress_rules | Map of inbound rules | map(object) | {} |
| egress_rules | Map of outbound rules | map(object) | {} |
| tags | Tags for SG + all rules | map(string) | {} |

## Outputs

| Name | Description |
|---|---|
| security_group_id | SG id |
| security_group_arn | SG arn |
| security_group_name | SG name |
| ingress_rule_ids | map of rule key -> ingress rule id |
| egress_rule_ids | map of rule key -> egress rule id |
