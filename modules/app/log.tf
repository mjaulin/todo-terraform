
resource "aws_cloudwatch_log_group" "log-grp" {
  name = "lg-${var.app_name}"

  tags = "${var.default_tags}"
}