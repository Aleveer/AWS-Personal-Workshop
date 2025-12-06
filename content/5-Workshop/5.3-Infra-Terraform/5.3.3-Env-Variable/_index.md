---
title : "Configure Local Variables"
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

#### Define Local Variables

The `dev.tfvars` file contains specific values for the locally used variables defined:

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

+ The `dev.tfvars` file needs to be adjusted with your actual values:
  - Replace MongoDB URI with the actual connection string.
  - Set a unique S3 bucket name (S3 bucket names must be globally unique).
  - Provide VPC ID and subnet IDs from your AWS account.
  - Configure email SMTP credentials.