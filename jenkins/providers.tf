terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = "jenkins/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.table_name
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}
