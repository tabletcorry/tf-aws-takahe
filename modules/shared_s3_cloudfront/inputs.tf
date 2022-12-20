variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "primary_domain_name" {
  type = string
}

variable "domain_prefix_parts" {
  type        = list(string)
  default     = []
  description = "Overrides automatic domain name creation. Prepends these parts on primary_domain_name"
}

variable "cloudfront_priceclass" {
  type    = string
  default = "PriceClass_200"
}