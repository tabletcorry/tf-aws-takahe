resource "aws_s3_bucket" "media" {
  bucket_prefix = "takahe-${var.name}"

}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.media.id
  acl    = "private"
}