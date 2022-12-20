module "ses" {
  source = "../modules/shared_ses"
  name = var.name
  primary_domain_name = var.primary_domain_name
  takahe_domain_name = local.takahe_domain_name
  tags = local.tags
}