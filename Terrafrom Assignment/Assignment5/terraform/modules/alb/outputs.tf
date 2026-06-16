# =====================================================================
# ALB MODULE - OUTPUTS
# =====================================================================

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB - use this to reach the app"
  value       = aws_lb.alb.dns_name
}

output "app_tg_arn" {
  description = "ARN of the OpenSearch (9200) target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "dashboards_tg_arn" {
  description = "ARN of the Dashboards (5601) target group"
  value       = aws_lb_target_group.dashboards_tg.arn
}
