
# Scheduled Scaling Actions (optional)


resource "aws_autoscaling_schedule" "this" {
  for_each = var.scheduled_actions

  scheduled_action_name  = each.key
  autoscaling_group_name = aws_autoscaling_group.this.name

  min_size         = each.value.min_size
  max_size         = each.value.max_size
  desired_capacity = each.value.desired_capacity

  start_time = each.value.start_time
  end_time   = each.value.end_time
  recurrence = each.value.recurrence
  time_zone  = each.value.time_zone
}
