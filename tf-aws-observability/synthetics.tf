

resource "aws_s3_bucket" "canary" {
  count = var.enable_synthetics ? 1 : 0

  bucket = local.canary_bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "canary" {
  count = var.enable_synthetics ? 1 : 0

  bucket                  = aws_s3_bucket.canary[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "canary" {
  count = var.enable_synthetics ? 1 : 0

  bucket = aws_s3_bucket.canary[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "canary" {
  count = var.enable_synthetics ? 1 : 0

  depends_on = [aws_s3_bucket_ownership_controls.canary]

  bucket = aws_s3_bucket.canary[0].id
  acl    = "private"
}

resource "aws_synthetics_canary" "this" {
  count = var.enable_synthetics ? 1 : 0

  name                 = var.canary_name
  artifact_s3_location = "s3://${aws_s3_bucket.canary[0].id}/canary"
  execution_role_arn   = aws_iam_role.canary[0].arn
  handler              = var.canary_handler
  zip_file             = var.canary_zip_file
  runtime_version      = var.canary_runtime_version
  start_canary         = true

  run_config {
    active_tracing     = true
    memory_in_mb       = var.canary_memory_in_mb
    timeout_in_seconds = var.canary_timeout_in_seconds
  }

  schedule {
    expression = var.canary_schedule
  }

  depends_on = [aws_iam_role_policy_attachment.canary]

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "canary_success" {
  count = var.enable_synthetics ? 1 : 0

  alarm_name          = "${var.name}-${var.canary_name}-success"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.canary_success_evaluation_periods
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = var.canary_success_period
  statistic           = "Average"
  threshold           = var.canary_success_threshold
  alarm_description   = "Canary SuccessPercent is below ${var.canary_success_threshold}"

  dimensions = {
    CanaryName = aws_synthetics_canary.this[0].name
  }

  # Same as your script: the scale-out policy runs on alarm, SNS gets the OK notice.
  alarm_actions = [aws_autoscaling_policy.scale_out[0].arn]
  ok_actions    = [var.sns_topic_arn]

  lifecycle {
    precondition {
      condition     = var.enable_asg_alarms
      error_message = "enable_synthetics requires enable_asg_alarms = true, because the canary alarm triggers the ASG scale-out policy."
    }
  }

  tags = var.tags
}