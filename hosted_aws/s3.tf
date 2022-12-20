resource "aws_s3_bucket" "media" {
  bucket_prefix = "${local.module_tags.module}-${var.name}"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.media.id
  acl    = "private"
}