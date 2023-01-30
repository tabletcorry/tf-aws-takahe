resource "aws_cloudfront_origin_access_identity" "self" {
}

data "aws_cloudfront_cache_policy" "Managed-CachingOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "Managed-CachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "Managed-AllViewer" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_origin_request_policy" "Managed-UserAgentRefererHeaders" {
  name = "Managed-UserAgentRefererHeaders"
}

resource "aws_cloudfront_distribution" "self" {
  origin {
    domain_name = var.origin_web_domain_name
    origin_id   = "fly-web"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = var.origin_inbox_domain_name
    origin_id   = "fly-inbox"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"

  aliases = [local.takahe_domain_name]

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.origin_logs.bucket_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingDisabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-AllViewer.id

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  ordered_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingDisabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-AllViewer.id

    path_pattern           = "/inbox/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "manifest.json"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  /*ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "nodeinfo/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = ".well-known/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }*/

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "robots.txt"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "static/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "proxy/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

    ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly-web"

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-UserAgentRefererHeaders.id

    path_pattern           = "media/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  /*ordered_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "fly"

    cache_policy_id = aws_cloudfront_cache_policy.api.id

    path_pattern           = "api/v1/*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }*/

  price_class = var.cloudfront_priceclass

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}

resource "aws_cloudfront_response_headers_policy" "self" {
  name = md5(local.takahe_domain_name)

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
      preload                    = true
    }

    xss_protection {
      mode_block = true
      override   = true
      protection = true
    }

    referrer_policy {
      override        = true
      referrer_policy = "strict-origin-when-cross-origin"
    }

    /*content_security_policy {
      content_security_policy = "default-src 'none'; img-src 'self'; script-src 'unsafe-inline'; style-src 'self'"
      override                = true
    }*/


  }
}

resource "aws_cloudfront_cache_policy" "api" {
  name = md5("${local.takahe_domain_name}-api")
  default_ttl = 60
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Authorization",
          "Idempotency-Key"
        ]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}