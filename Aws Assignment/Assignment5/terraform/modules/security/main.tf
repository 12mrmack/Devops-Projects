# =====================================================================
# SECURITY MODULE
# alb-sg, bastion-sg, app-sg
# =====================================================================

# ---------------------------------------------------------------------
# alb-sg
# ---------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.public_cidr_blocks
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = var.public_cidr_blocks
  }

  ingress {
    description = "OpenSearch Dashboards ${var.opensearch_dashboards_port} from internet"
    from_port   = var.opensearch_dashboards_port
    to_port     = var.opensearch_dashboards_port
    protocol    = "tcp"
    cidr_blocks = var.public_cidr_blocks
  }

  ingress {
    description = "OpenSearch REST API ${var.opensearch_api_port} from internet"
    from_port   = var.opensearch_api_port
    to_port     = var.opensearch_api_port
    protocol    = "tcp"
    cidr_blocks = var.public_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name    = var.alb_sg_name
    Project = var.project
  }
}

# ---------------------------------------------------------------------
# bastion-sg
# ---------------------------------------------------------------------
resource "aws_security_group" "bastion_sg" {
  name        = var.bastion_sg_name
  description = var.bastion_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.public_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name    = var.bastion_sg_name
    Project = var.project
  }
}

# ---------------------------------------------------------------------
# app-sg
# ---------------------------------------------------------------------
resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "OpenSearch REST API ${var.opensearch_api_port} from ALB"
    from_port       = var.opensearch_api_port
    to_port         = var.opensearch_api_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "OpenSearch REST API ${var.opensearch_api_port} from Bastion"
    from_port       = var.opensearch_api_port
    to_port         = var.opensearch_api_port
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "OpenSearch node-to-node ${var.opensearch_cluster_port} within VPC"
    from_port   = var.opensearch_cluster_port
    to_port     = var.opensearch_cluster_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description     = "OpenSearch Dashboards ${var.opensearch_dashboards_port} from ALB"
    from_port       = var.opensearch_dashboards_port
    to_port         = var.opensearch_dashboards_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "HTTP from ALB"
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name    = var.app_sg_name
    Project = var.project
  }
}
