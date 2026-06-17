# =====================================================================
# SECURITY MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the security groups belong to"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (used for in-VPC ingress rules)"
  type        = string
}

# ---- Security group names / descriptions ----
variable "alb_sg_name" {
  description = "Name for the ALB security group"
  type        = string
  default     = "alb-sg"
}

variable "alb_sg_description" {
  description = "Description for the ALB security group"
  type        = string
  default     = "Allow HTTP and HTTPS from internet to ALB"
}

variable "bastion_sg_name" {
  description = "Name for the bastion host security group"
  type        = string
  default     = "bastion-sg"
}

variable "bastion_sg_description" {
  description = "Description for the bastion security group"
  type        = string
  default     = "Allow SSH from internet to Bastion Host"
}

variable "app_sg_name" {
  description = "Name for the application security group"
  type        = string
  default     = "app-sg"
}

variable "app_sg_description" {
  description = "Description for the application security group"
  type        = string
  default     = "Allow traffic from ALB and Bastion to app instances and OpenSearch"
}

# ---- CIDR blocks ----
variable "public_cidr_blocks" {
  description = "CIDR blocks permitted for public-facing ingress rules (HTTP, HTTPS, SSH, OpenSearch)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for security group egress rules (allow all outbound by default)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ---- Ports ----
variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port"
  type        = number
  default     = 443
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "opensearch_api_port" {
  description = "OpenSearch REST API port"
  type        = number
  default     = 9200
}

variable "opensearch_dashboards_port" {
  description = "OpenSearch Dashboards UI port"
  type        = number
  default     = 5601
}

variable "opensearch_cluster_port" {
  description = "OpenSearch inter-node cluster communication port"
  type        = number
  default     = 9300
}
