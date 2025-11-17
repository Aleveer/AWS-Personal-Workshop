---
title: "Worklog Tuần 9"
weight: 1
chapter: false
pre: " <b> 1.9. </b> "
---

### Mục tiêu Tuần 9:
- Thiết lập môi trường phát triển local hoàn chỉnh.
- Xây dựng cấu trúc dự án monorepo với Vue.js (frontend) và Nest.js (backend).
- Phát triển giao diện chat cơ bản và kết nối real-time.
- Xây dựng backend WebSocket, quản lý tin nhắn và người dùng.
- Thiết kế schema MongoDB và Docker hóa toàn bộ ứng dụng.
- Chạy thử nghiệm local với Docker Compose, đảm bảo real-time chat hoạt động.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Setup môi trường phát triển local: Node.js, MongoDB, Docker, VS Code.<br>- Khởi tạo monorepo với 2 apps: frontend (Vue.js), backend (Nest.js). | 03/11/2025 | 03/11/2025 | - https://doc.vueframework.com/ <br> - https://docs.nestjs.com/ |  |
| 3 | - Phát triển frontend Vue.js: giao diện chat cơ bản (login, room list, chat box).<br>- Tích hợp Socket.IO client để nhận/gửi tin nhắn real-time. | 04/11/2025 | 04/11/2025 | https://socket.io/docs/v4  |  |
| 4 | - Phát triển backend Nest.js: WebSocket gateway, message service, user controller,... <br>- Xử lý kết nối người dùng, broadcast tin nhắn theo room. | 05/11/2025 | 05/11/2025 | |  |
| 5 | - Thiết kế schema MongoDB: collections users, rooms, messages, .. <br>- Kết nối Mongoose trong Nest.js, thực hiện CRUD tin nhắn. | 06/11/2025 | 06/11/2025 | | Database modeling |
| 6 | - Docker hóa ứng dụng: Dockerfile cho frontend, backend, mongo.<br>- Viết docker-compose.yml để chạy toàn bộ stack local.<br>- Test real-time chat giữa nhiều tab/user. | 07/11/2025 | 07/11/2025 | | Containerization & local run |

### Kết quả đạt được tuần 9:
- Hoàn thiện môi trường phát triển local:
  - Monorepo chạy mượt với frontend Vue.js và backend Nest.js.
  - IDE, Git, Docker sẵn sàng.
- Giao diện chat cơ bản hoạt động:
  - Login, chọn phòng, gửi/nhận tin nhắn real-time.
  - UI responsive, state management với Pinia.
- Backend Nest.js xử lý WebSocket ổn định:
  - Quản lý kết nối người dùng, phòng chat.
  - Broadcast tin nhắn chính xác, không mất dữ liệu.
- MongoDB schema hợp lý:
  - Lưu trữ user, room, message với index tối ưu.
  - CRUD tin nhắn qua API và WebSocket.
- Docker hóa thành công:
  - 3 container: vue-frontend, nest-backend, mongo-db.
  - docker-compose up chạy toàn bộ hệ thống local.
- Real-time chat hoạt động giữa nhiều người dùng:
  - Test với 3-5 tab/browser, tin nhắn đồng bộ tức thì.
