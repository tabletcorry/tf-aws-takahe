variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "takahe_domain_name" {
  type = string
}

variable "primary_domain_name" {
  type = string
}