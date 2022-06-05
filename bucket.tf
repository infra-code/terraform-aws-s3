resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name

  tags = merge(local.extra_tags)

  lifecycle {
    ignore_changes = [
      replication_configuration,
      lifecycle_rule
    ]
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.s3_acl
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  count = var.s3_encryption_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3_encryption_sse_algorithm
    }
  }
}

resource "aws_s3_bucket_website_configuration" "bucket" {
  count = var.s3_website_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.s3_website_index_document
  }

  error_document {
    key = var.s3_website_error_document
  }
}

resource "aws_s3_bucket_logging" "bucket" {
  count = var.s3_logging_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  target_bucket = var.s3_logging_target_bucket
  target_prefix = var.s3_logging_target_prefix
}

resource "aws_s3_bucket_versioning" "bucket" {
  count = var.s3_versioning_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}