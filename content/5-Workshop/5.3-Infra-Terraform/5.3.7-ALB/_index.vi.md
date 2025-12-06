---
title : "Cấu hình Application Load Balancer và Target Group"
weight : 7
chapter : false
pre : " <b> 5.3.7. </b> "
---

#### Tạo Application Load Balancer và Target Group

File `alb.tf` định nghĩa ALB, security groups, target group và listener:

```hcl
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  # Mở HTTP cho mọi nơi (thay bằng HTTPS hoặc giới hạn IP khi lên production)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = var.default_tags
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.project_name}-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/ping"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
    interval            = 30
    timeout             = 5
  }

  tags = var.default_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
```

+ ALB configuration bao gồm:
  - Security Group: Cho phép inbound HTTP (port 80) từ mọi nơi, outbound tất cả traffic
  - Load Balancer: Application Load Balancer type, deploy trên public subnets
  - Target Group: Listen trên port 3000 (backend port), health check tại `/api/ping`
  - Listener: HTTP listener trên port 80, forward traffic đến target group

+ Health check path `/api/ping` cần được implement trong code Backend để ALB có thể verify tasks đang healthy.
