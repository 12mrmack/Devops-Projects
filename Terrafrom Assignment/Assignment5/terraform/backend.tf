terraform {
  backend "s3" {
    bucket = "my-terraform-assignment-bucket2"
    key    = "assignment04/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-locks-table"
    encrypt = true
  }
}

