resource "aws_ecs_cluster" "self" {
  name = "${local.module_tags.module}-${var.name}"
}

