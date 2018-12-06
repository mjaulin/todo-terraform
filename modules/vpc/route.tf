
resource "aws_default_route_table" "rt-default" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = "${merge(var.default_tags, map("Name", "rt-default"))}"
}

resource "aws_route_table" "rt-pub" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = "${merge(var.default_tags, map("Name", "rt-pub"))}"
}

resource "aws_route_table_association" "rt-ass-pub" {
  count          = "${aws_subnet.subnets-pub.count}"
  subnet_id      = "${element(aws_subnet.subnets-pub.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-pub.id}"
}

resource "aws_route_table" "rt-priv" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags = "${merge(var.default_tags, map("Name", "rt-priv"))}"
}

resource "aws_route_table_association" "rt-ass-priv" {
  count          = "${aws_subnet.subnets-priv.count}"
  subnet_id      = "${element(aws_subnet.subnets-priv.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-priv.id}"
}
