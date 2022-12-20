resource "aws_iam_user" "s3" {
  name = "${local.module_tags.module}-${var.name}-s3"
}

resource "aws_iam_user_policy" "s3" {
  user = aws_iam_user.s3.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectAttributes",
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.origin.arn,
          "${aws_s3_bucket.origin.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}