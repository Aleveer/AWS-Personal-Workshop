---
title: "Worklog Tuần 11"
weight: 2
chapter: false
pre: " <b> 1.11. </b> "
---

### Mục tiêu Tuần 11:
- Xây dựng workshop và hoàn thiện proposal trên Hugo.
- Triển khai dự án lên AWS Cloud: mạng, database, backend, frontend.
- Giám sát hệ thống bằng CloudWatch, kiểm tra live, theo dõi chi phí.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Xây dựng workshop.<br>- Hoàn thiện proposal trên Hugo: viết nội dung, thêm sơ đồ, deploy site. | 17/11/2025 | 17/11/2025 | Hugo Docs<br>Reveal.js / Markdown Slides ||
| 3 | - Cấu hình mạng AWS: tạo VPC, public subnet, Internet Gateway, Route Table.<br>- Thiết lập Security Group cho backend/frontend. | 18/11/2025 | 18/11/2025 | AWS VPC Console<br>Lab 000003 Guide ||
| 4 | - Triển khai MongoDB trên Atlas Free Tier: tạo cluster, user, connection string.<br>- Kết nối backend Nest.js với Atlas MongoDB. | 19/11/2025 | 19/11/2025 | MongoDB Atlas Docs<br>Mongoose Config ||
| 5 | - Đưa backend lên EC2: build Docker image, push ECR, chạy container trên EC2.<br>- Đưa frontend lên S3 + CloudFront: build Vue.js, upload S3, tạo distribution. | 20/11/2025 | 20/11/2025 | AWS EC2/ECR Console<br>S3/CloudFront Guide ||
| 6 | - Thiết lập CloudWatch: log groups, dashboard (CPU, memory, connections), alarms (high latency).<br>- Kiểm tra live: test chat real-time với 5+ users, fix issues.<br>- Theo dõi chi phí AWS (Cost Explorer), dọn dẹp nếu cần. | 21/11/2025 | 21/11/2025 | CloudWatch Console<br>AWS Cost Explorer ||

### Kết quả đạt được tuần 11:
- Hoàn thiện proposal với sơ đồ hệ thống.
- Triển khai thành công lên AWS:
  - Mạng VPC ổn định, public subnet cho frontend/backend.
  - MongoDB Atlas kết nối mượt.
  - Backend chạy trên EC2 Docker, frontend truy cập qua CloudFront.
- Giám sát hệ thống:
  - CloudWatch dashboard theo dõi real-time metrics/logs.
  - Alarms gửi alert cho high load, low health.
- Kiểm tra live toàn diện:
  - Chat hoạt động không lỗi với multiple users, real-time sync.
  - Latency < 200ms, no dropped messages.