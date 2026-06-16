# =====================================================================
# ALB MODULE - INPUT VARIABLES
# =====================================================================

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs the ALB is placed in"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

# ---- ALB ----
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

# ---- OpenSearch (9200) listener + target group ----
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
  description = "HTTP status codes that indicate a healthy OpenSearch node"
  type        = string
  default     = "200,401"
}

# ---- OpenSearch Dashboards (5601) listener + target group ----
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
  description = "HTTP status codes that indicate a healthy Dashboards instance"
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

# ---- Shared health check settings ----
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
