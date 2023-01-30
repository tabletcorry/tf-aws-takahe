resource "aws_iam_user" "ses_sendemail" {
  name = "${local.module_tags.module}-${var.name}-ses-sendemail"
}

resource "aws_iam_user_policy" "ses_sendemail" {
  user = aws_iam_user.ses_sendemail.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ses:SendRawEmail",
        ]
        Effect = "Allow"
        Resource = [
          aws_ses_domain_identity.self.arn,
        ]
      },
    ]
  })
}

resource "aws_iam_access_key" "ses_sendemail" {
  user = aws_iam_user.ses_sendemail.name
}