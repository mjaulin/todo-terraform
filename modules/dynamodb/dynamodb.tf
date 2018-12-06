
resource "aws_dynamodb_table" "table" {
  name = "${var.table_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "${var.table_id}"

  attribute {
    name = "${var.table_id}"
    type = "S"
  }

  tags = "${var.default_tags}"
}