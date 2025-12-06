---
title : "Configure Variables"
weight : 2
chapter : false
pre : " <b> 5.3.2. </b> "
---

#### Define Variables in Variables.tf

The `variables.tf` file defines all variables used in the Terraform configuration:

```hcl
variable "project_name" {
  description = "Project name, used to prefix resources."
  type        = string
  default     = "webchat-app"
}

variable "aws_region" {
  description = "AWS region to deploy."
  type        = string
  default     = "ap-southeast-2"
}

variable "uploads_bucket_name" {
  description = "S3 bucket name for storing uploads."
  type        = string
}

variable "backend_image_tag" {
  description = "Docker image tag for backend on ECR."
  type        = string
  default     = "latest"
}

variable "node_env" {
  description = "NODE_ENV value for backend."
  type        = string
  default     = "production"
}

variable "jwt_secret" {
  description = "JWT secret if you still use self-signed JWT in backend."
  type        = string
  sensitive   = true
}

variable "jwt_expires_in" {
  description = "JWT access token expiration time."
  type        = string
  default     = "7d"
}

variable "jwt_refresh_expires_in" {
  description = "JWT refresh token expiration time."
  type        = string
  default     = "30d"
}

variable "cognito_callback_urls" {
  description = "List of callback URLs for Cognito Hosted UI (e.g., frontend URL)."
  type        = list(string)
  default     = []
}

variable "cognito_logout_urls" {
  description = "List of logout URLs for Cognito Hosted UI."
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    managed-by = "terraform"
  }
}

variable "mongodb_uri" {
  description = "MongoDB URI for backend."
  type        = string
}

# List of emails to receive AWS Budgets alerts (cost threshold exceeded)
variable "budget_alert_emails" {
  description = "List of emails that will receive alerts when AWS costs exceed budget threshold."
  type        = list(string)
  default     = ["nguyenngocthanhdai2003@gmail.com"]
}

#mail smtp:
variable "email_host" {
  description = "SMTP server host."
  type        = string
}

variable "email_port" {
  description = "SMTP server port."
  type        = number
}

variable "email_secure" {
  description = "Whether to use SSL."
  type        = bool
}

variable "email_user" {
  description = "Email account."
  type        = string
}

variable "email_pass" {
  description = "Email password."
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID for ALB (Application Load Balancer) + ECS (Elastic Container Service)"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB (Application Load Balancer) and ECS (Fargate)"
  type        = list(string)
}

```
