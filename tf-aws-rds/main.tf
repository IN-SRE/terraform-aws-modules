# IAM role for enhanced monitoring
resource "aws_iam_role" "monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name = "${var.identifier}-rds-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  role       = aws_iam_role.monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# CloudWatch log groups (must match the names RDS writes to)
resource "aws_cloudwatch_log_group" "this" {
  for_each = toset(var.create_cloudwatch_log_group ? var.enabled_cloudwatch_logs_exports : [])

  name              = "/aws/rds/instance/${var.identifier}/${each.key}"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(var.tags, var.cloudwatch_log_group_tags)
}

# Parameter group
resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.identifier}-"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.identifier}"

  dynamic "parameter" {
    for_each = { for p in var.parameters : p.name => p }

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, var.db_parameter_group_tags)
}

# Option group
resource "aws_db_option_group" "this" {
  name_prefix              = "${var.identifier}-"
  option_group_description = "Option group for ${var.identifier}"
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, var.db_option_group_tags)
}

# DB instance
resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted

  db_name             = var.db_name
  username            = var.username
  password            = var.password
  port                = var.port

  # manage_master_user_password = false

  multi_az               = var.multi_az
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = aws_db_parameter_group.this.name
  option_group_name      = aws_db_option_group.this.name
  publicly_accessible    = false

  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  copy_tags_to_snapshot   = true

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"
  deletion_protection       = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.monitoring[0].arn : null

  depends_on = [aws_cloudwatch_log_group.this]

  tags = merge(var.tags, var.db_instance_tags)
}