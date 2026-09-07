# EC2 Autoscaling Module

Terraform module I built to provision an EC2 Auto Scaling Group — launch
template, IAM role/instance profile, ASG, and a few optional pieces
(target group attachment, SNS alerts, scheduled scaling, target tracking).

I looked at how `terraform-aws-modules/terraform-aws-autoscaling` structures
things and adapted a trimmed-down version for this project instead of building
everything from scratch.

## What it does

- Launch template with EBS config, monitoring, IMDSv2 enforced by default
- IAM role + instance profile
- ASG with configurable health checks
- SNS email alerts on scale events, scheduled scaling, target tracking policies (CPU / ALB request count)

## Example

```hcl
module "ec2_autoscaling" {
  source = "./modules/ec2-autoscaling"

  project     = "banking"
  environment = "prod"

  ami_id             = data.aws_ami.instance_ami.id
  instance_type      = "t3.medium"
  key_name           = "webapp-key"
  security_group_ids = [module.private_sg.security_group_id]
  user_data_path     = "${path.module}/webserver.sh"
  vpc_zone_identifiers = module.vpc.private_subnets

  min_size         = 2
  max_size         = 10
  desired_capacity = 2

  target_group_arns = [module.alb.target_groups["mytg1"].arn]

  enable_sns_notifications = true
  sns_subscription_emails  = ["platform-alerts@example.com"]

  tags = {
    Owner = "platform-team"
  }
}
```

## Notes

- IMDSv2 is enforced by default (`metadata_http_tokens = "required"`) —
  set to `optional` only if something legacy needs IMDSv1.
- If your org already manages IAM centrally, then IAM script require modification as it is static with IAM role.
- Scheduled scaling accepts either `recurrence` (cron) or a one-off
  `start_time`/`end_time` window.

## Why I built it this way

I wanted a single module I could reuse across my github projects instead of
copy-pasting ASG related blocks every time.

## Inputs / Outputs

See `variables.tf` and `outputs.tf` for the full list.