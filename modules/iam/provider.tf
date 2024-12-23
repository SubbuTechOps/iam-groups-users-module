provider "aws" {
  region = var.region
}

terraform {  
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = contains(["us-east-1", "us-west-1", "ap-south-1"], var.region)
    error_message = "Invalid region. Choose one of: us-east-1, us-west-1, ap-south-1."
  }
}
