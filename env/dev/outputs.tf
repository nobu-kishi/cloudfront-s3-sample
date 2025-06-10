output "s3_bucket_list" {
  description = "S3バケット名のリスト"
  value       = [for cdn in module.static_site_cdn : cdn.s3_bucket_name]
}