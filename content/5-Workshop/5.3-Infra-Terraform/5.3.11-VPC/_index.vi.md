---
title : "Cấu hình VPC"
weight : 11
chapter : false
pre : " <b> 5.3.11. </b> "
---

#### Tạo VPC

File `vpc.tf` định nghĩa một VPC cơ bản với các subnet công cộng:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = var.default_tags
}
```

- Tạo VPC với module `terraform-aws-modules/vpc/aws` giúp đơn giản hóa việc cấu hình mạng. Trong ví dụ này, chúng ta tạo một VPC với CIDR `10.0.0.0/16`, hai Availability Zones, và các subnet công cộng.
- Các tham số như `enable_nat_gateway` và `enable_vpn_gateway` được đặt thành `false` để giữ cấu hình đơn giản.
