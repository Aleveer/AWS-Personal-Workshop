---
title : "Cấu hình ECR Repository"
weight : 5
chapter : false
pre : " <b> 5.3.5. </b> "
---

#### Tạo ECR Repository cho Docker Images

File `ecr.tf` định nghĩa ECR repository để lưu trữ Docker images:

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

+ ECR repository được cấu hình với:
  + Image Scanning: Enabled để tự động scan images khi push.
  + Repository name: `${var.project_name}-backend`.

+ Sau khi tạo repository, bạn sẽ sử dụng repository URL để push Docker images trong phần deploy backend.
