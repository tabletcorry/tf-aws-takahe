locals {
  module_tags = {
    module          = "tf-aws-takahe-codebuild"
    module_var_name = var.name
  }
  tags = merge(local.module_tags, var.tags)
}