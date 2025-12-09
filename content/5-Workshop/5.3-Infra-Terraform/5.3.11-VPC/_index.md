---
title : "Configure AWS VPC"
weight : 11
chapter : false
pre : " <b> 5.3.11. </b> "
---

#### Create VPC

The `vpc.tf` file defines a basic VPC with public subnets:

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

- Create VPC using the `terraform-aws-modules/vpc/aws` module to simplify network configuration. In this example, we create a VPC with CIDR `10.0.0.0/16`, two Availability Zones, and public subnets.
- Parameters such as `enable_nat_gateway` and `enable_vpn_gateway` are set to `false` to keep the configuration simple.