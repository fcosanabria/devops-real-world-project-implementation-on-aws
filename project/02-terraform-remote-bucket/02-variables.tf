variable "environment_name" {
  description = "Deploy environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS Region to deploy"
  type        = string
  default     = "us-east-1"
}