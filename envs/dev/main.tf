provider "aws" {
  region = var.region
}

locals {
  app_name = "${var.env}-${var.name}"
}

terraform {
  required_version = "=v1.9.8"
  required_providers {
    aws = {
      version = "=5.77.0"
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "dev-cloudfront-s3-sample"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}


module "s3" {
  source = "../../module/origin_s3"

  name                         = local.app_name
  cloudfront_distribution_arns = [module.cloudfront.cloudfront_distribution_arn]
}

module "cloudfront" {
  source = "../../module/cloudfront"

  name                           = local.app_name
  s3_bucket_id                   = module.s3.s3_bucket_id
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
}
