resource "aws_cloudwatch_log_group" "ecs" {
  name = "/${local.module_tags.module}/${var.name}/ecs"

  retention_in_days = 7
}
