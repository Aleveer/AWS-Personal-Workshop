---
title : "Cấu hình Custom Domain với Route53 và xác thực SSL với AWS Certificate Manager"
weight : 3
chapter : false
pre : " <b> 5.5.3 </b> "
---
#### Chuẩn bị Domain của bạn

Đầu tiên bạn cần phải mua 1 Domain ở bất kì nhà cung cấp Domain nào mà bạn muốn, ở đây mình đã mua 1 Domain có tên là webchat.mom của Porkbun.
![prepare-domain](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/prepare-domain.png)

#### Tạo Hosted Zone trong Route53 và trỏ Domain đó về HostedZone này.

Truy cập vào Route53 và chọn Create hosted zones -> Get Started
Nhập tên domain bạn đã mua vào ô Domain Name . Rồi nhấn Create hosted zone.
![hosted-zone](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone.png)

Nhập tên domain bạn đã mua vào ô Domain Name . Rồi nhấn Create hosted zone.
![hosted-zone1](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone1.png)

Sau khi tạo xong Hosted Zone , nhấn Hosted zone details vừa tạo , rồi copy lại 4 dòng Name Servers.
![hosted-zone2](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone2.png)

Quay trở lại trang quản lý Domain mà bạn đã mua Domain ,ở đây mình mua ở Pokbun , mình sẽ tiến hành đổi 4 Name Servers của domain thành 4 Name Servers của Hosted Zone. Chọn NameServers
![hosted-zone3](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone3.png)

Xóa 4 DNS có sẵn trong NameServers.
![hosted-zone4](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone4.png)

Thay bằng 4 DNS của Hosted Zone lúc nãy. Rồi nhấn Submit.
![hosted-zone5](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone5.png)

### Yêu cầu chứng chỉ cho Domain Với Amazon Certificate Manager
Truy cập vào Amazon Certificate Manager , chọn Request a certificate.
![acm](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm.png)

Chọn Request a public certificate, rồi nhấn Next.
![acm1](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm1.png)

Chúng ta tiến hành nhập Domain vào Domain names với dòng 1 là Domain dành cho backend và Domain 2 là dành cho frontend .
![acm2](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm2.png)

Kéo xuống dưới và chọn Request.
![acm3](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm3.png)

Chọn Create records in Route53 và nhấn Create Record để thêm 2 dòng Domain đó vào Hosted Zone của Route53.
![acm4](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm4.png)

Chọn 2 Domain và nhấn Create records.
![acm5](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm5.png)

Đợi vài phút status sẽ hoành thành tạo Certificate.
![acm6](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/acm6.png)

Quay trở lại Route53 , tìm Hosted Zone đã tạo , tiến hành chọn Create record để tạo Alias tới DNS của ALB Backend.
![hosted-zone6](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone6.png)

Tiến hành nhập subdomain cho backend và bật Alias rồi chọn Alas to Application and Classic Load Balancer , rồi chọn Region và ALB mà bạn đã tạo trước đó cho Backend .Rồi nhấn Create records.
![hosted-zone7](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone7.png)

Chúng ta đã hoàn tất cấu hình DNS trên Route 53 bằng cách tạo một Alias record trỏ domain api.webchat.mom tới Application Load Balancer.
![hosted-zone8](/images/5-Workshop/5.5-DeployFE/5.5.2-Custom-Domain-BE/hosted-zone8.png)

Vậy là chúng ta đã hoàn tất thiết lập và cấp chứng chỉ SSL cho Domain đã mua. Tiếp theo chúng ta sẽ cấu hình các bước cần thiết để kết nối giữa Frontend và Backend. 
