---
title : "Cấu hình IAM Roles và Policies"
weight : 8
chapter : false
pre : " <b> 5.3.8. </b> "
---

#### Tạo IAM Roles và Policies

File `alb.tf` định nghĩa ALB, security groups, target group và listener:

```hcl
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.project_name}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_app" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = ["${aws_s3_bucket.uploads.arn}/*"]
  }
}

resource "aws_iam_policy" "lambda_app" {
  name   = "${var.project_name}-lambda-app"
  policy = data.aws_iam_policy_document.lambda_app.json
}

resource "aws_iam_role_policy_attachment" "lambda_app" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_app.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

```

+ IAM role được cấu hình với:
  - Assume Role Policy: Cho phép ECS tasks và Lambda assume role này
  - AWSLambdaBasicExecutionRole: Managed policy cho CloudWatch Logs permissions
  - AmazonECSTaskExecutionRolePolicy: Managed policy cho ECR pull permissions
  - Custom Policy: Permissions cho S3 (get/put/delete object)

+ Role này được sử dụng làm cả execution role và task role cho ECS tasks.
