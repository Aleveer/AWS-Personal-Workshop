---
title : "Configure ECR Repository"
weight : 5
chapter : false
pre : " <b> 5.3.5. </b> "
---

#### Create ECR Repository for Docker Images

The `ecr.tf` file defines an ECR repository to store Docker images:

```hcl
resource "aws_ecr_repository" "backend" {
  name = "${var.project_name}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-backend-ecr"
    }
  )
}
```

+ The ECR repository is configured with:
  + Image Scanning: Enabled to automatically scan images when pushed.
  + Repository name: `${var.project_name}-backend`.

+ After creating the repository, you will use the repository URL to push Docker images in the backend deployment section.
