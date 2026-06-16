# =====================================================================
# ROOT MODULE
# All configurable values come from terraform.tfvars → variables.tf.
# No literals appear here; every argument references a variable or a
# module output.
# =====================================================================

# ---------------------------------------------------------------------
# VPC + Internet Gateway
# ---------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project              = var.project
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  igw_name             = var.igw_name
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

# ---------------------------------------------------------------------
# Public + private subnets
# ---------------------------------------------------------------------
module "subnets" {
  source = "./modules/subnets"

  project                    = var.project
  vpc_id                     = module.vpc.vpc_id
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  availability_zones         = var.availability_zones
  map_public_ip_on_launch    = var.map_public_ip_on_launch
  public_subnet_name_prefix  = var.public_subnet_name_prefix
  private_subnet_name_prefix = var.private_subnet_name_prefix
}

# ---------------------------------------------------------------------
# Elastic IP + NAT Gateway
# ---------------------------------------------------------------------
module "nat" {
  source = "./modules/nat"

  project          = var.project
  public_subnet_id = module.subnets.public_subnet_ids[0]
  eip_domain       = var.eip_domain
  eip_name         = var.eip_name
  nat_name         = var.nat_name

  depends_on = [module.vpc]
}

# ---------------------------------------------------------------------
# Route tables + associations
# ---------------------------------------------------------------------
module "routing" {
  source = "./modules/routing"

  project            = var.project
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  nat_gateway_id     = module.nat.nat_gateway_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  public_route_cidr  = var.public_route_cidr
  private_route_cidr = var.private_route_cidr
  public_rt_name     = var.public_rt_name
  private_rt_name    = var.private_rt_name
}

# ---------------------------------------------------------------------
# Network ACLs
# ---------------------------------------------------------------------
module "nacl" {
  source = "./modules/nacl"

  project                   = var.project
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr                  = module.vpc.vpc_cidr
  public_subnet_ids         = module.subnets.public_subnet_ids
  private_subnet_ids        = module.subnets.private_subnet_ids
  public_nacl_name          = var.public_nacl_name
  private_nacl_name         = var.private_nacl_name
  public_nacl_ingress_rules = var.public_nacl_ingress_rules
  public_nacl_egress_rules  = var.public_nacl_egress_rules
  private_nacl_ingress_rules = var.private_nacl_ingress_rules
  private_nacl_egress_rules = var.private_nacl_egress_rules
}

# ---------------------------------------------------------------------
# Security Groups
# ---------------------------------------------------------------------
module "security" {
  source = "./modules/security"

  project                    = var.project
  vpc_id                     = module.vpc.vpc_id
  vpc_cidr                   = module.vpc.vpc_cidr
  alb_sg_name                = var.alb_sg_name
  alb_sg_description         = var.alb_sg_description
  bastion_sg_name            = var.bastion_sg_name
  bastion_sg_description     = var.bastion_sg_description
  app_sg_name                = var.app_sg_name
  app_sg_description         = var.app_sg_description
  public_cidr_blocks         = var.public_cidr_blocks
  egress_cidr_blocks         = var.egress_cidr_blocks
  http_port                  = var.http_port
  https_port                 = var.https_port
  ssh_port                   = var.ssh_port
  opensearch_api_port        = var.opensearch_api_port
  opensearch_dashboards_port = var.opensearch_dashboards_port
  opensearch_cluster_port    = var.opensearch_cluster_port
}

# ---------------------------------------------------------------------
# Application Load Balancer
# ---------------------------------------------------------------------
module "alb" {
  source = "./modules/alb"

  project                       = var.project
  vpc_id                        = module.vpc.vpc_id
  public_subnet_ids             = module.subnets.public_subnet_ids
  alb_sg_id                     = module.security.alb_sg_id
  alb_name                      = var.alb_name
  alb_internal                  = var.alb_internal
  alb_name_tag                  = var.alb_name_tag
  opensearch_listener_port      = var.opensearch_listener_port
  opensearch_tg_port            = var.opensearch_tg_port
  opensearch_tg_protocol        = var.opensearch_tg_protocol
  opensearch_health_path        = var.opensearch_health_path
  opensearch_health_protocol    = var.opensearch_health_protocol
  opensearch_health_matcher     = var.opensearch_health_matcher
  dashboards_listener_port      = var.dashboards_listener_port
  dashboards_tg_port            = var.dashboards_tg_port
  dashboards_tg_protocol        = var.dashboards_tg_protocol
  dashboards_health_path        = var.dashboards_health_path
  dashboards_health_protocol    = var.dashboards_health_protocol
  dashboards_health_matcher     = var.dashboards_health_matcher
  dashboards_stickiness_enabled = var.dashboards_stickiness_enabled
  dashboards_cookie_duration    = var.dashboards_cookie_duration
  health_check_interval         = var.health_check_interval
  health_check_timeout          = var.health_check_timeout
  healthy_threshold             = var.healthy_threshold
  unhealthy_threshold           = var.unhealthy_threshold
}

# ---------------------------------------------------------------------
# Compute (bastion + launch template + ASG)
# ---------------------------------------------------------------------
module "compute" {
  source = "./modules/compute"

  project                       = var.project
  ami_id                        = var.ami_id
  key_name                      = var.key_name
  bastion_instance_type         = var.bastion_instance_type
  app_instance_type             = var.app_instance_type
  public_subnet_id              = module.subnets.public_subnet_ids[0]
  private_subnet_ids            = module.subnets.private_subnet_ids
  bastion_sg_id                 = module.security.bastion_sg_id
  app_sg_id                     = module.security.app_sg_id
  app_tg_arn                    = module.alb.app_tg_arn
  dashboards_tg_arn             = module.alb.dashboards_tg_arn
  bastion_name_tag              = var.bastion_name_tag
  app_instance_name_tag         = var.app_instance_name_tag
  lt_name_prefix                = var.lt_name_prefix
  lt_name_tag                   = var.lt_name_tag
  asg_name                      = var.asg_name
  bastion_associate_public_ip   = var.bastion_associate_public_ip
  asg_min_size                  = var.asg_min_size
  asg_max_size                  = var.asg_max_size
  asg_desired_capacity          = var.asg_desired_capacity
  asg_health_check_type         = var.asg_health_check_type
  asg_health_check_grace_period = var.asg_health_check_grace_period
  root_volume_size              = var.root_volume_size
  ebs_volume_type               = var.ebs_volume_type
  ebs_device_name               = var.ebs_device_name
  ebs_delete_on_termination     = var.ebs_delete_on_termination
  opensearch_version            = var.opensearch_version
  opensearch_admin_password     = var.opensearch_admin_password
}

# ---------------------------------------------------------------------
# Remote State Bucket
# ---------------------------------------------------------------------
module "s3" {
  source = "./modules/s3"

  project                 = var.project
  bucket_name             = var.state_bucket_name
  bucket_name_tag         = var.bucket_name_tag
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# ---------------------------------------------------------------------
# Remote State Bucket
# ---------------------------------------------------------------------
module "dynamodb" {
  source                  = "./modules/dynamodb"
  table_name              = var.table_name
  hash_key                = var.hash_key
  lock_table_tag          = var.lock_table_tag
}