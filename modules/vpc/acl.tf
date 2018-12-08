
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  tags = "${merge(var.default_tags, map("Name", "acl-default"))}"
}

resource "aws_network_acl" "acl-pub" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.subnets-pub.*.id}"]

  ingress {
    action = "allow"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  tags = "${merge(var.default_tags, map("Name", "acl-pub"))}"
}

resource "aws_network_acl" "acl-priv" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.subnets-priv.*.id}"]

  ingress {
    action = "allow"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    rule_no = 100
    cidr_block = "0.0.0.0/0"
  }

  tags = "${merge(var.default_tags, map("Name", "acl-priv"))}"
}
