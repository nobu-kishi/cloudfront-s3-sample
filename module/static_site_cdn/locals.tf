locals {
  NAME_PREFIX     = format("%s-%s", var.system_name, var.env)
  S3_BUCKET_NAME  = format("%s-s3-bucket-%s", local.NAME_PREFIX, var.name)
  CLOUDFRONT_NAME = format("%s-cf-%s", local.NAME_PREFIX, var.name)
}