
resource "aws_ecs_cluster" "cluster" {
  name = "${var.default_tags["Project"]}-cluster"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.cluster.name}"
}