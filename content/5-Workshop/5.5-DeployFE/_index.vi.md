---
title : "Triển khai Frontend với Amazon Amplify và thực hiện kết nối an toàn với API của Backend"
weight : 5
chapter : false
pre : " <b> 5.5 </b> "
---
#### Tổng quan về triển khai Frontend với Amazon Amplify và thực hiện kết nối với API của Backend .
Trong phần này , chúng ta sẽ từng bước  triển khai ứng dụng Frontend (sử dụng Vue.js) lên dịch vụ Hosting tĩnh của AWS Amplify, đồng thời thiết lập kết nối an toàn và hiệu quả với Backend API đang chạy trên ECS/ALB bằng cách sử dụng Tên miền Tùy chỉnh (Custom Domain), AWS Route 53, AWS Certificate Manager (ACM) và cơ chế Rewrite/Redirect của Amplify.

Các dịch vụ chúng ta sẽ cần sử dụng trong quá trình triển khai :
- **Amazon Amplify** : Dùng để triển khai Frontend Vue.js lên Amplify Hosting, tự động xây dựng và phân phối nội dung Frontend đến người dùng thông qua CDN (dịch vụ cơ sở của Amplify Hosting, bao gồm CloudFront). Đồng thời, sử dụng cơ chế Rewrite/Redirects để chuyển tiếp yêu cầu API tới Backend.
- **Route 53** : Dùng để tạo Hosted Zone và quản lý các bản ghi DNS  cho tên miền tùy chỉnh (ví dụ: webchat.mom). Dùng để trỏ Name Servers từ nhà cung cấp tên miền bên thứ ba (Porkbun) về Route 53. Cuối cùng là tạo bản ghi Alias để trỏ subdomain API (api.webchat.mom) về Application Load Balancer (ALB) của Backend.
- **Amazon Certificate Management** : Dùng để yêu cầu và cấp chứng chỉ SSL/TLS công cộng (Public Certificate) cho các tên miền (Frontend và Backend). Chứng chỉ này sau đó được gắn vào ALB của Backend và được sử dụng bởi Amplify Hosting để bật HTTPS.

#### Nội dung

1. [Triển khai Frontend lên AWS Amplify](5.5.1-Deploy-Frontend/)
2. [Cấu hình để kết nối giữa Frontend và Backend](5.5.2-Connect-BE-FE/)
3. [Cấu hình Custom Domain với Route53 và xác thực SSL với AWS Certificate Manager](5.5.3-Custom-Domain-BE/)
4. [Tùy chỉnh Domain cho Amplify Frontend](5.5.4-Custom-Domain-FE/)