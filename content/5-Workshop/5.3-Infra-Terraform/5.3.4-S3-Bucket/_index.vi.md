---
title : "Cấu hình S3 Bucket"
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
---

#### Tạo S3 Bucket cho File Storage

File `s3.tf` định nghĩa S3 bucket với các cấu hình bảo mật và versioning:

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

+ S3 bucket được cấu hình với:

  + Versioning: Enabled để lưu trữ multiple versions của files
  + Encryption: AES256 server-side encryption để bảo mật data
  + Public Access Block: Tất cả public access bị chặn để đảm bảo security

+ Bucket name phải globally unique. Đảm bảo `uploads_bucket_name` trong `dev.tfvars` là unique.
