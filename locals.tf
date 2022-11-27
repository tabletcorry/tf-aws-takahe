locals {
  module_tags = {
    module          = "tf-aws-takahe"
    module_var_name = var.name
  }
  tags = merge(local.module_tags, var.tags)

  region = "us-west-2"

  takahe_domain_name = "${var.name}.takahe.${var.primary_domain_name}"
}