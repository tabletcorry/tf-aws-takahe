output "s3_iam_user_key_id" {
  value = aws_iam_access_key.s3.id
}

output "s3_iam_user_key_secret" {
  value = aws_iam_access_key.s3.secret
}

output "s3_url" {
  value = "s3://${aws_iam_access_key.s3.id}:${urlencode(aws_iam_access_key.s3.secret)}@/${aws_s3_bucket.origin.bucket}"
}

output "s3_arn" {
  value = aws_s3_bucket.origin.arn
}

output "s3_name" {
  value = aws_s3_bucket.origin.bucket
}