# tf-aws-takahe

Contains Terraform required to deploy Takahē. Currently supports AWS Fargate and Fly.io.

## Fly.io

Deploys secondary infrastructure required for a Takahē instance in Fly.io.

Specifically, creates the following:
* SES identity (for sending email)
* S3 Bucket (for media)
* Cloudfront distribution (for fronting S3)
* Route53 records (for A, AAAA, and CAA records)

Currently assumes that your DNS zone is in route53. If yours isn't, please delegate a subdomain to route53
(or create a patch to make that TF optional).

Example usage:

```hcl
module "takahe_fly" {
  source = "git::https://github.com/tabletcorry/tf-aws-takahe.git//hosted_flyio"
  acme_challenge_cname = "CNAME provided by Fly for ACME challenge"
  name = "takahe-fly"
  primary_domain_name = "Domain Zone for route53"
  domain_prefix_parts = ["takahe"]
  target_ipv4 = "IPv4 provided by Fly"
  target_ipv6 = "IPv6 provided by Fly"
}
```

## AWS

Note: AWS should work for 0.4.0, but needs updates beyond that. I will return to the AWS setup soon, file an issue if
this affects you.

Completely deploys a functional Takahē system to AWS Fargate.

Optimization still possible, but as currently implemented this will cost ~$48/month (plus usage-based costs).

Note:
* This will be very restricted if your SES isn't unlocked (basically, Takahe can only email its own domain otherwise)
* If you don't want this open to the whole internet, set the lb_ingress_ipv4 and lb_ingress_ipv6 variables

Example usage:

```hcl
module "takahe" {
  source = "git::https://github.com/tabletcorry/tf-aws-takahe.git//hosted_aws"

  name = "testing"

  primary_domain_name = "example.com"

  enable_sentry = true

  # Optional! If not provided, defaults to Docker Hub latest
  ecr_name = module.takahe_build.ecr_name
}

# Optional! Only required if you want to build your instance from source.
module "takahe_build" {
  source = "git::https://github.com/tabletcorry/tf-aws-takahe.git//codebuild"

  github_url = "https://github.com/tabletcorry/takahe.git"
  name = "testing"
}
```