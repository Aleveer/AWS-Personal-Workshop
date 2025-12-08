---
title: "Bản đề xuất"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---
### Ứng dụng trò chuyện thời gian thực
### 1. Tóm tắt điều hành

Serverless Web Chat Platform được phát triển nhằm cung cấp một giải pháp giao tiếp nội bộ nhanh chóng, bảo mật và dễ vận hành. Ứng dụng hỗ trợ nhắn tin thời gian thực giữa các thành viên thông qua giao diện web nhẹ, có kha năng mở rộng linh hoạt trong tương lai. Nền tảng tận dụng các dịch vụ AWS Serverless như API Gateway AWS Lambda, DynamoDB và Amazon Cognito để đảm bảo vận hành ổn định, chi phí thấp và không yêu cầu quản lý máy chủ. Quyền truy cập được giới hạn cho các thành viên phòng lab, đảm bảo bảo mật và tính riêng tư trong quá trình trao đổi thông tin.

### 2. Tuyên bố vấn đề  
*Vấn đề hiện tại*<br>
Nhóm đang phát triển một ứng dụng chat phục vụ mục đích học tập và nghiên cứu về cách xây dựng hệ thống web thời gian thực. Nếu triển khai theo mô hình truyền thống (tự dựng máy chủ, tự quản lý cơ sở dữ liệu và duy trì kết nối WebSocket), nhóm sẽ phải đối mặt với nhiều khó khăn như: thiết lập hạ tầng phức tạp, xử lý mở rộng khi có nhiều kết nối đồng thời, đảm bảo tính ổn định và bảo mật, cũng như theo dõi và ghi log đầy đủ cho hệ thống. Việc không tận dụng các dịch vụ AWS khiến nhóm khó mô phỏng các mô hình hạ tầng hiện đại, đồng thời tốn thời gian cho các tác vụ vận hành thay vì tập trung vào phần ứng dụng và các bài học kỹ thuật cốt lõi.

*Giải pháp*<br>
Ứng dụng Web Chat được triển khai dựa trên các dịch vụ Serverless của AWS, nhằm mô phỏng kiến trúc ứng dụng hiện đại, có khả năng mở rộng tối đa.Giải pháp tập trung vào việc loại bỏ nhu cầu quản lý máy chủ, tối đa hóa khả năng mở rộng tức thì và giảm chi phí vận hành. Bằng cách sử dụng WebSocket API qua CloudFront và Lambda, giải pháp đảm bảo giao tiếp WSS tốc độ cao, đồng thời áp dụng DynamoDB để xử lý hiệu quả các thao tác đọc/ghi lớn cho dữ liệu chat. Cognito cung cấp lớp xác thực mạnh mẽ, bảo vệ toàn bộ ứng dụng từ lớp truy cập (frontend) đến lớp API.

*Lợi ích và hoàn vốn đầu tư (ROI)*<br>
Giải pháp giúp nhóm thực hành xây dựng ứng dụng chat hoàn chỉnh từ frontend đến backend, kết hợp với các dịch vụ cloud thường dùng trong môi trường doanh nghiệp. Nhờ tận dụng Free Tier và các tài nguyên test, chi phí triển khai thấp nhưng vẫn đảm bảo đủ tính thực tiễn để nhóm hiểu rõ về quản lý hạ tầng, giám sát, mở rộng và bảo mật. Việc triển khai trên AWS giúp giảm thời gian cấu hình thủ công, đồng thời tạo nền tảng vững chắc cho các nghiên cứu nâng cao như chatbot, xử lý dữ liệu hoạt động người dùng hoặc tích hợp hệ thống AI. Thời gian hoàn vốn gần như tức thời do không yêu cầu chi phí phần cứng và giảm đáng kể nỗ lực vận hành.

## 3. Kiến trúc giải pháp

Ứng dụng Web Chat được triển khai theo kiến trúc *container hóa trên AWS*, sử dụng Amazon ECS Fargate làm nền tảng chạy backend NestJS, trong khi frontend VueJS được lưu trữ trên Amazon Amplify. Kiến trúc này đảm bảo tính tách biệt giữa frontend – backend, dễ mở rộng, an toàn và giảm thiểu các tác vụ vận hành máy chủ.

### Luồng truy cập tổng quan

Người dùng truy cập ứng dụng thông qua tên miền được quản lý bởi *Amazon Route 53. Các request đến frontend sẽ được phân phối tới **Amazon Amplify Hosting, trong khi các request backend theo đường dẫn api.webchat.mom sẽ được chuyển đến **Application Load Balancer (ALB)*, nơi điều phối traffic đến các container Fargate trong từng subnet khác nhau để đảm bảo tính sẵn sàng cao.


![WebChat Realtime Architecture](/images/2-Proposal/webchat_architecture.jpg)

### *Thành phần chính trong kiến trúc*

- **Amazon Route 53**: Quản lý DNS, phân giải tên miền tùy chỉnh webchat.mom và api.webchat.mom. Route 53 điều hướng request frontend vào Amplify và request backend vào Application Load Balancer.

- **Amazon Amplify Hosting (Frontend)**: Deploy và phân phối ứng dụng VueJS. Amplify cũng tích hợp với Amazon Certificate Manager (ACM) để cung cấp HTTPS cho giao diện web. Ngoài ra, Amplify sử dụng Rewrite & Redirect rule để điều hướng người dùng vào đúng domain API khi truy cập frontend.

- **Amazon Certificate Manager (ACM)**: Cung cấp chứng chỉ SSL/TLS cho cả Amplify và Application Load Balancer nhằm bảo đảm toàn bộ giao tiếp giữa người dùng và hệ thống đều được mã hóa.

- **Application Load Balancer (ALB)**: Đóng vai trò điều phối traffic backend. ALB nhận request từ api.webchat.mom và định tuyến đến các ECS Fargate tasks nằm trong các **public subnet**, đảm bảo khả năng scale-out khi có số lượng request tăng cao.

- **Amazon ECS Fargate (Backend)**: Chạy các container NestJS backend mà không cần quản lý EC2. Các tasks nằm trong nhiều subnet khác nhau để tăng tính sẵn sàng. Ứng dụng backend giao tiếp trực tiếp với MongoDB và SMTP server thông qua Internet Gateway hoặc VPC routing.

- **Amazon ECR**: Lưu trữ Docker Image của backend NestJS. Mỗi lần CI/CD cập nhật backend, Fargate sẽ pull image trực tiếp từ ECR.

- **Amazon S3**: Dùng để lưu trữ tệp tĩnh như hình ảnh, file đính kèm hoặc nội dung được chia sẻ trong chat.

- **MongoDB Atlas / MongoDB Server**: Lưu trữ toàn bộ thông tin người dùng, tin nhắn và dữ liệu ứng dụng. Backend Fargate kết nối tới MongoDB thông qua Internet Gateway.

- **SMTP Server**: Được backend sử dụng để gửi email thông báo (nếu có).

- **Amazon CloudWatch (Shared Service)**: Thu thập log từ ECS Fargate và ALB, hỗ trợ việc giám sát, cảnh báo và theo dõi hiệu suất hệ thống.

- **Amazon IAM**: Quản lý quyền truy cập giữa các dịch vụ như Fargate → ECR, ALB → CloudWatch, Amplify → S3, và cấp quyền tối thiểu cần thiết theo mô hình Least Privilege.

### *Tổng quan hoạt động*
1. *User* truy cập webchat.mom → Route 53 → Amplify Web.
2. Giao diện frontend tải về từ Amplify.
3. Các request backend từ frontend được gửi đến domain api.webchat.mom.
4. Route 53 điều hướng request backend đến *ALB*.
5. ALB định tuyến đến các container NestJS chạy trên ECS Fargate.
6. Container Fargate kết nối với:
   * *MongoDB* để xử lý dữ liệu chat
   * *S3* để lưu file
   * *SMTP* để gửi mail
7. Tất cả log được đẩy vào *CloudWatch*.
8. Quyền truy cập được kiểm soát bởi *IAM* và toàn bộ traffic được mã hóa thông qua chứng chỉ từ *ACM*.

### *Lợi ích kiến trúc*

* Không cần quản lý máy chủ (Serverless Container – Fargate).
* Tự động mở rộng khi số lượng người dùng tăng.
* Tách biệt frontend – backend dễ phát triển độc lập.
* Hỗ trợ CI/CD qua Amplify và ECR → Fargate.
* Dễ giám sát, chuẩn mô hình Cloud Native thực tế trong doanh nghiệp.
* Bảo mật toàn diện từ DNS đến backend.

### 4. Triển khai kỹ thuật  
**Các giai đoạn triển khai**  
Dự án Web Chat gồm 2 phần chính — xây dựng backend , frontend cho web và triển khai lên Cloud AWS - trải qua 5 giai đoạn:  
1. **Xây dựng Prototype**: Tìm hiểu VueJS, NestJS và lên kế hoạch xây dựng Web chat chạy trên mạng LAN  (1 tháng trước kỳ thực tập).  
2. **Nghiên cứu và vẽ kiến trúc**: Tìm hiểu các dịch vụ AWS và vẽ kiến trúc phù hợp với dự án WebChat (Tháng 1).  
3. **Tính toán chi phí và kiểm tra tính khả thi**: Sử dụng AWS Pricing Calculator để ước tính chi phí cho ECS Fargate, Application Load Balancer (ALB), DynamoDB, Amplify, CloudFront và CloudWatch; đồng thời đánh giá mức sử dụng tài nguyên container để dự báo chi phí chính xác. (Tháng 2). 
4. **Điều chỉnh kiến trúc để tối ưu chi phí/giải pháp**: Tối ưu cấu hình ECS Service (CPU/memory), số task chạy tối thiểu/tự động scale; tinh chỉnh thiết kế WebSocket trên Fargate qua ALB; tối ưu DynamoDB (PK/SK, GSI) và thiết lập cache frontend với CloudFront để giảm tải lên backend. (Tháng 3).
5. **Phát triển, kiểm thử, triển khai**: Xây dựng backend (NestJS) chạy trong container ECS Fargate; phát triển frontend VueJS; triển khai toàn bộ hạ tầng (ECS Fargate, ALB, DynamoDB, Amplify + CloudFront, Route53, Cognito). Thực hiện kiểm thử hệ thống (functional, integration, load test) và đưa vào vận hành. (Tháng 3–4).

---

**_Yêu cầu kỹ thuật_**  
- **Backend**: Chạy ứng dụng NestJS trong container ECS Fargate, xử lý API và WebSocket thời gian thực thông qua Application Load Balancer (ALB). Dữ liệu chat và người dùng lưu trữ trên DynamoDB; log và giám sát bằng CloudWatch; tích hợp domain bằng Route53. 
- **Frontend**: Phát triển bằng VueJS; triển khai qua Amplify và phân phối qua CloudFront để tối ưu tốc độ tải và hiệu suất giao diện chat realtime.
- **Realtime & hiệu năng**: Kết nối WebSocket thông qua ALB tới backend chạy trên Fargate để đảm bảo độ trễ thấp và kết nối ổn định. CloudFront cache frontend nhằm giảm tải lên backend và tăng tốc độ phản hồi. 
- **Bảo mật & quản lý người dùng**: Sử dụng AWS Cognito để xác thực người dùng, quản lý phiên đăng nhập và phân quyền truy cập dữ liệu chat.

### 5. Lộ trình & Mốc triển khai  
- *Trước thực tập (Tháng 0)*: 1 tháng khảo sát yêu cầu, phân tích phạm vi, lựa chọn công nghệ (VueJS, NestJS, ECS Fargate, ALB, Amplify, DynamoDB, CloudFront, Route53, CloudWatch) và lập kế hoạch kiến trúc tổng thể.
- *Thực tập (Tháng 1–3)*:  
    - Tháng 1: Học và làm quen với AWS (EC2, ECS, DynamoDB, Amplify, CloudFront, Route53, CloudWatch). Thiết lập môi trường phát triển, tạo prototype backend NestJS và frontend VueJS. 
    - Tháng 2: Thiết kế và điều chỉnh kiến trúc hệ thống, xây dựng tính năng chính (chat realtime, lưu tin nhắn, giao diện cơ bản). Thiết lập hạ tầng: ECS service, ALB listener, DynamoDB tables, Amplify cho frontend, CloudFront CDN, Route53 cho domain.  
    - Tháng 3: Triển khai chính thức, kiểm thử , tối ưu hiệu năng, cấu hình giám sát CloudWatch và đưa vào sử dụng. 
- *Sau triển khai*:  Tiếp tục nghiên cứu và mở rộng tính năng trong vòng 1 năm (chatbot, phân tích dữ liệu, cải thiện UI/UX, tối ưu bảo mật và chi phí).  

### 6. Ước tính ngân sách  
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  

*Chi phí hạ tầng*  

- ECS Fargate: 9,50 USD/tháng (1 task 0.25 vCPU + 0.5GB RAM chạy 720 giờ)
- Application Load Balancer: 16,00 USD/tháng (listener + LCU + traffic thấp)
- DynamoDB: 0,50 USD/tháng (~50.000 Read/Write on-demand)
- Amplify: 0,20 USD/tháng
- CloudFront: 0,70 USD/tháng (Data Transfer Out ~8GB)
- CloudWatch: 0,10 USD/tháng (50MB log)
- Route53: 0,50 USD/tháng

*Tổng*: 27,50 USD/tháng, 330 USD/12 tháng


### 7. Đánh giá rủi ro

**Ma trận rủi ro**

- Mất mạng / sự cố internet: Ảnh hưởng trung bình, xác suất trung bình.
- Lỗi dữ liệu / DynamoDB: Ảnh hưởng cao, xác suất thấp.
- Vượt ngân sách AWS: Ảnh hưởng trung bình, xác suất thấp.
- Lỗi frontend / CloudFront: Ảnh hưởng thấp, xác suất trung bình.
- Lỗi backend / ECS Fargate hoặc ALB: Ảnh hưởng cao, xác suất thấp.

**Chiến lược giảm thiểu**

- Mất mạng / Internet: Dùng CloudFront để cache frontend; lưu tạm tin nhắn cục bộ (localStorage/IndexedDB).
- Lỗi dữ liệu / DynamoDB: Bật Point-In-Time Recovery, kiểm tra schema, theo dõi bằng CloudWatch Logs và Metrics.
- Vượt ngân sách AWS: Thiết lập CloudWatch billing alarm, giới hạn log retention, tối ưu task Fargate (CPU/RAM).
- Frontend / CloudFront lỗi: Dùng versioned deployment để rollback nhanh.
- Backend / ECS Fargate lỗi: Triển khai nhiều task khi cần, dùng health check của ALB để tự động thay thế task lỗi.

**Kế hoạch dự phòng**

- Sử dụng Infrastructure as Code (CloudFormation / Terraform) để tái tạo nhanh toàn bộ ECS Service, ALB, DynamoDB, Amplify, CloudFront.
- Khi AWS gặp sự cố kéo dài, có thể chạy **phiên bản local** (VueJS + NestJS) để duy trì trao đổi nội bộ.
- Theo dõi định kỳ CloudWatch Dashboard, ALB health checks và ECS task status để phát hiện sớm sự cố.

---

### 8. Kết quả kỳ vọng

**Cải tiến kỹ thuật**

- Ứng dụng chat realtime chạy ổn định trên kiến trúc container (ECS Fargate + ALB), thay thế việc trao đổi bằng email hoặc ghi chú thủ công.
- Lưu trữ tin nhắn và dữ liệu người dùng tập trung qua DynamoDB, dễ quản lý và truy xuất.
- Kiến trúc mô-đun với backend NestJS (chạy Fargate), frontend VueJS (Amplify + CloudFront) và hạ tầng AWS (ECS, ALB, DynamoDB, CloudFront, Amplify, Route53, CloudWatch) có thể mở rộng lên 50–100 người dùng.

**Giá trị dài hạn**

- Hệ thống có thể lưu trữ dữ liệu chat và log trong 1 năm để phục vụ nghiên cứu, đánh giá người dùng hoặc tích hợp AI/ML (chatbot, phân tích hành vi).
- Kiến trúc và codebase có thể tái sử dụng lại cho các dự án nội bộ, microservice khác hoặc làm nền tảng học DevOps/Cloud.
- Giúp nhóm thành thạo cách triển khai, tối ưu và giám sát hệ thống cloud-native chạy container trên AWS.

---
