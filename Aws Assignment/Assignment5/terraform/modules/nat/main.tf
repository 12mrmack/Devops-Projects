# =====================================================================
# NAT MODULE
# Elastic IP + NAT Gateway (placed in a public subnet).
# Ordering against the IGW is handled at the root via depends_on.
# =====================================================================

resource "aws_eip" "nat_eip" {
  domain = var.eip_domain

  tags = {
    Name    = var.eip_name
    Project = var.project
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name    = var.nat_name
    Project = var.project
  }
}
