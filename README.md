# tf-aws-takahe

Completely deploys a functional Takahe system to AWS Fargate.

Optimization still possible, but as currently implemented this will cost ~$48/month (plus usage-based costs).

Note:
* This will be very restricted if your SES isn't unlocked (basically, Takahe can only email its own domain otherwise)
* If you don't want this open to the whole internet, set the lb_ingress_ipv4 and lb_ingress_ipv6 variables

Example usage:

```hcl
module "takahe" {
  source = "git::https://github.com/tabletcorry/tf-aws-takahe.git"

  name = "testing"

  primary_domain_name = "example.com"

  enable_sentry = true

  ecr_name = module.takahe_build.ecr_name
}

module "takahe_build" {
  source = "git::https://github.com/tabletcorry/tf-aws-takahe.git//modules/codebuild"

  github_url = "https://github.com/tabletcorry/takahe.git"
  name = "testing"
}
```