
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  tags = "${merge(var.default_tags, map("Name", "acl-default"))}"
}

resource "aws_network_acl" "acl-pub" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.subnets-pub.*.id}"]

  ingress {
    action = "allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    rule_no = 130
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    rule_no = 120
    cidr_block = "0.0.0.0/0"
  }

  tags = "${merge(var.default_tags, map("Name", "acl-pub"))}"
}

resource "aws_network_acl" "acl-priv" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.subnets-priv.*.id}"]

  ingress {
    action = "allow"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    rule_no = 100
    cidr_block = "${var.cidr_block}"
  }

  ingress {
    action = "allow"
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    rule_no = 130
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    rule_no = 120
    cidr_block = "${var.cidr_block}"
  }

  tags = "${merge(var.default_tags, map("Name", "acl-priv"))}"
}
