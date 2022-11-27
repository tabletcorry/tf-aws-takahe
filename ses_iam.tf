resource "aws_iam_user" "ses" {
  name = "takahe-${var.name}-ses"
}

resource "aws_iam_user_policy" "ses" {
  user = aws_iam_user.ses.name

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
          aws_ses_email_identity.ses_admin.arn,
        ]
      },
    ]
  })
}

resource "aws_iam_access_key" "ses" {
  user = aws_iam_user.ses.name
}