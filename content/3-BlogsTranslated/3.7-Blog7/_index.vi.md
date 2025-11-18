---
title: "Blog 7"
weight: 1
chapter: false
pre: " <b> 3.7. </b> "
---

# GNOME có một đối tác cung cấp hạ tầng mới: Chào mừng AWS !

_Bài đăng này được đóng góp bởi Andrea Veri từ Tổ chức GNOME. Được đăng tải lại từ [gnome.org](https://foundation.gnome.org/2025/06/10/gnome-has-a-new-infrastructure-partner-welcome-aws/) với sự cho phép._

[GNOME](https://foundation.gnome.org/) trước đây tự quản lý cơ sở hạ tầng của mình tại chỗ . Điều đó đã thay đổi với 1 chương trình tài trợ [AWS Open Source Credits](https://aws.amazon.com/blogs/opensource/aws-cloud-credits-for-open-source-projects-affirming-our-commitment/) , sự tài trợ này đã cho phép đội ngũ 2 kỹ sư  SRE của chúng tôi di chuyển  phần lớn khối lượng công việc lên Cloud và biến môi trường Openshift hiện tại thành một môi trường có khả năng mở rộng hoàn toàn và chịu lỗi nhờ vào cơ sở hạ tầng được cung cấp bởi AWS . Bằng cách di chuyển lên Cloud, chúng tôi đã giảm đáng kể gánh nặng bảo trì , đạt được độ trễ thấp hơn cho người dùng của chúng tôi và các cộng tác viên và làm tăng tính bảo mật thông qua kiểm soát truy cập tốt hơn.

Cơ sở hạ tầng ban đầu của chúng tôi đã không tính đến sự tăng trưởng theo cấp số nhân mà GNOME đã chứng kiến trong nhiều người đóng góp và cơ sở người dùng trong 4-5 năm qua nhờ vào sự giới thiệu của [GNOME Circle](https://circle.gnome.org/) . GNOME Circle được hình thành bởi nhiều ứng dụng mà không phải là thành phần của lõi GNOME nhưng được định nghĩa để mở rộng hệ sinh thái mà không bị ràng buộc  bởi các chính sách lõi và lịch trình ra mắt nghiêm ngặt . Việc đóng góp trong những dự án này cũng khiến cho những người đóng góp có [đủ điều kiện trở thành GNOME Foundation membership](https://handbook.gnome.org/foundation/membership-benefits.html) và có khả năng cho phép họ nhận quyền truy cập trực tiếp để commit lên Gitlab trong trường hợp các đóng góp của họ diễn ra đều đặn trong một khoảng thời gian dài để nhận được nhiều sự tin tưởng hơn từ cộng đồng . GNOME gần đây cũng đã di chuyển sang GitLab , rời khỏi cgit và Bugzilla.

Trong bài đăng này , chúng tôi muốn chia sẻ 1 số sự cải tiến mà chúng tôi đã làm như là kết quả của việc di chuyển lên Cloud của chúng tôi.

## Lịch sử của những thách thức về mạng và lưu trữ

Trong năm 2020 , chúng tôi đã ghi chép lại những thử thách trong kiến trúc chính của chúng tôi.

1. Cơ sở hạ tầng của chúng tôi đã được xây dựng trên OpenShift trong hệ thống cơ sở hạ tầng siêu hội tụ , sử dụng OpenShift Data Foundations (ODF) , chạy Ceph và Rook ở phía “sau” . Mặt phẳng điều khiển và khối lượng công việc của chúng tôi cũng chạy trên cùng của cùng 1 nút.
2. Bởi vì GNOME trước đây không có mạng L3 và nhìn chung cũng không có kế hoạch nâng cấp thiết bị mạng cơ sở và/hoặc đầu tư thời gian trong việc tái cấu trúc nó , chúng tôi sẽ phải chạy cổng kết nối của mình bằng cách sử dụng máy ảo Linux thông thường với tất cả các hệ quả đi kèm. 
3. Chúng tôi cũng đã muốn tận dụng 1 nhóm Cluster bên ngoài với tốc độ lưu trữ chậm hơn , nhưng điều này đã không được hỗ trợ trong ODF và yêu cầu thêm các thành phần kết nối để làm cho nó hoạt động.
4. Không có thay đổi nào được lên kế hoạch trong phía thiết bị mạng để tạo ra kết nối dự phòng . Điều đó có nghĩa là việc nâng cấp mã code trên các thiết bị chuyển mạch sẽ yêu cầu dừng toàn bộ dịch vụ trong 1 khoảng thời gian.
5. Chúng tôi phải làm việc với đội ngũ hỗ trợ của Dell cho mọi linh kiện phần cứng bị hỏng , việc đó thêm phần vất vả.
6. Với cộng đồng người dùng và người đóng góp GNOME luôn tăng  , chúng tôi chưa bao giờ có cách nào thật sự hiệu quả để mở rộng quy mô tài nguyên máy tính do hạn chế về ngân sách.

## Những sự cải tiến khi di chuyển lên Cloud 

Vào năm 2024 , trong suốt quá trình chu kì làm mới phần cứng , chúng tôi đã bắt đầu đánh giá ý tưởng về việc di chuyển lên Cloud công khai . Chúng tôi đã tham gia chương trình AWS Open Source Credits trong nhiều năm và nhận được sự tài trợ cho 1 bộ của kho lưu trữ Amazon Simple Storage Service (Amazon S3)  , cái mà chúng tôi sử dụng rộng rãi thông qua dịch vụ GNOME . Dựa trên kinh nghiệm trước đó của chúng tôi với những chương trình và những người điều hành nó , Chúng tôi quyết định gửi yêu cầu tài trợ từ AWS cho toàn bộ cơ sở hạ tầng và yêu cầu đã được chấp nhận 1 cách thiện chí.

Tôi tin rằng việc then chốt là để hiểu được tại sao AWS lại giải quyết được những thách thức về cơ sở hạ tầng chúng tôi có khi là 1 đội nhỏ SRE ( chỉ có 2 kỹ sư ) . Điều quan trọng nhất là , việc chuyển đổi này đã giảm đáng kể công việc bảo trì vất vả mà chúng tôi đã phải chịu. 

1. Sử dụng các dịch vụ mạng được định nghĩa bằng phần mềm do AWS cung cấp , chúng tôi không còn phải phụ thuộc vào đội ngũ bên ngoài để thay đổi các cấu trúc mạng cơ sở . Điều này cũng giúp cho chúng tôi 1 cách để dùng các cổng kết nối và NAT dự phòng mà không phải làm lộ các nút xử lý ra ngoài Internet.
2. Chúng tôi hiện giờ dùng các phiên bản  AWS Elastic Load Balancing (ELB) ( bộ cân bằng tải cổ điển là 1 loại duy nhất được hỗ trợ bởi OpenShift cho tới bây giờ ) như là điểm vào lưu lượng truy cập cho nhóm máy chủ OpenShift của chúng tôi . Điều này giúp giảm độ trễ vì chúng tôi bây giờ đang vận hành trong cùng 1 VPC thay vì phụ thuộc vào nhà cung cấp cân bằng tải bên ngoài . Điều này cũng đi kèm khả năng  truy cập vào các API của security group , cái mà  giúp chúng ta dùng thêm các IP một cách động . Điều này là thiết yếu khi chúng tôi có những cá nhân hoặc tổ chức lạm dụng hàng ngàn truy vấn mỗi phút cho các dịch vụ GNOME cụ thể.
3. Chúng tôi cũng sử dụng Amazon Elastic Block Store (Amazon EBS ) và Amazon Elastic File System ( Amazon EFS ) thông qua trình điều khiển OpenShift CSI  . Việc này cho phép chúng tôi tránh được việc phải quản lý cụm máy chủ Ceph , cái mà là một lợi thế lớn trong vấn đề về mặt bảo trì và vận hành.
4. Với các phiên bản AWS Graviton , giờ chúng tôi đã có quyền truy cập vào các máy chủ ARM64 , cái mà chúng tôi có thể tận dụng tối đa vì chúng thường rẻ hơn so với những máy Intel tương đương.
5. Với mức độ rộng rãi mà chúng tôi sử dụng Amazon S3 trên cơ sở hạ tầng , chúng tôi có thể giảm độ trễ và chi phí nhờ việc sử dụng VPC S3 endpoints nội bộ.
6. Chúng tôi tận dụng AWS Identity và Access Management(IAM) để cung cấp quyền truy cập chi tiết đến các dịch vụ AWS , giúp chúng tôi có khả năng cho phép các nhà đóng góp cá nhân để quản lý các bộ tài nguyên giới hạn mà không cần phải quyền cao hơn.
7. Chúng tôi giờ đã hoàn thành việc trừu tượng hóa việc quản lý phần cứng , cái mà thiết yếu cho một đội chỉ có 2 kỹ sư, những người đang cố gắng tránh bất kì gánh nặng bảo trì phát sinh nào.

## Cảm ơn bạn,  AWS!

Tôi muốn cảm ơn AWS vì sự tài trợ dành của họ và cơ hội to lớn mà họ đang trao cho cơ sở hạ tầng GNOME để cung cấp các khối lượng công việc bền bỉ , ổn định và có tính sẵn sàng cao đến những người dùng và người đóng góp của GNOME trên toàn cầu.
