# =====================================================================
# S3 MODULE - OUTPUTS
# =====================================================================

output "state_bucket" {
  description = "Name of the S3 bucket holding tfstate"
  value       = aws_s3_bucket.tf_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the state bucket"
  value       = aws_s3_bucket.tf_state.arn
}

output "bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}