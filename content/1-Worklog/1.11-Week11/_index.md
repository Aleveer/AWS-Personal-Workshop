---
title: "Week 11 Worklog"
weight: 2
chapter: false
pre: " <b> 1.11. </b> "
---

### Week 11 Objectives:
- Build the workshop and finalize the proposal on Hugo.
- Deploy the project to AWS Cloud: networking, database, backend, frontend.
- Monitor the system with CloudWatch, perform live testing, and track costs.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material | Note |
| ---- | ---- | ---------- | --------------- | ------------------ | ---- |
| 2 | - Build the workshop.<br>- Finalize the proposal on Hugo: write content, add diagrams, deploy the site. | 11/17/2025 | 11/17/2025 | Hugo Docs<br>Reveal.js / Markdown Slides | |
| 3 | - Configure AWS networking: create VPC, public subnet, Internet Gateway, Route Table.<br>- Set up Security Groups for backend/frontend. | 11/18/2025 | 11/18/2025 | AWS VPC Console<br>Lab 000003 Guide | |
| 4 | - Deploy MongoDB on Atlas Free Tier: create cluster, user, connection string.<br>- Connect Nest.js backend to Atlas MongoDB. | 11/19/2025 | 11/19/2025 | MongoDB Atlas Docs<br>Mongoose Config | |
| 5 | - Deploy backend to EC2: build Docker image, push to ECR, run container on EC2.<br>- Deploy frontend to S3 + CloudFront: build Vue.js, upload to S3, create distribution. | 11/20/2025 | 11/20/2025 | AWS EC2/ECR Console<br>S3/CloudFront Guide | |
| 6 | - Set up CloudWatch: log groups, dashboard (CPU, memory, connections), alarms (high latency).<br>- Live testing: test real-time chat with 5+ users, fix issues.<br>- Track AWS costs (Cost Explorer), clean up if needed. | 11/21/2025 | 11/21/2025 | CloudWatch Console<br>AWS Cost Explorer | |

### Week 11 Achievements:
- Finalized proposal with system diagrams.
- Successfully deployed to AWS:
  - Stable VPC network with public subnet for frontend/backend.
  - Smooth MongoDB Atlas connection.
  - Backend running on EC2 with Docker, frontend accessible via CloudFront.
- System monitoring:
  - CloudWatch dashboard tracking real-time metrics/logs.
  - Alarms sending alerts for high load and low health.
- Comprehensive live testing:
  - Chat works without errors with multiple users, real-time sync.
  - Latency < 200ms, no dropped messages.