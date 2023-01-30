module "cloudfront" {
  source = "../modules/takahe_cloudfront"
  name   = var.name
  primary_domain_name = var.primary_domain_name
  domain_prefix_parts = var.domain_prefix_parts
  origin_inbox_domain_name = local.origin_inbox_domain_name
  origin_web_domain_name = local.origin_web_domain_name
}