---
title: "Blog 10"
weight: 2
chapter: false
pre: " <b> 3.10. </b> "
---

# Accelerate Microservices Development with DAPR and Amazon EKS

Microservices and containers are revolutionizing how modern applications are built, deployed, and managed in the cloud. However, developing and operating microservices can introduce significant complexity, often requiring developers to spend valuable time on cross-cutting concerns like service discovery, state management, and observability.

[Dapr](https://dapr.io/) (Distributed Application Runtime) is an open source runtime for building microservices on cloud and edge. It provides platform-agnostic building blocks like service discovery, state management, pub/sub messaging, and observability out of the box. Dapr graduated from the [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/) on Oct. 30, 2024, marking a major milestone in the project’s journey.

When combined with [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/), a managed Kubernetes service from AWS, Dapr can accelerate the adoption of microservices and containers, enabling developers to focus on writing business logic without worrying about infrastructure plumbing. Amazon EKS makes managing Kubernetes clusters easy, enabling effortless scaling as workloads change. In this blog post we’ll explore how Dapr simplifies microservices development on Amazon EKS and quickly demonstrate how to deploy a sample application on EKS using Dapr.

## The Power of Dapr and Amazon EKS

The combination of Dapr and Amazon EKS provides a powerful platform for building robust and scalable microservices. Some of the benefits include:

1. __Increased Portability__: With Dapr and Amazon EKS, microservices can be deployed to any standard Kubernetes cluster, providing increased portability across environments.
2. __Improved Resiliency__: Dapr’s resiliency constructs, such as retries and circuit breakers, combined with Amazon EKS’ automated container restarts, improve overall service availability and uptime.
3. __Seamless Observability__: Dapr’s monitoring integrations and Amazon EKS’ native CloudWatch monitoring deliver end-to-end visibility into microservices.
4. __Accelerated Innovation__: Dapr accelerates microservices development, while Amazon EKS streamlines cluster operations, enabling developers to focus on business logic rather than infrastructure.
5. __Separation of Concerns__: Dapr handles cross-cutting concerns like service discovery and pub-sub messaging, enabling clearer separation of concerns in microservices architectures.
6. __AWS Service Integration__: Dapr building block’s integration with AWS services provides access to a rich ecosystem of capabilities for building robust microservices on Amazon EKS. Some examples are Amazon Dynamo DB, AWS Secrets Manager, AWS Parameter Store, Amazon SNS, Amazon SQS, Amazon Kinesis and Amazon S3.

## Service Invocation and State Management with Dapr

We’ll start by diving into two essential building blocks of Dapr functionality: service invocation and state management.

[Service Invocation](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview/): Seamless and reliable communication between microservices is crucial. However, developers often struggle with complex tasks like service discovery, standardizing APIs, securing communication channels, handling failures gracefully, and implementing observability. Your services can effortlessly communicate with each other using industry-standard protocols like gRPC and HTTP/HTTPS. Service invocation handles all the heavy lifting, from service registration and discovery to request retries, encryption, access control, and distributed tracing.

[State Management](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/) : Dapr’s state management building block simplifies the way developers work with state in their applications. It provides a consistent API for storing and retrieving state data, regardless of the underlying state store (e.g., ElastiCache, AWS DynamoDB, Azure Cosmos DB). This abstraction enables developers to build stateful applications without worrying about the complexities of managing and scaling state stores.

## Application Architecture

In this diagram, we have two microservices: a Python app and a Node.js app. The Python app generates order data and invokes the `/neworder` endpoint exposed by the Node.js app. The Node.js app writes the incoming order data to a state store (in this case, Amazon ElastiCache) and returns an order ID to the Python app as a response.

By leveraging Dapr’s service invocation building block, the Python app can seamlessly communicate with the Node.js app without worrying about service discovery, API standardization, communication channel security, failure handling, or observability. It implements mTLS to have secure service to service communication. Dapr handles these cross-cutting concerns, allowing developers to focus on writing the core business logic.

Additionally, Dapr’s state management building block simplifies how the Node.js app interacts with the state store ([Amazon ElastiCache](https://aws.amazon.com/elasticache/)). Dapr provides a consistent API for storing and retrieving state data, abstracting away the complexities of managing and scaling the underlying state store. This abstraction enables developers to build stateful applications without worrying about the intricacies of state store management.

The Amazon EKS cluster hosts a namespace called `dapr-system`, which contains the Dapr control plane components. The `dapr-sidecar-injector` automatically injects a Dapr runtime into the pods of Dapr-enabled microservices.

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_1.png)

## Application and Service invocations

This application architecture diagram has these service invocation steps.

1. The order generator service (Python app) invokes Node app’s method /neworder. This request is sent to the local Dapr sidecar which is running in the same pod as the Python app.
2. Dapr resolves the target app by using the Amazon EKS cluster’s DNS provider and sends the request to Node app’s sidecar.
3. The Node app’s sidecar then sends the request to Node app microservice.
4. Node app then writes the order ID received from Python app to Amazon ElastiCache.
5. The Node app sends the response to its local Dapr sidecar.
6. Node app’s side car forwards the response to Python app’s Dapr sidecar.
7. Python app side car returns the response to Python app which had initiated the request to Node app’s method /neworder.

## Connect an application to Dapr on Amazon EKS

### Prerequisites
In order to deploy a sample application on Amazon EKS using Dapr, follow along with this post. You should have the following:

* An AWS account. If you don’t have one, you can [sign up](https://portal.aws.amazon.com/billing/signup#/start) for one.
* An AWS Identity and Access Management (IAM) user with proper permissions – The IAM security principal that you’re using must have permissions to work with Amazon EKS IAM roles, service linked roles, AWS CloudFormation, a VPC, and related resources. For more information, see [Actions, resources, and condition keys for Amazon Elastic Container Service for Kubernetes](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonelastickubernetesservice.html) and [create a service-linked role](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html) in the IAM User Guide.

To understand how Dapr works on Amazon EKS, let’s set up an Amazon EKS cluster and deploy a sample application. Then we’ll install Dapr runtime and apply Dapr configurations to the sample microservices. We’ll next test out the sample application and visualize Dapr components on a Dapr dashboard.

### 1. Set up Amazon EKS Cluster

Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) and [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) which are needed to execute the commands in your terminal.

Create an Amazon EKS cluster named eksworkshop-dapr using this example cluster-config.yaml

```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eksworkshop-dapr
  region: us-east-2
  version: "1.31"
  tags:
    karpenter.sh/discovery: eksworkshop-dapr

iam:
  withOIDC: true

managedNodeGroups:
  - name: default
    desiredCapacity: 3
    minSize: 3
    maxSize: 5
    instanceType: m7i.large
    privateNetworking: true

addons:
  - name: vpc-cni 
    attachPolicyARNs:
      - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
  - name: coredns
    version: latest 
  - name: kube-proxy
    version: latest
  - name: aws-ebs-csi-driver
    wellKnownPolicies: 
      ebsCSIController: true
```

Run this command to apply yaml and create your Amazon EKS cluster.

```
eksctl create cluster -f cluster-config.yaml
```

Before proceeding with your application deployment, you’ll need to configure the security settings to enable proper Dapr sidecar communication. Use the following command to update the security rule to allow your Amazon EKS cluster to communicate with the Dapr sidecar.

```
aws ec2 authorize-security-group-ingress --region [your_aws_region] \
--group-id [your_security_group] \
--protocol tcp \
--port 4000 \
--source-group [your_security_group]
```

Next you will add a default storage class which is needed for the Dapr [scheduler](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-persisting-scheduler/) to function properly.

```
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

Next run this command to confirm that Amazon EKS nodes are up and running.

```
kubectl get nodes
```

You should get output like this.

```
ip-192-168-117-234.us-east-2.compute.internal Ready <none> 7m46s v1.31.7-eks-473151a
ip-192-168-141-0.us-east-2.compute.internal   Ready <none> 7m47s v1.31.7-eks-473151a
ip-192-168-179-109.us-east-2.compute.internal Ready <none> 7m47s v1.31.7-eks-473151a
```

The sample application leverages the AWS Load Balancer Controller, a component that orchestrates AWS Elastic Load Balancers within your Kubernetes cluster. To get started, install the AWS Load Balancer Controller by following the steps [here](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html).

### 2. Install DAPR on your Amazon EKS cluster

In this step you will install Dapr CLI and use it as the tool for Dapr related tasks like installing Dapr and listing Dapr components.

Run this command to install the latest Linux Dapr CLI to /usr/local/bin

```
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
```

You can verify the Dapr CLI installation by running this command.

```
dapr -h
```

Next, install Dapr by using this command in your cluster context.

```
dapr init -k
```

You can verify Dapr Installation by running this command.

```
dapr status -k
```

You should get output like this

```
dapr-placement-server dapr-system True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-dashboard dapr-system        True Running 1 0.15.0 1m 2025-05-12 17:38.10 
dapr-sentry dapr-system           True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-operator dapr-system         True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-sidecar-injector dapr-system True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-scheduler-server dapr-system True Running 3 1.15.4 1m 2025-05-12 17:38.08
```

### 3. Set up Amazon ElastiCache as state store

In this step, you’ll create a state store for your sample application using [Amazon ElastiCache Serverless](https://aws.amazon.com/elasticache/?p=pm&c=database&pd=ecache&z=4). This managed service automatically scales to meet your application’s traffic demands without requiring server management.

To keep it simple, create an Amazon ElastiCache serverless instance in the same VPC as your Amazon EKS cluster. Configure the security group to allow incoming connections from your Amazon EKS cluster. Note down the cache endpoint, you will need this in step 5 while applying Dapr configurations.

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_2.png)

### 4. Sample Application

In this step you need to clone a sample application from Dapr Quickstarts. Dapr Quickstarts has sample applications to get you started quickly with Dapr. For this tutorial we’ll use the sample applications node app and Python app which are in the hello-kubernetes directory.

```
git clone https://github.com/dapr/quickstarts.git
```

### 5. Configuring the Dapr State Store Component

In this step, you’ll create and configure the Dapr state store component to communicate with Amazon ElastiCache.

Create a file named redis-state.yaml with the following state store configurations. Replace the redisHost value with your Amazon ElastiCache endpoint from Step 3.

UPDATE apiVersion: dapr.io/v1alpha1 kind: Component metadata: name: statestore namespace: default spec: type: state.redis version: v1 metadata:

* name: redisHost value: redisdaprd-7rr1vd.serv3rless.use1.cache.amazonaws.com:6379
* name: enableTLS value: true

Apply the configuration to your cluster.

```
kubectl apply -f redis-state.yaml
```

### 6. Deploying Microservices with Dapr Sidecars

In this step you will deploy two microservices: a Node app which processes orders and a Python app which has the business logic to generate new orders. You obtained these apps in step 4 from Dapr Quickstart.

To deploy the microservice Node app, navigate to /quickstarts/tutorials/hello-kubernetes/deploy/node.yaml file. Note the crucial Dapr annotations.

The annotation tells the Dapr control plane to inject a side car and assigns a name to the Dapr application.

```
annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "nodeapp"
        dapr.io/app-port: "3000
```

Add AWS Load Balancer annotation to create an internet-facing AWS Load Balancer.

```
kind: Service
apiVersion: v1
metadata:
  name: nodeapp
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
  labels:
    app: node
spec:
  selector:
    app: node
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: LoadBalancer
```

Next, deploy the node app using kubectl. Navigate to the directory /quickstarts/tutorials/hello-kubernetes/deploy and execute this command.

```
kubectl apply -f node.yaml
```

Next, retrieve the load balancer endpoint. It appears under External IP on the output of the following command.

```
kubectl get svc nodeapp

http://k8s-default-nodeapp-3a173exxxx-f7b14bedf0c4dd8.elb.us-east-2.amazonaws.com
```

Now that your service is deployed, let’s verify that it is working correctly. You’ll test the order submission functionality using a sample JSON payload.

Navigate to the directory /quickstarts/tutorials/hello-kubernetes which has sample.json file to execute this step.

```
curl --request POST --data "@sample.json" --header Content-Type:application/json http://k8s-default-nodeapp-3a173exxxx-f14bedff0c4dd8.elb.us-east-2.amazonaws.com/neworder
```

You can verify the output by accessing /order endpoint using the load balancer in a browser.

http://k8s-default-nodeapp-3a173exxxx-f7b14bedff0c4dd8.elb.us-east-2.amazonaws.com/order

You will get output similar to {“OrderId”:“42”}

To complete your microservices setup, you’ll now deploy a Python application that has a business logic to generate a new order id every second. It automatically invokes /neworder endpoint of the nodeapp application.

Navigate to the directory /quickstarts/tutorials/hello-kubernetes/deploy and execute this command.

```
kubectl apply -f python.yaml
```

### 7. Validating your Dapr enabled Microservices

Let’s verify that your microservices architecture is functioning correctly by checking the logs and endpoints.

Monitor the Python app service’s Dapr sidecar logs to confirm it’s generating and sending orders. Run the following command and you should get continuous HTTP API calls with method=”POST /neworder”
```
kubectl logs --selector=app=python -c daprd --tail=-1
time="2024-03-07T12:43:11.556356346Z" level=info msg="HTTP API Called" app_id=pythonapp instance=pythonapp-974db9877-dljtw method="POST /neworder" scope=dapr.runtime.http-info type=log useragent=python-requests/2.31.0 ver=1.12.5
time="2024-03-07T12:43:12.563193147Z" level=info msg="HTTP API Called" app_id=pythonapp instance=pythonapp-974db9877-dljtw method="POST /neworder" scope=dapr.runtime.http-info type=log useragent=python-requests/2.31.0 ver=1.12.5
```

Next, check the Node app application logs to confirm order processing and state persistence. Run this command and you should get order processing confirmations.

```
kubectl logs —selector=app=node -c node —tail=-1


Got a new order! Order ID: 367
Successfully persisted state for Order ID: 367
Got a new order! Order ID: 368
Successfully persisted state for Order ID: 368
Got a new order! Order ID: 369
Successfully persisted state for Order ID: 369
```

You can also confirm whether orders are being properly stored in Amazon ElastiCache. You can append /order to the application load balancer. It returns the latest order id which was generated by the Python app.

http://k8s-default-nodeapp-3a173exxxx-f7b14beff0c4dd8.elb.us-east-2.amazonaws.com/order

You will get an output with most recent order as as {“OrderId”:“370”}

### 8. Visualizing your Dapr Components with the Dashboard

Dapr provides a powerful dashboard that helps you monitor your applications, configurations, components, and logs. You can set it up with external access through Elastic Load Balancing (ELB).

In this section you will create a yaml file for the dashboard and apply to your Amazon EKS cluster.

Create a yaml file called dashboard.yaml with these annotations.

```
kind: Service
apiVersion: v1
metadata:
  name: dapr-mydashboard
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
  namespace: dapr-system  
  labels:
    app: dapr-dashboard
spec:
  selector:
    app: dapr-dashboard
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

Navigate to the directory where dashboard.yaml is placed and execute this command to create a service

```
kubectl apply -f dashboard.yaml
```

Next, retrieve the ELB endpoint from dapr-mydasboard by executing the following command. We’ll use this endpoint to access the dashboard.

```
kubectl get svc dapr-mydashboard -n dapr-system
```

Access the Dapr dashboard using the ELB endpoint which we just retrieved. Here is an example endpoint URL and screen capture.

http://k8s-daprsyst-daprdash-ca3914xxxx-b507661502aa8eb.elb.us-east-2.amazonaws.com/overview

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_3.png)

The Dapr dashboard provides a detailed view of all Dapr applications, components and configurations running on Amazon EKS from one single place.

## Clean up

Run the following command to delete the deployments Node app and Python app with the state store component.

Navigate to the directory /quickstarts/tutorials/hello-kubernetes/deploy to execute the following commands.

```
kubectl delete -f node.yaml
kubectl delete -f python.yaml
```

You can tear down your Amazon EKS cluster using the eksctl command and delete Amazon ElascticCache.

Navigate to the directory which has cluster.yaml file use to create the cluster in first step.

```
eksctl delete cluster -f cluster-config.yaml 
```

## Conclusion
In this post, you’ve seen how the combination of Dapr and Amazon EKS simplifies microservices development and deployment.

This solution offers several key benefits:

* Dapr abstracts away complex distributed system patterns
* Amazon EKS handles the heavy lifting of Kubernetes management
* Developers can focus purely on business logic
* Built-in support for critical capabilities like state management and service-to-service communication

Where to go from here:

* Explore Dapr’s distributed tracing capabilities
* Check out Dapr’s additional building blocks for features like pub/sub and secrets management
* Scale your microservices architecture with Amazon EKS’s robust orchestration

By leveraging Dapr on Amazon EKS, you can accelerate your microservices development while maintaining enterprise-grade reliability and scalability. The combination provides a production-ready foundation for modern, cloud-native applications.

To learn more, visit the [Dapr documentation](https://docs.dapr.io/) and [Amazon EKS documentation](https://docs.aws.amazon.com/eks/).