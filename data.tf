data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_region" "current" {}

data "aws_s3_bucket" "logging_bucket" {
  count  = var.s3_logging_enabled ? 1 : 0
  bucket = local.default_logging_bucket
}