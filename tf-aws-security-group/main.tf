resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = var.name },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}


# Ingress

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  referenced_security_group_id = each.value.referenced_security_group_id
  description = each.value.description != null ? each.value.description : each.key
}


# Egress

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  referenced_security_group_id = each.value.referenced_security_group_id
  description = each.value.description != null ? each.value.description : each.key
}

