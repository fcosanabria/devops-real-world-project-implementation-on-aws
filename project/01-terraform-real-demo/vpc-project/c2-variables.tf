variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "Environment"
  type = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16" # aca podemos interactuar con 65.000 address to work with when we are using /16.
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "subnet_newbits" {
  description = "Number of new bits to add to VPC CIDR to generate subnets (eg: 8 means /24 from )"
  # it tells Terraform how to split the VPC CIDR block.
  type = number
  default = 8
}
