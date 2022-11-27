resource "aws_ssm_parameter" "ecs_primary_web_database_server" {
  name  = "/${local.module_tags.module}/${var.name}/ecs/primary/web/database_server"
  type  = "SecureString"
  value = random_password.rds_app_root.result
}

resource "random_password" "ecs_primary_web_secret_key" {
  length = 64
}

resource "aws_ssm_parameter" "ecs_primary_web_secret_key" {
  name  = "/${local.module_tags.module}/${var.name}/ecs/primary/web/secret_key"
  type  = "SecureString"
  value = random_password.ecs_primary_web_secret_key.result

}

resource "aws_ssm_parameter" "ecs_primary_web_email_password" {
  name  = "/${local.module_tags.module}/${var.name}/ecs/primary/web/email_password"
  type  = "SecureString"
  value = aws_iam_access_key.ses.ses_smtp_password_v4
}

resource "aws_ssm_parameter" "ecs_primary_web_sentry_dsn" {
  name  = "/${local.module_tags.module}/${var.name}/ecs/primary/web/sentry_dsn"
  type  = "SecureString"
  value = "filler"

  lifecycle {
    ignore_changes = [value]
  }
}