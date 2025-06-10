variable "region" {
  description = "AWSリージョン"
  type        = string
}

variable "system_name" {
  description = "システム名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "static_site_list" {
  type = list(object({
    name                = string
    allow_locations     = list(string)
    price_classes       = string
    default_root_object = string
  }))
}