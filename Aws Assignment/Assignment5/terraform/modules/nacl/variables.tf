# =====================================================================
# NACL MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (auto-substituted into rules with use_vpc_cidr = true)"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs the public NACL is attached to"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs the private NACL is attached to"
  type        = list(string)
}

variable "public_nacl_name" {
  description = "Name tag for the public NACL"
  type        = string
  default     = "Public-NACL"
}

variable "private_nacl_name" {
  description = "Name tag for the private NACL"
  type        = string
  default     = "Private-NACL"
}

variable "public_nacl_ingress_rules" {
  description = "Ingress rules for the public NACL"
  type = list(object({
    rule_no    = number
    protocol   = string
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
  default = [
    { rule_no = 100, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 80,   to_port = 80    },
    { rule_no = 110, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 443,  to_port = 443   },
    { rule_no = 120, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 22,   to_port = 22    },
    { rule_no = 130, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
  ]
}

variable "public_nacl_egress_rules" {
  description = "Egress rules for the public NACL"
  type = list(object({
    rule_no    = number
    protocol   = string
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
  default = [
    { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
  ]
}

variable "private_nacl_ingress_rules" {
  description = "Ingress rules for the private NACL. Set use_vpc_cidr = true to automatically use the VPC CIDR block."
  type = list(object({
    rule_no      = number
    protocol     = string
    action       = string
    cidr_block   = optional(string)
    use_vpc_cidr = optional(bool, false)
    from_port    = number
    to_port      = number
  }))
  default = [
    { rule_no = 100, protocol = "-1",  action = "allow", use_vpc_cidr = true,                             from_port = 0,    to_port = 0     },
    { rule_no = 110, protocol = "tcp", action = "allow", use_vpc_cidr = false, cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
  ]
}

variable "private_nacl_egress_rules" {
  description = "Egress rules for the private NACL"
  type = list(object({
    rule_no    = number
    protocol   = string
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
  default = [
    { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
  ]
}
