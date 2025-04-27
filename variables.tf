#--------------------------------------------------------------
# S3 Variables
#--------------------------------------------------------------
variable "s3_acl" {
  type        = string
  default     = "private"
  description = "The canned ACL to apply"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the bucket"
}

variable "s3_encryption_enabled" {
  type        = bool
  default     = true
  description = "When set to 'true' the resource will have encryption enabled by default"
}

variable "s3_logging_enabled" {
  type        = bool
  default     = true
  description = "Enable logging for s3 bucket"
}

variable "s3_logging_target_prefix" {
  type        = string
  default     = "s3/%s3_bucket_name/"
  description = "Formatted path to log in target s3 bucket, use %s in replace of current s3 bucket name"
}

variable "s3_public_access_block" {
  type        = bool
  default     = true
  description = "Enable public access block"
}

variable "s3_versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable versioning"
}

variable "s3_versioning_status" {
  type        = string
  default     = "Enabled"
  description = "The versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
}

variable "s3_versioning_mfa_delete" {
  type        = string
  default     = "Disabled"
  description = "Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled."
}

variable "s3_website_enabled" {
  type        = bool
  default     = false
  description = "Enable website for s3 bucket"
}

variable "s3_website_index_document" {
  type        = string
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the sub-folders"
}

variable "s3_website_error_document" {
  type        = string
  default     = "404.html"
  description = "An absolute path to the document to return in case of a 4XX error"
}

variable "s3_website_redirect_all_requests_to" {
  type        = string
  default     = ""
  description = "A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored"
}

variable "s3_website_routing_rules" {
  type        = string
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
}

variable "s3_lifecycle_enabled" {
  type        = bool
  default     = false
  description = "If s3 lifecycle should be enabled"
}

variable "s3_lifecycle_expiration" {
  type = list(object({
    days = number
  }))
  default     = null
  description = "A data structure to create lifecycle rules"
}

variable "s3_lifecycle_prefix" {
  type        = string
  default     = null
  description = "Prefix identifying one or more objects to which the rule applies."
}

variable "s3_lifecycle_noncurrent_version_expiration" {
  type = list(object({
    noncurrent_days = number
  }))
  default     = null
  description = "A data structure to create lifecycle rules"
}

variable "s3_lifecycle_noncurrent_version_transition" {
  type = list(object({
    noncurrent_days = number
    storage_class   = string
  }))
  default     = null
  description = "A data structure to create lifecycle rules"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption"
  type        = string
  default     = null
}

#--------------------------------------------------------------
# S3 Cors Variables
#--------------------------------------------------------------
variable "s3_cors_enabled" {
  type        = bool
  description = "When set to 'true' the resource will add a cors policy to the s3 bucket"
  default     = false
}

variable "s3_cors_allowed_origins" {
  type        = list(string)
  description = "A list of allowed origins to be placed in the cors policy"
  default     = []
}

#--------------------------------------------------------------
# S3 Policy Variables
#--------------------------------------------------------------
variable "s3_bucket_policy_extra_statements" {
  type        = list(string)
  default     = []
  description = "List of custom policies to add to the bucket policy"
}

variable "s3_bucket_policy_ssl_required" {
  type        = bool
  default     = true
  description = "When set to 'true' the policy will updated to enforce PutObject to include SSL"
}

variable "s3_bucket_policy_encryption_required" {
  type        = bool
  default     = false
  description = "When set to 'true' the policy will updated to enforce PutObject to include encryption"
}

variable "s3_bucket_policy_cloudfront_identities" {
  type        = list(string)
  default     = []
  description = "List of cloudfront identities to add to the bucket policy"
}

#--------------------------------------------------------------
# Misc Variables
#--------------------------------------------------------------
variable "extra_tags" {
  type        = map(any)
  default     = {}
  description = "Map of additional tags to add the resources"
}
