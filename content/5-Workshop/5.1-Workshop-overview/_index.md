---
title : "Introduction"
weight : 1 
chapter : false
pre : " <b> 5.1. </b> "
---

#### Introduction to WebChat Application

+ WebChat is a real-time messaging system that allows users to communicate with each other through a modern web interface. The system supports basic features such as sending and receiving text messages, file sharing, voice messages, group chat creation, and member permissions management within groups.

+ The application backend is built using the NestJS framework, a powerful Node.js framework using TypeScript, providing a modular and scalable architecture. Real-time messaging functionality is implemented through Socket.io, enabling efficient bidirectional communication between client and server without continuous polling.

+ The frontend is developed using VueJS with the Vite build tool. Pinia is used for state management, while Socket.io-client ensures stable WebSocket connection with the backend.

+ User authentication is implemented through JWT (JSON Web Tokens), allowing secure and stateless session management.

#### Workshop Overview

In this workshop, we will build a complete WebChat application from start to finish, using AWS services and modern technologies. The workshop is divided into the following main sections:

+ Infrastructure Setup with Terraform: Use Terraform to define and deploy the entire AWS infrastructure following Infrastructure as Code (IaC) principles. This includes creating S3 buckets for file storage, ECR repositories for Docker images, ECS clusters and services, Application Load Balancer (ALB) for traffic distribution, along with necessary IAM roles and CloudWatch log groups.

+ Backend Application Development: Build the backend API using NestJS, including main modules such as authentication (JWT), chat with WebSocket support, file upload integrated with S3, and modules for managing users, groups, messages, authentication, and chat. The backend will be containerized using Docker and deployed to Amazon ECS Fargate, a serverless container orchestration service that automatically scales and manages containers.

+ Deploy Backend to AWS: After building the Docker image, we will push the image to Amazon ECR (Elastic Container Registry) and configure the ECS service to run containers. Application Load Balancer (ALB) will be used to distribute HTTP/WebSocket traffic to ECS tasks, ensuring application availability and scalability.

+ Frontend Application Development: Build the user interface with VueJS, integrate Socket.io-client to connect real-time with the backend, and use Pinia for state management. The frontend will include components such as chat interface, message list, file upload, and authentication pages.

+ Frontend Deployment: **This section is being written**

+ Monitoring and Logging: After deploying the entire Backend and Frontend to the AWS platform. We configure Amazon CloudWatch Logs to collect and monitor logs from ECS tasks, create CloudWatch dashboards to monitor metrics such as request count, error rates, and response times. AWS Budgets will be set up to track and alert on AWS service usage costs.

+ Database: The system uses MongoDB Atlas as the main database to store user data, conversations, and messages.

**Add overall architecture diagram**
![overview](/images/5-Workshop/5.1-Workshop-overview/diagram1.png)
