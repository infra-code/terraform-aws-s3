#--------------------------------------------------------------
# AWS Variables
#--------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

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

variable "s3_encryption_sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use"
}

variable "s3_logging_enabled" {
  type        = bool
  default     = false
  description = "Enable logging for s3 bucket"
}

variable "s3_logging_target_bucket" {
  type        = string
  default     = ""
  description = "Target s3 bucket for logging for current s3 bucket"
}

variable "s3_logging_target_prefix" {
  type        = string
  default     = ""
  description = "Formatted path to log in target s3 bucket, use %s in replace of current s3 bucket name"
}

variable "s3_public_access_block" {
  type        = bool
  default     = true
  description = "Enable public access block"
}

variable "s3_versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable versioning"
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

#--------------------------------------------------------------
# S3 Policy Variables
#--------------------------------------------------------------
variable "s3_bucket_policy_extra_statements" {
  type        = list(object({
    effect = string
    principals = optional(object({
      type = string
      identifiers = list(string)
    }))
    resources = list(string)
    actions = list(string)
    condition = optional(object({
      test = string
      variable = string
      values = list(string)
    }))
  }))

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
  default     = true
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
