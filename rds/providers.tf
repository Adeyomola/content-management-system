terraform {
  backend "s3" {
    bucket         = "capstone-9-tfstate-bucket"
    key            = "rds/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "capstone_9_dynamodb"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }

  required_version = "~> 1.3"
}


provider "aws" {
  region = "eu-west-1"
}
