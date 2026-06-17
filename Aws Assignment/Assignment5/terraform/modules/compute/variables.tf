# =====================================================================
# COMPUTE MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used for the bastion and app instances"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for the app / ASG instances"
  type        = string
  default     = "c7i-flex.large"
}

variable "public_subnet_id" {
  description = "Public subnet ID where the bastion is launched"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs the ASG spreads instances across"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for the app instances"
  type        = string
}

variable "app_tg_arn" {
  description = "ARN of the OpenSearch target group"
  type        = string
}

variable "dashboards_tg_arn" {
  description = "ARN of the Dashboards target group"
  type        = string
}

# ---- Name / tag overrides ----
variable "bastion_name_tag" {
  description = "Name tag for the bastion host instance"
  type        = string
  default     = "Bastion-Host"
}

variable "app_instance_name_tag" {
  description = "Name tag for ASG-launched app instances"
  type        = string
  default     = "App-ASG-Instance"
}

variable "lt_name_prefix" {
  description = "Name prefix for the launch template"
  type        = string
  default     = "app-LT"
}

variable "lt_name_tag" {
  description = "Name tag for the launch template resource"
  type        = string
  default     = "App-Launch-Template"
}

variable "asg_name" {
  description = "Name for the Auto Scaling Group"
  type        = string
  default     = "app-asg"
}

# ---- Bastion settings ----
variable "bastion_associate_public_ip" {
  description = "Whether to assign a public IP to the bastion host"
  type        = bool
  default     = true
}

# ---- ASG settings ----
variable "asg_min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_health_check_type" {
  description = "Health check type for the ASG (EC2 or ELB)"
  type        = string
  default     = "ELB"
}

variable "asg_health_check_grace_period" {
  description = "Grace period in seconds before the ASG starts health checks"
  type        = number
  default     = 600
}

# ---- EBS / launch template settings ----
variable "root_volume_size" {
  description = "Root EBS volume size in GiB for app instances"
  type        = number
  default     = 30
}

variable "ebs_volume_type" {
  description = "EBS volume type for the root device"
  type        = string
  default     = "gp3"
}

variable "ebs_device_name" {
  description = "Root device name (e.g. /dev/sda1 for Ubuntu, /dev/xvda for Amazon Linux)"
  type        = string
  default     = "/dev/sda1"
}

variable "ebs_delete_on_termination" {
  description = "Whether to delete the root EBS volume on instance termination"
  type        = bool
  default     = true
}

# ---- OpenSearch / userdata settings ----
variable "opensearch_version" {
  description = "OpenSearch version to install on app instances"
  type        = string
  default     = "2.19.1"
}

variable "opensearch_admin_password" {
  description = "Initial admin password for OpenSearch (sensitive)"
  type        = string
  sensitive   = true
}
