---
title : "Deploy Frontend with Amazon Amplify and establish a secure connection with the Backend API"
weight : 5
chapter : false
pre : " <b> 5.5 </b> "
---
#### Overview of Frontend Deployment with Amazon Amplify and Connecting to the Backend API .
In this section, we will step-by-step deploy the Frontend application (using Vue.js) to the static Hosting service of AWS Amplify, while simultaneously establishing a secure and efficient connection with the Backend API running on ECS/ALB by using Custom Domain, AWS Route 53, AWS Certificate Manager (ACM), and Amplify's Rewrite/Redirect mechanism.

The services we will need to use during the deployment process:
- **Amazon Amplify** : Used to deploy the Vue.js Frontend to Amplify Hosting, automatically build and distribute Frontend content to users via CDN (the underlying service of Amplify Hosting, including CloudFront). At the same time, use the Rewrite/Redirects mechanism to forward API requests to the Backend.
- **Route 53** : Used to create a Hosted Zone and manage DNS records for the custom domain (e.g., webchat.mom). Used to point Name Servers from the third-party domain provider (Porkbun) to Route 53. Finally, create an Alias record to point the API subdomain (api.webchat.mom) to the Application Load Balancer (ALB) of the Backend.
- **Amazon Certificate Management** : Used to request and issue public SSL/TLS certificates (Public Certificate) for domains (Frontend and Backend). This certificate is then attached to the Backend's ALB and used by Amplify Hosting to enable HTTPS.

#### Contents

1. [Deploy Frontend to AWS Amplify](5.5.1-Deploy-Frontend/)
2. [Configure to connect Frontend and Backend](5.5.2-Connect-BE-FE/)
3. [Configure Custom Domain with Route53 and SSL verification with AWS Certificate Manager](5.5.3-Custom-Domain-BE/)
4. [Customize Domain for Amplify Frontend](5.5.4-Custom-Domain-FE/)