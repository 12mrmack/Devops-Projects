# =====================================================================
# S3 MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "bucket_name" {
  description = "Globally-unique name for the state bucket"
  type        = string
}

variable "bucket_name_tag" {
  description = "Name tag value for the S3 bucket"
  type        = string
  default     = "My-terraform-Assignment-bucket"
}

variable "block_public_acls" {
  description = "Block public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket access"
  type        = bool
  default     = true
}
