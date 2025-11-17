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

### [Blog 7 - ...](3.7-Blog7/)

### [Blog 8 - ...](3.8-Blog8/)

### [Blog 9 - ...](3.9-Blog9/)

### [Blog 10 - ...](3.10-Blog10/)

### [Blog 11 - ...](3.11-Blog11/)

### [Blog 12 - ...](3.12-Blog12/)
