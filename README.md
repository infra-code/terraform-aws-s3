# Amazon S3 Terraform Module

Terraform module that creates a S3 bucket in AWS using optional security requirements provided by Terraform AWS provider.

### Features ###
* static website hosting
* custom policies
* cloudfront identity policy
* versioning
* logging
* require SSL
* require Encryption

*Currently does not support*
* Replication
* Lifecycles
* Object locks

## Examples

### Minimum Required
```
module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
}
```

### Logging Enabled
```
module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
  
  s3_logging_enabled = true
  s3_logging_target_bucket = "test-logging-us-east-1"
  s3_logging_target_prefix = "/logs/s3-bucket-name"
}
```

### Custom Policy
```
module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
  
  s3_bucket_policy_extra_statements = [
    {
      effect = "Allow"
      principals = {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }
      actions   = ["s3:GetBucketAcl"]
      resources = ["arn:aws:s3:::s3-bucket-name"]
    },
    {
      effect = "Allow"
      principals = {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }
      actions = ["s3:PutObject"]
      resources = ["arn:aws:s3:::s3-bucket-name/cloudtrail/*", "arn:aws:s3:::s3-bucket-name/cloudtrail"]
      condition = {
        test = "StringEquals"
        variable = "s3:x-amz-acl"
        values = ["bucket-owner-full-control"]
      }
    }
  ]
}
```

### Disabling SSL Requirement
```
module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
  
  s3_bucket_policy_ssl_required = false
}
```

### Cloudfront Identity
```
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
  
  s3_bucket_policy_cloudfront_identities = [
    aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
  ]
}
```

### Extra Tags
```
module "s3" {
  source  = "git@github.com:infra-code/terraform-aws-s3.git"

  aws_region = "us-east-1"

  s3_bucket_name = "s3-bucket-name"
  
  extra_tags = {
    Department = "MyDepartment"
    Service = "MyService"
  }
}
```