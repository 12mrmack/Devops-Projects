# =====================================================================
# ROOT MODULE - OUTPUTS
# =====================================================================

output "vpc_id" {
  description = "App VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS - use this to reach the app"
  value       = module.alb.alb_dns_name
}

output "bastion_public_ip" {
  description = "Bastion Host public IP"
  value       = module.compute.bastion_public_ip
}

output "state_bucket" {
  description = "S3 bucket holding tfstate"
  value       = module.s3.state_bucket
}

output "dynamodb_table" {
  description = "DynamoDB table name"
  value = module.dynamodb.dynamodb_table
}
