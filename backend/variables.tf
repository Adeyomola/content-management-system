variable "table_name" {
  description = "Dynamo DB Table Name"
  default       = "capstone_9_dynamodb"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  default       = "capstone-9-tfstate-bucket"
}

variable "arn" {}
