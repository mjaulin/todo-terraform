
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"

  tags = "${merge(var.default_tags, map("Name", "vpc-${var.default_tags["Project"]}"))}"
}

resource "aws_subnet" "subnets-pub" {
  count             = "${length(var.availability_zones)}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, 3, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map("Name", "pub-${element(split("-", element(var.availability_zones, count.index)), 2)}"))}"
}

resource "aws_subnet" "subnets-priv" {
  count             = "${length(var.availability_zones)}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, 3, count.index + 1 + aws_subnet.subnets-pub.count)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map("Name", "priv-${element(split("-", element(var.availability_zones, count.index)), 2)}"))}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnets-pub" {
  value = "${aws_subnet.subnets-pub.*.id}"
}

output "subnets-priv" {
  value = "${aws_subnet.subnets-priv.*.id}"
}