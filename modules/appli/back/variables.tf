variable "default_tags" { type = "map" }
variable "ecr_repository_arn" {}
variable "version" { default = "latest" }
variable "cluster_id" {}
variable "lb_tg_arn" {}