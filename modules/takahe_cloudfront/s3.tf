resource "aws_s3_bucket" "origin_logs" {
  bucket_prefix = "${var.name}-logs"
}

resource "aws_s3_bucket_acl" "origin_logs" {
  bucket = aws_s3_bucket.origin_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "origin_logs" {
  bucket = aws_s3_bucket.origin_logs.id

  block_public_acls   = true
  block_public_policy = true
}