terraform {
  required_providers {
    aws = {
      source = "aws"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "ddavydov"
}
