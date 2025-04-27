resource "aws_s3_bucket_cors_configuration" "config" {
  count  = var.s3_cors_enabled ? 1 : 0
  bucket = var.s3_bucket_name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = var.s3_cors_allowed_origins
    max_age_seconds = 3000
  }
}