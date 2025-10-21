---
title: "Blog 5"
weight: 1
chapter: false
pre: " <b> 3.5. </b> "
---

# Modernizing SAP Procurement Processes with Amazon Appflow, SAP BTP Integration Suite, and Amazon Bedrock

by Simon Cunningham, Diego Lombardini, John Gray, and Sridhar Mahadevan on [Permalink](https://aws.amazon.com/blogs/awsforsap/modernizing-sap-procurement-processes-with-aws-appflow-sap-btp-integration-suite-and-amazon-bedrock/) [Share](#)

Many of our customers are seeking guidance on how generative AI can support their enterprise-wide modernization strategy. [Amazon Bedrock](https://aws.amazon.com/bedrock/) is a fully managed service that provides access to a wide range of high-performing foundation models (FMs) from leading AI companies such as [Anthropic](https://www.anthropic.com/), [AI21 Labs](https://www.ai21.com/), [Cohere](https://cohere.com/), [Stability AI](https://stability.ai/), [Mistral](https://aws.amazon.com/bedrock/mistral/), [Meta Llama](https://aws.amazon.com/bedrock/llama/), [Amazon Nova](https://aws.amazon.com/ai/generative-ai/nova/?gclid=EAIaIQobChMI97Keq4HkigMVxJVQBh1uWQx-EAAYASAAEgJatvD_BwE&trk=42edd3ad-f9d1-4bec-98be-19a453395a44&sc_channel=ps&ef_id=EAIaIQobChMI97Keq4HkigMVxJVQBh1uWQx-EAAYASAAEgJatvD_BwE:G:s&s_kwcid=AL!4422!3!691967596755!e!!g!!amazon%20nova!21048269259!166106444064) and [Amazon Titan](https://aws.amazon.com/bedrock/titan/).

Amazon Bedrock offers a comprehensive set of capabilities to build generative AI applications, simplifying development while maintaining privacy and security. Key features include model customization with your own data, fine-tuning for specific tasks, and [Retrieval Augmented Generation (RAG)](https://aws.amazon.com/what-is/retrieval-augmented-generation/) to enhance response accuracy using your company’s knowledge base. Bedrock also supports building intelligent agents that can automate tasks by interacting with your enterprise systems.

Enterprises have high expectations for security and infrastructure reliability, particularly for critical workloads such as those running on SAP. Amazon Bedrock meets these expectations by incorporating robust security measures, including data encryption and compliance with standards like [SOC](https://aws.amazon.com/compliance/soc-faqs/) and [ISO](https://aws.amazon.com/compliance/iso-27001-faqs/). This facilitates a secure environment, making Bedrock an ideal choice for developing innovative AI-driven applications that meet the stringent requirements of enterprise-grade solutions.

## Enhance Procurement: The Power of Generative AI in Sustainable Sourcing

Today’s procurement practices face significant challenges, particularly in the time-consuming process of reviewing multiple supplier quotations and the complex task of gathering sustainability data from disparate sources. Generative AI is emerging as a transformative solution, with examples like the Sustainability Sourcing Assistant (powered by Amazon Bedrock) demonstrating how AI can leverage both SAP & Non-SAP data to transform procurement processes and enhance sustainability initiatives throughout the supply chain. Using Amazon Bedrock, SAP customers can provide natural language prompts to analyze quotation information from SAP systems. It then combines this data with non-SAP sustainability metrics to recommend the optimal quotation based on business-specific sustainability criteria. The system also enables users to create purchase orders in SAP using natural language commands, streamlining the entire procurement process.

The example addresses key challenges faced by sustainability sourcing specialists including:

* Time-consuming quotation reviews, the need to access multiple external data sources.
* Difficulties in obtaining comprehensive sustainability information.
* Difficulty in aligning quotations with specific organizational goals (in this case, sustainability).

## Solution Overview

### Exploring the Potential of AI in Procurement: A Sustainable Sourcing Assistant Use Case

In this blog post, we’ll explore an innovative example of how AI can transform business processes through a conceptual AI-powered assistant. It’s important to note that this is not a turn-key product or service, but rather a demonstration of how various technologies can be combined to address common business challenges in procurement. This use case serves as an inspiration for how similar approaches could be adopted and customized for different functional areas within your organization, whether it’s manufacturing, finance, human resources, or other business operations.

Throughout this blog post, we’ll discuss various architectural options and AWS services that can be implemented through a combination of chatbot technology, natural language processing, Amazon Bedrock Agents, and integration with [SAP BTP Integration Suite](https://www.sap.com/products/technology-platform/integration-suite.html). While we focus on one specific example, this flexibility allows organizations to choose components that best align with their requirements, existing infrastructure, and technical preferences, making the underlying principles and technologies adaptable to a wide range of business processes and use cases.

### Potential Benefits of AI-Assisted Procurement

In our example use case, we demonstrate how generative AI could be used to:

1. Streamline Evaluation : Automate the quotation assessment process, potentially reducing the time spent on evaluations.
2. Integrate Data : Tap into both internal and external data sources, providing more comprehensive information for decision-making.
3. Enhance Objectivity : Utilize Generative AI driven approaches to support unbiased selection processes that adhere to predefined principles.
4. Streamlined Processes : Generative AI can help automate subsequent steps, such as generating purchase orders, seamlessly transitioning from Request for Quotation (RFQ) to creating a purchase order.
5. Reduce human error: Generative AI can enhance accuracy and consistency in business processes by automatically validating data inputs, identifying patterns of errors, and providing real-time guidance to users before mistakes are committed.

Now let’s delve into the technical architecture behind our conceptual AI-powered procurement use case. This example demonstrates how various AWS services and SAP technologies can be combined to create a powerful tool for procurement processes. We will be using a chatbot style interface to query RFQ’s in near real-time, augment this SAP data with third party sustainability data, and finally create a purchase order using the assistant. Again, it’s important to note that this is not a turn-key product, but rather an illustration of what’s possible when leveraging these technologies.

## Detailed Architecture:

![high level steps & architecture diagram](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Screenshot-2025-06-16-at-20.46.19.png)

**high level steps & architecture diagram**

This solution has been built and tested on [SAP S/4HANA 2023](https://help.sap.com/doc/e2048712f0ab45e791e6d15ba5e20c68/2023/en-US/FSD_OP2023_latest.pdf) and can be implemented across various deployment options including RISE with SAP, SAP on AWS, Native AWS installations, or on-premises environments. The solution architecture demonstrates a flexible approach to implementation, allowing organizations to adapt the components based on their specific needs and existing technology landscape. While our example showcases a specific combination of AWS and SAP services, it’s important to understand that there are three key layers where alternative technologies can be employed without compromising the overall functionality of the solution.

### Core Components and Their Alternatives:

1. **Data Integration Layer**
   - Our Example: Amazon AppFlow with SAP OData Connector
   - Alternative [AWS Glue connection for SAP](https://aws.amazon.com/blogs/big-data/scaling-rise-with-sap-data-and-aws-glue/) (using ODATA)
   - Purpose: Handles near real-time data extraction from SAP systems
2. **Processing & Intelligence Layer**
3. **User Interface Layer**

### Architectural Flow (Referenced in high level steps & architecture diagram):

1. Data Extraction: Amazon AppFlow connects to SAP OData Connector for near real-time data extraction
2. Data Storage: Amazon S3 stores extracted data in JSON format
3. User Interface: A chatbot assistant receives natural language inputs from users
4. Processing: Bedrock Agent interprets user input, leveraging its chat history and underlying Foundation Model
5. Action Orchestration: Bedrock Agent is configured with Action Groups to manage processing steps
6. Data Querying: Lambda functions translate natural language to SQL queries for Athena database
7. SAP Integration: AWS Lambda invokes [BTP API](https://developers.sap.com/tutorials/api-mgmt-isuite-initial-setup..html) to create Purchase Orders in SAP
8. Secure Connectivity: [SAP Cloud Connector](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/cloud-connector?locale=en-US) creates a secure tunnel between AWS and BTP accounts
9. Knowledge Enhancement: Amazon Bedrock’s Knowledge Base provides managed RAG for additional context
10. Data Preparation: S3 bucket data is synced and transformed into embeddings for machine learning use
11. Response Generation: The agent curates a final response, delivered via a Streamlit app

### Supporting Infrastructure:

* Data Storage: Amazon S3 (JSON format)
* Query Processing: AWS Lambda with Amazon Athena
* Integration Components: SAP BTP Integration Suite, SAP Cloud Connector
* Knowledge Management: Amazon Bedrock Knowledge Base for RAG
* Data Preparation: S3 bucket with embedding transformation

This modular approach allows organizations to mix and match components based on their existing technology stack, preferences, and requirements while maintaining the core functionality of the solution.

Let’s explore the key AWS services that power this solution and their specific roles, before we demonstrate the Assistant in action through practical examples.

* Amazon S3
* Amazon AppFlow
* AWS Glue
* Amazon Athena
* AWS Lambda
* Amazon Bedrock

### Amazon S3 : 
S3 functions as a central data lake, receiving data directly from S/4HANA via AppFlow and storing it in analytics-optimized formats including CSV, JSON, or Parquet. The solution combines AppFlow for data ingestion, S3 for scalable storage, and Athena for SQL-based analysis, with AWS Glue cataloging the data for easier discovery.

### Amazon AppFlow: 
[Amazon AppFlow](https://aws.amazon.com/appflow/) extracts quotation and RFQ data from SAP into Amazon S3 in near real-time, using a secure SAP connector without requiring custom integrations. It employs Change Data Capture to detect and transfer only new or modified records, ensuring the S3 data lake maintains the most current information.

### AWS Glue: 
AWS Glue crawler automatically discovers, catalogs, and organizes data stored in S3 buckets, making it easily searchable and analyzable. It’s a fully managed ETL service that streamlines data preparation and loading for analytics purposes.

### Amazon Athena: 
Athena is a serverless query service that analyzes data directly in S3 using standard SQL, supporting various data formats and automatically parallelizing queries for distributed execution. It integrates with AWS Glue Data Catalog and supports complex analysis while maintaining a pay-per-query pricing model.

### AWS Lambda: 
Lambda functions as an intermediary between Amazon Bedrock Agents and SAP API, handling the technical integration for purchase order processing. It manages authentication, data transformation, and error handling, enabling scalable, cost-effective processing of AI-driven purchase order requests.

### Amazon Bedrock: 
Bedrock, utilizing Claude 3 Sonnet v1, provides advanced natural language processing capabilities for analyzing quotations based on price and sustainability. It offers serverless architecture for easy deployment and includes Model Evaluation features to ensure accuracy in tasks like quotation analysis.

### Security Considerations:

In this blog example, we have assumed LDAP groups via Single Sign-On to restrict access to authorized procurement users. For a production environment, we recommend implementing identity propagation for enhanced security.

### Cost Considerations:

While exact costs will vary based on usage and specific implementation details, here’s a general overview:

* SAP Integration Suite: [Free 90-day trial](https://help.sap.com/docs/integration-suite/sap-integration-suite/using-free-service-plans), then its subscription based. [Link](https://www.sap.com/products/technology-platform/integration-suite/pricing.html#:~:text=SAP%20Integration%20Suite%2C%20additional%20messages,USD%2077.04) to the SAP pricing.
* AWS Services: Estimated $900 per month for processing 30,000 purchase orders

It’s crucial to note that these costs are illustrative and should be carefully evaluated for your specific use case. AWS recommends closely monitoring costs during any proof of concept and scaling accordingly.

### Cost Optimization:

To maximize value, consider leveraging the [SAP Integration Suite](https://help.sap.com/docs/integration-suite/sap-integration-suite/what-s-new-for-sap-integration-suite) across multiple use cases within your organization. This approach can help achieve economies of scale and help justify the investment.

## Demonstration Overview

Let’s examine the Sustainability Sourcing Assistant in operation. Through a series of interactive queries using natural language, we will demonstrate how the assistant processes and responds to various related inquiries. The system integrates SAP data, in near real-time pulled via Amazon AppFlow into an Amazon S3 data lake, while enriching responses with third-party sustainability metrics from the Bedrock Knowledge Base through Amazon Bedrock Agents orchestration.

By entering the following prompts, starting with “Please List RFQs”, you can see the output.

1. Please list RFQs?

![Image 1](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-2-1.png)

2. Were any RFQs created on 2024-09-03?

![Image 2](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-3-2.png)

3. How many quotations are received for RFQ 7000000026 and from whom and what is the total cost ?

![Image 3](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-4-2.png)

4. Do you have sustainability and other payment term details for these suppliers ?

![Image 4](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-5.png)

5. Recommend the best supplier for RFQ 7000000026 based on price and sustainability score.

![Image 5](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-6.png)

6. Create a purchase order for the recommended supplier.

![Image 6](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-7.png)

## Conclusion

The Sustainability Sourcing Assistant exemplifies how generative AI, powered by Amazon Bedrock, can revolutionize procurement processes by integrating SAP data with external sustainability metrics. This conceptual solution demonstrates the potential for automating quotation analysis, enhancing decision-making with objective criteria, and streamlining purchase order creation—all while maintaining enterprise-grade security and scalability.

Organizations looking to modernize their SAP procurement workflows can start by exploring Amazon Bedrock’s capabilities for building custom AI agents. Combined with AWS services like Amazon AppFlow for seamless data integration and SAP BTP Integration Suite for secure connectivity, this approach offers a flexible foundation for innovation across various business functions.

We encourage you to experiment with these technologies in your own environment, adapting the architecture to your specific needs. Whether enhancing sustainability initiatives or optimizing other procurement aspects, generative AI holds immense promise for driving efficiency and strategic value in your operations.

<!-- ### About the Authors

![Simon Cunningham](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-simon-cunningham.png)

**Simon Cunningham** is a Principal Specialist Solutions Architect for SAP on AWS. With over 25 years in enterprise software and cloud, he focuses on helping customers achieve business value through innovative SAP and AI solutions on AWS.

![Diego Lombardini](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-diego-lombardini.png)

**Diego Lombardini** is a Senior Solutions Architect at AWS, specializing in SAP workloads. He assists customers in designing scalable, secure architectures for SAP on AWS, leveraging his expertise in cloud migration and optimization.

![John Gray](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-john-gray.png)

**John Gray** is a Senior Solutions Architect focused on Generative AI and SAP integrations. He helps customers build innovative AI applications that enhance SAP processes, driving digital transformation.

![Sridhar Mahadevan](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-sridhar-mahadevan.png)

**Sridhar Mahadevan** is a Principal Specialist SA for SAP on AWS, with deep expertise in SAP S/4HANA migrations and AI integrations. He guides customers in leveraging AWS for SAP modernization strategies. -->
