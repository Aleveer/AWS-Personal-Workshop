---
title : "Dọn dẹp tài nguyên"
weight : 6
chapter : false
pre : " <b> 5.6. </b> "
---

#### 1. Dọn dẹp dịch vụ backend được tạo bởi terraform

Để dọn dẹp dịch vụ backend được tạo bởi terraform, chạy lệnh sau trong terminal:

```bash
terraform destroy -var-file="dev.tfvars"
```

Lệnh này sẽ yêu cầu bạn xác nhận việc phá hủy các tài nguyên. Nhập `yes` và nhấn Enter để tiếp tục.

![Terraform Destroy Processing](/images/5-Workshop/5.6-Cleanup/tf-destroy-processing.png)

Khi hoàn tất thành công, bạn sẽ thấy thông báo cho biết các tài nguyên đã được phá hủy, nhưng trong trường hợp này có 2 lỗi là `deleting-s3-bucket` và `ECR-Repository`. Điều này là do S3 bucket không trống và ECR repository chứa images.

![Terraform Destroy Complete](/images/5-Workshop/5.6-Cleanup/tf-destroy-complete.png)

Để xóa hoàn toàn S3 bucket và ECR repository, bạn cần xóa thủ công các đối tượng trong S3 bucket và các images trong ECR repository trên AWS Management Console.

#### 2. Xóa các đối tượng trong S3 bucket

1. Truy cập [S3 console](https://s3.console.aws.amazon.com/s3/home).

2. Tìm bucket có tên `webchat-app-dev-uploads-2025-sg123456` như trong ảnh chụp màn hình bên dưới và nhấp vào nó.

   ![S3 Bucket List](/images/5-Workshop/5.6-Cleanup/aws-s3-bucket.png)

3. Chúng ta cần làm trống bucket trước khi xóa nó. Nhấp vào nút "Empty".

   ![Empty S3 Bucket](/images/5-Workshop/5.6-Cleanup/empty-bucket.png)

4. Xác nhận hành động bằng cách nhập "permanently delete" vào ô input và nhấp vào nút "Empty bucket". Sau một vài phút, bucket sẽ được làm trống.

   ![Confirm Empty S3 Bucket](/images/5-Workshop/5.6-Cleanup/bucket-emptied.png)

5. Bây giờ, quay lại danh sách S3 bucket, chọn lại bucket và nhấp vào nút "Delete" để xóa bucket trống.

   ![Delete S3 Bucket](/images/5-Workshop/5.6-Cleanup/delete-bucket.png)

6. Xác nhận việc xóa bằng cách nhập tên bucket và nhấp vào nút "Delete".

#### 3. Xóa images trong ECR repository

1. Truy cập [ECR console](https://console.aws.amazon.com/ecr/repositories).
2. Tìm repository có tên `webchat-app-dev-backend` và nhấp vào nó.
3. Chọn tất cả images trong repository bằng cách đánh dấu vào checkbox bên cạnh "Image Tag".
4. Nhấp vào nút "Delete" để xóa các images đã chọn.
5. Xác nhận việc xóa image bằng cách nhập "delete" vào ô input và nhấp vào nút "Delete".

   ![Confirm Delete ECR Images](/images/5-Workshop/5.6-Cleanup/ecr-repo-delete-image.png)

6. Sau khi xóa tất cả images trong repository, quay lại terminal và chạy lại lệnh `terraform destroy`:

```bash
terraform destroy -var-file="dev.tfvars"
```

Lần này, lệnh sẽ hoàn thành thành công mà không có lỗi nào.

![Terraform Destroy Complete No Errors](/images/5-Workshop/5.6-Cleanup/tf-destroy-complete-no-error.png)

Sau khi hoàn thành các bước này, bạn đã dọn dẹp thành công dịch vụ backend và tất cả các tài nguyên liên quan được tạo bởi terraform.

#### 4. Dọn dẹp dịch vụ Frontend đã triển khai với Amplify.

1. Truy cập vào Amazon Amplify , chọn App bạn đã deploy.

![Clean Up Amplify](/images/5-Workshop/5.6-Cleanup/cleanupfe.png)

2. Từ thanh bên trái chọn App Settings -> General settings.

![Clean Up Amplify2](/images/5-Workshop/5.6-Cleanup/cleanupfe2.png)

3. Ở mục Delete app ,chọn nút Delete app.

![Clean Up Amplify3](/images/5-Workshop/5.6-Cleanup/cleanupfe3.png)

4. Nhập "delete" để xác nhận muốn xóa App này, rồi nhấn nút Delete app.

![Clean Up Amplify4](/images/5-Workshop/5.6-Cleanup/cleanupfe4.png)

5. Thông báo xóa App thành công, vậy là App Frontend đã được dọn dẹp.

![Clean Up Amplify5](/images/5-Workshop/5.6-Cleanup/cleanupfe5.png)

Sau khi xong các bước trên, chúng ta đã dọn dẹp xong Frontend trên dịch vụ Amplify, tiếp theo chúng ta sẽ dọn dẹp Hosted Zone mà chúng ta đã tạo để Domain trỏ đến Hosted Zone này.

#### 5. Dọn dẹp Hosted Zone trong Route53.

1. Truy cập vào Route53 -> Hosted Zone , chọn Hosted Zone bạn cần dọn dẹp.

![Clean Up Hosted Zone](/images/5-Workshop/5.6-Cleanup/cleanuphostedzone.png)

2. Chọn tất cả các Record ngoại trừ 2 Record mặc định là NS và SOA. Chọn Delete records.

![Clean Up Hosted Zone1](/images/5-Workshop/5.6-Cleanup/cleanuphostedzone1.png)

3. Kiểm tra lại và nhấn Delete.

![Clean Up Hosted Zone2](/images/5-Workshop/5.6-Cleanup/cleanuphostedzone2.png)

4. Sau khi xóa thành công , quay trở lại Hosted Zone, chọn Hosted Zone cần dọn dẹp, nhấn Delete.

![Clean Up Hosted Zone3](/images/5-Workshop/5.6-Cleanup/cleanuphostedzone3.png)

5. Nhập delete để xác nhận muốn xóa Hosted Zone này, nhấn Delete.

![Clean Up Hosted Zone4](/images/5-Workshop/5.6-Cleanup/cleanuphostedzone4.png)

Vậy là đã dọn dẹp thành công các tài nguyên đã sử dụng của dịch vụ AWS.
