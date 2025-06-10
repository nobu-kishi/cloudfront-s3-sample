terraform {
  required_version = "=v1.12.1"
  required_providers {
    aws = {
      version = "=5.77.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {}
}