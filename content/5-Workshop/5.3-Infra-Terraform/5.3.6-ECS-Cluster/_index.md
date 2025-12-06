---
title : "Configure ECS Cluster"
weight : 6
chapter : false
pre : " <b> 5.3.6. </b> "
---

#### Create ECS Cluster

The `ecs-cluster.tf` file defines an ECS cluster:

```hcl
resource "aws_ecs_cluster" "backend" {
  name = "${var.project_name}-ecs-cluster"

  tags = var.default_tags
}
```

+ The ECS cluster is a container orchestration platform where ECS tasks will run.
