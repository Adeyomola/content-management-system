locals {
  cluster_name = "capstone-9"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "account_id" {}
