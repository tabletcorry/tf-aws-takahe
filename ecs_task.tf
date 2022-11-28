locals {
  base_web_secrets = {
    PGPASSWORD          = aws_ssm_parameter.rds_root_password
    TAKAHE_SECRET_KEY   = aws_ssm_parameter.django_web_secret_key
    TAKAHE_EMAIL_SERVER = aws_ssm_parameter.email_server
  }
  primary_web_secrets = merge(
    local.base_web_secrets,
    var.enable_sentry ? { SENTRY_DSN = aws_ssm_parameter.sentry_dsn } : {}
  )
  base_web_environment = {
    TAKAHE_MAIN_DOMAIN       = local.takahe_domain_name
    TAKAHE_EMAIL_FROM        = length(var.takahe_email_from) == 0 ? "noreply@${local.takahe_domain_name}" : var.takahe_email_from
    TAKAHE_AUTO_ADMIN_EMAIL  = length(var.takahe_auto_admin_email) == 0 ? "admin@${local.takahe_domain_name}" : var.takahe_auto_admin_email
    TAKAHE_USE_PROXY_HEADERS = "true"
    SECRETS_ARN_HASH         = sha1(join(":", [for secret in values(local.primary_web_secrets) : secret.arn]))
    SECRETS_VERSIONS         = join(":", [for secret in values(local.primary_web_secrets) : secret.version])
    PGHOST                   = aws_db_instance.self.address
    PGPORT                   = "5432"
    PGUSER                   = aws_db_instance.self.username
    PGDATABASE               = aws_db_instance.self.db_name
    TAKAHE_SECURE_HEADER     = "X-Forwarded-Proto"
    TAKAHE_MEDIA_BACKEND     = "s3:///${aws_s3_bucket.media.bucket}"
  }
  primary_web_environment = merge(
    local.base_web_environment,
    var.hazardous_dangerous_django_debug ? { TAKAHE__SECURITY_HAZARD__DEBUG = "True" } : {}
  )
}

resource "aws_ecs_task_definition" "primary_web" {
  family                   = "${local.module_tags.module}-${var.name}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_web.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = local.image_address
      essential = true
      environment = [
        for key, value in local.primary_web_environment : { "name" : "${key}", "value" : "${value}" }
      ]
      secrets = [
        for key, value in local.primary_web_secrets : { "name" : "${key}", "valueFrom" : "${value.arn}" }
      ]
      portMappings = [
        {
          containerPort = local.web_listen_port
          hostPort      = local.web_listen_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
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
      image     = local.image_address
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
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = local.region
          awslogs-stream-prefix = "migrate"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "primary_stator" {
  family                   = "${local.module_tags.module}-${var.name}-stator"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_stator.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "stator"
      image     = local.image_address
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
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = local.region
          awslogs-stream-prefix = "stator"
        }
      }
      command = ["/takahe/manage.py", "runstator"]
    }
  ])
}