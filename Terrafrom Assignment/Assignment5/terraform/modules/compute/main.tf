# =====================================================================
# COMPUTE MODULE
# Bastion host, launch template and auto scaling group
# =====================================================================

# ---------------------------------------------------------------------
# BASTION HOST
# ---------------------------------------------------------------------
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = var.bastion_associate_public_ip
  key_name                    = var.key_name

  tags = {
    Name    = var.bastion_name_tag
    Project = var.project
  }
}

# ---------------------------------------------------------------------
# LAUNCH TEMPLATE
# ---------------------------------------------------------------------
resource "aws_launch_template" "app_lt" {
  name_prefix            = var.lt_name_prefix
  image_id               = var.ami_id
  instance_type          = var.app_instance_type
  vpc_security_group_ids = [var.app_sg_id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    opensearch_version = var.opensearch_version
    admin_password     = var.opensearch_admin_password
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = var.app_instance_name_tag
      Project = var.project
    }
  }

  block_device_mappings {
    device_name = var.ebs_device_name
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = var.ebs_delete_on_termination
    }
  }

  tags = {
    Name    = var.lt_name_tag
    Project = var.project
  }
}

# ---------------------------------------------------------------------
# AUTO SCALING GROUP
# ---------------------------------------------------------------------
resource "aws_autoscaling_group" "app_asg" {
  name                      = var.asg_name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  target_group_arns = [
    var.app_tg_arn,
    var.dashboards_tg_arn,
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.app_instance_name_tag
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }
}
