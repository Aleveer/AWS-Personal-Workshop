---
title: "Worklog Tuần 7"
weight: 1
chapter: false
pre: " <b> 1.7. </b> "
---

### Mục tiêu Tuần 7:
- Hoàn thiện kiến thức mạng AWS qua workshop thực hành.
- Triển khai CloudFront + Lambda@Edge để tối ưu phân phối nội dung.
- Triển khai WordPress trên hạ tầng AWS Cloud.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Hoàn thành Lab 000092: Workshop về mạng AWS.<br> | 20/10/2025 | 20/10/2025 | https://000092.awsstudygroup.com/ |  |
| 3 | - Thực hành Lab 000094: Tạo CloudFront distribution cho S3 static website.<br> | 21/10/2025 | 21/10/2025 | https://000094.awsstudygroup.com/ | CDN cơ bản |
| 4 | - Thực hành Lab 000130: Áp dụng Lambda@Edge.<br>- Tạo Lambda function (Viewer Request/Response, Origin Request).<br> | 22/10/2025 | 22/10/2025 | https://000130.awsstudygroup.com/vi/ | Edge computing |
| 5 | - Thực hành Lab 000101: Triển khai WordPress trên AWS.<br>- Tạo EC2 (Linux), cài MySQL, cấu hình Apache/Nginx, upload WordPress.<br> | 23/10/2025 | 23/10/2025 | https://000130.awsstudygroup.com/vi/ | CMS trên Cloud |
| 6 | - Ôn lại toàn bộ Lab tuần 7.<br>- Dọn dẹp tài nguyên: xóa CloudFront distribution, Lambda@Edge, EC2 WordPress, RDS, S3 bucket. | 24/10/2025 | 24/10/2025 |  |  |

### Kết quả đạt được tuần 7:
- Hoàn thành workshop mạng (Lab 000092):
  - Xây dựng kiến trúc VPC đa tầng, phân biệt public/private subnet.
  - Cấu hình route table, gateway, security group chính xác.
- Triển khai CloudFront thành công (Lab 000094):
  - Phân phối nội dung tĩnh từ S3 qua CDN toàn cầu.
  - Tối ưu tốc độ tải, giảm latency.
- Áp dụng Lambda@Edge (Lab 000130):
  - Tùy chỉnh request/response tại edge location.
- Triển khai WordPress trên AWS (Lab 000101):
  - Cài đặt và chạy WordPress ổn định trên EC2.
  - Kết nối database (RDS hoặc local MySQL), cấu hình domain.
- Hoàn thành Lab 000092, 000094, 000130, 000101.