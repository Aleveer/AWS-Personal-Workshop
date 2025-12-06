---
title : "Cấu hình Provider"
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

#### Cấu hình Provier.tf

Đầu tiên, chúng ta cần cấu hình Terraform provider và backend. File `provider.tf` định nghĩa AWS provider và các yêu cầu về version:
```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

+ File `provider.tf` định nghĩa:
  - Terraform version requirement (>= 1.5.0)
  - AWS provider version (~> 5.0)
  - AWS region được sử dụng (từ variable `aws_region`)