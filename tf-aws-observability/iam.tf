data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "canary" {
  count = var.enable_synthetics ? 1 : 0

  statement {
    sid       = "ArtifactsReadWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.canary[0].arn}/canary/*"]
  }

  statement {
    sid       = "ArtifactsBucketLocation"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation"]
    resources = [aws_s3_bucket.canary[0].arn]
  }

  statement {
    sid    = "CanaryLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cwsyn-${var.canary_name}-*",
    ]
  }

  statement {
    sid       = "ListBucketsAndTracing"
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets", "xray:PutTraceSegments"]
    resources = ["*"]
  }

  statement {
    sid       = "PutCanaryMetrics"
    effect    = "Allow"
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["CloudWatchSynthetics"]
    }
  }
}

resource "aws_iam_policy" "canary" {
  count = var.enable_synthetics ? 1 : 0

  name        = "${var.name}-canary"
  description = "CloudWatch Synthetics canary permissions"
  policy      = data.aws_iam_policy_document.canary[0].json

  tags = var.tags
}

resource "aws_iam_role" "canary" {
  count = var.enable_synthetics ? 1 : 0

  name = "${var.name}-canary"
  path = "/system/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "canary" {
  count = var.enable_synthetics ? 1 : 0

  role       = aws_iam_role.canary[0].name
  policy_arn = aws_iam_policy.canary[0].arn
}