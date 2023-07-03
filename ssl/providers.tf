terraform {
  backend "s3" {
    bucket         = "capstone-9-tfstate-bucket"
    key            = "ssl/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "capstone_9_dynamodb"
  }
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "aws" {
  region = "eu-west-1"
}
