---
title : "Configure Provider"
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

#### Configure Provider.tf

First, we need to configure the Terraform provider and backend. The `provider.tf` file defines the AWS provider and version requirements:

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

+ The `provider.tf` file defines:
  - Terraform version requirement (>= 1.5.0)
  - AWS provider version (~> 5.0)
  - AWS region to use (from `aws_region` variable)
