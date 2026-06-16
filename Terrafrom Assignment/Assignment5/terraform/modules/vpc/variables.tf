# =====================================================================
# VPC MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "env" {
  description = "Environment tag (dev / staging / prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "App-VPC"
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "App-IGW"
}
