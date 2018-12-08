variable "default_tags" { type = "map" }
variable "region" {}
variable "profile" {}

variable "app_name" {}
variable "app_version" {}
variable "app_port" {}
variable "app_desired_count" {}
variable "app_healthcheck_path" {}
variable "app_healthcheck_status_code" {}
variable "app_path_pattern" { type = "list" }
variable "app_memory" {}
variable "app_cpu" {}

variable "vpc_id" {}
variable "private_subnets" { type = "list"}
variable "lb_arn" {}
variable "lb_listener_arn" {}
variable "lb_sg" {}
variable "lb_lr_priority" {}
variable "cluster_id" {}
variable "task_role_arn" { default = "" }
