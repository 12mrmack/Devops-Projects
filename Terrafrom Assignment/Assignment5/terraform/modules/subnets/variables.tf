# =====================================================================
# SUBNETS MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the subnets belong to"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private (app) subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "AZs (index-aligned with the subnet CIDR lists)"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IPs to instances in public subnets"
  type        = bool
  default     = true
}

variable "public_subnet_name_prefix" {
  description = "Name tag prefix for public subnets (index is appended)"
  type        = string
  default     = "Public-Subnet-"
}

variable "private_subnet_name_prefix" {
  description = "Name tag prefix for private subnets (index is appended)"
  type        = string
  default     = "App-Private-Subnet-"
}
