# =====================================================================
# ROUTING MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID for the public default route"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID for the private default route"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs to associate with the public route table"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to associate with the private route table"
  type        = list(string)
}

variable "public_route_cidr" {
  description = "Destination CIDR for the public default route (via IGW)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_route_cidr" {
  description = "Destination CIDR for the private default route (via NAT)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_rt_name" {
  description = "Name tag for the public route table"
  type        = string
  default     = "Public-RT"
}

variable "private_rt_name" {
  description = "Name tag for the private route table"
  type        = string
  default     = "Private-RT"
}
