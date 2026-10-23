terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-dev-us-east-1-d8wsmq"
    key = "vpc/dev/terraform.tfstate" # path to the file
    region = "us-east-1" # vars are not allowed in terraform blocks
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
