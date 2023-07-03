variable "region" {
  default = "eu-west-1"
}

variable "key_name" {
description = "SSH Key Name"
  default = "windows11"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  default       = "capstone-9-tfstate-bucket"
}

variable "table_name" {
  description = "Dynamo DB Table Name"
  default       = "capstone_9_dynamodb"
}
