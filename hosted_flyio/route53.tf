resource "aws_route53_record" "fly_inbox_cert_cname" {
  name    = "_acme-challenge.${local.origin_inbox_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.acme_inbox_challenge_cname]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_inbox_a" {
  name    = local.origin_inbox_domain_name
  type    = "A"
  ttl     = 60
  records = [var.target_inbox_ipv4]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_inbox_aaaa" {
  name    = local.origin_inbox_domain_name
  type    = "AAAA"
  ttl     = 60
  records = [var.target_inbox_ipv6]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_inbox_caa" {
  name    = local.origin_inbox_domain_name
  type    = "CAA"
  ttl     = 60
  records = ["0 issue \"letsencrypt.org\""]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_web_cert_cname" {
  name    = "_acme-challenge.${local.origin_web_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.acme_web_challenge_cname]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_web_a" {
  name    = local.origin_web_domain_name
  type    = "A"
  ttl     = 60
  records = [var.target_web_ipv4]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_web_aaaa" {
  name    = local.origin_web_domain_name
  type    = "AAAA"
  ttl     = 60
  records = [var.target_web_ipv6]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_web_caa" {
  name    = local.origin_web_domain_name
  type    = "CAA"
  ttl     = 60
  records = ["0 issue \"letsencrypt.org\""]
  zone_id = data.aws_route53_zone.self.zone_id
}