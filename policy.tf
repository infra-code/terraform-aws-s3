resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  count = length(var.s3_bucket_policy_extra_statements) == 0 && length(var.s3_bucket_policy_cloudfront_identities) == 0 && var.s3_bucket_policy_ssl_required == false && var.s3_bucket_policy_encryption_required == false ? 0 : 1

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.policyStatements
  })

  depends_on = [
    var.s3_bucket_policy_cloudfront_identities,
    aws_s3_bucket_public_access_block.bucket.id
  ]
}