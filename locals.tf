#--------------------------------------------------------------
# locals - common variables
#--------------------------------------------------------------
locals {
  tags = merge(var.extra_tags, {
    CreatedBy = "Terraform"
  })
}

// Workaround - Terraform does not currently support templatefile as a string, only as a file
data "template_file" "extra_statements" {
  count    = length(var.s3_bucket_policy_extra_statements)
  template = element(var.s3_bucket_policy_extra_statements, count.index)
  vars = {
    bucket_arn = local.bucket_arn
  }
}


locals {

  template_dir = "${path.module}/templates"
  template_vars = {
    require_encryption = var.s3_encryption_enabled == true ? var.s3_bucket_policy_encryption_required : false
    require_ssl        = var.s3_bucket_policy_ssl_required
    bucket_arn         = local.bucket_arn
  }

  bucket_arn = aws_s3_bucket.bucket.arn

  requiredPolicy         = [for p in compact([for file in fileset("${local.template_dir}/policy", "*.tpl") : templatefile("${local.template_dir}/policy/${file}", local.template_vars)]) : jsondecode(p)]
  cloudfrontPolicy       = [for p in compact([for i in var.s3_bucket_policy_cloudfront_identities : templatefile("${local.template_dir}/cloudfront/CloudfrontIdentities.tpl", { identity : i, bucket_arn : local.bucket_arn })]) : jsondecode(p)]
  extraPolicy            = flatten([for p in data.template_file.extra_statements.*.rendered : jsondecode(p)])
  policyStatements       = concat(local.requiredPolicy, local.cloudfrontPolicy, local.extraPolicy)
  default_logging_bucket = "${data.aws_iam_account_alias.current.id}-logging-${data.aws_region.current.name}"
}
