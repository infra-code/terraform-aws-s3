%{ if require_ssl ~}
{
    "Sid": "OnlyAllowSSL",
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": "${bucket_arn}/*",
    "Condition": {
        "Bool": {
            "aws:SecureTransport": "false"
        }
    }
}
%{ endif ~}