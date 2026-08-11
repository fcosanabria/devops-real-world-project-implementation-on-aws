# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # In production grade, the best recommended version option.
    }                    # Major versions upgrades are not recommended.
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

# Provider Block
provider "aws" {
  # Configuration options
  region = "us-east-1"
}