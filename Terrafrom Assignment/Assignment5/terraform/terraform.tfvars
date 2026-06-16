# =====================================================================
# VARIABLE VALUES — single source of truth for all environments
# Change values here; never touch *.tf files for environment tuning.
# =====================================================================

# ---- Provider ----
aws_region = "ap-south-1"

# ---- Shared ----
project = "assignment04"
env     = "dev"

# =====================================================================
# VPC
# =====================================================================
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "App-VPC"
igw_name             = "App-IGW"
enable_dns_support   = true
enable_dns_hostnames = true

# =====================================================================
# SUBNETS
# =====================================================================
public_subnet_cidrs        = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs       = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones         = ["ap-south-1a", "ap-south-1b"]
map_public_ip_on_launch    = true
public_subnet_name_prefix  = "Public-Subnet-"
private_subnet_name_prefix = "App-Private-Subnet-"

# =====================================================================
# NAT GATEWAY
# =====================================================================
eip_domain = "vpc"
eip_name   = "NAT-EIP"
nat_name   = "NAT-Gateway"

# =====================================================================
# ROUTING
# =====================================================================
public_route_cidr  = "0.0.0.0/0"
private_route_cidr = "0.0.0.0/0"
public_rt_name     = "Public-RT"
private_rt_name    = "Private-RT"

# =====================================================================
# NETWORK ACLs
# =====================================================================
public_nacl_name  = "Public-NACL"
private_nacl_name = "Private-NACL"

public_nacl_ingress_rules = [
  { rule_no = 100, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 80,   to_port = 80    },
  { rule_no = 110, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 443,  to_port = 443   },
  { rule_no = 120, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 22,   to_port = 22    },
  { rule_no = 130, protocol = "tcp", action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
]

public_nacl_egress_rules = [
  { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
]

# use_vpc_cidr = true auto-substitutes the VPC CIDR at plan time
private_nacl_ingress_rules = [
  { rule_no = 100, protocol = "-1",  action = "allow", use_vpc_cidr = true,  from_port = 0,    to_port = 0     },
  { rule_no = 110, protocol = "tcp", action = "allow", use_vpc_cidr = false, cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
]

private_nacl_egress_rules = [
  { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
]

# =====================================================================
# SECURITY GROUPS
# =====================================================================
alb_sg_name            = "alb-sg"
alb_sg_description     = "Allow HTTP and HTTPS from internet to ALB"
bastion_sg_name        = "bastion-sg"
bastion_sg_description = "Allow SSH from internet to Bastion Host"
app_sg_name            = "app-sg"
app_sg_description     = "Allow traffic from ALB and Bastion to app instances and OpenSearch"

# Restrict to known CIDR(s) in production (e.g. ["203.0.113.0/24"])
public_cidr_blocks  = ["0.0.0.0/0"]
egress_cidr_blocks  = ["0.0.0.0/0"]

http_port                  = 80
https_port                 = 443
ssh_port                   = 22
opensearch_api_port        = 9200
opensearch_dashboards_port = 5601
opensearch_cluster_port    = 9300

# =====================================================================
# ALB
# =====================================================================
alb_name     = "app-alb1"
alb_internal = false
alb_name_tag = "App-ALB"

opensearch_listener_port   = 9200
opensearch_tg_port         = 9200
opensearch_tg_protocol     = "HTTPS"
opensearch_health_path     = "/_cluster/health"
opensearch_health_protocol = "HTTPS"
opensearch_health_matcher  = "200,401"

dashboards_listener_port      = 5601
dashboards_tg_port            = 5601
dashboards_tg_protocol        = "HTTP"
dashboards_health_path        = "/api/status"
dashboards_health_protocol    = "HTTP"
dashboards_health_matcher     = "200,302,401"
dashboards_stickiness_enabled = true
dashboards_cookie_duration    = 86400

health_check_interval = 300
health_check_timeout  = 5
healthy_threshold     = 2
unhealthy_threshold   = 2

# =====================================================================
# COMPUTE
# =====================================================================
ami_id                = "ami-0388e3ada3d9812da"
key_name              = "batch34"
bastion_instance_type = "t3.micro"
app_instance_type     = "c7i-flex.large"

bastion_name_tag      = "Bastion-Host"
app_instance_name_tag = "App-ASG-Instance"
lt_name_prefix        = "app-LT"
lt_name_tag           = "App-Launch-Template"
asg_name              = "app-asg1"

bastion_associate_public_ip   = true
asg_min_size                  = 1
asg_max_size                  = 3
asg_desired_capacity          = 1
asg_health_check_type         = "ELB"
asg_health_check_grace_period = 600

root_volume_size          = 30
ebs_volume_type           = "gp3"
ebs_device_name           = "/dev/sda1"
ebs_delete_on_termination = true

opensearch_version        = "2.19.1"
opensearch_admin_password = "@1234Mrmack"

# =====================================================================
# S3 (remote state bucket)
# =====================================================================
state_bucket_name       = "my-terraform-assignment-bucket2"
bucket_name_tag         = "My-terraform-Assignment-bucket"
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true


# =====================================================================
# DynamoDb
# =====================================================================
table_name              = "terraform-locks-table"
hash_key                = "LockID"
lock_table_tag          = "Lock_table_tag"
