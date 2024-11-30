terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "omantel-terraform-state"
    key            = "test/dev/canary/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform_locks"
  }
}