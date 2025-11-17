---
title: "Worklog Tuần 2"
weight: 1
chapter: false
pre: " <b> 1.2. </b> "
---

### Mục tiêu Tuần 2:
- Ôn lại bài Lab 000001 và nâng cao hiểu biết về quản lý chi phí AWS.
- Nắm vững các khái niệm mạng VPC và xây dựng kiến trúc mạng an toàn.
- Thực hành kết nối EC2, kiểm tra bảo mật và phân tích khả năng kết nối.
- Làm quen với các phương thức truy cập an toàn vào EC2.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Ôn lại Lab 000001.<br>- Thực hành Lab 000007: Quản lý chi phí với AWS Budgets – tạo ngân sách theo template cho Cost, Usage, Savings Plans.<br>- Dọn dẹp (cleanup) toàn bộ tài nguyên đã tạo.<br>- (Nhận 20$ thưởng khi tạo Budget thành công) | 15/09/2025 | 15/09/2025 | https://000007.awsstudygroup.com/ | Kiểm soát chi phí & dọn dẹp |
| 3 | - Xem video Module 02 và ghi chép các khái niệm cốt lõi:<br> • VPC<br> • Subnet (Public & Private)<br> • Route Table<br> • Interface/Gateway Endpoints<br> • Internet Gateway / NAT Gateway | 16/09/2025 | 16/09/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 02) | Cơ bản về mạng |
| 4 | - Thực hành Lab 000003.3:<br> • Tạo VPC<br> • Tạo Public Subnet và Private Subnet<br> • Gắn Internet Gateway<br> • Cấu hình Route Table<br> • Tạo Security Groups | 17/09/2025 | 17/09/2025 | https://000003.awsstudygroup.com/vi/ | Thiết lập nền tảng mạng |
| 5 | - Tiếp tục Lab 000003 (phần còn lại):<br> • Khởi chạy EC2 trong Public và Private Subnet<br> • SSH từ Public EC2 → Private EC2<br> • Kiểm tra kết nối Internet từ cả hai instance<br> • Dùng Reachability Analyzer để kiểm tra đường đi giữa 2 EC2 | 18/09/2025 | 18/09/2025 | https://000003.awsstudygroup.com/ | Kết nối & kiểm tra mạng EC2 |
| 6 | - Thực hành và so sánh 3 cách kết nối EC2:<br> 1. Bastion Host (Jump Server)<br> 2. VPC Interface Endpoint + EC2 Instance Connect<br> 3. AWS Systems Manager – Session Manager<br>- Ghi chú ưu/nhược điểm và mức độ bảo mật | 19/09/2025 | 19/09/2025 | https://000003.awsstudygroup.com/ | Truy cập EC2 an toàn |


### Kết quả đạt được tuần 2:
- Ôn tập thành công Lab 000001 và áp dụng tốt các thực hành quản lý tài nguyên.
- Nắm vững AWS Budgets:
  - Tạo ngân sách Cost, Usage, Savings Plans theo template.
  - Thực hiện dọn dẹp tài nguyên triệt để để kiểm soát chi phí.
  - Nhận thưởng 20$ từ nhiệm vụ tạo Budget.
- Nắm chắc kiến thức mạng VPC AWS:
  - Phân biệt rõ Public vs Private Subnet, Route Table, Internet/NAT Gateway, Endpoint.
  - Xây dựng thành công kiến trúc VPC đa tầng hoạt động ổn định.
- Thực hành được EC2 trong môi trường cách ly:
  - Khởi chạy và cấu hình EC2 ở cả public và private subnet.
  - Kiểm chứng SSH nối tiếp và hành vi kết nối Internet.
  - Sử dụng Reachability Analyzer để chẩn đoán và xác nhận đường mạng.
- Tiếp thu các phương thức truy cập EC2 an toàn:
  - Triển khai và so sánh:
    - Bastion Host (SSH truyền thống qua jump server)
    - EC2 Instance Connect Endpoint (truy cập riêng tư)
    - Session Manager (không cần agent, kiểm soát bằng IAM, hỗ trợ audit)
  - Hiểu rõ ưu nhược về bảo mật, tiện lợi, khả năng kiểm tra.
- Hoàn thành Lab 000007 và Lab 000003 với đầy đủ yêu cầu.
