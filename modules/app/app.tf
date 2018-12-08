
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "template_file" "td" {
  template = "${file("${path.cwd}/app-template/${var.app_name}.json")}"

  vars {
    image = "${aws_ecr_repository.ecr.repository_url}:${var.app_version}"
    port = "${var.app_port}"
    region = "${var.region}"
    log-group = "${aws_cloudwatch_log_group.log-grp.name}"
    log-prefix = "${var.app_name}"
  }
}

resource "aws_ecs_task_definition" "ecs-task" {
  family                    = "aws_terraform_${var.app_name}"
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  container_definitions     = "${data.template_file.td.rendered}"
  execution_role_arn        = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  cpu                       = "${var.app_cpu}"
  memory                    = "${var.app_memory}"
  task_role_arn             = "${var.task_role_arn}"

  provisioner "local-exec" {
    working_dir = "../${var.app_name}/"
    command = "Powershell Invoke-Expression -Command (aws ecr --profile ${var.profile} get-login --no-include-email) && docker build -t ${aws_ecr_repository.ecr.repository_url}:${var.app_version} . && docker push ${aws_ecr_repository.ecr.repository_url}:${var.app_version}"
  }
}

resource "aws_security_group" "sg-app" {
  name   = "${replace(var.app_name, "-", "")}SecurityGroup"
  vpc_id = "${var.vpc_id}"

  ingress {
    description     = "HTTP"
    protocol        = "tcp"
    from_port       = "${var.app_port}"
    to_port         = "${var.app_port}"
    security_groups = [ "${var.lb_sg}" ]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map("Name", "sg-${var.app_name}"))}"
}

resource "aws_ecs_service" "ecs-service" {
  name            = "service-${var.app_name}"
  launch_type     = "FARGATE"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs-task.arn}"
  desired_count   = "${var.app_desired_count}"

  network_configuration {
    subnets = ["${var.private_subnets}"]
    security_groups = ["${aws_security_group.sg-app.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
    container_name   = "${var.app_name}"
    container_port   = "${var.app_port}"
  }
}