variable "system_name" {
  description = "システム名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "name" {
  description = "リソース名"
  type        = string
}

variable "allow_locations" {
  description = "許可するロケーション"
  type        = list(string)
}

variable "price_classes" {
  description = "CloudFrontの価格クラス"
  type        = string
}

variable "default_root_object" {
  description = "CloudFrontのデフォルトルートオブジェクト"
  type        = string
}