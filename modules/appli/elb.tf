
resource "aws_lb_target_group" "lb-tg" {
  name     = "${var.default_tags["Project"]}-tg-${var.app_name}"
  port     = "${var.app_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "${var.app_healthcheck_path}"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "${var.app_healthcheck_status_code}"
  }

  tags = "${var.default_tags}"
}

resource "aws_lb_listener_rule" "lb-lr" {
  listener_arn = "${var.elb_lb_listener_arn}"
  priority     = 100

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