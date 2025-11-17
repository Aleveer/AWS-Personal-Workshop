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
*Vấn đề hiện tại*  
Nhóm đang phát triển một ứng dụng chat phục vụ mục đích học tập và nghiên cứu về cách xây dựng hệ thống web thời gian thực. Nếu triển khai theo mô hình truyền thống (tự dựng máy chủ, tự quản lý cơ sở dữ liệu và duy trì kết nối WebSocket), nhóm sẽ phải đối mặt với nhiều khó khăn như: thiết lập hạ tầng phức tạp, xử lý mở rộng khi có nhiều kết nối đồng thời, đảm bảo tính ổn định và bảo mật, cũng như theo dõi và ghi log đầy đủ cho hệ thống. Việc không tận dụng các dịch vụ AWS khiến nhóm khó mô phỏng các mô hình hạ tầng hiện đại, đồng thời tốn thời gian cho các tác vụ vận hành thay vì tập trung vào phần ứng dụng và các bài học kỹ thuật cốt lõi.

*Giải pháp*
Ứng dụng Web Chat được triển khai dựa trên các dịch vụ AWS nhằm mô phỏng kiến trúc ứng dụng hiện đại. Backend sử dụng NestJS được đóng gói và chạy trên Amazon ECS hoặc triển khai trực tiếp trên Amazon EC2 tùy theo nhu cầu thử nghiệm của nhóm. DynamoDB được sử dụng để lưu trữ tin nhắn và thông tin người dùng. Amazon S3 kết hợp với CloudFront phục vụ frontend viết bằng VueJS, giúp tối ưu tốc độ phân phối nội dung. Route 53 được dùng để quản lý tên miền và định tuyến truy cập đến frontend và backend. Toàn bộ hệ thống được giám sát bằng Amazon CloudWatch, bao gồm log, chỉ số hoạt động và cảnh báo. Kiến trúc này tạo điều kiện cho nhóm nghiên cứu cách vận hành, triển khai và mở rộng ứng dụng thực tế trên môi trường AWS. Kiến trúc này giúp nhóm dễ dàng thử nghiệm, mở rộng tính năng và hiểu cách vận hành ứng dụng trên môi trường đám mây.

*Lợi ích và hoàn vốn đầu tư (ROI)*
Giải pháp giúp nhóm thực hành xây dựng ứng dụng chat hoàn chỉnh từ frontend đến backend, kết hợp với các dịch vụ cloud thường dùng trong môi trường doanh nghiệp. Nhờ tận dụng Free Tier và các tài nguyên test, chi phí triển khai thấp nhưng vẫn đảm bảo đủ tính thực tiễn để nhóm hiểu rõ về quản lý hạ tầng, giám sát, mở rộng và bảo mật. Việc triển khai trên AWS giúp giảm thời gian cấu hình thủ công, đồng thời tạo nền tảng vững chắc cho các nghiên cứu nâng cao như chatbot, xử lý dữ liệu hoạt động người dùng hoặc tích hợp hệ thống AI. Thời gian hoàn vốn gần như tức thời do không yêu cầu chi phí phần cứng và giảm đáng kể nỗ lực vận hành.

 ### 3. Kiến trúc giải pháp  
Nền tảng áp dụng kiến trúc AWS Serverless để quản lý dữ liệu từ 5 trạm dựa trên Raspberry Pi, có thể mở rộng lên 15 trạm. Dữ liệu được tiếp nhận qua AWS IoT Core, lưu trữ trong S3 data lake và xử lý bởi AWS Glue Crawlers và ETL jobs để chuyển đổi và tải vào một S3 bucket khác cho mục đích phân tích. Lambda và API Gateway xử lý bổ sung, trong khi Amplify với Next.js cung cấp bảng điều khiển được bảo mật bởi Cognito.  

![IoT Weather Station Architecture](/images/2-Proposal/edge_architecture.jpeg)

![IoT Weather Platform Architecture](/images/2-Proposal/platform_architecture.jpeg)

*Dịch vụ AWS sử dụng*  
- *AWS IoT Core*: Tiếp nhận dữ liệu MQTT từ 5 trạm, mở rộng lên 15.  
- *AWS Lambda*: Xử lý dữ liệu và kích hoạt Glue jobs (2 hàm).  
- *Amazon API Gateway*: Giao tiếp với ứng dụng web.  
- *Amazon S3*: Lưu trữ dữ liệu thô (data lake) và dữ liệu đã xử lý (2 bucket).  
- *AWS Glue*: Crawlers lập chỉ mục dữ liệu, ETL jobs chuyển đổi và tải dữ liệu.  
- *AWS Amplify*: Lưu trữ giao diện web Next.js.  
- *Amazon Cognito*: Quản lý quyền truy cập cho người dùng phòng lab.  

*Thiết kế thành phần*  
- *Thiết bị biên*: Raspberry Pi thu thập và lọc dữ liệu cảm biến, gửi tới IoT Core.  
- *Tiếp nhận dữ liệu*: AWS IoT Core nhận tin nhắn MQTT từ thiết bị biên.  
- *Lưu trữ dữ liệu*: Dữ liệu thô lưu trong S3 data lake; dữ liệu đã xử lý lưu ở một S3 bucket khác.  
- *Xử lý dữ liệu*: AWS Glue Crawlers lập chỉ mục dữ liệu; ETL jobs chuyển đổi để phân tích.  
- *Giao diện web*: AWS Amplify lưu trữ ứng dụng Next.js cho bảng điều khiển và phân tích thời gian thực.  
- *Quản lý người dùng*: Amazon Cognito giới hạn 5 tài khoản hoạt động.  

### 4. Triển khai kỹ thuật  
**Các giai đoạn triển khai**  
Dự án Web Chat gồm 2 phần chính — xây dựng backend và frontend — mỗi phần trải qua 4 giai đoạn:  

1. **Nghiên cứu và vẽ kiến trúc**: Tìm hiểu VueJS, NestJS và các dịch vụ AWS (EC2/ECS, S3, DynamoDB, CloudFront, Route53, CloudWatch). Thiết kế kiến trúc tổng thể, luồng dữ liệu, cơ sở dữ liệu và kết nối realtime (1 tháng trước kỳ thực tập).  
2. **Tính toán chi phí và kiểm tra tính khả thi**: Sử dụng AWS Pricing Calculator để ước tính chi phí EC2/ECS, DynamoDB, S3, CloudFront, CloudWatch và điều chỉnh thiết kế cho phù hợp (Tháng 1).  
3. **Điều chỉnh kiến trúc để tối ưu chi phí/giải pháp**: Tinh chỉnh cấu hình ECS/EC2, tối ưu query DynamoDB, cache frontend bằng CloudFront, và lập trình NestJS/VueJS để giảm tải backend, đảm bảo hiệu quả chi phí và performance (Tháng 2).  
4. **Phát triển, kiểm thử, triển khai**: Lập trình backend NestJS, frontend VueJS; triển khai ECS/EC2, S3 + CloudFront, DynamoDB, Route53, CloudWatch; kiểm thử hệ thống (functional, load test) và đưa vào vận hành (Tháng 2–3).  

---

**_Yêu cầu kỹ thuật_**  
- **Backend**: NestJS với kết nối realtime (WebSocket hoặc REST), lưu trữ dữ liệu chat và người dùng trên DynamoDB, log và giám sát trên CloudWatch, triển khai container trên ECS hoặc EC2, tích hợp domain qua Route53.  
- **Frontend**: VueJS, phân phối qua S3 + CloudFront để tối ưu tốc độ, load assets và giao diện chat realtime.  
- **Hạ tầng & CI/CD**: Sử dụng Infrastructure as Code (CloudFormation / CDK) để triển khai ECS/EC2, S3, DynamoDB, CloudFront, Route53; Docker hóa backend để dễ triển khai và mở rộng.  
- **Realtime & hiệu năng**: WebSocket hoặc API Gateway (nếu dùng REST) để gửi nhận tin nhắn thời gian thực; cache frontend bằng CloudFront để giảm request trực tiếp lên backend.  
- **Bảo mật & quản lý người dùng**: Sử dụng JWT hoặc Cognito nếu cần để xác thực, phân quyền truy cập dữ liệu chat nội bộ.  

### 5. Lộ trình & Mốc triển khai  
- *Trước thực tập (Tháng 0)*: 1 tháng khảo sát yêu cầu dự án, chọn công nghệ (VueJS, NestJS, EC2, S3, DynamoDB, CloudFront, Route53, ECS, CloudWatch) và xây dựng kế hoạch tổng thể.
- *Thực tập (Tháng 1–3)*:  
    - Tháng 1: Học và làm quen với AWS (EC2, ECS, DynamoDB, S3, CloudFront, Route53, CloudWatch). Thiết lập môi trường phát triển, tạo prototype backend NestJS và frontend VueJS. 
    - Tháng 2: Thiết kế và điều chỉnh kiến trúc hệ thống, xây dựng tính năng chính (chat realtime, lưu tin nhắn, giao diện cơ bản). Thiết lập hạ tầng AWS: ECS/EC2 cho backend, S3 + CloudFront cho frontend, DynamoDB cho dữ liệu, Route53 cho domain.  
    - Tháng 3: Triển khai chính thức, kiểm thử (functional, load 20–30 user), tối ưu hiệu năng, cấu hình giám sát CloudWatch và đưa vào sử dụng. 
- *Sau triển khai*:  Tiếp tục nghiên cứu và mở rộng tính năng trong vòng 1 năm (chatbot, phân tích dữ liệu, cải thiện UI/UX, tối ưu bảo mật và chi phí).  

### 6. Ước tính ngân sách  (chưa tính)
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  
Hoặc tải [tệp ước tính ngân sách](../attachments/budget_estimation.pdf).  

*Chi phí hạ tầng*  (chưa tinh toan)
- EC2: 0,00 USD/tháng (chưa ước tính loại máy & số giờ chạy).
- ECS (Fargate hoặc EC2-backed): 0,00 USD/tháng (chưa ước tính vCPU/Memory).
- DynamoDB: 0,00 USD/tháng (~30.000 writes, 0.086 GB dữ liệu, On-Demand hoặc RCU/WCU chưa ước tính).
- S3 Standard: 0,00 USD/tháng (~2.15 GB lưu trữ, 3.750 request/tháng).
- CloudFront: 0,00 USD/tháng (phân phối static frontend + giảm tải S3).
- CloudWatch: 0,00 USD/tháng (~56 MB log/tháng).
- Route53: 0,00 USD/tháng (1 hosted zone + DNS queries).
- Truyền dữ liệu: 0,00 USD/tháng (~0.387 GB outbound/tháng).

*Tổng*: 0,7 USD/tháng, 8,40 USD/12 tháng  
- *Phần cứng*: 265 USD một lần (Raspberry Pi 5 và cảm biến).  

### 7. Đánh giá rủi ro  
### 7. Đánh giá rủi ro

**Ma trận rủi ro**  
- Mất mạng / sự cố internet: Ảnh hưởng trung bình, xác suất trung bình.  
- Backend EC2/ECS downtime: Ảnh hưởng cao, xác suất thấp.  
- Lỗi dữ liệu / DynamoDB: Ảnh hưởng cao, xác suất thấp.  
- Vượt ngân sách AWS: Ảnh hưởng trung bình, xác suất thấp.  
- Lỗi frontend / CloudFront: Ảnh hưởng thấp, xác suất trung bình.  

**Chiến lược giảm thiểu**  
- Mất mạng / Internet: Dùng cache frontend (CloudFront) và retry logic trong NestJS; lưu tạm tin nhắn cục bộ nếu offline (localStorage hoặc IndexedDB).  
- Backend downtime: Triển khai ECS với autoscaling và health check; sử dụng multi-AZ EC2 nếu cần.  
- Lỗi dữ liệu / DynamoDB: Kích hoạt backup tự động, kiểm tra schema; log và giám sát bằng CloudWatch.  
- Vượt ngân sách AWS: Đặt CloudWatch billing alarm, kiểm soát retention logs, tối ưu instance/Service.  
- Frontend / CloudFront lỗi: Dùng versioned deployment để rollback nhanh nếu cần.  

**Kế hoạch dự phòng**  
- Dùng Infrastructure as Code (CloudFormation / Terraform) để nhanh chóng tái tạo hạ tầng AWS.  
- Nếu hệ thống AWS gặp sự cố kéo dài, có thể chạy **phiên bản local dev server (VueJS + NestJS trên máy cá nhân hoặc lab)** để tiếp tục chat nội bộ.  
- Định kỳ kiểm tra log CloudWatch và health metrics để phát hiện sớm sự cố.


### 8. Kết quả kỳ vọng  
### 8. Kết quả kỳ vọng

**Cải tiến kỹ thuật**  
- Ứng dụng chat thời gian thực, thay thế việc trao đổi thủ công qua email hoặc ghi chú.  
- Lưu trữ tin nhắn và file đính kèm tập trung, dễ truy xuất và quản lý.  
- Kiến trúc mô-đun với backend NestJS, frontend VueJS và hạ tầng AWS (EC2/ECS, S3, DynamoDB, CloudFront, Route53, CloudWatch) có thể mở rộng để phục vụ từ 50 đến 100 người dùng trong tương lai.  

**Giá trị dài hạn**  
- Nền tảng có thể lưu trữ dữ liệu chat và log sử dụng trong 1 năm cho nghiên cứu, đánh giá trải nghiệm người dùng hoặc thử nghiệm các tính năng AI/ML như chatbot, phân tích hành vi người dùng.  
- Kiến trúc và codebase có thể tái sử dụng cho các dự án nhóm hoặc các ứng dụng nội bộ khác trong phòng lab.  
- Giúp nhóm thành thạo cách triển khai, quản lý và giám sát hệ thống cloud-native trên AWS.
