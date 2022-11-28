resource "aws_ecr_repository" "self" {
  name = "${local.module_tags.module}-${var.name}"
}