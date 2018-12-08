provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
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

module "front" {
  source = "./modules/app"

  default_tags = "${local.default_tags}"
  region = "${var.region}"
  profile = "${var.profile}"

  app_name = "todo-frontend"
  app_version = "${var.version}"
  app_port = "80"
  app_path_pattern = [ "/*" ]
  app_healthcheck_path = "/"
  app_healthcheck_status_code = "200"
  app_desired_count = "1"
  app_memory = "512"
  app_cpu = "256"

  vpc_id = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.subnets-priv}"
  cluster_id = "${module.ecs.ecs_cluster_id}"
  lb_arn = "${module.lb.lb_arn}"
  lb_listener_arn = "${module.lb.lb_listener_arn}"
  lb_sg = "${module.lb.lb_sg}"
  lb_lr_priority = "2"
}

module "back" {
  source = "./modules/app"

  default_tags = "${local.default_tags}"
  region = "${var.region}"
  profile = "${var.profile}"

  app_name = "todo-backend"
  app_version = "${var.version}"
  app_port = "8080"
  app_path_pattern = [ "/api/*" ]
  app_healthcheck_path = "/api/health"
  app_healthcheck_status_code = "204"
  app_desired_count = "2"
  app_cpu = "512"
  app_memory = "1024"

  vpc_id = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.subnets-priv}"
  cluster_id = "${module.ecs.ecs_cluster_id}"
  lb_arn = "${module.lb.lb_arn}"
  lb_listener_arn = "${module.lb.lb_listener_arn}"
  lb_sg = "${module.lb.lb_sg}"
  lb_lr_priority = "1"
  task_role_arn = "${module.dynamodb.role-access-dynamodb-arn}"
}


output "elb-url" {
  value = "http://${module.lb.lb_public_dns_name}/"
}