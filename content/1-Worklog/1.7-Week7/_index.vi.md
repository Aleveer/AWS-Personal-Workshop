---
title: "Worklog Tuần 7"
weight: 1
chapter: false
pre: " <b> 1.7. </b> "
---

### Mục tiêu tuần 7:

* Hoàn thiện kiến thức về triển khai ứng dụng web trên AWS.
* Học cách tích hợp và triển khai ứng dụng frontend (Vue.js) và backend (Nest.js) lên AWS bằng Cloud9 và EC2.
* Tìm hiểu cơ bản về CI/CD trong AWS (CodeCommit, CodeBuild, CodeDeploy).
* Làm quen với quy trình triển khai container qua Amazon ECS và ECR.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |  Note                     |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- | --------------------- |
| 2   | - Tìm hiểu tổng quan về AWS Cloud9 và cấu hình môi trường phát triển cho dự án web chat.                                                                                             | 20/10/2025   | 20/10/2025      | <https://000013.awsstudygroup.com/vi/> | Làm quen IDE Cloud9 và tích hợp GitHub. |
| 3   | - Tạo EC2 instance để triển khai ứng dụng Nest.js backend.                                            | 21/10/2025   | 21/10/2025      | <https://000004.awsstudygroup.com/vi/> | Triển khai ứng dụng backend. |
| 4   | - Tạo S3 bucket và upload build Vue.js frontend, sau đó kết hợp CloudFront để phân phối nội dung. | 22/10/2025   | 22/10/2025      | <https://000094.awsstudygroup.com/vi/> | Triển khai frontend qua S3 + CDN. | 
| 5   | - Tìm hiểu và thử nghiệm CI/CD cơ bản bằng AWS CodeCommit, CodeBuild và CodeDeploy.                  | 23/10/2025   | 23/10/2025      | <https://000110.awsstudygroup.com/vi/> | Tự động hóa triển khai. |
| 6   | - Tìm hiểu về Amazon ECS và ECR. Tạo ECR repository và đẩy Docker image lên.                                                                                         | 24/10/2025   | 24/10/2025      | <https://000066.awsstudygroup.com/vi/> | Làm quen container deployment. |


### Kết quả đạt được tuần 7:

* Làm quen với môi trường phát triển AWS Cloud9, kết nối GitHub, và quản lý mã nguồn dự án trực tiếp trên nền tảng đám mây.
* Đã triển khai thành công backend Nest.js lên EC2 instance và cấu hình bảo mật cơ bản (Security Group, SSH key).
* Xây dựng và triển khai frontend Vue.js lên S3 và CloudFront, đảm bảo có thể truy cập qua domain tĩnh.
* Tìm hiểu về quy trình CI/CD trên AWS, nắm được cách commit mã, build và deploy tự động qua CodeCommit, CodeBuild và CodeDeploy.
* Đã tạo repository trên ECR và đẩy thành công image container đầu tiên.


