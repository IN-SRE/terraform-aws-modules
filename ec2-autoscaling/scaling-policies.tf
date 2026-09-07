
# Target Tracking Scaling Policies


resource "aws_autoscaling_policy" "target_tracking" {
  for_each = var.target_tracking_policies

  name                      = "${local.name_prefix}-${each.key}"
  autoscaling_group_name    = aws_autoscaling_group.this.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = each.value.estimated_instance_warmup

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = each.value.predefined_metric_type
      resource_label          = each.value.resource_label
    }

    target_value     = each.value.target_value
    disable_scale_in = each.value.disable_scale_in
  }
}
