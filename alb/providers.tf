data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    key    = "provision/terraform.tfstate"
    bucket = "capstone-9-tfstate-bucket"
    region = "eu-west-1"
  }
}

terraform {
  backend "s3" {
    bucket         = "capstone-9-tfstate-bucket"
    key            = "aws_lb/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "capstone_9_dynamodb"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.7.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks.outputs.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.eks.outputs.cluster_name
      ]
    }
  }
}
