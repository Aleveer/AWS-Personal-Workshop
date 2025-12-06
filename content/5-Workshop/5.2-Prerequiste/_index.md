---
title : "Prerequisite"
weight : 2 
chapter : false
pre : " <b> 5.2. </b> "
---

#### Setup Required IAM Permissions

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

#### Setup Working Environment

In this workshop, we will use AWS region ap-southeast-2 (Sydney) as the default.

To prepare for the workshop environment, you need to set up the following tools and resources:

1. AWS Account and AWS CLI Configuration

+ Log in to AWS Console and ensure you have full access to create the following resources:
  - ECS (clusters, services, task definitions).
  - ECR (repositories, images).
  - ALB (load balancers, target groups, listeners).
  - S3 (buckets, objects).
  - CloudWatch (log groups, metrics).
  - IAM (roles, policies).
  - VPC and Networking.

+ Install AWS CLI on your device if not already installed:

  ```bash
  # Windows (PowerShell)
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
  ```

+ Configure AWS CLI with your Credentials:

  ```bash
  aws configure
  ```
  
  Enter the following information when prompted:
  - AWS Access Key ID
  - AWS Secret Access Key
  - Default region name: `ap-southeast-2`
  - Default output format: `json`

+ Verify the configuration was successful:

  ```bash
  aws sts get-caller-identity
  ```

  The result will display your Account ID, User ARN, and User ID:

  ![get-caller-identity](/images/5-Workshop/5.2-Prerequisite/aws-sts.png)

#### 2. Install Terraform

+ Download Terraform from [HashiCorp-Terraform](https://developer.hashicorp.com/terraform/install)

+ Extract and add to PATH (or use package manager):
  
  ```bash
  choco install terraform
  ```
  
+ Verify installation:
  
  ```bash
  terraform version
  ```
  
  The result will display the installed Terraform version (e.g., `Terraform v1.14.0`):
  
  ![Terraform-Version](/images/5-Workshop/5.2-Prerequisite/terraform-Version.png)
  
#### 3. Install Other Tools

  Install other tools such as Docker, MongoDB, Git, ...

  How to set up MongoDB Atlas (Cloud):

+ Sign up for a free account at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
+ Create a free cluster (M0 Free Tier)
+ Get the connection string from MongoDB Atlas dashboard:
  - Click "Connect" on the cluster
  - Select "Connect your application"
  - Copy the connection string (e.g., `mongodb+srv://username:password@cluster.mongodb.net/`)
+ Save this connection string to use in the `terraform/dev.tfvars` file later.
