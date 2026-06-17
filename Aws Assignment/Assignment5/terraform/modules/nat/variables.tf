# =====================================================================
# NAT MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID the NAT gateway is placed in"
  type        = string
}

variable "eip_domain" {
  description = "Domain for the Elastic IP (vpc for VPC-scoped EIPs)"
  type        = string
  default     = "vpc"
}

variable "eip_name" {
  description = "Name tag for the NAT Elastic IP"
  type        = string
  default     = "NAT-EIP"
}

variable "nat_name" {
  description = "Name tag for the NAT Gateway"
  type        = string
  default     = "NAT-Gateway"
}
