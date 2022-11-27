resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = aws_ecs_cluster.primary.id
  task_definition = aws_ecs_task_definition.primary_web.arn
  desired_count   = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  launch_type = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_primary_web.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = 8000
  }

  propagate_tags = "TASK_DEFINITION"
}

resource "aws_ecs_service" "stator" {
  name            = "stator"
  cluster         = aws_ecs_cluster.primary.id
  task_definition = aws_ecs_task_definition.primary_stator.arn
  desired_count   = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0

  launch_type = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_primary_stator.id]
    assign_public_ip = true
  }

  propagate_tags = "TASK_DEFINITION"
}