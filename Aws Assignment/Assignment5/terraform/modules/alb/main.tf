# =====================================================================
# ALB MODULE
# Application Load Balancer, listeners and target groups
# =====================================================================

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name    = var.alb_name_tag
    Project = var.project
  }
}

# ---------------------------------------------------------------------
# OpenSearch listener + target group
# ---------------------------------------------------------------------
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.opensearch_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name_prefix = "apptg-"
  port        = var.opensearch_tg_port
  protocol    = var.opensearch_tg_protocol
  vpc_id      = var.vpc_id

  health_check {
    path                = var.opensearch_health_path
    protocol            = var.opensearch_health_protocol
    matcher             = var.opensearch_health_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------
# OpenSearch Dashboards listener + target group
# ---------------------------------------------------------------------
resource "aws_lb_listener" "dashboards_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.dashboards_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboards_tg.arn
  }
}

resource "aws_lb_target_group" "dashboards_tg" {
  name_prefix = "dastg-"
  port        = var.dashboards_tg_port
  protocol    = var.dashboards_tg_protocol
  vpc_id      = var.vpc_id

  health_check {
    path                = var.dashboards_health_path
    protocol            = var.dashboards_health_protocol
    matcher             = var.dashboards_health_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.dashboards_cookie_duration
    enabled         = var.dashboards_stickiness_enabled
  }

  lifecycle {
    create_before_destroy = true
  }
}
