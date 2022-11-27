resource "aws_ses_domain_identity" "self" {
  domain = local.takahe_domain_name
}

resource "aws_route53_record" "ses_txt" {
  zone_id = data.aws_route53_zone.self.zone_id
  name    = "_amazonses.${local.takahe_domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.self.verification_token]
}

resource "aws_ses_domain_identity_verification" "self" {
  domain = aws_ses_domain_identity.self.id

  depends_on = [aws_route53_record.ses_txt]
}

resource "aws_ses_domain_dkim" "ses" {
  domain = aws_ses_domain_identity.self.domain

  depends_on = [aws_ses_domain_identity_verification.self]
}

resource "aws_route53_record" "ses_dkim" {
  count   = 3
  zone_id = data.aws_route53_zone.self.zone_id
  name    = "${aws_ses_domain_dkim.ses.dkim_tokens[count.index]}._domainkey.${local.takahe_domain_name}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.ses.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_ses_email_identity" "ses_admin" {
  email = "admin@tabletcorry.com"
}