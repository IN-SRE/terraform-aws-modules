################################################################################
# Locals
################################################################################

locals {
  # Flatten targets from all target groups into one map for attachment
  target_attachments = {
    for item in flatten([
      for tg_key, tg in var.target_groups : [
        for t in tg.targets : {
          key    = "${tg_key}-${t.id}-${coalesce(t.port, tg.port)}"
          tg_key = tg_key
          id     = t.id
          port   = t.port
        }
      ]
    ]) : item.key => item
  }
}

################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "this" {
  name                       = "${var.name}-alb"
  load_balancer_type         = "application"
  internal                   = var.internal
  subnets                    = var.subnets
  security_groups            = var.security_group_ids
  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout
  drop_invalid_header_fields = var.drop_invalid_header_fields

  tags = var.tags
}

################################################################################
# Target groups
################################################################################

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name                 = "${var.name}-${each.key}"
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = var.vpc_id
  target_type          = each.value.target_type
  deregistration_delay = each.value.deregistration_delay

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    protocol            = each.value.protocol
    matcher             = each.value.health_check_matcher
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
  }

  tags = var.tags
}


###############################################################################
# Target group attachment 
################################################################################

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.target_attachments

  target_group_arn = aws_lb_target_group.this[each.value.tg_key].arn
  target_id        = each.value.id
  port             = each.value.port
}

################################################################################
# Listeners
################################################################################

resource "aws_lb_listener" "this" {
  for_each = var.listeners
  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn = each.value.certificate_arn
  ssl_policy      = each.value.ssl_policy

  default_action {
    type = each.value.default_action_type
    target_group_arn = each.value.default_action_type == "forward" ? aws_lb_target_group.this[each.value.target_group_key].arn : null

    dynamic "redirect" {
      for_each = each.value.default_action_type == "redirect" ? [1] : []

      content {
        port        = each.value.redirect_port
        protocol    = each.value.redirect_protocol
        status_code = each.value.redirect_status_code
      }
    }
  }

  tags = var.tags
}


################################################################################
# Listener rules 
################################################################################


resource "aws_lb_listener_rule" "this" {
  for_each = var.listener_rules

  listener_arn = aws_lb_listener.this[each.value.listener_key].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  dynamic "condition" {
    for_each = length(each.value.path_patterns) > 0 ? [1] : []

    content {
      path_pattern {
        values = each.value.path_patterns
      }
    }
  }

  dynamic "condition" {
    for_each = length(each.value.host_headers) > 0 ? [1] : []

    content {
      host_header {
        values = each.value.host_headers
      }
    }
  }

  tags = var.tags
}