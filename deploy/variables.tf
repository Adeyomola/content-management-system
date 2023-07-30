variable "db_user" {}
variable "db_password" {}
variable "db_port" {}
variable "db_name" {}

variable "domain_name" {
  type    = string
  default = "adeyomola.tech"
}

variable "namespaces" {
  type    = set(any)
  default = ["cms"]
}

variable "namespaces_list" {
  description = "namespaces list"
  default     = ["cms"]
}

variable "region" {
  type    = string
  default = "eu-west-1"
}
