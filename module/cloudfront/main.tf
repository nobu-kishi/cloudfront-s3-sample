#--------------------------------------------------------------
# CloudFront
#--------------------------------------------------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "s3_default" {
  name = "${var.s3_bucket_id}-oac"
  description                       = "OAC policy for s3 ${var.s3_bucket_id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "default" {
  origin {
    origin_id                = var.s3_bucket_id
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.name
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_id

    compress                   = true
    default_ttl                = 0
    max_ttl                    = 0
    min_ttl                    = 0
    viewer_protocol_policy     = "https-only"
    cache_policy_id            = var.caching_optimized_policy_id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.custom-res-header.id
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "JP"]
    }
  }

  viewer_certificate {
    # ACMを利用する場合は、false
    cloudfront_default_certificate = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy
resource "aws_cloudfront_response_headers_policy" "custom-res-header" {
  name = "${var.name}-policy"

  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
      override                = true
    }
  }

  custom_headers_config {
    items {
      header = "Server"
      value = "Server"
      override = true
    }
  }
}
