---
title: "Worklog Tuần 4"
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---

### Mục tiêu tuần 4:

* Học cách tự động mở rộng ứng dụng bằng EC2 Auto Scaling, bao gồm launch template, scaling group và scaling policy.  
* Giám sát và phân tích hiệu suất hệ thống với Amazon CloudWatch, bao gồm metrics, alarms và log monitoring.  
* Tìm hiểu giải pháp bộ nhớ đệm trong bộ nhớ với Amazon ElastiCache (Redis/Memcached) để tối ưu hiệu năng cơ sở dữ liệu.  
* Thực hành các khái niệm mạng cơ bản trên AWS, bao gồm VPC, Subnet, Route Table và Security Group.  
* Hiểu cơ chế phân phối nội dung với Amazon CloudFront và áp dụng điện toán biên với Lambda@Edge cho các kịch bản nâng cao.  
* Tìm hiểu về quản lý danh tính và dịch vụ thư mục với AWS Managed Microsoft AD.  

### Các công việc cần triển khai trong tuần này:
| Ngày | Nhiệm vụ                                                                                                               | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo | Ghi chú                                  |
| ---- | ----------------------------------------------------------------------------------------------------------------------- | ------------ | ---------------- | ------------------ | ---------------------------------------- |
| 2    | - Học các khái niệm cơ bản về EC2 Auto Scaling<br>- Tạo launch template và Auto Scaling Group<br>- Cấu hình scaling policy | 29/09/2025   | 29/09/2025       | <https://000006.awsstudygroup.com/vi/>   | Kiến thức nền tảng Auto Scaling          |
| 3    | - Khám phá metrics và dashboard của Amazon CloudWatch<br>- Thiết lập CloudWatch alarms<br>- Làm việc với CloudWatch Logs | 30/09/2025   | 30/09/2025       | <https://000008.awsstudygroup.com/vi/>   | Giám sát & ghi log                       |
| 4    | - Tìm hiểu cơ bản về Amazon ElastiCache (Redis, Memcached)<br>- Tạo ElastiCache cluster<br>- Tích hợp caching với RDS   | 01/10/2025   | 01/10/2025       | <https://000061.awsstudygroup.com/vi/>   | Bộ nhớ đệm trong RAM, tăng hiệu năng     |
| 5    | - Workshop: Cấu hình mạng AWS<br>- VPC, Subnet, Route Table, Security Group<br>- Thực hành thiết lập kết nối            | 02/10/2025   | 02/10/2025       | <https://000092.awsstudygroup.com/vi/>   | Nền tảng mạng                            |
| 6    | - Tạo CloudFront distribution với S3/EC2<br>- Khám phá các trường hợp Lambda@Edge (redirect, headers, A/B testing)<br>- Triển khai Windows Server trên EC2 và cài đặt ứng dụng IIS/.NET<br>- Tạo và quản lý AWS Managed Microsoft AD | 03/10/2025 | 03/10/2025 | <https://000094.awsstudygroup.com/vi/>, <https://000130.awsstudygroup.com/vi/>, <https://000095.awsstudygroup.com/vi/> | CloudFront, Edge computing, Microsoft AD |

### Kết quả đạt được tuần 4:

- Đã tạo và cấu hình EC2 Auto Scaling group với launch template và scaling policy.  
- Thiết lập CloudWatch dashboard, alarm và log để giám sát tình trạng và hiệu năng hệ thống.  
- Triển khai ElastiCache cluster (Redis/Memcached) giúp giảm tải cơ sở dữ liệu và cải thiện tốc độ phản hồi.  
- Hoàn thành workshop về mạng với VPC, Subnet, Route Table và Security Group.  
- Cấu hình CloudFront distribution và áp dụng Lambda@Edge cho các logic xử lý tại edge.  
- Tạo và quản lý AWS Managed Microsoft AD cho dịch vụ thư mục doanh nghiệp.  