resource "aws_acm_certificate" "lb" {
  domain_name       = local.takahe_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  subject_alternative_names = var.secondary_domain_names
}

resource "aws_acm_certificate_validation" "lb" {
  certificate_arn         = aws_acm_certificate.lb.arn
  validation_record_fqdns = [for record in aws_route53_record.lb_acm : record.fqdn]
}