resource "aws_route53_record" "fly_cert_cname" {
  name    = "_acme-challenge.${local.takahe_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.acme_challenge_cname]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_a" {
  name    = local.takahe_domain_name
  type    = "A"
  ttl     = 60
  records = [var.target_ipv4]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_aaaa" {
  name    = local.takahe_domain_name
  type    = "AAAA"
  ttl     = 60
  records = [var.target_ipv6]
  zone_id = data.aws_route53_zone.self.zone_id
}

resource "aws_route53_record" "fly_caa" {
  name    = local.takahe_domain_name
  type    = "CAA"
  ttl     = 60
  records = ["0 issue \"letsencrypt.org\""]
  zone_id = data.aws_route53_zone.self.zone_id
}