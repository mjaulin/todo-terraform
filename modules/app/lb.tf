
resource "null_resource" "lb-exist" {
  triggers {
    lb_name = "${var.lb_arn}"
  }
}

resource "aws_lb_target_group" "lb-tg" {
  name     = "${var.default_tags["Project"]}-tg-${var.app_name}"
  port     = "${var.app_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"

  depends_on = [ "null_resource.lb-exist" ]

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "${var.app_healthcheck_path}"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 60
    matcher             = "${var.app_healthcheck_status_code}"
  }

  tags = "${merge(var.default_tags, map("Name", "tg-var${var.app_name}"))}"
}

resource "aws_lb_listener_rule" "lb-lr" {
  listener_arn = "${var.lb_listener_arn}"
  priority     = "${var.lb_lr_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = "${var.app_path_pattern}"
  }
}

output "lb_tg_arn" {
  value = "${aws_lb_target_group.lb-tg.arn}"
}