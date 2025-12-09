---
title: "Project Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---
### Real-time Chat Application
### 1. Executive Summary

The Serverless Web Chat Platform is developed to provide a fast, secure, and easy-to-operate internal communication solution. The application supports real-time messaging among team members through a lightweight web interface, with flexible scalability capabilities for future expansion. The platform leverages AWS Serverless services such as AWS API Gateway, AWS Lambda, DynamoDB, and Amazon Cognito to ensure stable operation, low costs, and no server management requirements. Access is restricted to lab room members, ensuring security and privacy during information exchange.

### 2. Problem Statement  
*Current Issue*<br>
The team is developing a chat application for educational and research purposes on building real-time web systems. If implemented using a traditional model (self-hosted servers, self-managed databases, and maintaining WebSocket connections), the team will face numerous challenges such as: complex infrastructure setup, handling scalability with concurrent connections, ensuring stability and security, as well as comprehensive logging and monitoring for the system. Not utilizing AWS services makes it difficult for the team to simulate modern infrastructure models, while also spending time on operational tasks instead of focusing on the application core and key technical lessons.

*Solution*<br>
The Web Chat application is deployed based on AWS Serverless services to simulate modern application architecture with maximum scalability. The solution focuses on eliminating server management needs, maximizing instant scalability, and reducing operational costs. By using WebSocket API through CloudFront and Lambda, the solution ensures high-speed WSS communication, while applying DynamoDB for efficient handling of large read/write operations for chat data. Cognito provides a robust authentication layer, protecting the entire application from the access layer (frontend) to the API layer.

*Benefits and Return on Investment (ROI)*<br>
The solution enables the team to practice building a complete chat application from frontend to backend, integrated with commonly used cloud services in enterprise environments. Leveraging Free Tier and test resources keeps deployment costs low while ensuring sufficient practicality for the team to understand infrastructure management, monitoring, scaling, and security. Deployment on AWS reduces manual configuration time and creates a solid foundation for advanced research such as chatbots, user activity data processing, or AI system integration. The return on investment is nearly immediate due to no hardware costs and significant reduction in operational efforts.

## 3. Solution Architecture

The Web Chat application is implemented using a *containerized architecture on AWS*, utilizing Amazon ECS Fargate as the backend runtime platform for NestJS, while the VueJS frontend is hosted on Amazon Amplify. This architecture ensures separation between frontend and backend, ease of scaling, security, and minimization of server operational tasks.

### Overall Access Flow

Users access the application through a domain managed by *Amazon Route 53*. Frontend requests are routed to **Amazon Amplify Hosting**, while backend requests to the api.webchat.mom path are forwarded to the **Application Load Balancer (ALB)**, which directs traffic to Fargate containers in different subnets to ensure high availability.


![WebChat Realtime Architecture](/images/2-Proposal/webchat_architecture.jpg)

### *Key Components in the Architecture*

- **Amazon Route 53**: Manages DNS, resolves custom domains webchat.mom and api.webchat.mom. Route 53 routes frontend requests to Amplify and backend requests to the Application Load Balancer.

- **Amazon Amplify Hosting (Frontend)**: Deploys and distributes the VueJS application. Amplify also integrates with Amazon Certificate Manager (ACM) to provide HTTPS for the web interface. Additionally, Amplify uses Rewrite & Redirect rules to direct users to the correct API domain when accessing the frontend.

- **Amazon Certificate Manager (ACM)**: Provides SSL/TLS certificates for both Amplify and the Application Load Balancer to ensure all communication between users and the system is encrypted.

- **Application Load Balancer (ALB)**: Serves as the traffic director for the backend. ALB receives requests from api.webchat.mom and routes them to ECS Fargate tasks located in **public subnets**, ensuring scale-out capability when request volume increases.

- **Amazon ECS Fargate (Backend)**: Runs NestJS backend containers without managing EC2 instances. Tasks are placed in multiple subnets to enhance availability. The backend application communicates directly with MongoDB and SMTP server via Internet Gateway or VPC routing.

- **Amazon ECR**: Stores Docker images for the NestJS backend. During each CI/CD update, Fargate pulls images directly from ECR.

- **Amazon S3**: Used for storing static files such as images, attachments, or shared content in chats.

- **MongoDB Atlas / MongoDB Server**: Stores all user information, messages, and application data. The Fargate backend connects to MongoDB via Internet Gateway.

- **SMTP Server**: Used by the backend to send notification emails (if applicable).

- **Amazon CloudWatch (Shared Service)**: Collects logs from ECS Fargate and ALB, supporting monitoring, alerting, and system performance tracking.

- **Amazon IAM**: Manages access permissions between services such as Fargate → ECR, ALB → CloudWatch, Amplify → S3, and applies least privilege principles.

### *Operational Overview*
1. *User* accesses webchat.mom → Route 53 → Amplify Web.
2. The frontend interface is loaded from Amplify.
3. Backend requests from the frontend are sent to the api.webchat.mom domain.
4. Route 53 routes backend requests to *ALB*.
5. ALB routes to NestJS containers running on ECS Fargate.
6. Fargate containers connect to:
   * *MongoDB* for chat data processing
   * *S3* for file storage
   * *SMTP* for email sending
7. All logs are pushed to *CloudWatch*.
8. Access permissions are controlled by *IAM*, and all traffic is encrypted via certificates from *ACM*.

### *Architecture Benefits*

* No server management required (Serverless Container – Fargate).
* Automatic scaling with increasing user numbers.
* Separation of frontend and backend for independent development.
* CI/CD support via Amplify and ECR → Fargate.
* Easy monitoring, aligned with real-world enterprise Cloud Native models.
* Comprehensive security from DNS to backend.

### 4. Technical Implementation  
**Implementation Phases**  
The Web Chat project consists of two main parts—building the backend and frontend for the web—and deploying to AWS Cloud—spanning 5 phases:  
1. **Prototype Development**: Research VueJS, NestJS, and plan a Web chat running on LAN (1 month before internship).  
2. **Research and Architecture Design**: Research AWS services and design architecture suitable for the WebChat project (Month 1).  
3. **Cost Calculation and Feasibility Check**: Use AWS Pricing Calculator to estimate costs for ECS Fargate, Application Load Balancer (ALB), DynamoDB, Amplify, CloudFront, and CloudWatch; simultaneously evaluate container resource usage to accurately forecast costs. (Month 2). 
4. **Architecture Adjustment for Cost/Solution Optimization**: Optimize ECS Service configuration (CPU/memory), minimum/maximum tasks and auto-scaling; fine-tune WebSocket design on Fargate via ALB; optimize DynamoDB (PK/SK, GSI) and set up frontend caching with CloudFront to reduce backend load. (Month 3).
5. **Development, Testing, Deployment**: Build backend (NestJS) running in ECS Fargate containers; develop VueJS frontend; deploy full infrastructure (ECS Fargate, ALB, DynamoDB, Amplify + CloudFront, Route53, Cognito). Perform system testing (functional, integration, load testing) and bring into operation. (Months 3–4).

---

**_Technical Requirements_**  
- **Backend**: Run NestJS application in ECS Fargate containers, handling API and real-time WebSocket via Application Load Balancer (ALB). Chat and user data stored on DynamoDB; logging and monitoring via CloudWatch; domain integration via Route53. 
- **Frontend**: Developed with VueJS; deployed via Amplify and distributed through CloudFront for optimized loading speed and real-time chat interface performance.
- **Realtime & Performance**: WebSocket connections via ALB to backend on Fargate for low latency and stable connections. CloudFront caches frontend to reduce backend load and improve response times. 
- **Security & User Management**: Use AWS Cognito for user authentication, session management, and access control for chat data.

### 5. Roadmap & Implementation Milestones  
- *Pre-internship (Month 0)*: 1 month for requirement survey, scope analysis, technology selection (VueJS, NestJS, ECS Fargate, ALB, Amplify, DynamoDB, CloudFront, Route53, CloudWatch) and overall architecture planning.
- *Internship (Months 1–3)*:  
    - Month 1: Learn and familiarize with AWS (EC2, ECS, DynamoDB, Amplify, CloudFront, Route53, CloudWatch). Set up development environment, create NestJS backend prototype and VueJS frontend. 
    - Month 2: Design and adjust system architecture, build core features (real-time chat, message storage, basic interface). Set up infrastructure: ECS service, ALB listener, DynamoDB tables, Amplify for frontend, CloudFront CDN, Route53 for domain.  
    - Month 3: Official deployment, testing, performance optimization, CloudWatch monitoring configuration, and bring into use. 
- *Post-deployment*: Continue research and feature expansion within 1 year (chatbot, data analytics, UI/UX improvements, security and cost optimization).  

### 6. Budget Estimate  
Costs can be viewed on [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  

*Infrastructure Costs*  
- ECS Fargate: 9.50 USD/month (1 task 0.25 vCPU + 0.5GB RAM running 720 hours)
- Application Load Balancer: 16.00 USD/month (listener + LCU + low traffic)
- DynamoDB: 0.50 USD/month (~50,000 Read/Write on-demand)
- Amplify: 0.20 USD/month
- CloudFront: 0.70 USD/month (Data Transfer Out ~8GB)
- CloudWatch: 0.10 USD/month (50MB log)
- Route53: 0.50 USD/month

*Total*: 27.50 USD/month, 330 USD/12 months


### 7. Risk Assessment

**Risk Matrix**

- Network outage / internet issues: Medium impact, medium probability.
- Data errors / DynamoDB: High impact, low probability.
- AWS budget overrun: Medium impact, low probability.
- Frontend / CloudFront errors: Low impact, medium probability.
- Backend / ECS Fargate or ALB errors: High impact, low probability.

**Mitigation Strategies**

- Network outage / Internet: Use CloudFront for frontend caching; temporarily store messages locally (localStorage/IndexedDB).
- Data errors / DynamoDB: Enable Point-In-Time Recovery, validate schema, monitor via CloudWatch Logs and Metrics.
- AWS budget overrun: Set up CloudWatch billing alarms, limit log retention, optimize Fargate tasks (CPU/RAM).
- Frontend / CloudFront errors: Use versioned deployments for quick rollback.
- Backend / ECS Fargate errors: Deploy multiple tasks as needed, use ALB health checks for automatic faulty task replacement.

**Contingency Plan**

- Use Infrastructure as Code (CloudFormation / Terraform) for quick recreation of ECS Service, ALB, DynamoDB, Amplify, CloudFront.
- In case of prolonged AWS outages, run a **local version** (VueJS + NestJS) to maintain internal exchanges.
- Periodically monitor CloudWatch Dashboard, ALB health checks, and ECS task status for early issue detection.

---

### 8. Expected Outcomes

**Technical Improvements**

- Stable real-time chat application running on container architecture (ECS Fargate + ALB), replacing email or manual note exchanges.
- Centralized storage of messages and user data via DynamoDB, easy to manage and retrieve.
- Modular architecture with NestJS backend (on Fargate), VueJS frontend (Amplify + CloudFront), and AWS infrastructure (ECS, ALB, DynamoDB, CloudFront, Amplify, Route53, CloudWatch) scalable to 50–100 users.

**Long-term Value**

- The system can store chat data and logs for 1 year to support research, user evaluation, or AI/ML integration (chatbot, behavior analysis).
- Architecture and codebase can be reused for internal projects, other microservices, or as a DevOps/Cloud learning platform.
- Helps the team master deployment, optimization, and monitoring of cloud-native container systems on AWS.

---