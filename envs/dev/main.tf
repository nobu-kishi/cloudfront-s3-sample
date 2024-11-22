provider "aws" {
  region = var.region
}

terraform {
  required_version = "=v1.9.8"
  backend "s3" {
    # ${name_prefix}
    bucket = "stag-network-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
locals {
  name_prefix = "${var.env}-${var.name}"
}

module "s3" {
  source = "../../module/origin_s3"

  name                         = local.name_prefix
  cloudfront_distribution_arns = [module.cloudfront.cloudfront_distribution_arn]
}

module "cloudfront" {
  source = "../../module/cloudfront"

  name                           = local.name_prefix
  s3_bucket_id                   = module.s3.s3_bucket_id
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
}
