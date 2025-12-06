---
title: "Workshop"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Developing Web Chat Application using AWS Services

#### Overview

This workshop provides detailed guidance to build a complete WebChat application using modern technologies and services. The application is developed following a monorepo architecture with backend containerized and deployed on the AWS cloud platform.

From a technology perspective, the workshop uses NestJS as the backend framework, packaged in Docker containers and deployed on Amazon ECS Fargate to ensure scalability and automatic management. The frontend is built with VueJS using the Vite build tool and deployed on CloudFront.

Real-time messaging functionality is implemented through Socket.io, enabling efficient bidirectional communication between client and server. Amazon S3 serves as a centralized storage repository for files uploaded by users, ensuring data availability and durability.

#### Content

1. [Workshop Overview](5.1-Workshop-overview/)
2. [Prerequisites](5.2-Prerequiste/)
3. [Infrastructure Setup with Terraform](5.3-Infra-Terraform/)
4. [Build Docker Image and Deploy Backend](5.4-Docker-DeployBE/)
5. [Deploy Frontend](5.5-DeployFE/)
6. [Monitoring and Logging](5.6-Log-n-Monitor/)
7. [Resource Cleanup](5.7-Cleanup/)
