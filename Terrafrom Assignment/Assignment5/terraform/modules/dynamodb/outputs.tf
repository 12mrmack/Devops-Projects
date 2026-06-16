output "dynamodb_table" {
  description = "DynamoDB table name"
  value = aws_dynamodb_table.terraform_locks.name
}