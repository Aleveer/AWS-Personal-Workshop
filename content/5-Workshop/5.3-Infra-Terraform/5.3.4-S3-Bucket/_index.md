---
title : "Configure S3 Bucket"
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
---

#### Create S3 Bucket for File Storage

The `s3.tf` file defines an S3 bucket with security and versioning configurations:

```hcl
resource "aws_s3_bucket" "uploads" {
  bucket = var.uploads_bucket_name

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-uploads"
    }
  )
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

```

+ The S3 bucket is configured with:

  + Versioning: Enabled to store multiple versions of files
  + Encryption: AES256 server-side encryption to secure data
  + Public Access Block: All public access is blocked to ensure security

+ Bucket name must be globally unique. Ensure `uploads_bucket_name` in `dev.tfvars` is unique.
