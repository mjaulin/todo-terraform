variable "default_tags" { type = "map" }
variable "app_name" {}
variable "app_port" {}
variable "app_healthcheck_path" {}
variable "app_healthcheck_status_code" {}
variable "app_path_pattern" { type = "list" }
variable "vpc_id" {}
variable "ecs_cluster_id" {}
variable "elb_lb_listener_arn" {}