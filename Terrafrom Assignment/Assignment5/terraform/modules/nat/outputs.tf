# =====================================================================
# NAT MODULE - OUTPUTS
# =====================================================================

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gw.id
}

output "nat_eip" {
  description = "Elastic IP address attached to the NAT gateway"
  value       = aws_eip.nat_eip.public_ip
}
