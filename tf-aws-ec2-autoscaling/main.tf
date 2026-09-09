
# Launch Template

resource "aws_launch_template" "this" {
  name = local.launch_template_name

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

   network_interfaces {
    associate_public_ip_address = var.public_ip
  }
  vpc_security_group_ids = var.security_group_ids

   # bootstrap script for the instance on first boot
  user_data = filebase64(var.user_data_path)

  iam_instance_profile {
    arn = local.instance_profile_arn
  }

  ebs_optimized            = var.ebs_optimized
  disable_api_stop         = var.disable_api_stop
  disable_api_termination  = var.disable_api_termination

  monitoring {
    enabled = var.monitoring_enabled
  }

 # forcing IMDSv2 - blocks SSRF attacks from stealing instance creds
  metadata_options {
    http_tokens   = var.metadata_http_tokens
    http_endpoint = var.metadata_endpoint_enabled
  }


   dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
      }
    }
  }
 

  tag_specifications {
    resource_type = "instance"
    tags          = local.instance_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}




# Auto Scaling Group

resource "aws_autoscaling_group" "this" {
  name = local.asg_name

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  force_delete              = var.force_delete
  vpc_zone_identifier        = var.vpc_zone_identifiers

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  instance_maintenance_policy {
    min_healthy_percentage = var.min_healthy_percentage
    max_healthy_percentage = var.max_healthy_percentage
  }

  timeouts {
    delete = var.asg_delete_timeout
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

