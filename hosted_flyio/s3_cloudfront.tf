module "s3_cloudfront" {
  source = "../modules/shared_s3_cloudfront"
  name   = var.name
  primary_domain_name = var.primary_domain_name
  tags = local.tags
}