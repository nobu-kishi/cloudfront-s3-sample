output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.default.arn
}

# output "res-header-policy-id" {
#   value = aws_cloudfront_response_headers_policy.res-header-policy.id
# }