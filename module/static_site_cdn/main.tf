#--------------------------------------------------------------
# S3
#--------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket        = local.S3_BUCKET_NAME
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

#--------------------------------------------------------------
# CloudFront
#--------------------------------------------------------------

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${aws_s3_bucket.this.id}-oac"
  description                       = "OAC policy for s3 ${aws_s3_bucket.this.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    origin_id                = aws_s3_bucket.this.id
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.name
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id

    compress                   = true
    default_ttl                = 0
    max_ttl                    = 0
    min_ttl                    = 0
    viewer_protocol_policy     = "https-only"
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.custom_res_header.id
  }

  price_class = var.price_classes

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.allow_locations
    }
  }

  viewer_certificate {
    # ACMを利用する場合は、false
    cloudfront_default_certificate = true
  }
}

# キャッシュ最適化のマネージドポリシー
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_response_headers_policy" "custom_res_header" {
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
      content_security_policy = "frame-ancestors 'none'; this-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
      override                = true
    }
  }

  # NOTE: サーバー情報を隠蔽する設定
  custom_headers_config {
    items {
      header   = "Server"
      value    = "Server"
      override = true
    }
  }
}
