resource "aws_ecs_cluster" "primary" {
  name = "takahe-${var.name}"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_primary.name
      }
    }
  }
}

