# alb module

Small Terraform module for an AWS ALB/NLB. Trimmed down from terraform-aws-modules/terraform-aws-alb to only what we use.

Creates: load balancer, listeners, target groups. Listener rules and target group attachments are created only when you ask for them.

Doesn't create: security group (pass your own), Route53, WAF, Lambda permission, extra SNI certs.

Needs Terraform >= 1.3 and AWS provider >= 5.0.

## Usage

```hcl
module "alb" {
  source = "./modules/alb"

  name            = "my-alb"
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = [var.sg_id]

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.cert_arn
      forward         = { target_group_key = "app" }
    }
  }

  target_groups = {
    app = { port = 8080 }
  }
}
```

More examples (redirect, rules, attachment) in `example.tf.txt`.

## Inputs

Required: `name`, `vpc_id`, `subnets`

Common optional ones:
- `security_groups` - existing SG ids, default `[]`
- `listeners` - map of listeners, each can have `rules`. Set one of `forward`, `redirect` or `fixed_response` as the default action
- `target_groups` - map of target groups. `create_attachment = true` registers `target_id`, default is `false`
- `internal`, `load_balancer_type`, `idle_timeout`, `enable_deletion_protection`, `access_logs`
- `default_port` / `default_protocol` - fallbacks (80 / HTTP)
- `tags`, `create`

Everything else and the defaults are in `variables.tf`.

## Outputs

`lb_id`, `lb_arn`, `lb_arn_suffix`, `lb_dns_name`, `lb_zone_id`, `listener_arns`, `listener_rule_arns`, `target_group_arns`, `target_group_arn_suffixes`
