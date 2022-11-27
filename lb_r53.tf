resource "aws_route53_record" "lb_a" {
  name    = local.takahe_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.self.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${aws_lb.app.dns_name}"
    zone_id                = aws_lb.app.zone_id

  }
}

resource "aws_route53_record" "lb_aaaa" {
  name    = local.takahe_domain_name
  type    = "AAAA"
  zone_id = data.aws_route53_zone.self.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${aws_lb.app.dns_name}"
    zone_id                = aws_lb.app.zone_id
  }
}

resource "aws_route53_record" "lb_acm" {
  for_each = {
    for dvo in aws_acm_certificate.lb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 86400
  type            = each.value.type
  zone_id         = data.aws_route53_zone.self.zone_id
}