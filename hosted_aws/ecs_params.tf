resource "aws_ssm_parameter" "rds_root_password" {
  name  = "/${local.module_tags.module}/${var.name}/rds_root_password"
  type  = "SecureString"
  value = random_password.rds_root.result
}

resource "random_password" "django_web_secret_key" {
  length = 128
}

resource "aws_ssm_parameter" "django_web_secret_key" {
  name  = "/${local.module_tags.module}/${var.name}/django_web_secret_key"
  type  = "SecureString"
  value = random_password.django_web_secret_key.result

}

resource "aws_ssm_parameter" "email_server" {
  name  = "/${local.module_tags.module}/${var.name}/email_server"
  type  = "SecureString"
  value = module.ses.ses_smtp_url
  }

resource "aws_ssm_parameter" "sentry_dsn" {
  name  = "/${local.module_tags.module}/${var.name}/sentry_dsn"
  type  = "SecureString"
  value = "filler"

  lifecycle {
    ignore_changes = [value]
  }
}