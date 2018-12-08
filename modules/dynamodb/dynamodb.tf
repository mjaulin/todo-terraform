
resource "aws_iam_role" "role-access-dynamodb" {
  name = "${var.default_tags["Project"]}.role-access-dynamodb"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = "${var.default_tags}"
}

resource "aws_iam_role_policy" "role-policy-dynamodb" {
  name = "${var.default_tags["Project"]}.role-policy-dynamodb"
  role = "${aws_iam_role.role-access-dynamodb.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:ListTables",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource" : "*"
    }
  ]
}
EOF
}

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

output "role-access-dynamodb-arn" {
  value = "${aws_iam_role.role-access-dynamodb.arn}"
}
