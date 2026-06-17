# =====================================================================
# SECURITY MODULE - OUTPUTS
# =====================================================================

output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "Security group ID for the Bastion host"
  value       = aws_security_group.bastion_sg.id
}

output "app_sg_id" {
  description = "Security group ID for the app instances"
  value       = aws_security_group.app_sg.id
}
