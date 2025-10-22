---
title: "Các bài blogs đã dịch"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

### [Blog 1 - Bộ nhớ đệm ngoại tuyến với AWS Amplify, TanStack, AppSync và MongoDB Atlas](3.1-Blog1/)

Bài viết trình bày cách xây dựng ứng dụng offline-first với giao diện người dùng lạc quan (optimistic UI) sử dụng AWS Amplify, AWS AppSync, TanStack Query và MongoDB Atlas. Ứng dụng mẫu to-do minh họa cách hiển thị tức thì kết quả CRUD trên giao diện trước khi hoàn tất yêu cầu tới server, cải thiện trải nghiệm người dùng. TanStack Query quản lý bộ nhớ đệm cục bộ, đảm bảo dữ liệu khả dụng khi offline, trong khi AWS Amplify và AppSync cung cấp framework full-stack và API GraphQL. MongoDB Atlas đảm nhận lưu trữ dữ liệu, kết hợp với AWS Lambda và Cognito cho tính năng serverless và quản lý người dùng. Ứng dụng triển khai dễ dàng qua Amplify Gen 2, hỗ trợ đồng bộ hóa dữ liệu và xử lý xung đột đơn giản theo cơ chế "first-come, first-served", phù hợp với các ứng dụng có ít xung đột cập nhật.

### [Blog 2 - Giới thiệu chuỗi họp cộng đồng AWS CDK](3.2-Blog2/)

AWS công bố chuỗi họp cộng đồng mới cho AWS Cloud Development Kit (CDK), nhằm tạo cơ hội cho các nhà phát triển, từ người mới đến chuyên gia, học hỏi, đặt câu hỏi và chia sẻ phản hồi trực tiếp với đội ngũ CDK. Các buổi họp diễn ra hai lần mỗi quý, được tổ chức trực tuyến để đảm bảo tính bao quát và dễ tiếp cận, với nội dung bao gồm cập nhật lộ trình, demo tính năng, đánh giá đề xuất, và Q&A mở. Buổi họp đầu tiên dự kiến vào ngày 24/6/2025, với hai khung giờ (8h-9h và 17h-18h PDT) để hỗ trợ cộng đồng toàn cầu. Thông tin chi tiết, tài liệu và bản ghi sẽ được đăng trên GitHub và YouTube. Cộng đồng có thể tham gia qua Slack, đề xuất chủ đề trên GitHub, và đóng góp ý kiến qua khảo sát để định hình tương lai của CDK.

### [Blog 3 - Bảo mật API ứng dụng Express trong 5 phút với Cedar](3.3-Blog3/)

Bài viết giới thiệu gói `authorization-for-expressjs` của dự án mã nguồn mở Cedar, cho phép tích hợp kiểm tra phân quyền dựa trên chính sách vào ứng dụng Express trên Node.js chỉ trong vài phút, giảm 90% mã so với cách tích hợp thủ công. Sử dụng mẫu ứng dụng PetStore, Cedar tách biệt logic phân quyền khỏi mã ứng dụng, cho phép định nghĩa chính sách chi tiết thông qua ngôn ngữ Cedar, ví dụ: chỉ nhân viên được phép thực hiện các thao tác ghi (POST /pets, POST /pets/{petId}/sale), trong khi khách hàng chỉ được đọc (GET /pets, GET /pets/{petId}). Gói này tự động tạo lược đồ Cedar từ đặc tả OpenAPI, sinh chính sách mẫu và tích hợp middleware để kiểm tra phân quyền mà không cần gọi dịch vụ từ xa. Ứng dụng được bảo mật thông qua JWT và OIDC, với khả năng kiểm tra chính sách dễ dàng bằng lệnh `curl`, nâng cao hiệu suất phát triển và đơn giản hóa kiểm tra quyền truy cập.

### [Blog 4 -](3.4-Blog4/)

### [Blog 5 - ...](3.5-Blog5/)

### [Blog 6 - ...](3.6-Blog6/)

### [Blog 7 - ...](3.7-Blog7/)

### [Blog 8 - ...](3.8-Blog8/)

### [Blog 9 - ...](3.9-Blog9/)

### [Blog 10 - ...](3.10-Blog10/)

### [Blog 11 - ...](3.11-Blog11/)

### [Blog 12 - ...](3.12-Blog12/)
