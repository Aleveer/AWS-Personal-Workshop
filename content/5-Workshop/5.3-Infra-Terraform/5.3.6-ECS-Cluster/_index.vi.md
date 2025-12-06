---
title : "Cấu hình ECS Cluster"
weight : 6
chapter : false
pre : " <b> 5.3.6. </b> "
---

#### Tạo ECS Cluster

File `ecs-cluster.tf` định nghĩa ECS cluster:

```hcl
resource "aws_ecs_cluster" "backend" {
  name = "${var.project_name}-ecs-cluster"

  tags = var.default_tags
}
```

+ ECS cluster là container orchestration platform, nơi các ECS tasks sẽ chạy.
