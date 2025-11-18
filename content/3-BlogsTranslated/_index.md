---
title: "Translated Blogs"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

### [Blog 1 - Offline caching with AWS Amplify, Tanstack, AppSync and MongoDB Atlas](3.1-Blog1/)

The article demonstrates how to build an offline-first application with optimistic UI using AWS Amplify, AWS AppSync, TanStack Query, and MongoDB Atlas. The sample to-do application showcases instant rendering of CRUD operation results on the UI before server requests complete, enhancing user experience. TanStack Query manages local caching to ensure data availability offline, while AWS Amplify and AppSync provide a full-stack framework and GraphQL API. MongoDB Atlas handles data storage, integrated with AWS Lambda and Cognito for serverless functionality and user management. The application is easily deployed via Amplify Gen 2, supporting data synchronization and a simple "first-come, first-served" conflict resolution mechanism, suitable for applications with minimal update conflicts.

### [Blog 2 - Introducing AWS CDK Community Meetings](3.2-Blog2/)

AWS announces a new community meeting series for the AWS Cloud Development Kit (CDK), providing opportunities for developers, from novices to experts, to learn, ask questions, and share feedback directly with the CDK team. Held twice quarterly, these virtual meetings cover roadmap updates, feature demos, RFC reviews, and open Q&A, with the first sessions scheduled for June 24, 2025, at 8–9 AM and 5–6 PM PDT to accommodate the global community. Details, agendas, and recordings will be shared on GitHub and YouTube. Community members can participate via Slack, propose topics on GitHub, and provide input through surveys to shape the CDK’s future.

### [Blog 3 - Secure your Express application APIs in 5 minutes with Cedar](3.3-Blog3/)

The article introduces the authorization-for-expressjs package from the open-source Cedar project, enabling Express applications on Node.js to integrate policy-based authorization in minutes, reducing code by 90% compared to manual integration. Using the PetStore sample app, Cedar decouples authorization logic, allowing fine-grained policy definitions, e.g., restricting write operations (POST /pets, POST /pets/{petId}/sale) to employees while allowing read operations (GET /pets, GET /pets/{petId}) for customers. The package auto-generates Cedar schemas from OpenAPI specs, creates sample policies, and integrates middleware for authorization without remote calls. Security is enhanced via JWT and OIDC, with policy validation easily tested using curl commands, improving developer productivity and simplifying access audits.

### [Blog 4 - Amazon Bedrock baseline architecture in an AWS landing zone](3.4-Blog4/)

The article describes a reference architecture for securely managing and governing access to Amazon Bedrock's capabilities within a multi-account AWS environment, known as an AWS landing zone. This centralized architecture consists of three primary account types: a service network account, a generative AI account, and various workload accounts. The solution leverages Amazon VPC Lattice to streamline connectivity, security, and monitoring of communications between services. This approach establishes a multi-layered defense strategy, enforcing granular access control through network-level security and VPC Lattice authentication policies, while also emphasizing the importance of monitoring usage and compliance with tools like Amazon CloudWatch and AWS CloudTrail.

### [Blog 5 - Modernizing SAP Procurement Processes with Amazon Appflow, SAP BTP Integration Suite, and Amazon Bedrock](3.5-Blog5/)

The article presents a solution for modernizing SAP procurement by integrating AWS services like Amazon AppFlow and Amazon Bedrock with SAP BTP Integration Suite. This architecture automates and enhances the procurement workflow, specifically focusing on a use case for a Sustainability Sourcing Assistant. The system uses a chatbot interface and generative AI to analyze quotations based on both price and sustainability metrics. By leveraging Amazon Bedrock for natural language processing and integrating with SAP systems, the solution provides a flexible, serverless approach to transform procurement processes, making them more efficient and aligned with sustainability goals.

### [Blog 6 - Optimizing Unicode Conversion Downtime for SAP Systems on Oracle to AWS](3.6-Blog6/)

The article discusses a method to minimize downtime during the Unicode conversion of SAP systems on Oracle databases when migrating to AWS. It highlights a case study of Bell Canada, which successfully migrated an 11 TB non-Unicode SAP ERP system to AWS in under 5 hours, achieving a 75% reduction in technical downtime compared to a traditional one-step conversion and migration process. The approach involves setting up a temporary non-Unicode SAP system on Amazon EC2 and replicating data from the on-premises system using Oracle Data Guard. During the planned downtime, this temporary instance becomes the source for the Unicode conversion, with export and import processes running in parallel on different EC2 instances. This method, combined with best practices like pre-checks and network reliability, leverages AWS's scalable infrastructure to reduce business disruption and optimize operational efficiency.

### [Blog 7 - GNOME has a new infrastructure partner: welcome AWS!](3.7-Blog7/)

GNOME has partnered with AWS through the Open Source Credits program to migrate its infrastructure to the cloud, addressing severe technical limitations of the legacy system that could no longer keep up with rapid growth. By leveraging AWS's flexible infrastructure, GNOME's small SRE team has completely overcome networking and storage issues, while simultaneously minimizing the maintenance burden, enhancing security, and optimizing costs through the use of Graviton chips. This transition enables GNOME to deliver a stable, high-performance, and scalable platform to serve its global user community.

### [Blog 8 - Leveraging LLMs as an Augmentation to Traditional Hyperparameter Tuning](3.8-Blog8/)

The article introduces a breakthrough method utilizing Large Language Models (LLMs) to automatically redesign neural network architectures to improve performance, replacing resource-intensive hyperparameter tuning. Through a multi-agent workflow (using LangGraph and Amazon Bedrock), the system analyzes training metrics such as gradient norms to detect bottlenecks, thereby allowing the LLM to act as an 'expert' to provide dynamic network structural adjustments. Experimental results on the CIFAR dataset demonstrate superior effectiveness, with the LLM-optimized architecture achieving an accuracy of 83% (compared to the 10% level of the baseline model), affirming the potential of applying AI to automate the development process of complex machine learning models.

### [Blog 9 - Your unified view of travelers and guests from Amazon Connect Customer Profiles](3.9-Blog9/)

The article introduces Amazon Connect Customer Profiles specifically for the travel and hospitality industry, a solution that helps overcome the issue of fragmented data by automatically unifying information from over 75 sources into a unified 360-degree customer profile in real-time. This tool not only ensures compliance with global security standards but also integrates generative AI to analyze data and predict behavior, helping staff provide deeper personalized service. With ultra-low latency processing capabilities and a flexible pay-as-you-go pricing model, this is the key to helping businesses effectively enhance experiences and increase customer loyalty

### [Blog 10 - Accelerate Microservices Development with DAPR and Amazon EKS](3.10-Blog10/)

The article presents a solution to accelerate microservices development by combining Dapr (Distributed Application Runtime) and Amazon EKS, helping developers focus on business logic instead of worrying about complex infrastructure. Dapr provides platform-agnostic building blocks to handle common technical issues such as state management or service communication; when combined with the cluster management and flexible scaling capabilities of Amazon EKS, it creates a highly portable system with strong resiliency and easy integration with the AWS ecosystem (such as DynamoDB, S3). This solution helps abstract away the complexity of distributed systems, delivering a stable, secure, and production-ready enterprise-grade operational platform.

### [Blog 11 - Monitor, analyze, and manage capacity usage from a single interface with Amazon EC2 Capacity Manager](3.11-Blog11/)

The article introduces Amazon EC2 Capacity Manager, a free centralized management solution that helps monitor and analyze EC2 capacity across all AWS accounts and regions without the need for complex manual aggregation tools. This service consolidates data from On-Demand, Spot, and Capacity Reservations into a single interface, providing insights into usage trends and automatically detecting wasted resources to optimize costs. Besides the ability to directly adjust capacity reservations and export data to S3 for advanced analysis, the tool also integrates tightly with AWS Organizations, helping businesses make more accurate and effective infrastructure decisions.

### [Blog 12 - Introducing Amazon EBS Volume Clones: Create instant copies of your EBS volumes](3.12-Blog12/)

The article introduces Amazon EBS Volume Clones, a new feature that helps create instant copies of EBS volumes within the same Availability Zone with just a simple operation, allowing for immediate data access with low latency without affecting the performance of the source volume. This solution is ideal for quickly setting up testing or development environments using real data, effectively replacing the previously time-consuming manual snapshot creation process. Although it requires the source volume to be encrypted and applies a one-time initialization fee based on capacity, Volume Clones are positioned as a workflow acceleration tool rather than a replacement for the backup and long-term data protection role of EBS Snapshots.