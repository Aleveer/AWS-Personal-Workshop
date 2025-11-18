---
title: "Blog 10"
weight: 2
chapter: false
pre: " <b> 3.10. </b> "
---

# Tăng tốc phát triển Microservices với DAPR và Amazon EKS

Các Microservices và container đang cách mạng hóa cách xây dựng ứng dụng hiện đại, triển khai, và quản lý trên nền tảng đám mây. Tuy nhiên, việc phát triển và vận hành microsevices có thể làm tăng đáng kể mức độ phức tạp, thường xuyên yêu cầu các nhà phát triển phải dành ra nhiều thời gian quý báu cho những mối quan tâm chung như khám phá dịch vụ, quản lý trạng thái, và khả năng quan sát.

[Dapr](https://dapr.io/) ( Distributed Application Runtime ) là một runtime mã nguồn mở được thiết kế để xây dựng microservices trên nền tảng đám mây và biên ( edge ), Nó cung cấp các khối xây dựng độc lập với nền tảng như khám phá dịch vụ, quản lý trạng thái, nhắn tin pub/sub, và khả năng quan sát, tất cả đều được tích hợp sẵn. Dapr đã tốt nghiệp [Cloud Native Computing Foundation ( CNCF )](https://www.cncf.io/) vào ngày 30 tháng 10 năm 2024, đánh dấu một cột mốc quan trọng trong hành trình phát triển dự án.

Khi được kết hợp với [Amazon Elastic Kubernetes Service ( Amazon EKS )](https://aws.amazon.com/eks/), một dịch vụ Kubernetes được quản lý do AWS cung cấp, Dapr có thể tăng tốc việc áp dụng microservices và containers, các nhà phát triển có thể tập trung vào việc viết các logic nghiệp vụ mà không cần bận tâm về hạ tầng phức tạp bên dưới. Amazon EKS giúp việc quản lý các cụm Kubernetes trở nên dễ dàng, đồng thời cho phép mở rộng quy mô linh hoạt khi khối lượng công việc thay đổi. Trong bài viết này, chúng ta sẽ khám phá cách mà Dapr đơn giản hóa việc phát triển microservices trên AWS EKS và minh họa nhanh cách triển khai một ứng dụng mẫu trên EKS bằng Dapr.

## Sức mạnh của Dapr và Amazon EKS 

Sự kết hợp giữa Dapr và Amazon EKS mang đến một nền tảng mạnh mẽ để xây dựng các microservices có tính ổn định cao và khả năng mở rộng vượt trội. Một số lợi ích bao gồm :

1. __Tăng tính di động__ : Với Dapr và Amazon EKS, microservices có thể được triển khai thành bất cứ cụm Kubernetes tiêu chuẩn nào, giúp tăng khả năng di chuyển giữa các môi trường khác nhau.
2. __Cải thiện khả năng phục hồi__ : Các cơ chế đảm bảo độ tin cậy của Dapr như thử lại, ngắt mạch tạm thời, kết hợp với tính năng tự động khởi động lại container của Amazon EKS, giúp nâng cao tính sẵn sàng và thời gian hoạt động của toàn bộ dịch vụ.
3. __Khả năng quan sát liền mạch__ : các tích hợp giám sát của Dapr kết hợp với giám sát gốc qua Amazon CloudWatch trong EKS cung cấp khả năng quan sát toàn diện đối với các microservices.
4. __Tăng tốc đổi mới__ : Dapr đẩy nhanh sự phát triển của microservice, trong khi Amazon EKS  đơn giản hóa việc vận hành cụm, cho phép các nhà phát triển tập trung vào cái logic nghiệp vụ thay vì hạ tầng
5. __Phân tách các mối quan tâm__ : Dapr xử lý các mối quan tâm chung như khám phá dịch vụ và nhắn tin pub/sub, giúp phân tách rõ ràng các tầng chức năng trong kiến trúc microservices.
6. __Tích hợp dịch vụ của AWS__ : Các khối xây dựng Dapr được tích hợp với nhiều dịch vụ AWS mang đến hệ sinh thái phong phú để xây dựng các microservice mạnh mẽ trên Amazon EKS. Một số ví dụ là Amazon Dynamo DB, AWS Secrets Manager, AWS Parameter Store, Amazon SNS, Amazon SQS, Amazon Kinesis và Amazon S3.

## Gọi dịch vụ và quản lý trạng thái với Dapr

Chúng ta sẽ bắt đầu đi sâu vào hai khối chức năng thiết yếu trong Dapr : gọi dịch vụ và quản lý trạng thái.

Gọi dịch vụ ( [Service Invocation](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview/) ) : Việc giao tiếp liền mạch và đáng tin cậy giữa các microservices là rất quan trọng. Tuy nhiên, các nhà phát triển thường xuyên gặp khó khăn với những nhiệm vụ phức tạp như khám phá dịch vụ, chuẩn hóa APIs, bảo mật kênh giao tiếp, xử lý lỗi một cách linh hoạt, và triển khai khả năng quan sát. Các dịch vụ của bạn có thể giao tiếp dễ dàng với nhau thông qua các giao thức tiêu chuẩn trong ngành như gRPC và HTTP/HTTPS. Gọi dịch vụ đảm nhiệm toàn bộ phần phức tạp, từ đăng ký và khám phá dịch vụ đến thử lại yêu cầu, mã hóa, kiểm soát truy cập và theo dõi phân tán.

Quản lý trạng thái ( [State Management](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/) ) : Khối xây dựng quản lý trạng thái của Dapr đơn giản hóa cách mà các nhà phát triển làm việc với trạng thái trong ứng dụng của họ. Nó cung cấp một API nhất quán cho việc lưu trữ và truy xuất dữ liệu trạng thái, bất kể kho lưu trữ trạng thái bên dưới là gì ( Ví dụ : ElastiCache, AWS DynamoDB, Azure Cosmos DB ). Lớp trừu tượng này cho phép các nhà phát triển xây dựng ứng dụng có trạng thái mà không cần lo lắng về sự phức tạp của việc quản lý và mở rộng các kho lưu trữ trạng thái.

## Kiến trúc ứng dụng

Dựa vào sơ đồ, chúng ta có hai microservices : một ứng dụng Python và một ứng dụng Node.js. Ứng dụng Python tạo ra dữ liệu đơn hàng và gọi đến endpoint `/neworder` được cung cấp bởi ứng dụng Node.js. Ứng dụng Node.js ghi dữ liệu đơn hàng đến vào kho lưu trữ trạng thái ( Trong trường hợp này, Amazon ElastiCache ) và trả về mã đơn hàng cho ứng dụng Python như một phản hồi.

Bằng cách tận dụng dịch vụ khối xây dựng gọi dịch vụ của Dapr, ứng dụng Python có thể giao tiếp liền mạch với ứng dụng Node.js mà không cần lo lắng về khám phá dịch vụ, chuẩn hóa API, bảo mật kênh giao tiếp, xử lý lỗi, hay khả năng quan sát. Vận dụng mTLS để đảm bảo an toàn giao tiếp giữa các dịch vụ. Dapr xử lý các mối quan tâm chung, cho phép các nhà phát triển tập trung vào viết các logic nghiệp vụ cốt lõi.

Ngoài ra, khối xây dựng quản lý trạng thái của Dapr đơn giản hóa việc tương tác của ứng dụng Node.js với kho lưu trữ trạng thái ( [Amazon ElastiCache](https://aws.amazon.com/elasticache/) ). Dapr cung cấp một API nhất quán cho việc lưu trữ và truy xuất dữ liệu trạng thái, trừu tượng hóa toàn bộ sự phức tạp của việc quản lý và mở rộng kho lưu trữ và trạng thái bên dưới. Lớp trừu tượng này cho phép các nhà phát triển xây dựng ứng dụng có trạng thái mà không cần lo lắng về các chi tiết phức tạp trong việc quản lý kho lưu trữ trạng thái.

Cụm Amazon EKS chứa một namespace được gọi là `dapr-system`, nơi lưu trữ các thành phần của mặt điều khiển của Dapr. Thành phần `dapr-sidecar-injector` tự động chèn một runtime của Dapr vào các pod của những microservice được kích hoạt Dapr.

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_1.png)


## Ứng dụng và lời gọi dịch vụ 

Sơ đồ kiến trúc ứng dụng thể hiện các bước thực hiện lời gọi dịch vụ.

1. Dịch vụ tạo đơn hàng ( ứng dụng Python ) gọi đến phương thức /neworder của ứng dụng Node. Yêu cầu này được gửi đến Dapr sidecar cục bộ, vốn chạy chung trong cùng một pod với ứng dụng Python.
2. Dapr xác định ứng dụng đích bằng cách sử dụng nhà cung cấp DNS của cụm Amazon EKS và gửi yêu cầu đến sidecar của ứng dụng Node.js
3. Sidecar của ứng dụng Node.js sau đó gửi yêu cầu đến microservice của ứng dụng Node.
4. Ứng dụng Node sau đó viết mã đơn hàng đã nhận từ ứng dụng Python vào Amazon ElastiCache.
5. Ứng dụng Node gửi phản hồi đến Dapr sidecar cục bộ của nó.
6. Sidecar của ứng dụng Node chuyển tiếp phản hồi cho Dapr sidecar của ứng dụng Python.
7. Sidecar của ứng dụng Python trả về phản hồi cho ứng dụng Python, ứng dụng này là bên khởi tạo cái yêu cầu đến phương thức /neworder của ứng dụng Node.

## Kết nối ứng dụng với Dapr trên Amazon EKS

### Yêu cầu chuẩn bị : 

Để triển khai một ứng dụng mẫu trên Amazon EKS sử dụng Dapr, hãy theo dõi theo bài viết này. Bạn sẽ cần chuẩn bị những điều kiện sau : 

* Một tài khoản AWS. Nếu bạn chưa có tài khoản, bạn có thể đăng kí ở đây https://signin.aws.amazon.com/signup?request_type=register
* Người dùng AWS Identity and Access Management ( IAM ) có quyền thích hợp - Thực thể bảo mật IAM mà bạn đang dùng nên có những quyền hạn để làm việc với Amazon EKS IAM, service linked roles, AWS CloudFormation, một VPC, và những tài nguyên liên quan. Thêm nhiều thông tin hơn, hãy xem [Actions, resources, and condition keys for Amazon Elastic Container Service for Kubernetes](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonelastickubernetesservice.html) và [create a service-linked role](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html) trong hướng dẫn người dùng IAM.

Để hiểu cách làm việc của Dapr trên Amazon EKS, hãy chuẩn bị một cụm Amazon EKS và triển khai một ứng dụng mẫu. Sau đó chúng ta sẽ cài đặt Dapr runtime và áp dụng cấu hình Dapr cho các microservice mẫu. Chúng ta sẽ kiểm thử ứng dụng mẫu và trực quan hóa các thành phần Dapr trên bảng điều khiển Dapr.

### 1. Chuẩn bị cụm Amazon EKS

Cài đặt [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) và [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html), đây là những công cụ cần thiết để thực thi các lệnh trong terminal của bạn.

Tạo một cụm Amazon EKS tên là eksworkshop-dapr sử dụng ví dụ cluster-config.yaml

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

Chạy lệnh này để áp dụng yaml và tạo cụm Amazon EKS của bạn

```
eksctl create cluster -f cluster-config.yaml
```

Trước khi tiến hành với việc phát triển ứng dụng của bạn, bạn sẽ cần cấu hình các thiết lập bảo mật để cho phép việc giao tiếp đúng cách giữa các Dapr sidecar. Sử dụng các lệnh tiếp theo để cập nhật quyền bảo mật để cho phép cụm Amazon EKS của bạn có thể giao tiếp với Dapr sidecar

```
aws ec2 authorize-security-group-ingress --region [your_aws_region] \
--group-id [your_security_group] \
--protocol tcp \
--port 4000 \
--source-group [your_security_group]
```

Tiếp theo, bạn sẽ thêm vào một storage class mặc định, là phần cần thiết cho Dapr [scheduler](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-persisting-scheduler/) hoạt động đúng cách

```
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

Tiếp theo là chạy lệnh này để xác nhận rằng các node của Amazon EKS đang hoạt động

```
kubectl get nodes
```

Bạn sẽ nhận được kết quả như thế này

```
ip-192-168-117-234.us-east-2.compute.internal Ready <none> 7m46s v1.31.7-eks-473151a
ip-192-168-141-0.us-east-2.compute.internal   Ready <none> 7m47s v1.31.7-eks-473151a
ip-192-168-179-109.us-east-2.compute.internal Ready <none> 7m47s v1.31.7-eks-473151a
```

Ứng dụng mẫu tận dụng AWS Load Balancer Controller, một thành phần điều phối AWS Load Balancer Controller bên trong cụm Kubernetes của bạn. Để bắt đầu, cài đặt AWS Load Balancer Controller bằng cách theo dõi các bước sau [here](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)

### 2. Cài đặt DAPR trên cụm Amazon EKS của bạn 

Ở bước này, bạn sẽ cài đặt Dapr CLI và sử dụng nó như một công cụ cho các tác vụ liên quan đến Dapr như cài đặt Dapr và liệt kê các thành phần của Dapr.

Chạy lệnh này để cài đặt Dapr CLI mới nhất cho Linux vào /usr/local/bin 

```
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
```

Bạn cần xác thực việc cài đặt Dapr CLI bằng cách chạy dòng lệnh này. 

```
dapr -h
```

Tiếp theo, cài đặt Dapr bằng cách sử dụng lệnh này trong bối cảnh cụm của bạn.

```
dapr init -k
```

Bạn có thể xác thực việc cài đặt Dapr bằng cách chạy lệnh này. 

```
dapr status -k
```

Bạn sẽ nhận được kết quả như thế này.

```
dapr-placement-server dapr-system True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-dashboard dapr-system        True Running 1 0.15.0 1m 2025-05-12 17:38.10 
dapr-sentry dapr-system           True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-operator dapr-system         True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-sidecar-injector dapr-system True Running 1 1.15.4 1m 2025-05-12 17:38.08 
dapr-scheduler-server dapr-system True Running 3 1.15.4 1m 2025-05-12 17:38.08
```

### 3. Thiết lập Amazon ElastiCache làm khi lưu trữ trạng thái

Ở bước này, bạn sẽ tạo một kho lưu trữ trạng thái cho ứng dụng mẫu của mình sử dụng [Amazon ElastiCache Serverless](https://aws.amazon.com/elasticache/?p=pm&c=database&pd=ecache&z=4). Dịch vụ được quản lý này tự động mở rộng để đáp ứng lưu lượng truy cập của ứng dụng của bạn mà không yêu cầu về việc quản lý máy chủ.

Để làm cho nó đơn giản hơn, hãy tạo một phiên bản Amazon ElastiCache serverless trong cùng một VPC với cụm Amazon EKS của bạn. Cấu hình security group để cho phép những kết nối đến từ cụm Amazon EKS của bạn. Ghi lại endpoint của cache, bạn sẽ cần chúng ở bước thứ 5 trong khi áp dụng các cấu hình Dapr.

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_2.png)

### 4. Ứng dụng mẫu

Trong bước này, bạn cần sao chép một ứng dụng mẫu từ Dapr Quickstarts. Dapr Quickstarts có những ứng dụng mẫu để giúp bạn bắt đầu nhanh chóng với Dapr. Đối với hướng dẫn này, chúng ta sẽ sử dụng các ứng dụng mẫu là ứng dụng Node và ứng dụng Python, nằm trong thư mục hello-kubernetes.

```
git clone https://github.com/dapr/quickstarts.git
```

### 5. Cấu hình thành phần kho lưu trữ trạng thái của Dapr

Trong bước này, bạn sẽ tạo và cấu hình thành phần kho lưu trữ trạng thái Dapr để giao tiếp với Amazon ElastiCache.

Tạo một file đặt tên là redis-state.yaml với cấu hình kho lưu trữ trạng thái như sau. Hãy thay thế giá trị redisHost bằng endpoint Amazon ElastiCache của bạn từ bước thứ 3.

CẬP NHẬT apiVersion: dapr.io/v1alpha1 kind: Component metadata: name: statestore namespace: default spec: type: state.redis version: v1 metadata:

* name: redisHost value: redisdaprd-7rr1vd.serv3rless.use1.cache.amazonaws.com:6379
* name: enableTLS value: true
	
Áp dụng cấu hình vào cụm của bạn. 

```
kubectl apply -f redis-state.yaml
```

### 6. Triển khai Microservices với Dapr Sidecars

Ở bước này, bạn sẽ triển khai hai microservice : một ứng dụng Node với quy trình đặt hàng và ứng dụng Python chứa những logic nghiệp vụ để tạo ra đơn hàng mới. Bạn đã lấy các ứng dụng này ở bước thứ 4 từ Dapr Quickstart.

Để triển khai ứng dụng microservice Node, hãy truy cập vào /quickstarts/tutorials/hello-kubernetes/deploy/node.yaml file. Hãy chú ý đến các chú thích Dapr quan trọng.

Chú thích này chỉ thị cho control plane của Dapr chèn  một sidecar và gán một tên cho ứng dụng Dapr.

```
annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "nodeapp"
        dapr.io/app-port: "3000
```

Thêm chú thích AWS Load Balancer để tạo một internet-facing AWS Load Balancer.

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

Kế tiếp, triển khai ứng dụng Node sử dụng kubectl. Điều hướng để thư mục /quickstarts/tutorials/hello-kubernetes/deploy và thực thi lệnh này.

```
kubectl apply -f node.yaml
```

Tiếp theo, lấy endpoint của load balancer. Nó xuất hiện dưới mục External IP trong kết quả của lệnh sau đây. 

```
kubectl get svc nodeapp

http://k8s-default-nodeapp-3a173exxxx-f7b14bedf0c4dd8.elb.us-east-2.amazonaws.com
```

Bây giờ thi dịch vụ của bạn đã được triển khai, hãy xác thực để làm nó hoạt động chính xác hơn, Bạn sẽ kiểm thử chức năng gửi đơn hàng, sử dụng một mẫu tải trọng JSON.

Điều hướng đến thư mục /quickstarts/tutorials/hello-kubernetes chỗ có tệp sample.json để thực hiện bước này.

```
curl --request POST --data "@sample.json" --header Content-Type:application/json http://k8s-default-nodeapp-3a173exxxx-f14bedff0c4dd8.elb.us-east-2.amazonaws.com/neworder
```

Bạn có thể xác thực kết quả bằng cách truy cập endpoint /order sử dụng load balancer trên trình duyệt.

http://k8s-default-nodeapp-3a173exxxx-f7b14bedff0c4dd8.elb.us-east-2.amazonaws.com/order

Bạn sẽ nhận được kết quả tương tự như {“OrderId”:“42”}

Để hoàn thành phần chuẩn bị microservices của bạn, bạn sẽ cần triển khai ứng dụng Python bây giờ, phần có logic nghiệp vụ để tạo ra mã đơn hàng mới trong mỗi giây. Nó gọi tự động endpoint /neworder của ứng dụng Node.

Điều hướng đến thư mục quickstarts/tutorials/hello-kubernetes/deploy và thi hành lệnh này. 

```
kubectl apply -f python.yaml
```

### 7. Xác minh các Microservice đã được kích hoạt Dapr
Hãy xác thực kiến trúc microservices của bạn hoạt động chính xác bằng cách kiểm tra nhật ký và endpoints.

Theo dõi logs của sidecar Dapr thuộc dịch vụ ứng dụng Python để xác thực nó đã tạo ra và gửi đơn hàng. Hãy chạy những dòng lệnh sau đây và bạn sẽ nhận được các lệnh gọi API HTTP xuất hiện liên tục với phương thức là POST /neworder

```
kubectl logs --selector=app=python -c daprd --tail=-1

time="2024-03-07T12:43:11.556356346Z" level=info msg="HTTP API Called" app_id=pythonapp instance=pythonapp-974db9877-dljtw method="POST /neworder" scope=dapr.runtime.http-info type=log useragent=python-requests/2.31.0 ver=1.12.5
time="2024-03-07T12:43:12.563193147Z" level=info msg="HTTP API Called" app_id=pythonapp instance=pythonapp-974db9877-dljtw method="POST /neworder" scope=dapr.runtime.http-info type=log useragent=python-requests/2.31.0 ver=1.12.5
```

Tiếp theo, kiểm tra log của ứng dụng Node để xác nhận tiến trình đơn hàng và lưu trữ trạng thái. Hãy chạy lệnh sau và bạn sẽ nhận được thông báo xác thực đã xử lý  đơn hàng. 

```
kubectl logs —selector=app=node -c node —tail=-1

Got a new order! Order ID: 367
Successfully persisted state for Order ID: 367
Got a new order! Order ID: 368
Successfully persisted state for Order ID: 368
Got a new order! Order ID: 369
Successfully persisted state for Order ID: 369
```

Bạn cũng có thể xác thực xem các đơn hàng đang lưu trữ trạng thái đúng cách trên Amazon ElastiCache. Bạn có thể thêm /order vào load balancer của ứng dụng. Nó trả về mã đơn hàng gần nhất mà đã được tạo ra bởi ứng dụng Python.

http://k8s-default-nodeapp-3a173exxxx-f7b14beff0c4dd8.elb.us-east-2.amazonaws.com/order

Bạn sẽ nhận được kết quả của nhiều đơn hàng gần đây như {“OrderId”:“370”}

### 8. Trực quan hóa các thành phần Dapr bằng bảng điều khiển ( Dashboard )
Dapr cung cấp một bảng điều khiển mạnh mẽ mà nó có thể giúp cho bạn theo dõi ứng dụng, cấu hình, cách thành thành phần và log của bạn. Bạn có thể thiết lập quyền truy cập bên ngoài thông qua Elastic Load Balancing (ELB).

Trong phần này, bạn sẽ tạo một tệp yaml cho bảng điều khiển và áp dụng nó vào cụm Amazon EKS của bạn.

Tạo một tệp yaml được gọi là dashboard.yaml với những chú thích.

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

Điều hướng đến thư mục chứa dashbroad.yaml và thực hiện lệnh này để tạo dịch vụ.

```
kubectl apply -f dashboard.yaml
```

Tiếp theo, hãy lấy endpoint ELB từ dapr-mydashboard bằng cách thực lệnh sau. Chúng ta sẽ sử dụng endpoint này để truy cập đến bảng điều khiển.

```
kubectl get svc dapr-mydashboard -n dapr-system
```

Truy cập đến bảng điều khiển Dapr bằng endpoint ELB mà chúng ta đã lấy được, Đây là ví dụ của endpoint URL và ảnh chụp màn hình.

http://k8s-daprsyst-daprdash-ca3914xxxx-b507661502aa8eb.elb.us-east-2.amazonaws.com/overview

![](/images/3-BlogsTranslated/3.10-Blog10/Dapr-Architecture_3.png)

Bảng điều khiển Dapr cung cấp cái nhìn chi tiết về ứng dụng Dapr, các thành phần và cấu hình chạy Amazon EKS từ một vùng duy nhất.

## Dọn dẹp

Chạy lệnh sau để xóa các triển khai của ứng dụng Node và ứng dụng Python có kho lưu trữ trạng thái.

Điều hướng đến thư mục /quickstarts/tutorials/hello-kubernetes/deploy để thực hiện các lệnh sau đây.

```
kubectl delete -f node.yaml
kubectl delete -f python.yaml
```

Bạn có thể xóa cụm Amazon EKS của mình bằng lệnh eksctl và xóa Amazon ElasticCache.

Điều hướng đến thư mục chứa tệp cluster.yaml để tạo cụm ở bước đầu tiên.

```
eksctl delete cluster -f cluster-config.yaml 
```

## Tóm tắt

Trong bài viết này, bạn đã được nhìn thấy được cách kết hợp giữa Dapr và Amazon EKS đơn giản hóa việc phát triển và triển khai microservices.

Giải pháp này mang lại một số lợi ích chính :

* Dapr trừu tượng hóa các mô hình hệ thống phân tán phức tạp.
* Amazon EKS  đảm nhiệm phần việc phức tạp trong quản lý Kubernetes.
* Các nhà phát triển có thể hoàn toàn tập trung vào logic nghiệp vụ.
* Hỗ trợ tích hợp sẵn các khả năng quan trọng như quản lý trạng thái và giao tiếp giữa các dịch vụ.

Hướng đi tiếp theo : 

* Khám phá khả năng theo dõi phân tán của Dapr.
* Tìm hiểu các khối xây dựng bổ sung của Dapr cho những tính năng như pub/sub và quản lý bảo mật.
* Mở rộng kiến trúc microservice của bạn với khả năng điều phối mạnh mẽ của Amazon EKS.

Bằng cách tận dụng Dapr trên Amazon EKS, bạn có thể nhanh chóng phát triển microservices của bạn trong khi vẫn duy trì độ tin cậy và khả năng mở rộng cấp doanh nghiệp. Sự kết hợp cung cấp một nền tảng sẵn sàng cho các ứng dụng hiện đại, chạy trên nền tảng đám mây.

Tìm hiểu thêm ở [Dapr documentation](https://docs.dapr.io/) và [Amazon EKS documentation](https://docs.aws.amazon.com/eks/).