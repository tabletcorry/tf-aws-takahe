resource "aws_ses_domain_identity" "self" {
  domain = var.takahe_domain_name
}

resource "aws_route53_record" "ses_txt_verification" {
  zone_id = data.aws_route53_zone.self.zone_id
  name    = "_amazonses.${var.takahe_domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.self.verification_token]
}

resource "aws_ses_domain_identity_verification" "self" {
  domain = aws_ses_domain_identity.self.id

  depends_on = [aws_route53_record.ses_txt_verification]
}

resource "aws_ses_domain_dkim" "self" {
  domain = aws_ses_domain_identity.self.domain

  depends_on = [aws_ses_domain_identity_verification.self]
}

resource "aws_route53_record" "ses_cname_dkim_verification" {
  count   = 3
  zone_id = data.aws_route53_zone.self.zone_id
  name    = "${aws_ses_domain_dkim.self.dkim_tokens[count.index]}._domainkey.${var.takahe_domain_name}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.self.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_route53_record" "spf" {
  name    = var.takahe_domain_name
  type    = "TXT"
  ttl     = 60
  records = ["v=spf1 include:amazonses.com ~all"]
  zone_id = data.aws_route53_zone.self.zone_id
}