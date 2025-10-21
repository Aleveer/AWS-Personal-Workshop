---
title: "Blog 4"
weight: 1
chapter: false
pre: " <b> 3.4. </b> "
---

# Amazon Bedrock baseline architecture in an AWS landing zone

As organizations increasingly adopt [Amazon Bedrock](https://aws.amazon.com/bedrock/) to build and deploy large-scale AI applications, it’s important that they understand and adopt critical network access controls to protect their data and workloads. These generative AI-enabled applications might have access to sensitive or confidential information within their knowledge bases, Retrieval Augmented Generation (RAG) data sources, or models themselves, which could pose a risk if exposed to unauthorized parties. Additionally, organizations might want to limit access to certain AI models to specific teams or services, making sure only authorized users can use the most powerful capabilities. Another important consideration is cost optimization, because organizations need to be able to monitor and control access to manage various aspects of their cloud spending.

In this post, we explore the Amazon Bedrock baseline architecture and how you can secure and control network access to your various Amazon Bedrock capabilities within AWS network services and tools. We discuss key design considerations, such as using [Amazon VPC Lattice](https://aws.amazon.com/vpc/lattice/) [auth policies](https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html), [Amazon Virtual Private Cloud](https://aws.amazon.com/vpc/) (Amazon VPC) endpoints, and [AWS Identity and Access Management](https://aws.amazon.com/iam/) (IAM) to restrict and monitor access to your Amazon Bedrock capabilities.

By the end of this post, you will have a better understanding of how to configure your AWS landing zone to establish secure and controlled network connectivity to Amazon Bedrock across your organization using VPC Lattice.

## Solution overview

Addressing the aforementioned challenges requires a well-designed network architecture and security controls. For this, we use the [standard AWS Landing Zone Accelerator networking configuration](https://awslabs.github.io/landing-zone-accelerator-on-aws/v1.6.0/sample-configurations/standard/networking/). It provides a good starting point for managing network communication across multiple accounts. On top of the AWS Landing Zone Accelerator network design, we add two shared accounts.

In this solution design, we create a centralized architecture for managing organization AI capabilities across different accounts. The architecture consists of three main parts that work together to provide secure and controlled access to AI services:

* Service network account – This account serves as the central networking hub for the organization, managing network connectivity and access policies. Through this account, network administrators can centrally manage and control access to AI services across the organization. The account follows [AWS Landing Zone Accelerator networking](https://awslabs.github.io/landing-zone-accelerator-on-aws/v1.6.0/sample-configurations/standard/networking/#architecture) practices that scale with enterprise organizational needs.
* Generative AI account – This account hosts the organization’s Amazon Bedrock capabilities and serves as the central point for AI/ML management. The organization’s AI/ML scientists and prompt engineers will centrally build and manage Amazon Bedrock capabilities. The account provides access to various large language models (LLMs) through Amazon Bedrock by using VPC interface endpoints, while also enabling centralized monitoring of cost consumption and access patterns.
* Workload accounts (dev, test, prod) – These accounts represent different environments where teams develop and deploy applications that consume AI services. Through secure network connections established through the service network account, these workload accounts can access the AI capabilities hosted in the generative AI account. This separation enforces proper isolation between development, testing, and production workloads while maintaining secure access to AI services.

![Amazon Bedrock baseline architecture in an AWS landing zone](https://d2908q01vomqb2.cloudfront.net/fc074d501302eb2b93e2554793fcaf50b3bf7291/2025/06/18/ARCHBLOG-1133-image-1.png)

*Amazon Bedrock baseline architecture in an AWS landing zone*

The following diagram illustrates the solution architecture.

The service network account has its own VPC Lattice service network—a centralized networking construct that enables service-to-service communication across your organization, which is shared with workload accounts using [AWS Resource Access Manager](https://aws.amazon.com/ram/) (AWS RAM) to enable VPC Lattice Service network sharing.

Workload accounts (dev, test, prod) establish VPC associations with the shared VPC Lattice service network by creating a service network association in their VPC. When an application in these accounts makes a request, it first queries the VPC resolver for DNS resolution. The resolver routes the traffic to the VPC Lattice service network.

Access control is implemented through an [VPC Lattice auth policy](https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html). The service network policies determine which accounts can access the VPC Lattice service network, and service-level policies control access to specific AI services and define what actions each account can perform.

In the central AI services account, we find the proxy layer, we create a VPC Lattice service that points to a proxy layer, which acts as a single entry point, providing workload accounts access to Amazon Bedrock. This proxy layer then connects to Amazon Bedrock through VPC endpoints. Through this setup, the AI team can configure which foundation models (FMs) are available and manage access permissions for different workload accounts. After the necessary policies and connections are in place, workload accounts can access Amazon Bedrock capabilities through the established secure pathway. This setup enables secure, cross-account access to AI services while maintaining centralized control and monitoring.

## Network components

We use VPC Lattice, which is a fully managed application networking service that helps you simplify network connectivity, security, and monitoring for service-to-service communication needs. With VPC Lattice, organizations can achieve a centralized connectivity pattern to control and monitor access to the services required for building generative AI applications.

For details about VPC Lattice, refer to the [Amazon VPC Lattice User Guide](https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html). The following is an overview of the constructs you can use in setting up the centralized pattern in this solution:

* VPC Lattice service network – You can use the VPC Lattice service network to provide central connectivity and security to the central AI services account. The service network is a logical grouping mechanism that simplifies how you can enable connectivity across VPCs or accounts, and apply common security policies for application communication patterns. You can create a service network in an account and share it with other accounts within or outside [AWS Organizations](https://aws.amazon.com/organizations/) using AWS RAM.
* VPC Lattice service – In a service network, you can associate a VPC Lattice service, which consists of a listener (protocol and port number), routing rules that allow for control of the application flow (for example, path, method, header-based, or weighted routing), and target group, which defines the application infrastructure. A service can have multiple listeners to meet various client capabilities. Supported protocols include HTTP, HTTPS, gRPC, and TLS. The path-based routing allows control to various high-performing FMs and other capabilities you would need to build a generative AI application.
* Proxy layer – You use a proxy layer for the VPC Lattice service target group. The proxy layer can be built based on your organization’s preference of AWS services, such as [AWS Lambda](http://aws.amazon.com/lambda) , [AWS Fargate](https://aws.amazon.com/fargate) , or [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/) (Amazon EKS). The purpose of the proxy layer is to provide a single entry point to access LLMs, knowledge bases, and other capabilities that are tested and approved according to your organization’s compliance requirements.
* VPC Lattice auth policies – For security, you use VPC Lattice auth policies. VPC Lattice auth policies are specified using the same syntax as IAM policies. You can apply an auth policy to VPC Lattice service network as well as to the VPC Lattice service.
* Fully Qualified Domain Names –To facilitate service discovery, VPC Lattice supports custom domain names for your services and resources, and maintains a Fully Qualified Domain Name (FQDN) for each VPC Lattice service and resource you define. You can use these FQDNs in your [Amazon Route 53](https://aws.amazon.com/route53/) private hosted zone configurations, and empower business units or teams to discover and access services and resources.
* Service network VPC – Business units or teams can access generative AI services in a service network using service network VPC associations or a service network VPC endpoint.
* Monitoring – You can choose to enable monitoring at the VPC Lattice service network level and VPC Lattice service level. VPC Lattice generates metrics and logs for requests and responses, making it more efficient to monitor and troubleshoot applications

The preceding guidance takes a “secure by default” approach—you must be explicit about which features, models, and so on should be accessed by which business unit. The setup also enables you to implement a defense-in-depth strategy at multiple layers of the network:

* The first level of defense is that business team needs to connect to the service network in order to get access to the generative AI service through the central AI service account.
* The second level includes network-level security protections in the business team’s VPC for the service network, such as security groups and network access control lists (ACLs). By using these, you can allow access to specific workloads or teams in a VPC.
* The third level is through the VPC Lattice auth policy, which you can apply at two layers: at the service network level to allow authenticated requests within the organization, and at the service level to allow access to specific models and features.

## VPC Lattice auth policy

This solution makes it possible to centrally manage access to Amazon Bedrock resources across your organization. This approach uses an VPC Lattice auth policy to centrally control Amazon Bedrock resources and manage it from one location across all the organization accounts.

Typically, the auth policy on the service network is operated by the network or cloud administrator. For example, allowing only authenticated requests from specific workloads or teams in your AWS organization. In the following example, access is granted to invoke the generated AI service for authenticated requests and to principals that are part of the `o-123456example` organization:

```
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": "*",
         "Action": "vpc-lattice-svcs:Invoke",
         "Resource": "*",
         "Condition": {
            "StringEquals": {
                "aws:PrincipalOrgID": [ 
                   "o-123456example"
                ]
            }
         }
      }
   ]
}
```

The auth policy at the service level is managed by the central AI service team to set fine-grained controls, which can be more restrictive than the coarse-grained authorization applied at the service network level. For example, the following policy restricts access to `claude-3-haiku` for only `business-team1`:

```
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect": "Allow",
         "Principal": {
            "AWS": [
               "arn:aws:iam::<account-number>:role/businss-team1"
            ]
         },
         "Action": "vpc-lattice-svcs:Invoke",
         "Resource": [
            "arn:aws:vpc-lattice:<aws-region>:<account-number>:service/svc-0123456789abcdef0/*"
         ],
         "Condition": {
            "StringEquals": {
                "vpc-lattice-svcs:RequestQueryString/modelid": "claude-3-haiku" 
            }
         }
      }
   ]
}
```

## Monitoring and tracking

This design employs three monitoring approaches, using [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/), [AWS CloudTrail](https://aws.amazon.com/cloudtrail/), and VPC Lattice access logs. This strategy provides a view of service usage, security, and performance.

CloudWatch metrics offer real-time monitoring of VPC Lattice service performance and usage. CloudWatch tracks metrics such as request counts and response times for Amazon Bedrock related endpoints, allowing for the setup of alarms for proactive management of service health and capacity. This enables monitoring of overall usage patterns of Amazon Bedrock models across different business units, facilitating capacity planning and resource allocation. CloudTrail provides detailed API-level auditing of Amazon Bedrock related actions. It logs cross-account access attempts and interactions with Amazon Bedrock services, providing a compliance and security audit trail. This tracking of who is accessing which Amazon Bedrock models, when, and from which accounts helps organizations adhere to their organizational policies.VPC Lattice access logs provide detailed insights into HTTP/HTTPS requests to Amazon Bedrock services, capturing specific usage patterns of AI models by different business teams. These logs contain client-specific information, which for example can be used to enable organizations to implement capabilities such as charge-back models. This allows for accurate attribution of AI service usage to specific teams or departments, facilitating fair cost allocation and responsible resource utilization across the organization. These services work together to enhance security, optimize performance, and provide valuable insights for managing cross-account Amazon Bedrock access.

## Conclusion

In this post, we explored the importance of securing and controlling network access to Amazon Bedrock capabilities within an organization’s AWS landing zone. We discussed the key business challenges, such as the need to protect sensitive information in Amazon Bedrock knowledge bases, limit access to AI models, and optimize cloud costs by monitoring and controlling Amazon Bedrock capabilities. To address these challenges, we outlined a multi-layered network solution that uses AWS networking services, including a VPC Lattice auth policy to restrict and monitor access to Amazon Bedrock capabilities. Try out this solution for your own use case, and share your feedback in the comments.

<!-- ### About the authors

![Abdel-Rahman Awad](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abdel-rahman-awad.jpg)

### Abdel-Rahman Awad

Technical Leader at AWS with almost two decades of experience in the IT industry, he guides large organizations through their cloud journey, working with stakeholders from technical teams to C-level executives

![Abeer Binzaid](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abeer-binzaid.jpg)

### Abeer Binzaid

Abeer Binzaid is a Solutions Architect at Amazon Web Services (AWS), supporting customers in MENAT region as part of the Cloud Sales Center team. Abeer is passionate about cloud networking, generative AI, and enabling customers to accelerate their digital transformation by adopting modern cloud-native architectures.

![Ankit Gupta](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-ankit-gupta.jpg)

### Ankit Gupta

Ankit Gupta is a Senior Solutions Architect at Amazon Web Services (AWS), where he specializes in working with Software-as-a-Service (SaaS) customers. Ankit helps customers design and implement highly scalable and resilient solutions on AWS. As a networking specialist, Ankit works extensively with AWS networking services, providing guidance to customers across the EMEA region in building robust and scalable network architectures. When not architecting cloud solutions, Ankit can be found on the badminton court pursuing his passion for racket sports. -->