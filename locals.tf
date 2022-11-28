locals {
  module_tags = {
    module          = "tf-aws-takahe"
    module_var_name = var.name
  }
  tags = merge(local.module_tags, var.tags)

  region = "us-west-2"

  takahe_domain_name = length(var.domain_prefix_parts) == 0 ? "${var.name}.takahe.${var.primary_domain_name}" : join(".", concat(var.domain_prefix_parts, [var.primary_domain_name]))

  web_listen_port = 8000
}