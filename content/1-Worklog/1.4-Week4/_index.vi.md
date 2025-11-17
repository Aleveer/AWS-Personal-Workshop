---
title: "Worklog Tuần 4"
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---

### Mục tiêu Tuần 4:
- Nắm cơ chế Auto Scaling với EC2: Launch Template, Auto Scaling Group, Load Balancer.
- Hiểu cách quản lý truy cập S3 bằng IAM User + Access Key.
- Tìm hiểu, khám phá về Amazon S3 như một nền tảng lưu trữ và triển khai website tĩnh.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Thực hành lại Lab 000004 để ôn kiến thức EC2.<br>- Tiếp tục Lab 000006: Tạo Launch Template, Auto Scaling Group, cấu hình Load Balancer để đảm bảo khả năng mở rộng linh hoạt. | 29/09/2025 | 29/09/2025 | https://000006.awsstudygroup.com/ | Auto Scaling & High Availability |
| 3 | - Thực hành Lab 000048: Tạo IAM User với Access Key / Secret Access Key.<br>- Upload file lên S3 bucket bằng AWS CLI hoặc SDK.<br>- Dọn dẹp tài nguyên (xóa user, bucket). | 30/09/2025 | 30/09/2025 | https://000048.awsstudygroup.com/ | Quản lý truy cập S3 |
| 4 | - Xem YouTube Module 04 về Amazon S3 (các khái niệm: bucket, object, versioning, lifecycle, static website). | 01/10/2025 | 01/10/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 04) | Kiến thức nền S3 |
| 5 | - Thực hành Lab 000057:<br> • Chuẩn bị file website (HTML, CSS, JS).<br> • Tạo S3 bucket, bật Static Website Hosting.<br> • Cấu hình bucket policy cho phép public read.<br> • Upload file và truy cập qua URL S3. | 02/10/2025 | 02/10/2025 | https://000057.awsstudygroup.com/ | Triển khai website tĩnh |
| 6 | - Ôn lại toàn bộ các Lab tuần 4 và dọn dẹp tất cả tài nguyên để tránh phí. | 03/10/2025 | 03/10/2025 |  | Kiểm soát chi phí |
### Kết quả đạt được tuần 4:
- Thành công thiết lập EC2 Auto Scaling:
  - Tạo và cấu hình Launch Template.
  - Thiết lập Auto Scaling Group với min/max/desired capacity.
  - Kết hợp Elastic Load Balancer (ALB/NLB) để phân tải tự động.
- Thành công thiết lập truy cập S3 bằng IAM:
  - Tạo IAM User với Access Key / Secret Key.
  - Upload file thành công qua CLI/SDK.
  - Dọn dẹp sạch user và bucket.
- Triển khai website tĩnh trên S3:
  - Hiểu rõ S3 bucket, static website hosting, bucket policy.
  - Hoàn thành Lab 000057 – website truy cập được qua URL public.