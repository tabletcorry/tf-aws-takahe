output "iam_access_key_id" {
  value = aws_iam_access_key.ses_sendemail.id
}

output "iam_access_key_ses_smtp_password_v4" {
  value = aws_iam_access_key.ses_sendemail.ses_smtp_password_v4
}

output "ses_smtp_url" {
  value = "smtp://${aws_iam_access_key.ses_sendemail.id}:${aws_iam_access_key.ses_sendemail.ses_smtp_password_v4}@email-smtp.${data.aws_region.self.name}.amazonaws.com:587/?tls=true"
}