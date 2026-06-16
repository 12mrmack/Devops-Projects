# =====================================================================
# SUBNETS MODULE - OUTPUTS
# =====================================================================

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private (app) subnet IDs"
  value       = aws_subnet.private[*].id
}
