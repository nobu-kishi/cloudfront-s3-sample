#--------------------------------------------------------------
# CloudFront
#--------------------------------------------------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "s3_default" {
  name = "${var.s3_bucket_id}-oac"
  # description                       = "OAC policy for s3 ${var.s3_bucket_id}"
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

  # TODO
  # logging_config {
  #   bucket          = "tamahiyoapp-logs.s3.amazonaws.com"
  #   include_cookies = false
  #   prefix          = "CloudFront"
  # }

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
    response_headers_policy_id = aws_cloudfront_response_headers_policy.res-header-policy.id
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "JP"]
    }
  }

  # tags = {
  #   Environment = "${var.env}"
  # }

  viewer_certificate {
    # ACMを利用する場合は、false
    cloudfront_default_certificate = true
    # acm_certificate_arn            = var.acm_certificate_arn
    # cloudfront_default_certificate = false
    # minimum_protocol_version       = "TLSv1.2_2018"
    # ssl_support_method             = "sni-only"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy
resource "aws_cloudfront_response_headers_policy" "res-header-policy" {
  name = "${var.name}-policy"
  # comment = "test comment"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override = true
    }
    # 最新ブラウザではサポートされてない模様
    # xss_protection {
    #   mode_block = true
    #   protection = true
    #   override = true
    # }
    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
      override = true
    }
  }

  remove_headers_config {
    items {
      header = "Sever"
    }
  }
}
