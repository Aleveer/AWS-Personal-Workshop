---
title : "Giới thiệu"
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

#### Giới thiệu về ứng dụng WebChat

+ Ứng dụng WebChat là một hệ thống nhắn tin real-time cho phép người dùng giao tiếp với nhau thông qua giao diện web hiện đại. Hệ thống hỗ trợ các tính năng cơ bản như gửi và nhận tin nhắn văn bản, chia sẻ file, gửi tin nhắn thoại, tạo nhóm chat, phân quyền thành viên trong nhóm.

+ Backend của ứng dụng được xây dựng bằng framework NestJS, một framework Node.js mạnh mẽ sử dụng TypeScript, cung cấp kiến trúc modular và dễ mở rộng. Tính năng real-time messaging được triển khai thông qua Socket.io, cho phép giao tiếp hai chiều giữa client và server một cách hiệu quả mà không cần polling liên tục.

+ Phía frontend được phát triển bằng VueJS với công cụ build Vite. Pinia được sử dụng để quản lý state, trong khi Socket.io-client đảm bảo kết nối WebSocket ổn định với backend.

+ Xác thực người dùng được thực hiện thông qua JWT (JSON Web Tokens), cho phép quản lý phiên đăng nhập một cách an toàn và không trạng thái (stateless).

#### Tổng quan về workshop

Trong workshop này, chúng ta sẽ xây dựng một ứng dụng WebChat hoàn chỉnh từ đầu đến cuối, sử dụng các dịch vụ AWS và công nghệ hiện đại. Workshop được chia thành các phần chính như sau:

+ Thiết lập hạ tầng với Terraform: Sử dụng Terraform để định nghĩa và triển khai toàn bộ hạ tầng AWS theo nguyên tắc Infrastructure as Code (IaC). Điều này bao gồm việc tạo S3 bucket cho file storage, ECR repository cho Docker images, ECS cluster và service, Application Load Balancer (ALB) để phân phối lưu lượng, cùng với các IAM roles và CloudWatch log groups cần thiết.

+ Phát triển Backend Application: Xây dựng backend API sử dụng NestJS, bao gồm các module chính như authentication (JWT), chat với WebSocket support, file upload tích hợp với S3, và các module quản lý users, groups, messages, authentication, chat. Backend sẽ được containerized bằng Docker và deploy lên Amazon ECS Fargate, một dịch vụ container orchestration không cần quản lý server, tự động scale và quản lý containers.

+ Triển khai Backend lên AWS: Sau khi build Docker image, chúng ta sẽ push image lên Amazon ECR (Elastic Container Registry) và cấu hình ECS service để chạy containers. Application Load Balancer (ALB) sẽ được sử dụng để phân phối lưu lượng HTTP/WebSocket đến các ECS tasks, đảm bảo tính khả dụng và khả năng mở rộng của ứng dụng.

+ Phát triển Frontend Application: Xây dựng giao diện người dùng với VueJS, tích hợp Socket.io-client để kết nối real-time với backend, và sử dụng Pinia để quản lý state. Frontend sẽ bao gồm các component như chat interface, message list, file upload, và các trang authentication.

+ Triển khai Frontend: **Đại viết khúc này**

+ Monitoring và Logging: Sau khi triển khai toàn bộ Backend và Frontend lên nền tàng AWS. Chúng ta cấu hình Amazon CloudWatch Logs để thu thập và theo dõi logs từ ECS tasks, tạo CloudWatch dashboards để giám sát metrics như request count, error rates, và response times. AWS Budgets sẽ được thiết lập để theo dõi và cảnh báo về chi phí sử dụng các dịch vụ AWS.

+ Database: Hệ thống sử dụng MongoDB Atlas làm database chính để lưu trữ dữ liệu người dùng, cuộc trò chuyện và tin nhắn.

**Bổ sung Diagram kiến trúc tổng quát**
![overview](/images/5-Workshop/5.1-Workshop-overview/diagram1.png)
