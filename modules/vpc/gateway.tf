
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map("Name", "igw-meetup-aws"))}"
}

resource "aws_eip" "nat" {
  vpc = true

  tags = "${merge(var.default_tags, map("Name", "nat"))}"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.subnets-pub.0.id}"

  tags = "${merge(var.default_tags, map("Name", "nat-gw"))}"
}