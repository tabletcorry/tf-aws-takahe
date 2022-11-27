locals {
  primary_web_secrets = {
    PGPASSWORD            = aws_ssm_parameter.ecs_primary_web_database_server
    TAKAHE_SECRET_KEY     = aws_ssm_parameter.ecs_primary_web_secret_key
    TAKAHE_EMAIL_PASSWORD = aws_ssm_parameter.ecs_primary_web_email_password
    SENTRY_DSN            = aws_ssm_parameter.ecs_primary_web_sentry_dsn
  }
  primary_web_environment = {
    TAKAHE_MAIN_DOMAIN       = local.takahe_domain_name
    TAKAHE_EMAIL_FROM        = "admin@${local.takahe_domain_name}"
    TAKAHE_AUTO_ADMIN_EMAIL  = "admin@${local.takahe_domain_name}"
    TAKAHE_USE_PROXY_HEADERS = "true"
    SECRETS_ARN_HASH         = sha1(join(":", [for secret in values(local.primary_web_secrets) : secret.arn]))
    SECRETS_VERSIONS         = join(":", [for secret in values(local.primary_web_secrets) : secret.version])
    TAKAHE_EMAIL_USER        = aws_iam_access_key.ses.id
    TAKAHE_EMAIL_HOST        = "email-smtp.us-west-2.amazonaws.com"
    TAKAHE_EMAIL_PORT        = "587"
    PGHOST                   = aws_db_instance.app.address
    PGPORT                   = "5432"
    PGUSER                   = aws_db_instance.app.username
    PGDATABASE               = aws_db_instance.app.db_name
    TAKAHE_MEDIA_BUCKET      = aws_s3_bucket.media.bucket
    # TAKAHE__SECURITY_HAZARD__DEBUG = "True"
    TAKAHE_SECURE_HEADER = "X-Forwarded-Proto"
    TAKAHE_MEDIA_BACKEND = "s3"
  }
}

resource "aws_ecs_task_definition" "primary_web" {
  family                   = "takahe-${var.name}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024

  execution_role_arn = aws_iam_role.primary_web_execution.arn
  task_role_arn      = aws_iam_role.primary_web_task.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "jointakahe/takahe:latest"
      essential = true
      environment = [
        for key, value in local.primary_web_environment : { "name" : "${key}", "value" : "${value}" }
      ]
      secrets = [
        for key, value in local.primary_web_secrets : { "name" : "${key}", "valueFrom" : "${value.arn}" }
      ]
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_primary.name
          awslogs-region        = local.region
          awslogs-stream-prefix = "web"
        }
      }
      dependsOn = [
        {
          containerName = "migrate"
          condition     = "SUCCESS"
        }
      ]
    },
    {
      name      = "migrate"
      image     = "jointakahe/takahe:latest"
      essential = false
      environment = [
        for key, value in local.primary_web_environment : { "name" : "${key}", "value" : "${value}" }
      ]
      secrets = [
        for key, value in local.primary_web_secrets : { "name" : "${key}", "valueFrom" : "${value.arn}" }
      ]
      command = ["/takahe/manage.py", "migrate"]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_primary.name
          awslogs-region        = local.region
          awslogs-stream-prefix = "web"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "primary_stator" {
  family                   = "takahe-${var.name}-stator"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024

  execution_role_arn = aws_iam_role.primary_web_execution.arn
  task_role_arn      = aws_iam_role.primary_web_task.arn

  container_definitions = jsonencode([
    {
      name      = "stator"
      image     = "jointakahe/takahe:latest"
      essential = true
      environment = [
        for key, value in local.primary_web_environment : { "name" : "${key}", "value" : "${value}" }
      ]
      secrets = [
        for key, value in local.primary_web_secrets : { "name" : "${key}", "valueFrom" : "${value.arn}" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_primary.name
          awslogs-region        = local.region
          awslogs-stream-prefix = "web"
        }
      }
      command = ["/takahe/manage.py", "runstator"]
    }
  ])
}