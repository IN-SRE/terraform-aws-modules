locals {
  name_prefix = "${var.project}-${var.environment}-${var.component}"

  launch_template_name = "${local.name_prefix}-lt"
  asg_name              = "${local.name_prefix}-asg"
  iam_role_name         = "${local.name_prefix}-ec2-role"
  iam_instance_profile_name = "${local.name_prefix}-ec2-instance-profile"
  sns_topic_name        = "${local.name_prefix}-asg-notifications"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "ec2-autoscaling"
    },
    var.tags
  )

  instance_tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance"
    }
  )
}
