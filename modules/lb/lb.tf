
resource "aws_security_group" "sg-lb" {
  name   = "lbSecurityGroup"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map("Name", "sg-lb"))}"
}

resource "aws_lb" "lb" {
  name     = "${var.default_tags["Project"]}-lb"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-lb.id}"]
  subnets            = ["${var.subnets}"]

  tags = "${var.default_tags}"
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type  = "text/plain"
      message_body  = "Hello World !!!"
      status_code = "200"
    }
  }
}

output "lb_arn" {
  value = "${aws_lb.lb.arn}"
}

output "lb_public_dns_name" {
  value = "${aws_lb.lb.dns_name}"
}

output "lb_listener_arn" {
  value = "${aws_lb_listener.listener_http.arn}"
}

output "lb_sg" {
  value = "${aws_security_group.sg-lb.id}"
}