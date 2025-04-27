{
    "Effect": "Allow",
    "Principal": {
        "AWS": "${identity}"
    },
    "Action": [
        "s3:GetObject",
        "s3:ListBucket"
    ],
    "Resource": [
        "${bucket_arn}",
        "${bucket_arn}/*"
    ]
}