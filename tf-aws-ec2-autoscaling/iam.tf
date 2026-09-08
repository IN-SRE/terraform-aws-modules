
# IAM Role & Instance Profile for EC2

data "aws_iam_policy_document" "ec2_assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.iam_role_name
  assume_role_policy   = data.aws_iam_policy_document.ec2_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.iam_role_managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  name = local.iam_instance_profile_name
  role = aws_iam_role.this.name

  tags = local.common_tags
}

locals {
 instance_profile_arn = aws_iam_instance_profile.this.arn
}
