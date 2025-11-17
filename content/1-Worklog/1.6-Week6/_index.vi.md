---
title: "Worklog Tuần 6"
weight: 1
chapter: false
pre: " <b> 1.6. </b> "
---

### Mục tiêu Tuần 6:
- Nắm kiến thức về DNS với Amazon Route 53: hosted zone, record, routing policy.
- Thành thạo AWS CLI: cài đặt, cấu hình, thực hành lệnh cơ bản.
- Quản lý DynamoDB qua CLI: tạo bảng, thao tác CRUD.
- Triển khai và sử dụng ElastiCache Redis: khởi tạo cluster, lệnh SET/GET.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Thực hành Lab 000010: Tạo public hosted zone trên Route 53.<br>- Thêm các bản ghi (A, CNAME, MX).<br>- Cấu hình routing policy (Simple, Weighted, Latency). | 13/10/2025 | 13/10/2025 | https://000010.awsstudygroup.com/ | DNS quản lý |
| 3 | - Thực hành Lab 000011: Cài đặt AWS CLI.<br>- Cấu hình profile (Access Key, Secret Key, Region).<br>- Thực hành lệnh cơ bản: aws ec2 describe-instances, aws s3 ls, aws iam list-users, aws rds describe-db-instances. | 14/10/2025 | 14/10/2025 | https://000011.awsstudygroup.com/ | Tự động hóa quản trị |
| 4 | - Thực hành Lab 000060: Tạo bảng DynamoDB qua CLI (aws dynamodb create-table).<br>- Thực hiện CRUD: put-item, get-item, update-item, delete-item.<br>- Query và Scan dữ liệu. | 15/10/2025 | 15/10/2025 | https://000060.awsstudygroup.com/ | NoSQL qua CLI |
| 5 | - Thực hành Lab 000061: Khởi tạo Redis cluster trên ElastiCache.<br>- Kết nối bằng redis-cli hoặc ứng dụng.<br>- Thực hành lệnh SET key value và GET key. | 16/10/2025 | 16/10/2025 | https://000061.awsstudygroup.com/ | In-memory cache |
| 6 | - (Dự phòng) Ôn lại toàn bộ Lab tuần 6.<br>- Dọn dẹp tài nguyên: xóa hosted zone, bảng DynamoDB, Redis cluster, xóa CLI profile nếu cần. | 17/10/2025 | 17/10/2025 | | Kiểm soát chi phí |

### Kết quả đạt được tuần 6:
- Nắm kiến thức về Route 53:
  - Tạo và quản lý public hosted zone.
  - Cấu hình bản ghi và chính sách định tuyến linh hoạt.
- Nắm kiến thức về AWS CLI:
  - Cài đặt, cấu hình profile thành công.
  - Thực hiện lệnh quản lý EC2, S3, IAM, RDS mượt mà.
- Quản lý DynamoDB qua CLI:
  - Tạo bảng với primary key.
  - Thực hiện đầy đủ thao tác CRUD, Query, Scan.
- Triển khai ElastiCache Redis:
  - Khởi tạo cluster, kết nối ổn định.
  - Sử dụng lệnh SET/GET để lưu và lấy dữ liệu trong bộ nhớ.
- Hoàn thành Lab 000010, 000011, 000060, 000061.
