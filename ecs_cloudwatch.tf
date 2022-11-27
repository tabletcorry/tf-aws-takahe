resource "aws_cloudwatch_log_group" "ecs_primary" {
  name = "/${local.module_tags.module}/${var.name}/ecs/primary"
}
