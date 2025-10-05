terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }

  backend "s3" {
    bucket         = "iac-tcc-felix"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tcc-locks"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}