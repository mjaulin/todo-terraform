
resource "aws_ecr_repository" "ecr" {
  name = "${var.default_tags["Project"]}-${var.app_name}"
}

resource "aws_ecr_lifecycle_policy" "ecr-lp" {
  repository = "${aws_ecr_repository.ecr.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 3 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}