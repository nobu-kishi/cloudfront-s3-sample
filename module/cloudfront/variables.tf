variable "name" {
  type = string
}

variable "s3_bucket_id" {
  type = string
}

variable "s3_bucket_regional_domain_name" {
  type = string
}

variable "caching_optimized_policy_id" {
  type        = string
  default     = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  description = "キャッシュ最適化のマネージドポリシー"
}