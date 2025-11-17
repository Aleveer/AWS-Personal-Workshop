---
title: "Project Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---
### Real-Time Chat Application
### 1. Executive Summary

The Serverless Web Chat Platform is developed to provide a fast, secure, and easy-to-operate internal communication solution. The application supports real-time messaging between lab members through a lightweight web interface, with flexible scalability for future needs. The platform leverages AWS Serverless services such as API Gateway, AWS Lambda, DynamoDB, and Amazon Cognito to ensure stable operation, low cost, and no server management requirements. Access is restricted to lab members, ensuring security and privacy during information exchange.

### 2. Problem Statement  
*Current Challenges*  
The team is developing a chat application for learning and research purposes on building real-time web systems. If implemented using a traditional model (self-hosted servers, self-managed databases, and maintained WebSocket connections), the team would face numerous difficulties, including complex infrastructure setup, handling scalability with many concurrent connections, ensuring stability and security, as well as comprehensive system logging and monitoring. Not utilizing AWS services makes it difficult for the team to simulate modern infrastructure models, while also wasting time on operational tasks instead of focusing on core application development and technical learning.

*Solution*  
The Web Chat application is implemented using AWS services to simulate a modern application architecture. The backend uses NestJS, packaged and run on Amazon ECS or deployed directly on Amazon EC2 depending on the team's testing needs. DynamoDB is used to store messages and user information. Amazon S3 combined with CloudFront serves the VueJS frontend, optimizing content delivery speed. Route 53 is used for domain management and routing access to the frontend and backend. The entire system is monitored using Amazon CloudWatch, including logs, performance metrics, and alerts. This architecture enables the team to research the operation, deployment, and scaling of real-world applications in the AWS environment. It allows the team to easily experiment, expand features, and understand application operations in a cloud environment.

*Benefits and Return on Investment (ROI)*  
The solution enables the team to practice building a complete chat application from frontend to backend, combined with commonly used cloud services in enterprise environments. By leveraging the AWS Free Tier and test resources, deployment costs are low while still ensuring sufficient practicality for the team to gain a deep understanding of infrastructure management, monitoring, scaling, and security. Deploying on AWS reduces manual configuration time and creates a solid foundation for advanced research such as chatbots, user activity data processing, or AI system integration. The return on investment is nearly immediate due to no hardware costs and significantly reduced operational effort.

### 3. Solution Architecture  
The platform adopts an AWS Serverless architecture to manage data from 5 Raspberry Pi-based stations, scalable to 15 stations. Data is ingested via AWS IoT Core, stored in an S3 data lake, and processed by AWS Glue Crawlers and ETL jobs to transform and load into another S3 bucket for analytics purposes. Lambda and API Gateway handle additional processing, while Amplify with Next.js provides a dashboard secured by Cognito.  

![IoT Weather Station Architecture](/images/2-Proposal/edge_architecture.jpeg)

![IoT Weather Platform Architecture](/images/2-Proposal/platform_architecture.jpeg)

*AWS Services Utilized*  
- *AWS IoT Core*: Ingests MQTT data from 5 stations, scalable to 15.  
- *AWS Lambda*: Processes data and triggers Glue jobs (2 functions).  
- *Amazon API Gateway*: Interfaces with the web application.  
- *Amazon S3*: Stores raw data (data lake) and processed data (2 buckets).  
- *AWS Glue*: Crawlers index data; ETL jobs transform and load data.  
- *AWS Amplify*: Hosts the Next.js web interface.  
- *Amazon Cognito*: Manages access for lab users.  

*Component Design*  
- *Edge Devices*: Raspberry Pi collects and filters sensor data, sends to IoT Core.  
- *Data Ingestion*: AWS IoT Core receives MQTT messages from edge devices.  
- *Data Storage*: Raw data stored in S3 data lake; processed data in a separate S3 bucket.  
- *Data Processing*: AWS Glue Crawlers index data; ETL jobs transform for analysis.  
- *Web Interface*: AWS Amplify hosts the Next.js application for dashboard and real-time analytics.  
- *User Management*: Amazon Cognito limits access to 5 active accounts.  

### 4. Technical Implementation  
**Implementation Phases**  
The Web Chat project consists of 2 main parts — backend and frontend — each undergoing 4 phases:  

1. **Research and Architecture Design**: Study VueJS, NestJS, and AWS services (EC2/ECS, S3, DynamoDB, CloudFront, Route53, CloudWatch). Design overall architecture, data flow, database, and real-time connections (1 month before internship).  
2. **Cost Estimation and Feasibility Check**: Use AWS Pricing Calculator to estimate costs for EC2/ECS, DynamoDB, S3, CloudFront, CloudWatch and adjust the design accordingly (Month 1).  
3. **Architecture Optimization for Cost/Solution**: Fine-tune ECS/EC2 configuration, optimize DynamoDB queries, cache frontend with CloudFront, and program NestJS/VueJS to reduce backend load, ensuring cost-effectiveness and performance (Month 2).  
4. **Development, Testing, Deployment**: Program NestJS backend and VueJS frontend; deploy ECS/EC2, S3 + CloudFront, DynamoDB, Route53, CloudWatch; conduct system testing (functional, load test) and go live (Months 2–3).  

---

**_Technical Requirements_**  
- **Backend**: NestJS with real-time connectivity (WebSocket or REST), store chat and user data in DynamoDB, log and monitor via CloudWatch, container deployment on ECS or EC2, domain integration via Route53.  
- **Frontend**: VueJS, distributed via S3 + CloudFront for speed optimization, load assets and real-time chat interface.  
- **Infrastructure & CI/CD**: Use Infrastructure as Code (CloudFormation / CDK) to deploy ECS/EC2, S3, DynamoDB, CloudFront, Route53; Dockerize backend for easy deployment and scaling.  
- **Real-time & Performance**: WebSocket or API Gateway (if using REST) for real-time message sending/receiving; cache frontend with CloudFront to reduce direct backend requests.  
- **Security & User Management**: Use JWT or Cognito if needed for authentication, authorize access to internal chat data.  

### 5. Roadmap & Milestones  
- *Pre-Internship (Month 0)*: 1 month surveying project requirements, selecting technologies (VueJS, NestJS, EC2, S3, DynamoDB, CloudFront, Route53, ECS, CloudWatch) and building the overall plan.
- *Internship (Months 1–3)*:  
    - Month 1: Learn and familiarize with AWS (EC2, ECS, DynamoDB, S3, CloudFront, Route53, CloudWatch). Set up development environment, create NestJS backend and VueJS frontend prototypes. 
    - Month 2: Design and adjust system architecture, build core features (real-time chat, message storage, basic UI). Set up AWS infrastructure: ECS/EC2 for backend, S3 + CloudFront for frontend, DynamoDB for data, Route53 for domain.  
    - Month 3: Official deployment, testing (functional, load 20–30 users), performance optimization, configure CloudWatch monitoring and put into operation. 
- *Post-Deployment*: Continue research and feature expansion for 1 year (chatbot, data analytics, UI/UX improvements, security and cost optimization).  

### 6. Budget Estimation  (to be calculated)
View costs on the [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  
Or download the [budget estimation file](../attachments/budget_estimation.pdf).  

*Infrastructure Costs*  (not yet calculated)
- EC2: 0.00 USD/month (instance type & running hours not yet estimated).
- ECS (Fargate or EC2-backed): 0.00 USD/month (vCPU/Memory not yet estimated).
- DynamoDB: 0.00 USD/month (~30,000 writes, 0.086 GB data, On-Demand or RCU/WCU not yet estimated).
- S3 Standard: 0.00 USD/month (~2.15 GB storage, 3,750 requests/month).
- CloudFront: 0.00 USD/month (static frontend distribution + reduced S3 load).
- CloudWatch: 0.00 USD/month (~56 MB logs/month).
- Route53: 0.00 USD/month (1 hosted zone + DNS queries).
- Data Transfer: 0.00 USD/month (~0.387 GB outbound/month).

*Total*: 0.7 USD/month, 8.40 USD/12 months  
- *Hardware*: 265 USD one-time (Raspberry Pi 5 and sensors).  

### 7. Risk Assessment  
**Risk Matrix**  
- Network loss / internet outage: Medium impact, medium probability.  
- Backend EC2/ECS downtime: High impact, low probability.  
- Data errors / DynamoDB: High impact, low probability.  
- AWS budget overrun: Medium impact, low probability.  
- Frontend / CloudFront errors: Low impact, medium probability.  

**Mitigation Strategies**  
- Network/Internet loss: Use frontend cache (CloudFront) and retry logic in NestJS; temporarily store messages locally if offline (localStorage or IndexedDB).  
- Backend downtime: Deploy ECS with autoscaling and health checks; use multi-AZ EC2 if needed.  
- Data errors / DynamoDB: Enable automatic backups, validate schema; log and monitor with CloudWatch.  
- AWS budget overrun: Set CloudWatch billing alarms, control log retention, optimize instances/services.  
- Frontend / CloudFront errors: Use versioned deployments for quick rollback if needed.  

**Contingency Plan**  
- Use Infrastructure as Code (CloudFormation / Terraform) to quickly recreate AWS infrastructure.  
- If AWS experiences prolonged issues, run a **local dev server version (VueJS + NestJS on personal or lab machines)** to continue internal chat.  
- Regularly check CloudWatch logs and health metrics to detect issues early.

### 8. Expected Outcomes  
**Technical Improvements**  
- Real-time chat application, replacing manual exchanges via email or notes.  
- Centralized storage of messages and attachments, easy to retrieve and manage.  
- Modular architecture with NestJS backend, VueJS frontend, and AWS infrastructure (EC2/ECS, S3, DynamoDB, CloudFront, Route53, CloudWatch) scalable to serve 50 to 100 users in the future.  

**Long-Term Value**  
- The platform can store chat data and usage logs for 1 year for research, user experience evaluation, or testing AI/ML features such as chatbots and user behavior analysis.  
- The architecture and codebase can be reused for other team projects or internal lab applications.  
- Helps the team become proficient in deploying, managing, and monitoring cloud-native systems on AWS.