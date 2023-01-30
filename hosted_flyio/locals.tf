locals {
  module_tags = {
    module          = "tf-aws-takahe"
    module_var_name = var.name
  }
  tags = merge(var.tags, local.module_tags)

  region = "us-west-2"

  takahe_domain_name = length(var.domain_prefix_parts) == 0 ? "${var.name}.takahe.${var.primary_domain_name}" : join(".", concat(var.domain_prefix_parts, [var.primary_domain_name]))
  origin_inbox_domain_name = "inbox.origin.${local.takahe_domain_name}"
  origin_web_domain_name = "web.origin.${local.takahe_domain_name}"
}