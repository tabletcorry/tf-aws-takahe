locals {
  module_tags = {
    module          = "tf-aws-takahe.shared_ses"
    module_var_name = var.name
  }
  tags = merge(var.tags, local.module_tags)
}