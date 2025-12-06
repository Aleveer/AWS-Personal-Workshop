---
title : "Infrastructure Setup with Terraform"
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Infrastructure as Code Overview

In this section, we will use Terraform to define and deploy the entire AWS infrastructure for the WebChat application. Terraform allows us to manage infrastructure in a consistent, reusable, and easily version-controlled manner.

The deployed infrastructure includes the following main components:

- **DynamoDB Tables**: Store analytics events and backup data.
- **S3 Bucket**: Store files uploaded by users.
- **ECR Repository**: Registry for backend Docker images.
- **ECS Cluster and Service**: Container orchestration for backend application.
- **Application Load Balancer**: Traffic distribution and routing.
- **IAM Roles and Policies**: Access control management.
- **CloudWatch Logs**: Log collection and storage.
- **AWS Budgets**: Cost monitoring.

#### Content

1. [Configure Provider](5.3.1-Provider/)
2. [Configure Variables](5.3.2-Variables/)
3. [Configure Local Variables](5.3.3-Env-Variable/)
4. [Configure S3 Bucket](5.3.4-S3-Bucket/)
5. [Configure ECR Repository](5.3.5-ECR/)
6. [Configure ECS Cluster](5.3.6-ECS-Cluster/)
7. [Configure Application Load Balancer and Target Group](5.3.7-ALB/)
8. [Configure IAM Roles and Policies](5.3.8-IAM/)
9. [Configure CloudWatch Logs & ECS Service](5.3.9-Cloudwatch-ECSServices/)
10. [Configure AWS Budgets](5.3.10-Budgets/)

#### Deploy Infrastructure

After configuring all Terraform files, follow these steps to deploy the infrastructure:

+ Step 1: Initialize Terraform
  ```bash
  cd terraform
  terraform init
  ```
  
  This command will download the AWS provider and initialize the backend. The result will display "Terraform has been successfully initialized!":

  ![Terraform-Init](/images/5-Workshop/5.3-Infra-Terraform/terraform-init.png)

+ Step 2: View deployment plan
  ```bash
  terraform plan -var-file="dev.tfvars"
  ```
  
  This command will display all resources that will be created. Review carefully to ensure there are no errors and resources are as expected:

  ![Terraform-Plan](/images/5-Workshop/5.3-Infra-Terraform/terraform-plan.png)

+ Step 3: Deploy infrastructure
  ```bash
  terraform apply -var-file="dev.tfvars"
  ```
  
  Terraform will ask for confirmation. Type `yes` to continue. The deployment process may take 5-10 minutes:

+ Step 4: Check results

  ```bash
  terraform output
  ```
  
  This command will display important outputs such as ALB DNS name, ECR repository URL, S3 bucket name:

  ![Terraform-Output](/images/5-Workshop/5.3-Infra-Terraform/terraform-output.png)

+ After successful deployment, you will have:
  - 1 S3 bucket with encryption and versioning.
  - 1 ECR repository.
  - 1 ECS cluster.
  - 1 Application Load Balancer with target group.
  - IAM roles and policies.
  - CloudWatch log group.
  - AWS Budgets.

+ After successful deployment, you can quickly verify using AWS CLI:

  ```bash
  aws s3 ls 
  aws ecr describe-repositories
  aws ecs list-clusters
  aws elbv2 describe-load-balancers
  aws iam list-roles
  aws logs describe-log-groups
  # Replace <ACCOUNT_ID> with your AWS account ID
  aws budgets describe-budgets --account-id <ACCOUNT_ID>
  ```

  The results will display the created resources if your CLI is configured with correct permissions and region:
  ![AWS-Console](/images/5-Workshop/5.3-Infra-Terraform/aws-resources.png)
