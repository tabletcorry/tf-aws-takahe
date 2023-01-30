locals {
  module_tags = {
    module          = "tf-aws-takahe.takahe_cloudfront"
    module_var_name = var.name
  }
  tags = merge(var.tags, local.module_tags)

  s3_origin_id = "s3"

  takahe_domain_name = length(var.domain_prefix_parts) == 0 ? "${var.name}.cdn.takahe.${var.primary_domain_name}" : join(".", concat(var.domain_prefix_parts, [var.primary_domain_name]))
}