
data "aws_acm_certificate" "certificate" {
  domain   = "elb.amazonaws.com"
  statuses = ["ISSUED"]
}

resource "aws_security_group" "sg-elb" {
  name   = "elb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map("Name", "elb-sg"))}"
}

resource "aws_lb" "lb" {
  name     = "${var.default_tags["Project"]}-lb"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-elb.id}"]
  subnets            = ["${var.subnets}"]

  tags = "${var.default_tags}"
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "redirect"

    redirect {
      protocol = "HTTPS"
      port = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = "${data.aws_acm_certificate.certificate.arn}"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type  = "text/plain"
      message_body  = "Hello World !!!"
      status_code = "200"
    }
  }
}

output "elb_securiy_id" {
  value = "${aws_security_group.sg-elb.id}"
}

output "elb_public_dns_name" {
  value = "${aws_lb.lb.dns_name}"
}

output "elb_arn" {
  value = "${aws_lb.lb.arn}"
}