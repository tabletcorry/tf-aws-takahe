variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "github_url" {
  type = string
}