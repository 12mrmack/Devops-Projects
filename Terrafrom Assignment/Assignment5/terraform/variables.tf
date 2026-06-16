# =====================================================================
# ROOT MODULE - INPUT VARIABLES
# All values are set in terraform.tfvars. Defaults are provided here
# as documentation of the canonical value; override per environment.
# =====================================================================

# ---- Provider ----
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

# ---- Shared ----
variable "project" {
  description = "Project tag applied to every resource"
  type        = string
  default     = "assignment04"
}

variable "env" {
  description = "Environment tag (dev / staging / prod)"
  type        = string
  default     = "dev"
}

# =====================================================================
# VPC MODULE
# =====================================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
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

# =====================================================================
# SUBNETS MODULE
# =====================================================================

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (index-aligned with availability_zones)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets (index-aligned with availability_zones)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones (index-aligned with subnet CIDR lists)"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IPs to instances launched in public subnets"
  type        = bool
  default     = true
}

variable "public_subnet_name_prefix" {
  description = "Name tag prefix for public subnets (index number is appended)"
  type        = string
  default     = "Public-Subnet-"
}

variable "private_subnet_name_prefix" {
  description = "Name tag prefix for private subnets (index number is appended)"
  type        = string
  default     = "App-Private-Subnet-"
}

# =====================================================================
# NAT MODULE
# =====================================================================

variable "eip_domain" {
  description = "Domain scope for the Elastic IP (vpc)"
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

# =====================================================================
# ROUTING MODULE
# =====================================================================

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

# =====================================================================
# NACL MODULE
# =====================================================================

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
  description = "Ingress rules for the private NACL. Set use_vpc_cidr = true to auto-substitute the VPC CIDR."
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

# =====================================================================
# SECURITY MODULE
# =====================================================================

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

variable "public_cidr_blocks" {
  description = "CIDR blocks allowed for public-facing ingress (HTTP, HTTPS, SSH, OpenSearch). Restrict to known IPs in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for security group egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

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

# =====================================================================
# ALB MODULE
# =====================================================================

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "app-alb"
}

variable "alb_internal" {
  description = "Whether the ALB is internal (false = internet-facing)"
  type        = bool
  default     = false
}

variable "alb_name_tag" {
  description = "Name tag for the ALB resource"
  type        = string
  default     = "App-ALB"
}

variable "opensearch_listener_port" {
  description = "Listener port for the OpenSearch target"
  type        = number
  default     = 9200
}

variable "opensearch_tg_port" {
  description = "Target port for the OpenSearch target group"
  type        = number
  default     = 9200
}

variable "opensearch_tg_protocol" {
  description = "Backend protocol for the OpenSearch target group"
  type        = string
  default     = "HTTPS"
}

variable "opensearch_health_path" {
  description = "Health check path for the OpenSearch target group"
  type        = string
  default     = "/_cluster/health"
}

variable "opensearch_health_protocol" {
  description = "Protocol used for OpenSearch health checks"
  type        = string
  default     = "HTTPS"
}

variable "opensearch_health_matcher" {
  description = "HTTP codes that indicate a healthy OpenSearch node"
  type        = string
  default     = "200,401"
}

variable "dashboards_listener_port" {
  description = "Listener port for the Dashboards target"
  type        = number
  default     = 5601
}

variable "dashboards_tg_port" {
  description = "Target port for the Dashboards target group"
  type        = number
  default     = 5601
}

variable "dashboards_tg_protocol" {
  description = "Backend protocol for the Dashboards target group"
  type        = string
  default     = "HTTP"
}

variable "dashboards_health_path" {
  description = "Health check path for the Dashboards target group"
  type        = string
  default     = "/api/status"
}

variable "dashboards_health_protocol" {
  description = "Protocol used for Dashboards health checks"
  type        = string
  default     = "HTTP"
}

variable "dashboards_health_matcher" {
  description = "HTTP codes that indicate a healthy Dashboards instance"
  type        = string
  default     = "200,302,401"
}

variable "dashboards_stickiness_enabled" {
  description = "Enable sticky sessions on the Dashboards target group"
  type        = bool
  default     = true
}

variable "dashboards_cookie_duration" {
  description = "Stickiness cookie duration in seconds for the Dashboards target group"
  type        = number
  default     = 86400
}

variable "health_check_interval" {
  description = "Health check interval in seconds (shared by both target groups)"
  type        = number
  default     = 300
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Consecutive successes before marking a target healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Consecutive failures before marking a target unhealthy"
  type        = number
  default     = 2
}

# =====================================================================
# COMPUTE MODULE
# =====================================================================

variable "ami_id" {
  description = "AMI ID for bastion and app instances"
  type        = string
  default     = "ami-0388e3ada3d9812da"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "batch34"
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

variable "bastion_name_tag" {
  description = "Name tag for the bastion host"
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

variable "bastion_associate_public_ip" {
  description = "Whether to assign a public IP to the bastion host"
  type        = bool
  default     = true
}

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
  description = "Grace period in seconds before ASG health checks begin"
  type        = number
  default     = 600
}

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
  description = "Root device name (/dev/sda1 for Ubuntu, /dev/xvda for Amazon Linux)"
  type        = string
  default     = "/dev/sda1"
}

variable "ebs_delete_on_termination" {
  description = "Delete root EBS volume when the instance is terminated"
  type        = bool
  default     = true
}

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

# =====================================================================
# S3 MODULE
# =====================================================================

variable "state_bucket_name" {
  description = "Globally-unique name for the Terraform state S3 bucket"
  type        = string
  default     = "my-terraform-assignment-bucket"
}

variable "bucket_name_tag" {
  description = "Name tag value for the S3 bucket"
  type        = string
  default     = "My-terraform-Assignment-bucket"
}

variable "block_public_acls" {
  description = "Block public ACLs on the state bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies on the state bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs on the state bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public access to the state bucket"
  type        = bool
  default     = true
}

# =====================================================================
# DynamoDb
# =====================================================================
variable "table_name" {
    description = "Lock table name"
    type        = string
    default     = "terraform-locks-table"
}
variable "hash_key" {
    description = "Lock table name"
    type        = string
    default     = "LockID"
}

variable "lock_table_tag" {
  type        = string
  default     = "Lock_table_tag"
  description = "tag for lock table"
}
