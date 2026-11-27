# Observability Module

Sets up CloudWatch alarms for an ALB and an Auto Scaling group, CIS monitoring alarms, and a Synthetics canary. Everything uses native `aws_*` resources, and each part can be turned off with its `enable_*` variable.

Alarms send to an existing SNS topic, which you pass in with `sns_topic_arn`. The module does not create one.

## Example

module "observability" {
  source = "./modules/observability"

  name          = "dev-app"
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:dev-alarms"

  alb_arn_suffix              = module.alb.lb_arn_suffix
  alb_target_group_arn_suffix = module.alb.target_group_arn_suffix["app"]

  asg_name = "dev-app-asg"

  canary_name     = "sswebsite2"
  canary_zip_file = "sswebsite2/sswebsite2v1.zip"
  canary_handler  = "sswebsite2.handler"
}
```

## Notes

- The canary alarm runs the ASG scale-out policy, so `enable_synthetics` needs `enable_asg_alarms` to be `true`.
- CIS filters only fire if CloudTrail sends its events to `cis_log_group_name`.
- The canary zip file has to exist on the machine running Terraform.
- CIS patterns follow v3.0.0. Check them against the benchmark before an audit.