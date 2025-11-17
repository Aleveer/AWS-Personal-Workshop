---
title: "Week 6 Worklog"
weight: 1
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:
- Acknowledge DNS with Amazon Route 53: hosted zone, record, routing policy.
- Acknowledge AWS CLI: installation, configuration, basic command practice.
- Acknowledge DynamoDB via CLI: create table, perform CRUD operations.
- Deploy and use ElastiCache Redis: launch cluster, SET/GET commands.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| ---- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Practice Lab 000010: Create public hosted zone on Route 53.<br>- Add records (A, CNAME, MX).<br>- Configure routing policy (Simple, Weighted, Latency). | 10/13/2025 | 10/13/2025 | https://000010.awsstudygroup.com/ | DNS management |
| 3 | - Practice Lab 000011: Install AWS CLI.<br>- Configure profile (Access Key, Secret Key, Region).<br>- Practice basic commands: aws ec2 describe-instances, aws s3 ls, aws iam list-users, aws rds describe-db-instances. | 10/14/2025 | 10/14/2025 | https://000011.awsstudygroup.com/ | Admin automation |
| 4 | - Practice Lab 000060: Create DynamoDB table via CLI (aws dynamodb create-table).<br>- Perform CRUD: put-item, get-item, update-item, delete-item.<br>- Query and Scan data. | 10/15/2025 | 10/15/2025 | https://000060.awsstudygroup.com/ | NoSQL via CLI |
| 5 | - Practice Lab 000061: Launch Redis cluster on ElastiCache.<br>- Connect using redis-cli or application.<br>- Practice SET key value and GET key commands. | 10/16/2025 | 10/16/2025 | https://000061.awsstudygroup.com/ | In-memory cache |
| 6 | - (Reserve) Review all Week 6 labs.<br>- Clean up resources: delete hosted zone, DynamoDB table, Redis cluster, remove CLI profile if needed. | 10/17/2025 | 10/17/2025 | | Cost control |

### Week 6 Achievements:
- Acknowledged Route 53:
  - Created and managed public hosted zone.
  - Configured records and flexible routing policies.
- Acknowledged AWS CLI:
  - Installed and configured profile successfully.
  - Executed EC2, S3, IAM, RDS management commands smoothly.
- Managed DynamoDB via CLI:
  - Created table with primary key.
  - Performed full CRUD, Query, Scan operations.
- Deployed ElastiCache Redis:
  - Launched cluster with stable connection.
  - Used SET/GET commands to store and retrieve in-memory data.
- Completed labs 000010, 000011, 000060, 000061.