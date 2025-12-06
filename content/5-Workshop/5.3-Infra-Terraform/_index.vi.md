---
title : "Thiết lập Infrastructure với Terraform"
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Tổng quan về Infrastructure as Code

Trong phần này, chúng ta sẽ sử dụng Terraform để định nghĩa và triển khai toàn bộ hạ tầng AWS cho ứng dụng WebChat. Terraform cho phép chúng ta quản lý infrastructure một cách nhất quán, có thể tái sử dụng và dễ dàng version control.

Hạ tầng được triển khai bao gồm các thành phần chính sau:

- **DynamoDB Tables**: Lưu trữ analytics events và backup data
- **S3 Bucket**: Lưu trữ files được upload từ users
- **ECR Repository**: Registry cho Docker images của backend
- **ECS Cluster và Service**: Container orchestration cho backend application
- **Application Load Balancer**: Phân phối lưu lượng và routing
- **IAM Roles và Policies**: Quản lý quyền truy cập
- **CloudWatch Logs**: Thu thập và lưu trữ logs
- **AWS Budgets**: Giám sát chi phí

#### Nội dung

1. [Cấu hình Provider](5.3.1-Provider/)
2. [Cấu hình Variables](5.3.2-Variables/)
3. [Cấu hình Variables cục bộ](5.3.3-Env-Variable/)
4. [Cấu hình S3 Bucket](5.3.4-S3-Bucket/)
5. [Cấu hình ECR Repository](5.3.5-ECR/)
6. [Cấu hình ECS Cluster](5.3.6-ECS-Cluster/)
7. [Cấu hình Application Load Balancer và Target Group](5.3.7-ALB/)
8. [Cấu hình IAM Roles và Policies](5.3.8-IAM/)
9. [Cấu hình CloudWatch Logs & ECS Service](5.3.9-Cloudwatch-ECSServices/)
10. [Cấu hình AWS Budgets](5.3.10-Budgets/)

#### Triển khai Infrastructure

Sau khi đã cấu hình tất cả các files Terraform, thực hiện các bước sau để deploy infrastructure:

+ Bước 1: Khởi tạo Terraform
  ```bash
  cd terraform
  terraform init
  ```
  
  Lệnh này sẽ download AWS provider và khởi tạo backend. Kết quả sẽ hiển thị "Terraform has been successfully initialized!":

  ![Terraform-Init](/images/5-Workshop/5.3-Infra-Terraform/terraform-init.png)

+ Bước 2: Xem kế hoạch triển khai
  ```bash
  terraform plan -var-file="dev.tfvars"
  ```
  
  Lệnh này sẽ hiển thị tất cả các resources sẽ được tạo. Kiểm tra kỹ để đảm bảo không có lỗi và resources đúng như mong đợi:

  ![Terraform-Plan](/images/5-Workshop/5.3-Infra-Terraform/terraform-plan.png)

+ Bước 3: Triển khai infrastructure
  ```bash
  terraform apply -var-file="dev.tfvars"
  ```
  
  Terraform sẽ hỏi xác nhận. Nhập `yes` để tiếp tục. Quá trình triển khai có thể mất 5-10 phút:

+ Bước 4: Kiểm tra kết quả

  ```bash
  terraform output
  ```
  
  Lệnh này sẽ hiển thị các outputs quan trọng như ALB DNS name, ECR repository URL, S3 bucket name:

  ![Terraform-Output](/images/5-Workshop/5.3-Infra-Terraform/terraform-output.png)

+ Sau khi triển khai thành công, bạn sẽ có:
  - 1 S3 bucket với encryption và versioning.
  - 1 ECR repository.
  - 1 ECS cluster.
  - 1 Application Load Balancer với target group.
  - IAM roles và policies.
  - CloudWatch log group.
  - AWS Budgets.

+ Sau khi triển khai thành công, bạn có thể kiểm tra nhanh bằng AWS CLI:

  ```bash
  aws s3 ls 
  aws ecr describe-repositories
  aws ecs list-clusters
  aws elbv2 describe-load-balancers
  aws iam list-roles
  aws logs describe-log-groups
  # Thay <ACCOUNT_ID> bằng AWS account ID của bạn
  aws budgets describe-budgets --account-id <ACCOUNT_ID>
  ```

  Kết quả sẽ hiển thị các resources đã tạo nếu CLI của bạn đã cấu hình đúng quyền và region:
  ![AWS-Console](/images/5-Workshop/5.3-Infra-Terraform/aws-resources.png)
