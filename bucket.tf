resource "aws_s3_bucket" "bucket" {
  #checkov:skip=CKV_AWS_144: "We do not need to enforce cross-region replication especially inside a terraform module"
  #checkov:skip=CKV_AWS_145: "We have server side encryption enabled"

  bucket = var.s3_bucket_name

  tags = local.tags
}

resource "aws_s3_bucket_logging" "logging" {
  count = var.s3_logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  target_bucket = local.default_logging_bucket
  target_prefix = replace(var.s3_logging_target_prefix, "%s3_bucket_name", var.s3_bucket_name)
}



resource "aws_s3_bucket_public_access_block" "bucket" {
  count = var.s3_public_access_block ? 1 : 0
  #checkov:skip=CKV_AWS_144: "We do not need to enforce cross-region replication especially inside a terraform module"
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block

  depends_on = [
    aws_s3_bucket_policy.bucket
  ]
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.s3_acl

  depends_on = [
    aws_s3_bucket_public_access_block.bucket,
    aws_s3_bucket_ownership_controls.bucket
  ]
}

resource "aws_s3_bucket_lifecycle_configuration" "config" {
  count = var.s3_lifecycle_enabled ? 1 : 0

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "${var.s3_bucket_name}-lifecycle-config"

    dynamic "expiration" {
      for_each = var.s3_lifecycle_expiration == null || var.s3_lifecycle_expiration == "" ? [] : var.s3_lifecycle_expiration

      content {
        days = expiration.value.days
      }
    }

    dynamic "filter" {
      # Check if the prefix is set
      for_each = var.s3_lifecycle_prefix != null && var.s3_lifecycle_prefix != "" ? [1] : []

      content {
        prefix = var.s3_lifecycle_prefix
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.s3_lifecycle_noncurrent_version_expiration == null ? [] : var.s3_lifecycle_noncurrent_version_expiration

      content {
        noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
      }
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.s3_lifecycle_noncurrent_version_transition == null ? [] : var.s3_lifecycle_noncurrent_version_transition

      content {
        noncurrent_days = noncurrent_version_transition.value.noncurrent_days
        storage_class   = noncurrent_version_transition.value.storage_class
      }
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count  = var.s3_encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.s3_versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status     = var.s3_versioning_status
    mfa_delete = var.s3_versioning_mfa_delete
  }
}

resource "aws_s3_bucket_website_configuration" "default" {
  count  = var.s3_website_enabled ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.s3_website_index_document
  }

  error_document {
    key = var.s3_website_error_document
  }
}
