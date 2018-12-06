
data "template_file" "td" {
  template = "${file("${path.module}/back.json")}"

  vars {
    image = "${var.ecr_repository_arn}:${var.version}"
  }
}

resource "aws_ecs_task_definition" "ecs-task" {
  family                = "aws_terraform_back"
  container_definitions = "${data.template_file.td.rendered}"

  provisioner "local-exec" {
    working_dir = "../../../todo-backend/"
    command = "docker build -t ${var.ecr_repository_arn}:${var.version} . && `aws ecr get-login --no-include-email` && docker push ${var.ecr_repository_arn}:${var.version}"
  }
}

resource "aws_ecs_service" "ecs-service" {
  name            = "aws_terraform-service"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs-task.arn}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${var.lb_tg_arn}"
    container_name   = "back"
    container_port   = 8080
  }
}