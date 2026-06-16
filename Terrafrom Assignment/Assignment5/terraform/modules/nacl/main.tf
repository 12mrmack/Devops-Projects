# =====================================================================
# NACL MODULE
# Public and private network ACLs attached to their subnets.
# =====================================================================

locals {
  private_nacl_ingress_resolved = [
    for rule in var.private_nacl_ingress_rules : {
      rule_no    = rule.rule_no
      protocol   = rule.protocol
      action     = rule.action
      cidr_block = rule.use_vpc_cidr ? var.vpc_cidr : rule.cidr_block
      from_port  = rule.from_port
      to_port    = rule.to_port
    }
  ]
}

resource "aws_network_acl" "public_nacl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  dynamic "ingress" {
    for_each = var.public_nacl_ingress_rules
    content {
      rule_no    = ingress.value.rule_no
      protocol   = ingress.value.protocol
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.public_nacl_egress_rules
    content {
      rule_no    = egress.value.rule_no
      protocol   = egress.value.protocol
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = {
    Name    = var.public_nacl_name
    Project = var.project
  }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  dynamic "ingress" {
    for_each = local.private_nacl_ingress_resolved
    content {
      rule_no    = ingress.value.rule_no
      protocol   = ingress.value.protocol
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.private_nacl_egress_rules
    content {
      rule_no    = egress.value.rule_no
      protocol   = egress.value.protocol
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = {
    Name    = var.private_nacl_name
    Project = var.project
  }
}
