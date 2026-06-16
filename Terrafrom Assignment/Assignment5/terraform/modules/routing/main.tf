# =====================================================================
# ROUTING MODULE
# Public route table (-> IGW) and private route table (-> NAT),
# plus their subnet associations.
# =====================================================================

# ---- Public route table ----
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.public_route_cidr
    gateway_id = var.igw_id
  }

  tags = {
    Name    = var.public_rt_name
    Project = var.project
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}

# ---- Private route table ----
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = var.private_route_cidr
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name    = var.private_rt_name
    Project = var.project
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_rt.id
}
