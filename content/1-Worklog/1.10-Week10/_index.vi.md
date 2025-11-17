---
title: "Worklog Tuần 10"
weight: 2
chapter: false
pre: " <b> 1.10. </b> "
---

### Mục tiêu Tuần 10:
- Kiểm thử, hoàn thiện UI và chuẩn bị deploy.
- Bổ sung tính năng backend, kiểm thử toàn diện API & real-time.
- Hoàn thiện frontend UI, xử lý lỗi kết nối và trạng thái.
- Thiết kế kiến trúc AWS.
- Chuẩn bị tài liệu API và sơ đồ hệ thống.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Kiểm thử backend: API (REST), WebSocket (real-time).<br>| 10/11/2025 | 10/11/2025 | Postman<br>NestJS Docs | |
| 3 | - Hoàn thiện frontend UI. <br>- Xử lý lỗi. | 11/11/2025 | 11/11/2025 | Vue.js, Tailwind/Bootstrap<br>Socket.IO Reconnect | |
| 4 | - Thiết kế kiến trúc AWS:<br> • Frontend: S3 + CloudFront<br> • Backend: EC2/ECS<br> • Database: MongoDB Atlas/DynamoDB<br> • Real-time: WebSocket | 12/11/2025 | 12/11/2025 | AWS Architecture Icons<br>Draw.io / Lucidchart | |
| 5 | - Chuẩn bị tài liệu:<br> • API docs (Swagger)<br> • Deployment guide | 13/11/2025 | 13/11/2025 | Swagger UI<br>C4-PlantUML | |
| 6 | - Team review: duyệt tài liệu, sơ đồ, demo local.<br>- Sửa lỗi, tối ưu hệ thống.<br>- Chuẩn bị deploy script (Docker + AWS CLI). | 14/11/2025 | 14/11/2025 | GitHub PR Review<br>Docker Compose | |

### Kết quả đạt được tuần 10:
- Backend ổn định và đầy đủ tính năng:
  - API REST hoạt động 100%, WebSocket không mất kết nối.
  - Typing, online status, message seen hoạt động real-time.
- Frontend hoàn thiện:
  - UI đẹp, hỗ trợ emoji, responsive.
- Kiến trúc AWS rõ ràng:
  - Sơ đồ hệ thống chi tiết.
  - Lựa chọn dịch vụ tối ưu chi phí & hiệu năng.
- Tài liệu đầy đủ:
  - API docs tự động từ Swagger.
  - Hướng dẫn deploy từng bước.
- Toàn bộ code đã review, test local đa user thành công.
- Sẵn sàng deploy lên AWS.