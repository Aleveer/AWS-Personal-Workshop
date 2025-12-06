---
title : "Cấu hình Variables cục bộ"
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

#### Định nghĩa các biến xài cục bộ

File `dev.tfvars` chứa các giá trị cụ thể cho các variables xài cục bộ được định nghĩa:

```hcl
project_name = "webchat-app-dev"
aws_region   = "ap-southeast-2"

mongodb_uri         = "mongodb+srv://username:password@cluster.mongodb.net/"
uploads_bucket_name = "webchat-app-dev-uploads-2025-sg123456"
backend_image_tag   = "latest"
node_env            = "production"

jwt_secret             = "your-secret-key-here"
jwt_expires_in         = "7d"
jwt_refresh_expires_in = "30d"

email_host   = "smtp.gmail.com"
email_port   = 587
email_secure = false
email_user   = "your-email@gmail.com"
email_pass   = "your-app-password"

vpc_id            = "vpc-xxxxxxxxx"
public_subnet_ids = ["subnet-xxxxxxxxx", "subnet-yyyyyyyyy"]

default_tags = {
  managed-by = "terraform"
  env        = "dev"
  app        = "webchat-app"
}
```

+ File `dev.tfvars` cần được điều chỉnh với các giá trị thực tế của bạn:
  - Thay thế MongoDB URI với connection string thực tế.
  - Đặt tên S3 bucket unique (S3 bucket names phải globally unique).
  - Cung cấp VPC ID và subnet IDs từ AWS account của bạn.
  - Cấu hình email SMTP credentials.