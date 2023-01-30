resource "aws_acm_certificate" "cloudfront" {
  provider          = aws.us-east-1
  domain_name       = local.takahe_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route53_record.acm_caa]
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cf_acm : record.fqdn]
}