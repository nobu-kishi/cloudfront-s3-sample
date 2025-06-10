output "s3_bucket_name" {
  description = "S3バケット名"
  value       = aws_s3_bucket.this.id
}