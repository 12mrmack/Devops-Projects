
# Remote state stored in S3
terraform {
  backend "s3" {
    bucket = "my-terraform-assignment-bucket"
    key    = "opensearch/terraform.tfstate"
    region = "ap-south-1"
  }
}
