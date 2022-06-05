data "aws_iam_policy_document" "bucket" {

  dynamic "statement" {
    for_each = var.s3_bucket_policy_ssl_required == true ? [1] : []
    content {
      effect = "Deny"

      actions = ["s3:*"]

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      resources = ["${aws_s3_bucket.bucket.arn}/*"]

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_policy_encryption_required == true && var.s3_encryption_enabled == true ? [1] : []
    content {
      effect = "Deny"

      actions = ["s3:PutObject"]

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      resources = ["${aws_s3_bucket.bucket.arn}/*"]

      condition {
        test     = "Null"
        variable = "s3:x-amz-server-side-encryption"
        values   = ["true"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_policy_encryption_required == true && var.s3_encryption_enabled == true ? [1] : []
    content {
      effect = "Deny"

      actions = ["s3:PutObject"]

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      resources = ["${aws_s3_bucket.bucket.arn}/*"]

      condition {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption"
        values   = [var.s3_encryption_sse_algorithm]
      }
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_policy_cloudfront_identities
    content {
      effect = "Allow"

      actions = ["s3:GetObject"]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }

      resources = ["${aws_s3_bucket.bucket.arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_policy_extra_statements
    content {
      effect = title(statement.value["effect"])
      actions = statement.value["actions"]
      principals {
        type = try(title(statement.value["principals"].type), "*")
        identifiers = try(statement.value["principals"].identifiers, ["*"])
      } 
      resources = statement.value["resources"]
      
      dynamic "condition" {
        for_each = statement.value["condition"] != null ? try([statement.value["condition"]], []) : []
        content {
          test = condition.value["test"]
          variable = condition.value["variable"]
          values = condition.value["values"]
        }
      }
    }
  }

}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  policy = data.aws_iam_policy_document.bucket.json
}