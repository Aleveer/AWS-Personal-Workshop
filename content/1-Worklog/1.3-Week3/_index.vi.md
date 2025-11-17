---
title: "Worklog Tuần 3"
weight: 1
chapter: false
pre: " <b> 1.3. </b> "
---

### Mục tiêu Tuần 3:
- Củng cố kiến thức VPC, EC2, IAM thông qua thực hành lặp lại và dọn dẹp tài nguyên.
- Hiểu sâu cơ chế kết nối mạng: Internet Gateway → EC2 Public, NAT Gateway → EC2 Private.
- Nắm các phương thức truy cập EC2 an toàn: Bastion Host, Connect Endpoint, Session Manager.
- Nắm vững Site-to-Site VPN và IAM qua thực hành Lab.
- Làm quen với EC2, AMI tùy chỉnh, Snapshot, khôi phục keypair, và triển khai Node.js trên cả Linux & Windows.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu | Ghi chú |
| ---- | --------- | ------------ | --------------- | -------------- | ------- |
| 2 | - Xóa toàn bộ tài nguyên từ tuần trước.<br>- Thực hành lại từ đầu Lab 000003 (toàn bộ):<br> • Tạo VPC, Subnet, IGW, NATGW, Route Table, SG<br> • Khởi chạy EC2 Public & Private<br> • SSH qua Bastion Host, Connect Endpoint, Session Manager<br> • Kiểm tra kết nối Internet:<br>  – EC2 Public → qua Internet Gateway<br>  – EC2 Private → qua NAT Gateway<br> • Tìm hiểu tại sao cấu hình như vậy | 22/09/2025 | 22/09/2025 | https://000003.awsstudygroup.com/ | Củng cố kiến trúc mạng |
| 3 | - Xem Module 02 (phần nâng cao).<br>- Thực hành Lab 000003 – Site-to-Site VPN:<br> • Tạo Customer Gateway, Virtual Private Gateway<br> • Cấu hình VPN Connection<br> • Kiểm tra kết nối<br> • Dọn dẹp tài nguyên | 23/09/2025 | 23/09/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 02)<br>AWS VPN Docs | Mạng kết nối hybrid |
| 4 | - Xem và nắm vững AWS IAM (Users, Groups, Roles, Policies, MFA).<br>- Thực hành Lab 000002:<br> • Tạo IAM User, Group, Role<br> • Gắn Policy (inline & managed)<br> • Kích hoạt MFA<br> • Kiểm thử quyền truy cập<br> • Dọn dẹp | 24/09/2025 | 24/09/2025 | https://000002.awsstudygroup.com/ | Quản trị truy cập |
| 3 | - Xem Module 02 (phần nâng cao).<br>- Thực hành Lab 000003 – Site-to-Site VPN:<br> • Tạo Customer Gateway, Virtual Private Gateway<br> • Cấu hình VPN Connection<br> • Kiểm tra kết nối<br> • Dọn dẹp tài nguyên | 23/09/2025 | 23/09/2025 | https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i (Module 02)<br>AWS VPN Docs | Mạng kết nối hybrid |
| 4 | - Xem và nắm vững AWS IAM (Users, Groups, Roles, Policies, MFA).<br>- Thực hành Lab 000002:<br> • Tạo IAM User, Group, Role<br> • Gắn Policy (inline & managed)<br> • Kích hoạt MFA<br> • Kiểm thử quyền truy cập<br> • Dọn dẹp | 24/09/2025 | 24/09/2025 | https://000002.awsstudygroup.com/vi/<br>AWS IAM Console | Quản trị truy cập |
| 5 | - Dịch Blog cá nhân (Bản dịch + bản tiếng Anh). | 25/09/2025 | 25/09/2025 | AWS Blogs<br>Ví dụ: Secure VPC Design[](https://aws.amazon.com/blogs/architecture/) |  |
| 6.1 | - Xem Module 03.<br>- Thực hành Lab 000004 (phần 1):<br> • Tạo VPC + Security Group chuẩn bị cho Linux & Windows<br> • Khởi chạy EC2 Windows Instance<br> • Khởi chạy EC2 Linux Instance<br> • Dọn dẹp tài nguyên | 26/09/2025 | 26/09/2025 | https://000004.awsstudygroup.com/ |  |
| 6.2 | - Hoàn thành Lab 000004 (phần 2):<br> • Thay đổi instance type<br> • Tạo Snapshot → Custom AMI<br> • Mất keypair → khôi phục bằng Systems Manager<br> • Triển khai Node.js app trên:<br>  – EC2 Linux (User Data + PM2)<br>  – EC2 Windows (IIS hoặc Node trực tiếp)<br> • Dọn dẹp toàn bộ | 26/09/2025 | 26/09/2025 | https://000004.awsstudygroup.com/ |  |

### Kết quả đạt được tuần 3:
- Nắm kiến thức về kiến trúc VPC đa tầng:
  - Hiểu rõ lý do dùng IGW cho Public, NATGW cho Private.
  - Thực hành thành công 3 phương thức kết nối EC2:
    - Bastion Host → truyền thống, cần mở port 22
    - Connect Endpoint → private-only, không cần public IP
    - Session Manager → không cần SSH key, audit log, IAM control
- Thành công thiết lập Site-to-Site VPN:
  - Cấu hình kết nối on-premise ↔ AWS VPC.
  - Kiểm tra ping, traceroute qua tunnel.
- Nắm vững AWS IAM:
  - Tạo và quản lý User, Group, Role, Policy.
  - Áp dụng MFA, Least Privilege, Policy Conditions.
- Nắm kiến thức về EC2 nâng cao:
  - So sánh Linux vs Windows EC2 (RDP vs SSH).
  - Tạo Custom AMI từ Snapshot.
  - Khôi phục truy cập khi mất keypair bằng Session Manager.
  - Triển khai thành công ứng dụng Node.js trên cả Linux (systemd/PM2) và Windows (NSSM/IIS).
- Hoàn thành Lab 000002, 000003 (VPN), 000004 với đầy đủ yêu cầu.