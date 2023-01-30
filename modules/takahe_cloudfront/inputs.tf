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

variable "origin_inbox_domain_name" {
  type = string
}

variable "origin_web_domain_name" {
  type = string
}

variable "domain_prefix_parts" {
  type        = list(string)
  default     = []
  description = "Overrides automatic domain name creation. Prepends these parts on primary_domain_name"
}

variable "cloudfront_priceclass" {
  type    = string
  default = "PriceClass_100"
}

variable "fly_caa_records" {
  type = list(string)
  default = []
}