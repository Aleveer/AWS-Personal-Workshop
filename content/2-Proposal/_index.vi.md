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

 ### 3. Kiến trúc giải pháp  
Ứng dụng Web Chat được triển khai dựa trên kiến trúc AWS Serverless, đảm bảo khả năng mở rộng và hiệu suất cao. Backend Realtime được xây dựng xung quanh Amazon API Gateway (WebSocket API) và các AWS Lambda Functions để xử lý logic chat theo sự kiện. Amazon DynamoDB được sử dụng để lưu trữ tin nhắn và thông tin kết nối, cung cấp độ trễ thấp cần thiết cho ứng dụng realtime. Frontend viết bằng VueJS, được lưu trữ trên Amazon Amplify và phân phối qua CloudFront để tối ưu tốc độ và bảo mật kết nối WebSocket (WSS). Route 53 quản lý tên miền và định tuyến truy cập, sử dụng ACM (Certificate Manager) để cấp chứng chỉ. Amazon Cognito quản lý xác thực và danh tính người dùng. Toàn bộ hệ thống được giám sát bằng Amazon CloudWatch và được bảo vệ bởi các chính sách IAM. Kiến trúc này tạo điều kiện thuận lợi cho nhóm nghiên cứu các quy trình vận hành, triển khai liên tục và mở rộng ứng dụng chat realtime trên môi trường đám mây. 

![WebChat Realtime Serverless Architecture](/images/2-Proposal/webchat_architecture.png)

*Dịch vụ AWS sử dụng*
- *Amazon Amplify*: Lưu trữ giao diện web tĩnh được xây dựng bằng Vue.js.  
- *AWS Lambda*: 1 Lambda Authorizer để kiểm tra token Cognito và 3 Lambda Functions để xử lý nghiệp vụ cho các route WebSocket.
- *Amazon API Gateway*: Tiếp nhận và duy trì kết nối WebSocket, định tuyến các sự kiện .   
- *Amazon Route 53*: Quản lý DNS và định tuyến tên miền tùy chỉnh.  
- *Amazon CloudFront*: Phân phối Frontend Vue.js (CDN) và chuyển tiếp kết nối WebSocket (WSS).  
- *AWS Cognito*: quản lý xác thực và ủy quyền cho người dùng truy cập.  
- *Amazon DynamoDB*: Lưu trữ trạng thái kết nối và lịch sử tin nhắn.
- *Amazon Certificate Manager (ACM)*: Cung cấp chứng chỉ SSL/TLS cho CloudFront và API Gateway.
- *Amazon IAM*: Quản lý quyền truy cập và ủy quyền cho các dịch vụ.
- *Amazon CloudWatch*: Cung cấp dịch vụ giám sát và ghi log cho toàn bộ kiến trúc (Shared Service).

*Thiết kế thành phần*
- *Giao diện web*: Ứng dụng Vue.js được phân phối qua CloudFront, sử dụng WSS để giao tiếp realtime.
- *Quản lý người dùng*: Cognito và Lambda Authorizer quản lý việc đăng nhập, đăng ký và xác thực token trước khi thiết lập kết nối.
- *Tiếp nhận dữ liệu*: API Gateway (WebSocket) tiếp nhận các sự kiện $connect/$message/$disconnect và kích hoạt các hàm xử lý.
- *Xử lý Logic*: Lambda Functions thực thi logic chat
- *Lưu trữ dữ liệu*: DynamoDB cung cấp kho lưu trữ dữ liệu chính có khả năng mở rộng cao và độ trễ thấp cho ứng dụng realtime.
- *Bảo mật mạng*: ACM, Route 53, CloudFront đảm bảo toàn bộ luồng dữ liệu sử dụng tên miền tùy chỉnh và được mã hóa (WSS).

### 4. Triển khai kỹ thuật  
**Các giai đoạn triển khai**  
Dự án Web Chat gồm 2 phần chính — xây dựng backend , frontend cho web và triển khai lên Cloud AWS - trải qua 5 giai đoạn:  
1. **Xây dựng Prototype**: Tìm hiểu VueJS, NestJS và lên kế hoạch xây dựng Web chat chạy trên mạng LAN  (1 tháng trước kỳ thực tập).  
2. **Nghiên cứu và vẽ kiến trúc**: Tìm hiểu các dịch vụ AWS và vẽ kiến trúc phù hợp với dự án WebChat (Tháng 1).  
3. **Tính toán chi phí và kiểm tra tính khả thi**: Sử dụng AWS Pricing Calculator để ước tính chi phí Lambda, API Gateway, DynamoDB, Amplify, CloudFront, CloudWatch và điều chỉnh thiết kế cho phù hợp (Tháng 2).  
4. **Điều chỉnh kiến trúc để tối ưu chi phí/giải pháp**: Tinh chỉnh cấu hình API Gateway WebSocket, tối ưu hóa các hàm Lambda (memory/concurrency) và Schema DynamoDB. Cache frontend bằng CloudFront để đảm bảo hiệu suất và giảm tải backend. (Tháng 3).
5. **Phát triển, kiểm thử, triển khai**: Lập trình các Lambda Functions, frontend VueJS; triển khai toàn bộ hạ tầng (API Gateway, Lambda, DynamoDB, Amplify + CloudFront, Route53, Cognito) ; kiểm thử hệ thống (functional, load test) và đưa vào vận hành. (Tháng 3–4).

---

**_Yêu cầu kỹ thuật_**  
- **Backend**: API Gateway với Lambda Function kết nối realtime , lưu trữ dữ liệu chat và người dùng trên DynamoDB, log và giám sát trên CloudWatch, tích hợp domain qua Route53.  
- **Frontend**: VueJS, phân phối qua Amplify + CloudFront để tối ưu tốc độ, load assets và giao diện chat realtime.  
- **Realtime & hiệu năng**: API Gateway Websocket để gửi nhận tin nhắn thời gian thực; cache frontend bằng CloudFront để giảm request trực tiếp lên backend.  
- **Bảo mật & quản lý người dùng**: Sử dụng Cognito để xác thực, phân quyền truy cập dữ liệu chat nội bộ.  

### 5. Lộ trình & Mốc triển khai  
- *Trước thực tập (Tháng 0)*: 1 tháng khảo sát yêu cầu dự án, chọn công nghệ (VueJS, NestJS, EC2, Amplify, DynamoDB, CloudFront, Route53, ECS, CloudWatch) và xây dựng kế hoạch tổng thể.
- *Thực tập (Tháng 1–3)*:  
    - Tháng 1: Học và làm quen với AWS (EC2, ECS, DynamoDB, Amplify, CloudFront, Route53, CloudWatch). Thiết lập môi trường phát triển, tạo prototype backend NestJS và frontend VueJS. 
    - Tháng 2: Thiết kế và điều chỉnh kiến trúc hệ thống, xây dựng tính năng chính (chat realtime, lưu tin nhắn, giao diện cơ bản). Thiết lập hạ tầng AWS: Lambda + API Gateway cho backend, Amplify + CloudFront cho frontend, DynamoDB cho dữ liệu, Route53 cho domain.  
    - Tháng 3: Triển khai chính thức, kiểm thử (functional, load 20–30 user), tối ưu hiệu năng, cấu hình giám sát CloudWatch và đưa vào sử dụng. 
- *Sau triển khai*:  Tiếp tục nghiên cứu và mở rộng tính năng trong vòng 1 năm (chatbot, phân tích dữ liệu, cải thiện UI/UX, tối ưu bảo mật và chi phí).  

### 6. Ước tính ngân sách  
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  

*Chi phí hạ tầng*  
- AWS Lambda: 0,01 USD/tháng ( ~50.000 Invocations)
- Amazon API Gateway: 3,80 USD/tháng  ( giả định 30 user sử dụng 150000 phút và gửi 50000 tin nhắn)
- DynamoDB: 0,05 USD/tháng (~ 50.000 Writes)
- Amplify : 0,20 USD/tháng 
- CloudFront: 0,68 USD/tháng (Data Transfer Out 8GB)
- CloudWatch: 0,05 USD/tháng (50MB log)
- Route53: $0.50 USD/tháng 

*Tổng*: 5,29 USD/tháng, 63,48 USD/12 tháng  


### 7. Đánh giá rủi ro

**Ma trận rủi ro**  
- Mất mạng / sự cố internet: Ảnh hưởng trung bình, xác suất trung bình.  
- Lỗi dữ liệu / DynamoDB: Ảnh hưởng cao, xác suất thấp.  
- Vượt ngân sách AWS: Ảnh hưởng trung bình, xác suất thấp.  
- Lỗi frontend / CloudFront: Ảnh hưởng thấp, xác suất trung bình.  

**Chiến lược giảm thiểu**  
- Mất mạng / Internet: Dùng cache frontend (CloudFront) ; lưu tạm tin nhắn cục bộ nếu offline (localStorage hoặc IndexedDB).  
- Lỗi dữ liệu / DynamoDB: Kích hoạt backup tự động, kiểm tra schema; log và giám sát bằng CloudWatch.  
- Vượt ngân sách AWS: Đặt CloudWatch billing alarm, kiểm soát retention logs, tối ưu instance/Service.  
- Frontend / CloudFront lỗi: Dùng versioned deployment để rollback nhanh nếu cần.  

**Kế hoạch dự phòng**  
- Dùng Infrastructure as Code (CloudFormation / Terraform) để nhanh chóng tái tạo hạ tầng AWS.  
- Nếu hệ thống AWS gặp sự cố kéo dài, có thể chạy **phiên bản local dev server (VueJS + NestJS trên máy cá nhân hoặc lab)** để tiếp tục chat nội bộ.  
- Định kỳ kiểm tra log CloudWatch và health metrics để phát hiện sớm sự cố.

### 8. Kết quả kỳ vọng

**Cải tiến kỹ thuật**  
- Ứng dụng chat thời gian thực, thay thế việc trao đổi thủ công qua email hoặc ghi chú.  
- Lưu trữ tin nhắn và file đính kèm tập trung, dễ truy xuất và quản lý.  
- Kiến trúc mô-đun với backend , frontend VueJS và hạ tầng AWS (Lambda ,API Gateway,Amplify, DynamoDB, CloudFront, Route53, CloudWatch) có thể mở rộng để phục vụ từ 50 đến 100 người dùng trong tương lai.  

**Giá trị dài hạn**  
- Nền tảng có thể lưu trữ dữ liệu chat và log sử dụng trong 1 năm cho nghiên cứu, đánh giá trải nghiệm người dùng hoặc thử nghiệm các tính năng AI/ML như chatbot, phân tích hành vi người dùng.  
- Kiến trúc và codebase có thể tái sử dụng cho các dự án nhóm hoặc các ứng dụng nội bộ khác trong phòng lab.  
- Giúp nhóm thành thạo cách triển khai, quản lý và giám sát hệ thống cloud-native trên AWS.
