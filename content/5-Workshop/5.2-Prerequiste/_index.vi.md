---
title : "Các bước chuẩn bị"
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### Thiết lập IAM Permission cần thiết

```json
{
  "Version": "2025-12-05",
  "Statement": [
    {
      "Sid": "ProjectTaskPermission",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketVersioning",
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudfront:CreateInvalidation",
        "cloudfront:GetDistribution",
        "cloudfront:ListDistributions",
        "cloudfront:GetInvalidation",
        "cloudfront:ListInvalidations",
        "route53:ListHostedZones",
        "route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:GetChange",
        "route53:ChangeResourceRecordSets",
        "amplify:GetApp",
        "amplify:ListApps",
        "amplify:GetBranch",
        "amplify:ListBranches",
        "amplify:StartDeployment",
        "amplify:GetJob",
        "amplify:ListJobs"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Thiết lập môi trường làm việc

Trong workshop này, chúng ta sẽ sử dụng AWS region ap-southeast-2 (Sydney) làm mặc định.

Để chuẩn bị cho môi trường làm workshop, bạn cần thiết lập các công cụ và tài nguyên sau:

1. Tài khoản AWS và cấu hình AWS CLI

+ Đăng nhập vào AWS Console và đảm bảo bạn có quyền truy cập đầy đủ để tạo các tài nguyên sau:
  - ECS (clusters, services, task definitions).
  - ECR (repositories, images).
  - ALB (load balancers, target groups, listeners).
  - S3 (buckets, objects).
  - CloudWatch (log groups, metrics).
  - IAM (roles, policies).
  - VPC và Networking.

+ Cài đặt AWS CLI vào thiết bị của mình nếu chưa có:

  ```bash
  # Windows (PowerShell)
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
  ```

+ Cấu hình AWS CLI với Credentials của bạn:

  ```bash
  aws configure
  ```
  
  Nhập các thông tin sau khi được yêu cầu:
  - AWS Access Key ID
  - AWS Secret Access Key
  - Default region name: `ap-southeast-2`
  - Default output format: `json`

+ Kiểm tra cấu hình đã thành công:

  ```bash
  aws sts get-caller-identity
  ```

  Kết quả sẽ hiển thị Account ID, User ARN và User ID của bạn:

  ![get-caller-identity](/images/5-Workshop/5.2-Prerequisite/aws-sts.png)

#### 2. Cài đặt Terraform

+ Tải Terraform từ [HashiCorp-Terraform](https://developer.hashicorp.com/terraform/install)

+ Giải nén và thêm vào PATH (hoặc sử dụng package manager):
  
  ```bash
  choco install terraform
  ```
  
+ Kiểm tra cài đặt:
  
  ```bash
  terraform version
  ```
  
  Kết quả sẽ hiển thị phiên bản Terraform đã cài đặt (ví dụ: `Terraform v1.14.0`):
  
  ![Terraform-Version](/images/5-Workshop/5.2-Prerequisite/terraform-Version.png)
  
#### 3. Cài đặt các công cụ khác

  Cài đặt các công cụ khác như Docker, MongoDB, Git, ...

  Cách thiết lập MongoDB Atlas (Cloud):

+ Đăng ký tài khoản miễn phí tại [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
+ Tạo một cluster miễn phí (M0 Free Tier)
+ Lấy connection string từ MongoDB Atlas dashboard:
  - Click vào "Connect" trên cluster
  - Chọn "Connect your application"
  - Copy connection string (ví dụ: `mongodb+srv://username:password@cluster.mongodb.net/`)
+ Lưu connection string này để sử dụng trong file `terraform/dev.tfvars` sau này.
