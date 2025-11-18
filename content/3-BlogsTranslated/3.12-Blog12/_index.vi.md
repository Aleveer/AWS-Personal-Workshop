---
title: "Blog 12"
weight: 2
chapter: false
pre: " <b> 3.12. </b> "
---

# Giới thiệu Amazon EBS Volume Clones: Tạo các bản sao tức thì cho EBS volumes của bạn

Với tư cách là người đã làm việc tại [Sun Microsystems](https://en.wikipedia.org/wiki/Sun_Microsystems), nơi mà [ZFS](https://en.wikipedia.org/wiki/ZFS) được phát minh, tôi luôn yêu thích làm việc với các hệ thống lưu trữ có khả năng tạo bản sao volume tức thì cho nhu cầu phát triển và kiểm thử của mình.

Hôm nay, tôi rất vui khi chia sẻ rằng AWS đang mang điều có khả năng tương tự cho [Amazon Elastic Block Store (Amazon EBS)](https://aws.amazon.com/ebs/) với việc ra mắt Amazon EBS Volume Clones, một tính năng mới cho phép bạn tạo các bản sao tức thì ở một thời điểm cụ thể cho các EBS volume của mình bên trong cùng một Availability Zone.

Nhiều khách hàng cần tạo nhiều bản sao về dữ liệu production của họ để hỗ trợ các hoạt động phát triển và kiểm thử trong một môi trường phi production riêng biệt. Cho đến nay, quy trình này đã yêu cầu tạo một EBS snapshot ( được lưu trữ trong [Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) ) và sau đó tạo mới một volume từ snapshot đó. Mặc dù cách tiếp cận này vẫn hoạt động, quy trình này tạo ra gánh nặng vận hành do có nhiều bước.

Với Amazon EBS Volume Clones, bây giờ bạn có thể tạo ra các bản sao EBS volume của bạn với một lệnh gọi API hoặc chọn trên giao diện. Các volume được sao chép luôn sẵn sàng trong vài giây và cung cấp truy cập đến dữ liệu của bạn ngay lập tức với độ trễ một chữ số mili giây. Điều này làm cho tính năng Volume Clones đặc biệt hữu ích cho việc cài đặt tùy chỉnh nhanh chóng ở môi trường kiểm thử với dữ liệu production hoặc tạo ra những bản sao tạm thời của cơ sở dữ liệu cho mục đích phát triển.

### Để tôi giới thiệu cho bạn cách mà Volume Clones hoạt động.

Ở bài viết này, tôi đã tạo ra một ví dụ nho nhỏ về  [Amazon Elastic Compute Cloud (Amazon EC2)](https://aws.amazon.com/ec2/), với một volume được đính kèm. Tôi đã tạo một tệp ở hệ thống tệp gốc với dòng lệnh `echo "Hello CopyVolumes" > hello.txt` .

Để bắt đầu việc sao chép, tôi mở [AWS Management Console](https://console.aws.amazon.com/) ở trên trình duyệt và tôi điều hướng đến __EC2__, __Elastic Block Store__, __Volumes__. Tôi chọn volume mà tôi muốn sao chép.

Lưu ý rằng, tại thời điểm công bố bài viết này, chỉ có các volume đã được mã hóa mới được sao chép.

Trong mục lục __Actions__, tôi chọn tùy chọn __Copy Volume__.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_1.png)

Kế tiếp, tôi chọn chi tiết của volume đích. Tôi có thể thay đổi Volume type và điều chỉnh thông số __Size__, __IOPS__, và __Throughput__. Tôi chọn __Copy volume__ để bắt đầu hoạt động Volume Clone.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_2.png)


Volume được sao chép sẽ chuyển sang trạng thái __Creating__ và sẵn sàng để sử dụng trong vòng vài giây. Sau đó, tôi có thể đính kèm nó vào trong một phiên bản EC2 và bắt đầu sử dụng nó ngay lập tức.

Khối dữ liệu đã được sao chép từ volume nguồn và được viết vào volume bản sao ở chế độ nền. Volume sẽ duy trì ở trạng thái __Initializing__ cho đến khi quá trình này hoàn thành. Tôi có thể theo dõi tiến trình của nó với `describe-volume-status` [API](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVolumeStatus.html). Hoạt động khởi tạo này không ảnh hướng đến hiệu suất của volume nguồn. Tôi có thể tiếp tục sử dụng nó bình thường trong suốt quá trình sao chép.

Tôi rất thích volume được sao chép có thể sử dụng được ngay lập tức. Tôi không cần phải chờ đợi nó khởi tạo hoàn tất. Trong suốt giai đoạn khởi tạo, volume đã được sao chép của tôi sẽ cung cấp hiệu năng dựa trên mức thấp nhất sau : mức cơ bản là 3,000 IOPS và 125 MiB/s, hiệu năng đã cấu hình của volume nguồn, hoặc hiệu năng đã cấu hình của volume bản sao.

Sau quá trình khởi tạo hoàn thành, volume bản sao trở thành bản độc lập đầy đủ của volume nguồn và cung cấp đầy đủ hiệu năng đã cấu hình.

![](/images/3-BlogsTranslated/3.12-Blog12/IMG_3.png)

Ngoài ra, tôi có thể sử dụng [AWS Command Line Interface (AWS CLI)](https://aws.amazon.com/cli/) để bắt đầu việc sao chép :

```
aws ec2 copy-volumes                          \
     --source-volume-id vol-1234567890abcdef0 \
     --size 500                               \
     --volume-type gp3
```

Sau khi volume bàn được đã được tạo, tôi đính kèm nó vào trong phiên bản EC2 của mình và mount nó. Tôi có thể kiểm tra tệp mà tôi đã tạo lúc đầu có tồn tại không.

Đầu tiên, tôi đính kèm volume từ laptop của mình, sử dụng lệnh attach-volume : 

```
aws ec2 attach-volume \
         --volume-id 'vol-09b700e3a23a9b4ad' \
         --instance-id 'i-079e6504ad25b029e'   \
         --device '/dev/sdb'
```

Sau đó, tôi kết nối đến phiên bản, và tôi đánh các lệnh sau : 

```
$ sudo lsblk -f
NAME          FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1                                                                              
├─nvme0n1p1   xfs          /     49e26d9d-0a9d-4667-b93e-a23d1de8eacd    6.2G    22% /
└─nvme0n1p128 vfat   FAT16       3105-2F44                               8.6M    14% /boot/efi
nvme1n1                                                                              
├─nvme1n1p1   xfs          /     49e26d9d-0a9d-4667-b93e-a23d1de8eacd                
└─nvme1n1p128 vfat   FAT16       3105-2F44     

$ sudo mount -t xfs /dev/nvme1n1p1 /data

$ df -h
Filesystem        Size  Used Avail Use% Mounted on
devtmpfs          4.0M     0  4.0M   0% /dev
tmpfs             924M     0  924M   0% /dev/shm
tmpfs             370M  476K  369M   1% /run
/dev/nvme0n1p1    8.0G  1.8G  6.2G  22% /
tmpfs             924M     0  924M   0% /tmp
/dev/nvme0n1p128   10M  1.4M  8.7M  14% /boot/efi
tmpfs             185M     0  185M   0% /run/user/1000
/dev/nvme1n1p1    8.0G  1.8G  6.2G  22% /data

$ cat /data/home/ec2-user/hello.txt 
Hello CopyVolumes
```

### Những điều cần biết

Volume Clones tạo ra bản sao ở trên cùng một AZ với volume nguồn của bạn. Bạn chỉ có thể tạo những bản sao từ volumes được mã hóa, và kích thước của bản sao cần phải bằng hoặc lớn hơn volume nguồn.

Volume Clones tạo ra các bản sao nhất quán tại thời điểm xảy ra sự cố cho các volume của bạn. giống hệt như snapshot. Để đạt được tính nhất quán ở cấp độ ứng dụng, bạn cần phải tạm dừng hoạt động I/O của ứng dụng trước khi tạo ra bản sao. Ví dụ, với cơ sở dữ liệu Postgre SQL, bạn có thể sử dụng các hàm `pg_start_backup()` và `pg_stop_backup()` để tạm dừng viết và tạo bản sao nhất quán. Ở cấp độ điều hành trên Linux với XFS, bạn có thể sử dụng lệnh `xfs_freeze` để đình chỉ tạm thời và khôi phục quyền truy cập đến hệ thống tệp và đảm bảo mọi thứ đã được lưu vào bộ nhớ đệm được viết vào ổ đĩa. 

Mặc dù Volume Clones tạo ra bản sao ngay tại thời điểm cụ thể, nó mang tính bổ sung chứ không thay thế EBS snapshot cho mục đích sao lưu. EBS snapshots vẫn là giải pháp được khuyến nghị dành cho việc sao lưu dữ liệu và bảo vệ chống lại các sự cố ở cấp độ AZ và cấp độ volume. Snapshot cung cấp các bản sao lưu gia tăng lên Amazon S3 với độ bền 11 số 9, so với Volume Clones vốn duy trì độ bền của EBS volume ( 99.999% cho io2, 99,9% cho kiểu volume khác ). Hãy cân nhắc sử dụng tính năng Volume Clones cụ thể dành cho các kịch bản môi trường kiểm thử và phát triển nơi mà bạn cần truy cập tức thì để vào volume bản sao.

Các volume bản sao tồn tại độc lập với các volume nguồn và tiếp tục phát sinh chi phí EBS volume tiêu chuẩn cho đến khi bạn xóa chúng đi. Để quản lý hiệu quả chi phí, thực hiện quyền quản trị để xác định và xóa các volume được sao chép mà không còn cần thiết cho các hoạt động phát triển hay kiếm thử của bạn nữa.

### Giá cả và tính khả dụng

Volume Clones hỗ trợ mọi loại EBS volume và làm việc với volume trên cùng một tài khoản AWS và AZ. Tình năng mới này đã có sẵn ở mọi [Regions](https://docs.aws.amazon.com/glossary/latest/reference/glos-chap.html#region) thuộc về thương mại của AWS, [Local Zones](https://aws.amazon.com/about-aws/global-infrastructure/localzones/locations/) được chọn, và trong [AWS GovCloud (US)](https://aws.amazon.com/govcloud-us/).

Về giá cả, bạn sẽ bị tính chi phí một lần cho mỗi GiB dữ liệu ở volume nguồn tại thời điểm khởi tạo, cùng với mức giá EBS tiêu chuẩn cho volume mới.

Tôi thấy tính năng Volume Clones đặc biệt có giá trị cho các khối lượng công việc liên quan đến cơ sở dữ liệu và các kịch bản tích hợp liên tục (CI). Ví dụ, bạn có thể nhanh chóng tạo một bản sao của cơ sở dữ liệu production để kiểm thử các tính năng mới hoặc khắc phục sự cố mà không làm ảnh hưởng đến môi trường production của bạn hoặc phải chờ dữ liệu được nạp đầy đủ từ Amazon S3.

Để bắt đầu với Amazon EBS Volume Clones, truy cập [Amazon EBS section on the console](https://console.aws.amazon.com/ec2/home#Volumes:) hoặc xem [EBS documentation](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-copying-volume.html). Tôi rất mong được nghe về cách bạn sử dụng tính năng này để cải thiện các quy trình phát triển của mình.