# =====================================================================
# NACL MODULE - OUTPUTS
# =====================================================================

output "public_nacl_id" {
  description = "Public network ACL ID"
  value       = aws_network_acl.public_nacl.id
}

output "private_nacl_id" {
  description = "Private network ACL ID"
  value       = aws_network_acl.private_nacl.id
}
