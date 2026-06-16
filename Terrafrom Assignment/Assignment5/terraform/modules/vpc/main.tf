# =====================================================================
# VPC MODULE
# Core network container: the VPC and its Internet Gateway only.
# =====================================================================

resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name    = var.vpc_name
    Project = var.project
    Env     = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name    = var.igw_name
    Project = var.project
  }
}
