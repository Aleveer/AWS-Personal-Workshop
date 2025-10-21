---
title: "Blog 6"
weight: 1
chapter: false
pre: " <b> 3.6. </b> "
---

# Tối Ưu Hóa Thời Gian Ngừng Hoạt Động Chuyển Đổi Unicode Cho Các Hệ Thống SAP Trên Oracle Sang AWS

Các tổ chức toàn cầu sử dụng hệ thống SAP cần xử lý dữ liệu bằng nhiều ngôn ngữ. [Unicode](https://www.unicode.org/standard/WhatIsUnicode.html) cung cấp một cách tiêu chuẩn hóa để biểu diễn và xử lý dữ liệu văn bản từ các ngôn ngữ này, đảm bảo hiển thị và xử lý nhất quán trên các hệ thống và nền tảng khác nhau. SAP khuyến nghị sử dụng Unicode cho tất cả các cài đặt mới và chuyển đổi từ các hệ thống non-Unicode để đảm bảo tính tương thích, tính toàn vẹn dữ liệu và hỗ trợ hoạt động toàn cầu. Các bản phát hành SAP mới nhất, chẳng hạn như [SAP ERP 6.0 EHP8](https://help.sap.com/docs/SAP_ERP) và [SAP S/4HANA](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE), chỉ có sẵn dưới dạng Unicode, làm cho hệ thống nguồn phải tương thích Unicode trước khi nâng cấp lên bản phát hành cao hơn.

Để đảm bảo chuyển đổi mượt mà sang SAP S/4HANA, khách hàng cần ưu tiên áp dụng Unicode trong hệ thống của họ, xem xét hỗ trợ bảo trì chính cho ERP 6.0 dự kiến kết thúc vào ngày 31 tháng 12 năm 2027 theo [SAP Note 1648480](https://me.sap.com/notes/1648480) – Maintenance for SAP Business Suite 7 Software including SAP NetWeaver (yêu cầu đăng nhập SAP Support).

Việc chuyển đổi hệ thống SAP sang Unicode liên quan đến việc quản lý nhiều thách thức kỹ thuật: chuyển đổi dữ liệu, khắc phục mã, thời gian ngừng hoạt động theo kế hoạch, kiểm thử và xác thực, tác động hiệu suất, và điều chỉnh giao diện. Các cơ sở dữ liệu SAP lớn (10 TB+) yêu cầu 1-3 ngày ngừng hoạt động cho chuyển đổi Unicode. Quy trình cần thêm dung lượng phần cứng để giảm thiểu thời gian ngừng hoạt động. Các tổ chức có cơ sở hạ tầng hết hạn sử dụng phải cân bằng đầu tư phần cứng với yêu cầu thời gian ngừng hoạt động.

Trong bài viết blog này, chúng tôi giải quyết các thách thức mà một khách hàng gặp phải liên quan đến thời gian ngừng hoạt động hệ thống và trình bày một trường hợp sử dụng nơi [Bell Canada](https://d1.awsstatic.com/events/Summits/toronto24/TEL201_TurbochargingSAP_E2_TORSummit_20240911.pdf), một trong những công ty viễn thông lớn nhất Canada, đã áp dụng một cách tiếp cận thay thế để di chuyển hệ thống SAP ERP non-Unicode 11 TB chạy với cơ sở dữ liệu Oracle sang AWS trong vòng dưới 5 giờ.

## Nền Tảng

Khách hàng chạy hệ thống SAP ERP non-Unicode với cơ sở dữ liệu Oracle phải chuyển đổi hệ thống SAP non-Unicode (NUC) sang Unicode (UC) trước khi di chuyển sang S/4HANA theo [SAP Note 2033243](https://me.sap.com/notes/2033243/E). Ngoài ra, khi di chuyển hệ thống SAP chạy trên cơ sở dữ liệu Oracle sang AWS, khách hàng phải chuyển đổi sang hệ thống Unicode vì lý do hỗ trợ, như được nêu trong [SAP Note 2358420](https://me.sap.com/notes/2358420).

Trong trường hợp như vậy, khách hàng thực hiện chuyển đổi Unicode như một bước đầu tiên khi di chuyển sang AWS. Khi hệ thống hoạt động trên AWS, họ nâng cấp từ SAP ECC sang S/4HANA, tận dụng các dịch vụ đám mây có khả năng mở rộng của AWS.

Đối với chuyển đổi Unicode, quy trình SAP được ghi chép liên quan đến việc xuất dữ liệu hệ thống SAP từ hệ thống nguồn tại chỗ, chuyển dữ liệu đã xuất sang AWS sử dụng các dịch vụ như [AWS Direct Connect](https://aws.amazon.com/directconnect/) hoặc [AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html), và sau đó nhập nó vào hệ thống mục tiêu chạy trên AWS. Thời gian chính xác thay đổi dựa trên các yếu tố như dung lượng phần cứng, băng thông mạng có sẵn, công cụ di chuyển được sử dụng và các phương pháp cụ thể được sử dụng.

Khi xử lý các khối lượng công việc SAP, liên quan đến nhiều tích hợp bên thứ ba, việc giảm thiểu thời gian ngừng hoạt động là cần thiết để đảm bảo tính liên tục kinh doanh và ngăn chặn gián đoạn các quy trình quan trọng. Do đó, việc áp dụng các chiến lược và kỹ thuật có thể giảm thiểu thời gian ngừng hoạt động di chuyển là rất quan trọng.

## Trường Hợp Sử Dụng

Bell Canada đang vận hành hệ thống SAP ERP của họ với cơ sở dữ liệu Oracle 19c tại chỗ với Red Hat Enterprise Linux 8 (RHEL8) làm hệ điều hành. Kích thước cơ sở dữ liệu sản xuất khoảng 11 TB. Bell Canada muốn giữ nguyên cơ sở dữ liệu Oracle và khi di chuyển sang AWS, nó yêu cầu có hệ điều hành Oracle Enterprise Linux để hỗ trợ Oracle, theo [SAP Note 2358420](https://me.sap.com/notes/2358420). Ngoài ra, hệ thống SAP cần được chuyển đổi sang Unicode. Thời gian ngừng hoạt động kinh doanh tối đa được phê duyệt cho di chuyển là 32 giờ, với tối đa 10 giờ cho chuyển đổi kỹ thuật.

Chúng tôi xác định một cách tiếp cận di chuyển loại bỏ phần cứng tại chỗ bổ sung và tuân thủ các thực hành tốt nhất cho chuyển đổi AWS. Kế hoạch ưu tiên thời gian ngừng hoạt động chuyển đổi kỹ thuật tối thiểu trong khi phân bổ nhiều thời gian hơn cho các nhiệm vụ cutover. Chúng tôi cũng đánh giá các tùy chọn di chuyển khác nhau và các thực hành tốt nhất như sử dụng các tính năng cơ sở dữ liệu tiên tiến, xử lý song song hoặc các kỹ thuật tối ưu hóa khác.

## Cách Tiếp Cận Di Chuyển

Hãy khám phá các cách tiếp cận có sẵn để di chuyển hệ thống SAP non-Unicode với cơ sở dữ liệu Oracle (chạy trên RHEL) sang Oracle Enterprise Linux trên AWS.

| Approach | Description | Steps |
|  --  |  --  |  |
| Option 1 | Chuyển đổi Unicode cùng với di chuyển sang AWS giữ nguyên cơ sở dữ liệu Oracle | * Di chuyển hệ thống SAP từ trung tâm dữ liệu tại chỗ sang AWS, chuyển đổi từ non-Unicode sang Unicode trong quá trình.<br>* Thực hiện khắc phục và kiểm thử hệ thống SAP trên AWS, sau đó ngừng sử dụng hệ thống SAP tại chỗ. |
| Option 2 | Di chuyển SAP non-Unicode sang AWS, sau đó chuyển đổi sang Unicode giữ nguyên cơ sở dữ liệu Oracle | - Di chuyển hệ thống SAP từ trung tâm dữ liệu tại chỗ sang AWS sử dụng sao chép cơ sở dữ liệu không đồng bộ trong một hệ thống tạm thời cho đến cutover.<br>- Chuyển đổi từ non-Unicode sang Unicode trên AWS bằng cách xuất từ hệ thống tạm thời và nhập vào hệ thống cuối cùng.<br>- Thực hiện khắc phục và kiểm thử hệ thống SAP trên AWS, sau đó ngừng sử dụng hệ thống SAP tại chỗ và hệ thống tạm thời. |

Bảng 1: Các tùy chọn chuyển đổi Unicode cho SAP trên Oracle sang AWS

Cả hai tùy chọn di chuyển đều yêu cầu cửa sổ ngừng hoạt động kinh doanh để chuyển sang môi trường AWS mục tiêu. Trong khi Option 1 cung cấp cách tiếp cận thực thi có thể dự đoán hơn, nó yêu cầu phần cứng tại chỗ bổ sung để hỗ trợ các quy trình xuất tài nguyên cao trong chuyển đổi Unicode SAP và băng thông mạng ổn định để hỗ trợ chuyển dữ liệu từ tại chỗ sang AWS. Hơn nữa, tùy chọn này đòi hỏi hơn 24 giờ ngừng hoạt động kỹ thuật. Để giải quyết các thách thức này, chúng tôi sẽ khám phá Option 2 và thảo luận cách tiếp cận di chuyển và thực hành tốt nhất của nó.

Trong Option 2, một hệ thống SAP vanilla non-Unicode được cung cấp trên [Amazon Elastic Compute Cloud (Amazon EC2)](https://aws.amazon.com/ec2/) như một instance tạm thời, và một cài đặt SAP Unicode được thiết lập trên một [Amazon EC2](https://aws.amazon.com/ec2/) khác như instance cuối cùng. Instance staging nên được cấu hình với cùng phiên bản phần mềm cơ sở dữ liệu Oracle, bao gồm bản phát hành và bộ vá, như môi trường tại chỗ. Theo [SAP Note 1571295](https://me.sap.com/notes/1571295/E) các cài đặt hệ thống SAP non-Unicode mới không được phép theo mặc định. Do đó, hệ thống SAP non-Unicode ban đầu được tạo bằng cách thực hiện xuất system copy từ một hệ thống non-Unicode hiện có nhỏ. Xuất system copy này chỉ được thực hiện một lần, và xuất kết quả được tái sử dụng để xây dựng bất kỳ hệ thống SAP non-Unicode nào trên tất cả các môi trường. Hệ thống nguồn tại chỗ được di chuyển sang instance staging trên AWS sử dụng sao chép cơ sở dữ liệu không đồng bộ. Đối với sao chép cơ sở dữ liệu Oracle, [Oracle Data Guard](https://www.oracle.com/in/database/data-guard/) (ODG) được sử dụng, được bao gồm trong giấy phép Oracle Enterprise Edition được bao gồm trong các mua từ SAP. Sao chép không đồng bộ này hỗ trợ chuyển dữ liệu từ tại chỗ sang AWS mà không ảnh hưởng đến hoạt động kinh doanh đang diễn ra. Phương pháp này cho phép chuyển dữ liệu quy mô terabyte sang AWS trong hoạt động kinh doanh bình thường. Tại thời điểm bắt đầu cửa sổ ngừng hoạt động thực tế, instance staging tiếp quản và phục vụ như hệ thống nguồn cho chuyển đổi Unicode. Xuất hệ thống SAP được thực hiện trên instance staging, và nhập được thực thi trên instance SAP cuối cùng.

Hãy kiểm tra một thiết lập kiến trúc đơn giản hóa như được hiển thị trong Hình 1 để hiểu quy trình di chuyển cho cách tiếp cận này.

![Simplified architectural setup for Unicode conversion and migration](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Simplified-architectural-setup-for-Unicode-conversion-and-migration2.jpg)

**Hình 1: Thiết lập kiến trúc đơn giản hóa cho chuyển đổi Unicode và di chuyển**

Trong bước đầu tiên, Oracle Data Guard được cấu hình để đồng bộ hóa dữ liệu giữa cơ sở dữ liệu tại chỗ và instance staging trên AWS. Dữ liệu được chuyển từ môi trường tại chỗ sang instance staging qua [AWS Direct Connect](https://aws.amazon.com/directconnect/). Quy trình sao chép tiếp tục cho đến khi bắt đầu quy trình cutover trong cửa sổ ngừng hoạt động. Sau khi tiếp quản cơ sở dữ liệu trên instance staging, nó trở thành hệ thống nguồn cho xuất hệ thống SAP. Trong bước thứ hai, xuất system copy SAP, bao gồm bất kỳ chuẩn bị cần thiết như table splitting, được khởi động trên instance cơ sở dữ liệu staging. Export dump được lưu trữ trên một volume [Amazon Elastic Block Store (Amazon EBS)](https://aws.amazon.com/ebs/) gắn với instance staging (gọi là sapdump) và các file dữ liệu Oracle được lưu trữ trên các volume EBS (gọi là sapdata). Trong bước thứ ba, các file export dump được chuyển liên tục sang volume [Amazon EBS](https://aws.amazon.com/ebs/) gắn với instance cuối cùng sử dụng File Transfer Protocol (FTP) mà không có can thiệp thủ công. Trong bước thứ tư, quy trình nhập được bắt đầu trên instance cơ sở dữ liệu cuối cùng, chạy song song với quy trình xuất. Bằng cách áp dụng cách tiếp cận di chuyển song song sử dụng các công cụ SAP như [Software Provisioning Manager](https://help.sap.com/docs/SOFTWARE_PROVISIONING_MANAGER) (SWPM) và [SAP Migration Monitor](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf), quy trình xuất/nhập được song song hóa. Sau khi hoàn thành xuất/nhập, hệ thống SAP mục tiêu được khởi động, và các bước post-processing được thực hiện trên instance cuối cùng. Sau đó, instance staging được tắt và cuối cùng bị chấm dứt.

Sơ đồ đơn giản hóa ở trên trong Hình 1 không bao gồm các thành phần liên quan đến thiết lập high availability (HA) để đơn giản. Tuy nhiên, các hệ thống sản xuất cần cấu hình high availability tùy thuộc vào yêu cầu kinh doanh. Để biết thông tin về thiết lập high availability với cơ sở dữ liệu Oracle trên AWS cho các cài đặt SAP NetWeaver, vui lòng tham khảo bài blog [High availability design and solution for SAP NetWeaver installations with Oracle Data Guard (Fast-Start Failover)](https://aws.amazon.com/blogs/awsforsap/high-availability-design-and-solution-for-sap-netweaver-installations-with-oracle-data-guard-fast-start-failover/).

Khách hàng nên nhận được sự đồng thuận của SAP để tạm thời chạy hệ thống SAP non-Unicode trong thời gian cutover (không có end-user nào trên nó) và xác thực cách tiếp cận qua một proof of concept (POC) ở đầu dự án.

## Thực Hành Tốt Nhất

Hãy đi sâu vào các thực hành tốt nhất đã giúp giảm thiểu thời gian ngừng hoạt động trong chuyển đổi kỹ thuật. Để hiểu rõ hơn, chúng tôi sẽ kiểm tra các hướng dẫn và thực hành được triển khai trong mỗi giai đoạn của di chuyển hệ thống. Hình 2 hiển thị các giai đoạn cấp cao cho chuyển đổi Unicode và di chuyển hệ thống SAP dựa trên Oracle.

![Phases in SAP system Unicode conversion and migration based on Oracle](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Phases-in-SAP-system-Unicode-conversion-and-migration-based-on-Oracle.jpg)

**Hình 2: Các giai đoạn trong chuyển đổi Unicode và di chuyển hệ thống SAP dựa trên Oracle**

### Lập Kế Hoạch

Trong giai đoạn lập kế hoạch, chúng tôi khuyến nghị xem xét các chiến lược để giảm kích thước các bảng kỹ thuật lớn. Kiểm tra chéo xem các công việc tái tổ chức tiêu chuẩn có được lên lịch để ngăn chặn các bảng kỹ thuật phát triển vô hạn. Ví dụ, tuân thủ hướng dẫn trong [SAP Note 1616768](https://me.sap.com/notes/1616768/E) cho các bảng BALDAT và BALHDR sẽ có lợi nếu các bảng log này đã trở nên quá lớn.

Quy trình chuyển đổi Unicode yêu cầu các kiểm tra chuẩn bị cụ thể, bao gồm các báo cáo chạy lâu như SDBI_CLUSTER_CHECKS và UCCHECK. Chúng tôi khuyên nên chạy các báo cáo này vài tháng trước chuyển đổi thực tế. Cách tiếp cận chủ động này giúp xác định và giảm thiểu các vấn đề tiềm ẩn liên quan đến cluster tables và cung cấp cái nhìn sâu sắc về nỗ lực phát triển cần thiết cho các điều chỉnh liên quan đến Unicode. Các kiểm tra này là một phần của hướng dẫn chuyển đổi Unicode như được đề cập trong [SAP Note 551344](https://me.sap.com/notes/551344/E).

Khi chuyển sang Unicode và chuẩn bị cho cơ sở hạ tầng mục tiêu, bạn phải đánh giá các yêu cầu phần cứng liên quan đến Unicode được chỉ định trong [SAP Note 1139642](https://me.sap.com/notes/1139642/E). Di chuyển terabytes dữ liệu sẽ cần kết nối mạng đáng tin cậy với băng thông yêu cầu giữa nguồn tại chỗ và AWS, đạt được bằng [AWS Direct Connect](https://aws.amazon.com/directconnect/) hoặc [AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html).

Mở các cổng yêu cầu cho dịch vụ SAP và cơ sở dữ liệu Oracle trong firewall liên quan và [security group](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) để duy trì truy cập mạng nhất quán trong suốt quy trình di chuyển. Đối với dịch vụ SAP, chẳng hạn như SAP Application Server, SAP Central Services, và SAP Software Provisioning Manager (SWPM), tham khảo tài liệu SAP “[TCP/IP Ports of All SAP Products](https://help.sap.com/docs/Security/575a9f0e56f34c6e8138439eefc32b16/616a3c0b1cc748238de9c0341b15c63c.html)“. Đối với cơ sở dữ liệu Oracle và sao chép Oracle Data Guard, mở [Oracle Net Services Listener port](https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/oracle-database-component-port-numbers-and-protocols.html) được cấu hình cho kết nối client Oracle đến cơ sở dữ liệu, LOCAL_LISTENER port được cấu hình cho application pluggable databases (PDB) trong [multi-tenant architecture](https://docs.oracle.com/en/database/oracle/oracle-database/19/multi/introduction-to-the-multitenant-architecture.html) container database (CDB), cũng như các cổng cho Oracle Data Guard listener, nếu không sử dụng các cổng listener Oracle Net tiêu chuẩn. Tất cả các cổng này đều có thể cấu hình thủ công, và bạn nên lấy số cổng thực tế đang sử dụng từ thiết lập hiện có.

Nếu cơ sở dữ liệu nguồn được mã hóa, tạo [Oracle Wallet](https://docs.oracle.com/en/database/oracle/oracle-database/19/dbimi/using-oracle-wallet-manager.html) yêu cầu trên các hệ thống mục tiêu và sao chép tất cả các chứng chỉ SSL cần thiết từ Oracle Wallet của hệ thống nguồn. Ngoài ra, các dịch vụ listener cần được cấu hình để lắng nghe trên giao thức TCPS thay vì giao thức TCP tiêu chuẩn. Các thay đổi giao thức này phải được cập nhật trong cấu hình firewall đã thực hiện trước đó.

Trong quy trình di chuyển, việc giám sát tổng sử dụng CPU và IOPS (Input/Output Operations Per Second) là rất quan trọng. Tùy thuộc vào sử dụng CPU và IOPS dự kiến trong di chuyển, yêu cầu tăng giới hạn dịch vụ AWS. Khi nâng cấp loại instance để phù hợp với nhiều CPU hơn trong di chuyển, đảm bảo rằng quota giới hạn instance EC2 của tài khoản AWS của bạn cho vùng mục tiêu cho phép loại instance và dung lượng CPU mong muốn. Ví dụ, yêu cầu di chuyển 250.000 IOPS vượt quá quota dịch vụ mặc định 100.000 cho “IOPS for Provisioned IOPS SSD (io2) volume” và “IOPS modifications for Provisioned IOPS SSD (io2) volumes”. Trong các trường hợp như vậy, bạn nên chủ động yêu cầu tăng các quota này lên giá trị yêu cầu trước khi khởi động di chuyển. Xem xét chi tiết quota và giới hạn trong tài liệu [Amazon EC2 quotas](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html) và [Amazon EBS limits](https://docs.aws.amazon.com/general/latest/gr/ebs-service.html).

Trong khi di chuyển sang Unicode, các tham số hệ thống SAP cho hệ thống Unicode mục tiêu sẽ cần được điều chỉnh như được nêu trong [SAP Note 790099](https://me.sap.com/notes/790099/E). Tùy thuộc vào hợp đồng hỗ trợ với SAP, bạn nên xem xét sử dụng dịch vụ “Going Live Functional Upgrade service” được cung cấp bởi SAP, cung cấp các khuyến nghị cơ bản cho hệ thống Unicode. [SAP Note 2360708](https://me.sap.com/notes/2360708) cung cấp thêm thông tin về cách yêu cầu dịch vụ hỗ trợ từ SAP. Hãy xem xét triển khai các thay đổi tham số sớm trong môi trường non-production trước khi bắt đầu user acceptance testing. Cách tiếp cận chủ động này cho phép các đội ngũ kinh doanh và kỹ thuật đánh giá tác động của các thay đổi này và lập kế hoạch tốt hơn cho các điều chỉnh tham số tương tự trong môi trường sản xuất.

### Xây Dựng Hệ Thống

Trong giai đoạn xây dựng, cơ sở hạ tầng được cung cấp cho cả hệ thống SAP non-Unicode và Unicode. Hệ thống non-Unicode phục vụ như một instance staging tạm thời, chỉ được sử dụng trong quy trình di chuyển, trong khi hệ thống Unicode phục vụ như instance cuối cùng. Khi cơ sở hạ tầng sẵn sàng, các build SAP vanilla được thực hiện cho cả hai hệ thống non-Unicode và Unicode. Việc xây dựng các hệ thống vanilla này cho phép thực hiện các kiểm tra kỹ thuật chuẩn bị, chẳng hạn như kiểm thử high availability, trước. Như luôn luôn, hãy đảm bảo tận dụng lợi ích linh hoạt của đám mây để tắt các instance EC2 của bạn khi chúng không sử dụng, giúp giảm chi phí phần cứng.

Khi thiết kế bố trí đĩa cơ sở dữ liệu, lập kế hoạch số lượng [Amazon EBS](https://aws.amazon.com/ebs/) volumes, các loại [Amazon EBS volume types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html) như General Purpose SSD (gp3) hoặc Provisioned IOPS SSD (io2), và striping yêu cầu với Logical Volume Manager (LVM) để tối ưu hóa hiệu suất throughput.

Cuối cùng, kiểm tra giới hạn EC2 của bạn. Như được nêu trong hướng dẫn người dùng [Amazon EBS-optimized instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html), “Hiệu suất EBS của một instance bị giới hạn bởi giới hạn hiệu suất của loại instance, hoặc hiệu suất tổng hợp của các volume gắn kèm, bất kể cái nào nhỏ hơn”. Nếu khối lượng công việc của bạn yêu cầu hiệu suất IOPS cao và nhất quán, độ trễ thấp, độ bền cao, và bạn sẵn sàng trả phí cao cấp, các volume io2 là lựa chọn tốt hơn. Tuy nhiên, nếu khối lượng công việc của bạn có yêu cầu IOPS trung bình và chi phí là mối quan tâm, các volume gp3 là lựa chọn tiết kiệm chi phí hơn trong khi vẫn cung cấp hiệu suất và độ bền tốt. Để biết thông tin chi tiết hơn về đặc tính hiệu suất và trường hợp sử dụng của các volume gp3 và io2, bạn có thể tham khảo tài liệu AWS về [Amazon EBS volume types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html).

Provisioned IOPS SSD (io2) volumes cung cấp độ bền cao nhất và độ trễ thấp nhất trong số các loại [Amazon EBS](https://aws.amazon.com/ebs/) volume, làm chúng phù hợp cho các ứng dụng quan trọng với yêu cầu hiệu suất khắt khe. Để biết thông tin chi tiết hơn về Provisioned IOPS SSD (io2) volumes, bao gồm đặc tính hiệu suất, cung cấp và thực hành tốt nhất, vui lòng tham khảo tài liệu AWS về [Provisioned IOPS SSD (io2) Block Express volumes](https://docs.aws.amazon.com/ebs/latest/userguide/provisioned-iops.html#io2-block-express).

Một ví dụ bố trí đĩa được cung cấp cho một instance cơ sở dữ liệu Oracle trong Bảng 2, bao gồm hai volume io2 [Amazon EBS](https://aws.amazon.com/ebs/) 6.300 GB và 110.000 IOPS mỗi cái. Với striping, cấu hình này cung cấp throughput từ 3437.5 MB/s đến 8.000 MB/s.

| EBS Volumes | Volume Group | Volume Type | Description | File system | EBS Size (GB) | IOPS | EBS Throughput (at 16 KiB I/O size) | EBS Throughput (at 256 KiB I/O size) |
|-------------|--------------|-------------|-------------|-------------|---------------|------|------------------------------------|-------------------------------------|
| Volume 1   | VG-DB       | io2        | Database data files | /oracle/<SID>/sapdata<1..n> | 6,300 | 110,000 | 1,718.75 MB/s | 4,000 MB/s |
| Volume 2   | VG-DB       | io2        | Database data files |  | 6,300 | 110,000 | 1,718.75 MB/s | 4,000 MB/s |
| Total      |             |            |             |             | 12,600 | 220,000 | 3,437.5 MB/s | 8,000 MB/s |

Bảng 2: Mẫu bố trí đĩa cho instance cơ sở dữ liệu Oracle

### Thiết Lập ODG / Sao Chép / Giám Sát

Giải pháp bản địa của Oracle, [Oracle Data Guard](https://www.oracle.com/database/data-guard/) (ODG), được sử dụng để tạo một bản sao nhất quán giao dịch của cơ sở dữ liệu tại chỗ trên máy chủ cơ sở dữ liệu staging trong AWS. Ban đầu, [Oracle Recovery Manager](https://docs.oracle.com/en/database/oracle/oracle-database/19/bradv/getting-started-rman.html) (RMAN) được sử dụng để tạo một clone của cơ sở dữ liệu tại chỗ trên máy chủ staging. Sau đó, [Data Guard Broker](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/oracle-data-guard-broker-concepts.html) được cấu hình cho change data capture (CDC), đảm bảo rằng tất cả các thay đổi dữ liệu được thực hiện trên cơ sở dữ liệu tại chỗ được ghi nhận và áp dụng cho cơ sở dữ liệu staging mục tiêu theo thời gian thực.

Các kênh song song được sử dụng để tối đa hóa throughput sao chép. Vì RMAN sử dụng một large pool dành riêng cho các hoạt động backup và restore, cơ sở dữ liệu staging mục tiêu cần được cấu hình với các tham số LARGE_POOL_SIZE và SGA_MAX_SIZE. Các quy trình IO server cần được thêm vào database writer (DBWR) để tối ưu hóa quy trình viết trong hoạt động restore bằng cách tận dụng khả năng async IO của hệ điều hành.

Để nâng cao thêm quy trình chuyển đổi, ngay trước cutover, scale up các instance [Amazon EC2](https://aws.amazon.com/ec2/instance-types/) cơ sở dữ liệu staging và mục tiêu để đáp ứng yêu cầu chuyển đổi. Ngoài ra, cần điều chỉnh các tham số cơ sở dữ liệu Oracle, ví dụ MEMORY_TARGET và MEMORY_MAX_TARGET trong các cơ sở dữ liệu được cấu hình với automatic memory management, để tận dụng đầy đủ các tài nguyên bổ sung. Trong chuyển đổi, cả hai cơ sở dữ liệu staging và mục tiêu được đặt ở chế độ NOARCHIVELOG để giảm thiểu overhead liên quan đến log archiving.

### Thời Gian Hoạt Động Unicode / Các Bước Trước Di Chuyển

Chuyển đổi Unicode được thực hiện như một phần của quy trình system copy SAP. Trong quá trình này, hệ thống được xuất từ nguồn dưới định dạng Unicode và sau đó nhập vào hệ thống SAP mục tiêu. [SAP System Copy Guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf), và “Unicode conversion guide” như được đề cập trong [SAP Note 551344](https://me.sap.com/notes/551344/E)), cung cấp hướng dẫn chi tiết cho quy trình này.

Trước khi có thể thực hiện xuất và nhập Unicode, hệ thống phải trải qua một loạt các kiểm tra chuẩn bị, cả trong thời gian hoạt động và ngừng hoạt động. Các kiểm tra này được nêu trong hướng dẫn chuyển đổi Unicode. Các kiểm tra và báo cáo uptime được thực hiện trên hệ thống tại chỗ, trong khi các báo cáo và kiểm tra yêu cầu ngừng hoạt động hệ thống được thực hiện trên instance staging trên AWS, sau khi tiếp quản hệ thống.

### Ramp Down

Trong thời gian ngừng hoạt động kinh doanh theo lịch, các hệ thống được khóa một cách nhẹ nhàng cho end-user. Khi các giao diện giao tiếp được dừng, các hệ thống được chuẩn bị cho quy trình di chuyển. Trong giai đoạn này, các nhiệm vụ chuẩn bị được thực hiện như được nêu trong [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf), bao gồm tạm dừng batch jobs, vô hiệu hóa alerts, dừng background processing, xử lý các update bị hủy hoặc đang chờ, và xóa các bảng tạm thời không hợp lệ v.v. Các bước này đảm bảo di chuyển mượt mà bằng cách đưa các hệ thống đến trạng thái nhất quán trước khi các hoạt động di chuyển thực tế bắt đầu.

### Takeover

Sau khi xác nhận rằng hệ thống primary và standby đã đồng bộ, hệ thống staging (trên AWS) được tiếp quản. Việc tiếp quản này được xác thực sử dụng quy trình [switchover](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/examples-using-data-guard-broker-DGMGRL-utility.html#GUID-1403D1C3-8944-42D0-8BDA-21D695C7958A) của Oracle Data Guard (ODG). Sau khi tiếp quản thành công, cấu hình ODG được [removed](https://docs.oracle.com/en/database/oracle/oracle-database/19/dgbkr/examples-using-data-guard-broker-DGMGRL-utility.html#GUID-820B4A3F-6FA3-4CC7-A06E-27BE25AB66F4) để ngăn chặn bất kỳ giao tiếp ngược nào từ hệ thống mục tiêu sang môi trường tại chỗ. Sau đó, loại instance và các tham số liên quan đến cơ sở dữ liệu được điều chỉnh trước khi khởi động quy trình system copy.

### System Copy (Export / Import / Monitor)

Để tối ưu hóa quy trình system copy, bắt đầu bằng việc xác định các bảng hàng đầu từ danh sách DB02 hệ thống và lập kế hoạch splitting các bảng lớn (ví dụ: bảng lớn hơn 20 GB). Các kỹ thuật như Package Splitting và Table Splitting được sử dụng để kích hoạt xử lý song song cho xuất và nhập bảng. Chạy [SAP migration time analyzer](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf) có thể cung cấp cái nhìn tổng hợp về xuất và nhập package, cho phép xác định các cơ hội tối ưu hóa thêm. Bài tập tối ưu hóa này có thể yêu cầu nhiều lần chạy test để xác định thứ tự đúng.

Đối với các bảng lớn, splitting có thể cần thiết để xử lý xuất và nhập song song. Trong khi bạn có tùy chọn sử dụng SAPup/R3ta (theo phần 2.6.4 của [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf)) hoặc splitter cụ thể cơ sở dữ liệu được hỗ trợ, trong trường hợp di chuyển hệ thống dựa trên Oracle, hãy xem xét sử dụng Oracle splitter cho table splitting hiệu quả theo [SAP Note 1043380](https://me.sap.com/notes/1043380/E).

Các thiết lập và cấu hình tham số Oracle (ví dụ: db_cache_size, pga_aggregate_target, processes, kích thước PSAPTEMP, và vô hiệu hóa archive logging) cho system copy dựa trên R3load nên được đặt theo khuyến nghị từ [SAP Note 936441](https://me.sap.com/notes/936441/E).

Trong quy trình xuất/nhập di chuyển, một instance EC2 với số lượng CPU cao hơn, RAM, mạng và dung lượng throughput lưu trữ nên được chọn. Ngoài ra, khuyến nghị tạm thời sử dụng io2 EBS Volumes với giá trị provisioned IOPS được tăng cường để giảm thời gian nhập, sau đó được chuyển đổi lại thành gp3 sau, trong các hoạt động trực tuyến. Kích thước instance được chọn nên có ít nhất số lượng CPU yêu cầu để chạy nhiều quy trình R3load đồng thời và cũng hỗ trợ throughput EBS và IOPS đủ để đảm bảo các volume throughput cao của bạn không bị giới hạn. Như một quy tắc ngón tay cái, sử dụng ba lần số lượng CPU. Ví dụ, nếu bạn lập kế hoạch chạy 300 quy trình R3load, chọn một instance [Amazon EC2](https://aws.amazon.com/pm/ec2/) với ít nhất 100 vCPUs.

Thay đổi kích thước instance và điều chỉnh tham số trong mỗi lần chạy proof of concept (POC) tiếp theo dựa trên các phát hiện. Lập kế hoạch cho nhiều lần lặp POC trong hệ thống test hoặc sandbox với kích thước cơ sở dữ liệu tương tự sản xuất. Sau vài lần chạy POC, bạn nên có cấu hình tối ưu của CPU, RAM, băng thông mạng, EBS throughput và IOPS yêu cầu để hoàn thành chuyển đổi Unicode trong thời gian ngừng hoạt động kỹ thuật mong muốn. Trước hoạt động xuất và nhập, loại instance được thay đổi để đạt hiệu suất tối ưu với CPU cao hơn, bộ nhớ, hiệu suất mạng và băng thông tối đa. Ví dụ, EC2 [r7i.48xlarge](https://aws.amazon.com/ec2/instance-types/r7i/), được cung cấp bởi bộ xử lý Intel Xeon Scalable thế hệ 4, cung cấp 192 CPU, 1536 GB bộ nhớ, 50 Gbps Network Bandwidth, 5000 MB/s Max EBS Throughput và 240000 Max IOPS.

Việc giám sát thực thi di chuyển là cần thiết, và bạn có thể tận dụng [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) để tạo dashboard cho giám sát trong cutover. Điều này sẽ giúp xác định bất kỳ nút cổ chai nào hoặc chỉ ra các cơ hội để tinh chỉnh thêm thời gian ngừng hoạt động chuyển đổi Unicode.

Sử dụng [Amazon CloudWatch dashboards](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html), bạn có thể giám sát các [EBS metrics](https://docs.aws.amazon.com/ebs/latest/userguide/using_cloudwatch_ebs.html) liên quan cho throughput (VolumeReadBytes, VolumeWriteBytes hoặc VolumeThroughputPercentage), và IOPS (VolumeReadOps, VolumeWriteOps hoặc VolumeConsumedReadWriteOps) cho các volume quan trọng như volume sapdata (sử dụng cho file Oracle sapdata) và volume sapdump (sử dụng để lưu trữ dữ liệu xuất/nhập từ hệ thống SAP). Ngoài ra, bạn có thể giám sát sử dụng CPU cùng với các metrics khác như throughput và IOPS. Nếu giới hạn không được đạt và [SAP migration time analyzer](https://help.sap.com/doc/3a697dba3b544d3ab0db197f753088b1/CURRENT_VERSION/en-US/MigrationMonitor7xx.pdf) hiển thị một số nhiệm vụ mất lâu hơn, bạn nên tăng số lượng quy trình R3load và cho phép các nhiệm vụ chậm hơn được xử lý trước trong xuất. Bạn có thể kiểm soát thứ tự xuất/nhập bằng thuộc tính orderBy như được mô tả trong phần 2.6.7 của [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf).

Khuyến nghị giám sát các volume chứa Oracle online redo logs, có thể được sử dụng cho cơ chế logging trong xuất/nhập. Điều này áp dụng cho cả instance cơ sở dữ liệu staging và instance cơ sở dữ liệu cuối cùng. Bằng cách giám sát chặt chẽ các metrics này, bạn có thể xác định các nút cổ chai tiềm ẩn và đưa ra quyết định sáng suốt để tối ưu hóa quy trình chuyển đổi Unicode, đảm bảo di chuyển mượt mà và hiệu quả trong thời gian ngừng hoạt động kỹ thuật mong muốn.

Hình 3 minh họa một ví dụ về [Amazon CloudWatch Dashboard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html) hiển thị các metrics quan trọng.

![Amazon CloudWatch Dashboard with important metrics](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/Amazon-CloudWatch-Dashboard-with-important-metrics.jpg)

**Hình 3: Amazon CloudWatch Dashboard với các metrics quan trọng**

### Các Bước Sau Di Chuyển

Trong giai đoạn này, tất cả các hoạt động post-Unicode conversion, post-migration như được nêu trong hướng dẫn chuyển đổi Unicode SAP được đề cập trong [SAP Note 551344](https://me.sap.com/notes/551344/E) và [SAP system copy guide](https://help.sap.com/doc/23afa39273d149f5b747805421f54017/CURRENT_VERSION/en-US/SystemCopy_71X_ux_abap.pdf) được thực hiện. Khi các hoạt động này hoàn thành, bất kỳ tối ưu hóa nào được thực hiện cụ thể cho di chuyển (ví dụ: kích thước instance, IOPS, throughput, tham số SAP/database) được khôi phục về thiết lập ban đầu.

Trước khi bàn giao hệ thống cho xác thực người dùng, đảm bảo rằng một backup hệ thống đang hoạt động đầy đủ. Sau khi di chuyển hoàn thành và được xác thực bởi kinh doanh, hệ thống staging được tắt (và sau đó chấm dứt) để tránh phát sinh chi phí không cần thiết.

Tuân thủ chính xác các bước được quy định đảm bảo kiểm thử post-migration thành công và triển khai sản xuất.

## Kết Luận

Trong bài viết blog này, bạn đã học cách [Bell Canada](https://www.bell.ca/) tận dụng cơ sở hạ tầng có khả năng mở rộng của AWS để hoàn thành chuyển đổi kỹ thuật Unicode của hệ thống ERP Production 11 TB trong vòng dưới 5 giờ và di chuyển thành công sang AWS. Cách tiếp cận này dẫn đến giảm 75% thời gian ngừng hoạt động kỹ thuật so với quy trình chuyển đổi và di chuyển Unicode một bước, mất hơn 24 giờ. Ngoài ra, nó loại bỏ nhu cầu tài nguyên phần cứng tại chỗ bổ sung.

Bằng cách áp dụng cách tiếp cận này, [Bell Canada](https://www.bell.ca/) có thể tối ưu hóa quy trình chuyển đổi và di chuyển Unicode, giảm thiểu gián đoạn kinh doanh và tối đa hóa hiệu quả hoạt động. Khả năng mở rộng và linh hoạt của cơ sở hạ tầng AWS đóng vai trò quan trọng trong việc đạt được thành tựu đáng chú ý này, cho phép [Bell Canada](https://www.bell.ca/) hoàn thành quy trình di chuyển phức tạp trong khung thời gian ngắn hơn đáng kể.

Trong bài blog này, chúng tôi sử dụng [Oracle Data Guard](https://www.oracle.com/in/database/data-guard/) để thiết lập instance staging. Tuy nhiên, có các hạn chế khi thay đổi endianness (Big Endian và Little Endian), chẳng hạn như từ AIX (Big Endian) sang X86_64 (Little Endian), theo tài liệu Oracle [Data Guard Support for Heterogeneous Primary and Physical Standbys in Same Data Guard Configuration](https://support.oracle.com/knowledge/Oracle Cloud/413484_1.html) (yêu cầu đăng nhập hỗ trợ Oracle). [SAP Note 552464](https://me.sap.com/notes/552464/E) hướng dẫn xác định endianness chính xác cho các kiến trúc và hệ điều hành khác nhau. Trong các kịch bản nơi khách hàng cần di chuyển hệ thống SAP non-Unicode trên cơ sở dữ liệu Oracle từ big-endian sang little-endian platform, Oracle Cross-Platform Transportable Tablespaces (XTTS) được sử dụng để di chuyển hệ thống non-Unicode sang AWS theo bài blog [Reducing downtime with Oracle XTTS method for cross-platform SAP migrations](https://aws.amazon.com/blogs/awsforsap/reducing-downtime-with-oracle-xtts-method-for-cross-platform-sap-migrations/). Khi hệ thống non-Unicode có sẵn trên AWS, bạn có thể thực hiện các quy trình xuất và nhập trên AWS theo các bước được nêu trong bài blog này.


<!-- ### Về Các Tác Giả

![Sriram Rajan](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-sriram-rajan.jpg)  
**Sriram Rajan** là Kiến Trúc Sư Giải Pháp Chuyên Gia Chính cho SAP trên AWS. Với hơn 20 năm kinh nghiệm trong công nghệ SAP và đám mây, ông giúp khách hàng kiến trúc và di chuyển các khối lượng công việc SAP sang AWS.

![Gokul Rajaram](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-gokul-rajaram.jpg)  
**Gokul Rajaram** là Kiến Trúc Sư Giải Pháp Cấp Cao tại AWS, chuyên về di chuyển SAP. Ông hỗ trợ khách hàng tối ưu hóa thời gian ngừng hoạt động và tận dụng các dịch vụ AWS cho chuyển đổi Unicode SAP.

![Vijayakumar Subramanian](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/10/author-vijayakumar-subramanian.jpg)  
**Vijayakumar Subramanian** là Tư Vấn SAP Basis tại Bell Canada, với chuyên môn về cơ sở dữ liệu Oracle và di chuyển AWS. -->