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

variable "secondary_domain_names" {
  type    = list(string)
  default = []
}

variable "takahe_email_from" {
  type = string
  default = ""
  description = "Overrides default FROM address"
}

variable "takahe_auto_admin_email" {
  type = string
  default = ""
  description = "Overrides default auto-admin email address"
}

variable "hazardous_dangerous_django_debug" {
  type = bool
  default = false
  description = "DANGEROUS: Enabled Django DEBUG mode. Incredibly dangerous!"
}

variable "enable_sentry" {
  type = bool
  default = false
  description = "Enable injection of Sentry SSM Parameter. Note: Please populate SSM parameter or this will fail."
}

variable "domain_prefix_parts" {
  type = list(string)
  default = []
  description = "Overrides automatic domain name creation. Prepends these parts on primary_domain_name"
}