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
The Web Chat application is deployed based on AWS Serverless services, aiming to simulate a modern application architecture with maximum scalability. The solution focuses on eliminating the need for server management, maximizing instant scalability, and reducing operational costs. By utilizing the WebSocket API via CloudFront and Lambda, the solution ensures high-speed WSS communication, while DynamoDB is applied to efficiently handle large read/write operations for chat data. Cognito provides a robust authentication layer, securing the entire application from the frontend access layer to the API layer.

*Benefits and Return on Investment (ROI)*  
The solution enables the team to practice building a complete chat application from frontend to backend, combined with commonly used cloud services in enterprise environments. By leveraging the AWS Free Tier and test resources, deployment costs are low while still ensuring sufficient practicality for the team to gain a deep understanding of infrastructure management, monitoring, scaling, and security. Deploying on AWS reduces manual configuration time and creates a solid foundation for advanced research such as chatbots, user activity data processing, or AI system integration. The return on investment is nearly immediate due to no hardware costs and significantly reduced operational effort.

### 3. Solution Architecture  
The Web Chat application is deployed based on the AWS Serverless architecture, ensuring high scalability and performance.The Realtime Backend is built around Amazon API Gateway (WebSocket API) and AWS Lambda Functions to handle event-driven chat logic. Amazon DynamoDB is used to store messages and connection information, providing the low latency required for a realtime application.The Frontend, written in VueJS, is hosted on Amazon Amplify and distributed via CloudFront to optimize speed and secure the WebSocket (WSS) connection. Route 53 manages the custom domain and routes traffic, utilizing ACM (Certificate Manager) for certification. Amazon Cognito handles user authentication and identity management.The entire system is monitored by Amazon CloudWatch and secured by IAM policies. This architecture facilitates the team's research into the processes of operations (DevOps), continuous deployment, and scaling a realtime chat application on the cloud environment.

![WebChat Realtime Serverless Architecture](/images/2-Proposal/webchat_architecture.png)

*AWS Services Utilized*  
- *Amazon Amplify*: Stores the static web interface built with Vue.js. 
- *AWS Lambda*: 1 Lambda Authorizer to check the Cognito token and 3 Lambda Functions to handle business logic for the WebSocket routes.
- *Amazon API Gateway*: Receives and maintains WebSocket connections, routing events.
- *Amazon Route 53*: Manages DNS and routes the custom domain.
- *Amazon CloudFront*: Distributes the Vue.js Frontend (CDN) and forwards the WebSocket (WSS) connection.
- *AWS Cognito*:Manages authentication and authorization for user access. 
- *Amazon DynamoDB*: Stores connection status and message history.
- *Amazon Certificate Manager (ACM)*:Provides SSL/TLS certificates for CloudFront and API Gateway.
- *Amazon IAM*: Manages access permissions and authorization for services.
- *Amazon CloudWatch*: Provides monitoring and logging services for the entire architecture (Shared Service).

*Component Design*  
- *Web interface*: The Vue.js application is distributed via CloudFront, using WSS for realtime communication.
- *User management*: Cognito and Lambda Authorizer manage sign-in, sign-up, and token authentication before establishing a connection.
- *Data reception*: API Gateway (WebSocket) receives the $connect/$message/$disconnect events and triggers the processing functions.
- *Logic processing*: Lambda Functions execute the chat logic.
- *Data storage*: DynamoDB provides the core data storage with high scalability and low latency for the realtime application.
- *Network security*: ACM, Route 53, and CloudFront ensure the entire data flow uses a custom domain and is encrypted (WSS).

### 4. Technical Implementation  
**Implementation Phases**  
The Web Chat Project consists of 2 main parts—building the backend, frontend for the web, and deployment to the AWS Cloud—carried out in 5 phases:

1. **Building the Prototype**: Research VueJS, NestJS, and plan the construction of the Web Chat running on a LAN network (1 month before the internship period).
2. **Research and Architecture Design**: Research AWS services and draw the architecture suitable for the WebChat project (Month 1).
3. **Cost Estimation and Feasibility Check**:Use the AWS Pricing Calculator to estimate the costs of Lambda, API Gateway, DynamoDB, Amplify, CloudFront, CloudWatch, and adjust the design accordingly (Month 2).
4. **Architecture Optimization for Cost/Solution**: Fine-tune API Gateway WebSocket configuration, optimize Lambda functions (memory/concurrency) and DynamoDB Schema. Cache the frontend using CloudFront to ensure performance and reduce backend load (Month 3).
5. **Development, Testing, Deployment**: Program the Lambda Functions, VueJS frontend; deploy the entire infrastructure (API Gateway, Lambda, DynamoDB, Amplify + CloudFront, Route53, Cognito); test the system (functional, load test) and launch operations (Month 3–4)."

---

**_Technical Requirements_**  
- **Backend**:API Gateway with Lambda Functions provides real-time connectivity, stores chat and user data on DynamoDB, logs and monitoring are handled on CloudWatch, and the custom domain is integrated via Route53. 
- **Frontend**: VueJS, distributed via Amplify + CloudFront for speed optimization, load assets and real-time chat interface.  
- **Real-time & Performance**: WebSocket or API Gateway (if using REST) for real-time message sending/receiving; cache frontend with CloudFront to reduce direct backend requests.  
- **Security & User Management**: Use JWT or Cognito if needed for authentication, authorize access to internal chat data.  

### 5. Roadmap & Milestones  
- *Pre-Internship (Month 0)*: 1 month surveying project requirements, selecting technologies (VueJS, NestJS, EC2, Amplify, DynamoDB, CloudFront, Route53, ECS, CloudWatch) and building the overall plan.
- *Internship (Months 1–3)*:  
    - Month 1: Learn and familiarize with AWS (EC2, ECS, DynamoDB, Amplify, CloudFront, Route53, CloudWatch). Set up development environment, create NestJS backend and VueJS frontend prototypes. 
    - Month 2: Design and adjust system architecture, build core features (real-time chat, message storage, basic UI). Set up AWS infrastructure: Lambda + API Gateway for backend, Amplify + CloudFront for frontend, DynamoDB for data, Route53 for domain.  
    - Month 3: Official deployment, testing (functional, load 20–30 users), performance optimization, configure CloudWatch monitoring and put into operation. 
- *Post-Deployment*: Continue research and feature expansion for 1 year (chatbot, data analytics, UI/UX improvements, security and cost optimization).  

### 6. Budget Estimation  
View costs on the [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  

*Infrastructure Costs*  
- AWS Lambda: 0,01 USD/month ( ~50.000 Invocations)
- Amazon API Gateway: 3,80 USD/month  ( Assumes 30 users utilizing 150,000 minutes of connection time and sending 50,000 messages)
- DynamoDB: 0,05 USD/month (~ 50.000 Writes)
- Amplify: 0,20 USD/month 
- CloudFront: 0,68 USD/month (Data Transfer Out 8GB)
- CloudWatch: 0,05 USD/month (50MB log)
- Route53: $0.50 USD/month 


*Total*: 5,29 USD/month, 63,48 USD/12 months  


### 7. Risk Assessment  
**Risk Matrix**  
- Network loss / internet outage: Medium impact, medium probability.  
- Data errors / DynamoDB: High impact, low probability.  
- AWS budget overrun: Medium impact, low probability.  
- Frontend / CloudFront errors: Low impact, medium probability.  

**Mitigation Strategies**  
- Network/Internet loss: Use frontend cache (CloudFront) ; temporarily store messages locally if offline (localStorage or IndexedDB).  
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
- Modular architecture with NestJS backend, VueJS frontend, and AWS infrastructure (Lambda ,API Gateway, Amplify, DynamoDB, CloudFront, Route53, CloudWatch) scalable to serve 50 to 100 users in the future.  

**Long-Term Value**  
- The platform can store chat data and usage logs for 1 year for research, user experience evaluation, or testing AI/ML features such as chatbots and user behavior analysis.  
- The architecture and codebase can be reused for other team projects or internal lab applications.  
- Helps the team become proficient in deploying, managing, and monitoring cloud-native systems on AWS.