# =====================================================================
# SUBNETS MODULE
# Public and private subnets spread across the given AZs.
# =====================================================================

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name    = "${var.public_subnet_name_prefix}${count.index + 1}"
    Project = var.project
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "${var.private_subnet_name_prefix}${count.index + 1}"
    Project = var.project
  }
}
