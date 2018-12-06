provider "aws" {
  region = "${var.region}"
  profile = "onepoint-lab"
  version = "~> 1.2"
}

provider "template" {
  version = "1.0"
}

module "vpc" {
  source = "./modules/vpc"

  default_tags = "${local.default_tags}"
  availability_zones = "${var.availability_zones}"
  cidr_block = "${var.cidr_block}"
}

module "lb" {
  source = "./modules/lb"

  default_tags = "${local.default_tags}"
  vpc_id = "${module.vpc.vpc_id}"
  subnets = "${module.vpc.subnets-pub}"
}

module "ecs" {
  source = "./modules/ecs"

  default_tags = "${local.default_tags}"
}

module "dynamodb" {
  source = "./modules/dynamodb"

  default_tags = "${local.default_tags}"
  table_name = "Task"
}

module "back" {
  source = "./modules/appli"

  default_tags = "${local.default_tags}"
  app_name = "back"
  app_port = "8080"
  app_path_pattern = [ "/api/*" ]
  app_healthcheck_path = "/api/health"
  app_healthcheck_status_code = "204"
  vpc_id = "${module.vpc.vpc_id}"
  ecs_cluster_id = "${module.ecs.ecs_cluster_id}"
  elb_lb_listener_arn = "${module.lb.elb_arn}"
}

output "elb-url" {
  value = "http://${module.lb.elb_public_dns_name}/"
}