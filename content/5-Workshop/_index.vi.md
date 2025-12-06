---
title: "Workshop"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Phát triển ứng dụng Web Chat sử dụng các dịch vụ AWS

#### Tổng quan

Workshop này cung cấp hướng dẫn chi tiết để xây dựng một ứng dụng WebChat hoàn chỉnh, sử dụng các công nghệ và dịch vụ hiện đại. Ứng dụng được phát triển theo kiến trúc monorepo với backend được containerized và deploy trên nền tảng đám mây AWS.

Về mặt công nghệ, workshop sử dụng NestJS làm framework backend, được đóng gói trong Docker containers và triển khai trên Amazon ECS Fargate để đảm bảo khả năng mở rộng và quản lý tự động. Phía frontend được xây dựng bằng VueJS với công cụ build Vite và được triển khai trên CloudFront, 

Tính năng real-time messaging được triển khai thông qua Socket.io, cho phép giao tiếp hai chiều giữa client và server một cách hiệu quả. Amazon S3 đóng vai trò là kho lưu trữ tập trung cho các file được người dùng upload, đảm bảo tính sẵn sàng và độ bền của dữ liệu.

#### Nội dung

1. [Tổng quan về workshop](5.1-Workshop-overview/)
2. [Chuẩn bị](5.2-Prerequiste/)
3. [Thiết lập Infrastructure với Terraform](5.3-Infra-Terraform/)
4. [Build Docker Image và Deploy Backend](5.4-Docker-DeployBE/)
5. [Deploy Frontend](5.5-DeployFE/)
6. [Monitoring và Logging](5.6-Log-n-Monitor/)
7. [Dọn dẹp tài nguyên](5.7-Cleanup/)
