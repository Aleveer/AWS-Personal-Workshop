---
title : "Cấu hình CloudWatch Logs & ECS Service"
weight : 9
chapter : false
pre : " <b> 5.3.9. </b> "
---

#### CloudWatch Logs & ECS Service

CloudWatch Log Group (trong `ecs-service.tf`):

```hcl
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}-backend"
  retention_in_days = 14
  tags              = var.default_tags
}
```

- Tên log group: `/ecs/${var.project_name}-backend`
- Retention: 14 ngày (tự động xóa để tiết kiệm chi phí)

ECS Task & Service (trong `ecs-service.tf`):

```hcl
# Security group cho ECS service
resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "ECS service security group"
  vpc_id      = var.vpc_id

  # Chỉ cho phép ALB gọi vào port 3000
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

# Task definition (Fargate)
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project_name}-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.lambda_exec.arn
  task_role_arn      = aws_iam_role.lambda_exec.arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = "${aws_ecr_repository.backend.repository_url}:${var.backend_image_tag}"
      essential = true
      portMappings = [{ containerPort = 3000, protocol = "tcp" }]
      environment = [
        { name = "NODE_ENV",              value = var.node_env },
        { name = "MONGODB_URI",           value = var.mongodb_uri },
        { name = "UPLOADS_BUCKET_NAME",   value = var.uploads_bucket_name },
        { name = "JWT_SECRET",            value = var.jwt_secret },
        { name = "JWT_EXPIRES_IN",        value = var.jwt_expires_in },
        { name = "JWT_REFRESH_EXPIRES_IN",value = var.jwt_refresh_expires_in },
        { name = "EMAIL_HOST",            value = var.email_host },
        { name = "EMAIL_PORT",            value = tostring(var.email_port) },
        { name = "EMAIL_SECURE",          value = tostring(var.email_secure) },
        { name = "EMAIL_USER",            value = var.email_user },
        { name = "EMAIL_PASS",            value = var.email_pass },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])

  tags = var.default_tags
}

# ECS service gắn với ALB target group
resource "aws_ecs_service" "backend" {
  name            = "${var.project_name}-ecs-service"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "backend"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
  tags       = var.default_tags
}
```

- Security Group: chỉ cho phép traffic từ ALB vào port 3000; outbound mở để ECS task truy cập internet/AWS services.
- Task Definition: Fargate, 0.5 vCPU, 1GB RAM; dùng chung role `lambda_exec` cho execution/task; inject toàn bộ env cho DB, S3, JWT, email.
- Logging: awslogs driver, log group `/ecs/${var.project_name}-backend`, stream prefix `backend`.
- Service: chạy 1 task, gắn ALB target group trên port 3000, cấp public IP qua public subnets.
- Phụ thuộc: service phụ thuộc listener HTTP của ALB (`depends_on = [aws_lb_listener.http]`).
