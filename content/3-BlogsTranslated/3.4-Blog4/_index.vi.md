---
title: "Blog 4"
weight: 1
chapter: false
pre: " <b> 3.4. </b> "
---

# Kiến Trúc Cơ Sở Amazon Bedrock Trong Một Vùng Hạ Tầng AWS

Khi các tổ chức ngày càng áp dụng [Amazon Bedrock](https://aws.amazon.com/bedrock/) để xây dựng và triển khai các ứng dụng trí tuệ nhân tạo (AI) quy mô lớn, việc hiểu và triển khai các kiểm soát truy cập mạng quan trọng là rất cần thiết nhằm bảo vệ dữ liệu và khối lượng công việc của họ. Các ứng dụng được hỗ trợ bởi trí tuệ nhân tạo sinh tạo này có thể tiếp cận thông tin nhạy cảm hoặc bảo mật trong các cơ sở tri thức, nguồn dữ liệu Tăng Cường Truy Vấn Trả Lời (Retrieval Augmented Generation - RAG), hoặc chính các mô hình, điều này có thể tạo ra rủi ro nếu bị lộ cho các bên không được ủy quyền. Hơn nữa, các tổ chức có thể muốn hạn chế truy cập vào một số mô hình AI nhất định đối với các nhóm hoặc dịch vụ cụ thể, đảm bảo chỉ những người dùng được ủy quyền mới có thể sử dụng các khả năng mạnh mẽ nhất. Một yếu tố quan trọng khác là tối ưu hóa chi phí, vì các tổ chức cần có khả năng giám sát và kiểm soát truy cập để quản lý các khía cạnh khác nhau của chi tiêu đám mây.

Trong bài viết này, chúng tôi khám phá kiến trúc cơ sở Amazon Bedrock và cách thức bảo mật cũng như kiểm soát truy cập mạng đối với các khả năng Amazon Bedrock khác nhau trong các dịch vụ và công cụ mạng AWS. Chúng tôi thảo luận về các cân nhắc thiết kế chính, chẳng hạn như sử dụng [Amazon VPC Lattice](https://aws.amazon.com/vpc/lattice/) với các [chính sách xác thực](https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html), các điểm cuối [Amazon Virtual Private Cloud](https://aws.amazon.com/vpc/) (Amazon VPC), và [Quản Lý Danh Tính Và Truy Cập AWS](https://aws.amazon.com/iam/) (IAM) để hạn chế và giám sát truy cập vào các khả năng Amazon Bedrock.

Đến cuối bài viết này, bạn sẽ có sự hiểu biết tốt hơn về cách cấu hình vùng hạ tầng AWS của mình để thiết lập kết nối mạng an toàn và được kiểm soát đối với Amazon Bedrock trên toàn tổ chức bằng cách sử dụng VPC Lattice.

## Tổng Quan Giải Pháp

Việc giải quyết các thách thức nêu trên đòi hỏi một kiến trúc mạng được thiết kế tốt và các kiểm soát bảo mật. Để thực hiện điều này, chúng tôi sử dụng [cấu hình mạng tiêu chuẩn của AWS Landing Zone Accelerator](https://awslabs.github.io/landing-zone-accelerator-on-aws/v1.6.0/sample-configurations/standard/networking/). Nó cung cấp một điểm khởi đầu tốt để quản lý giao tiếp mạng trên nhiều tài khoản. Trên nền tảng thiết kế mạng AWS Landing Zone Accelerator, chúng tôi thêm hai tài khoản chia sẻ.

Trong thiết kế giải pháp này, chúng tôi tạo ra một kiến trúc tập trung để quản lý các khả năng AI của tổ chức trên các tài khoản khác nhau. Kiến trúc bao gồm ba phần chính hoạt động cùng nhau để cung cấp truy cập an toàn và được kiểm soát vào các dịch vụ AI:

* Tài khoản mạng dịch vụ – Tài khoản này đóng vai trò là trung tâm mạng tập trung cho tổ chức, quản lý kết nối mạng và các chính sách truy cập. Thông qua tài khoản này, các quản trị viên mạng có thể quản lý và kiểm soát tập trung truy cập vào các dịch vụ AI trên toàn tổ chức. Tài khoản tuân thủ [các thực hành mạng AWS Landing Zone Accelerator](https://awslabs.github.io/landing-zone-accelerator-on-aws/v1.6.0/sample-configurations/standard/networking/#architecture) có khả năng mở rộng theo nhu cầu tổ chức doanh nghiệp.
* Tài khoản AI Sinh Tạo – Tài khoản này lưu trữ các khả năng Amazon Bedrock của tổ chức và đóng vai trò là điểm trung tâm cho quản lý AI/ML. Các nhà khoa học AI/ML và kỹ sư prompt của tổ chức sẽ xây dựng và quản lý tập trung các khả năng Amazon Bedrock. Tài khoản cung cấp truy cập vào các mô hình ngôn ngữ lớn (Large Language Models - LLMs) thông qua Amazon Bedrock bằng cách sử dụng các điểm cuối giao diện VPC, đồng thời cho phép giám sát tập trung chi phí tiêu thụ và mô hình truy cập.
* Các tài khoản khối lượng công việc (dev, test, prod) – Các tài khoản này đại diện cho các môi trường khác nhau nơi các nhóm phát triển và triển khai các ứng dụng tiêu thụ dịch vụ AI. Thông qua các kết nối mạng an toàn được thiết lập qua tài khoản mạng dịch vụ, các tài khoản khối lượng công việc này có thể truy cập các khả năng AI được lưu trữ trong tài khoản AI sinh tạo. Sự phân tách này thực thi sự cô lập đúng đắn giữa các khối lượng công việc phát triển, kiểm thử và sản xuất trong khi duy trì truy cập an toàn vào các dịch vụ AI.

![Kiến trúc cơ sở Amazon Bedrock trong một vùng hạ tầng AWS](https://d2908q01vomqb2.cloudfront.net/fc074d501302eb2b93e2554793fcaf50b3bf7291/2025/06/18/ARCHBLOG-1133-image-1.png)

*Kiến trúc cơ sở Amazon Bedrock trong một vùng hạ tầng AWS*

Sơ đồ sau minh họa kiến trúc giải pháp.

Tài khoản mạng dịch vụ có mạng dịch vụ VPC Lattice riêng – một cấu trúc mạng tập trung cho phép giao tiếp dịch vụ-đến-dịch vụ trên toàn tổ chức, được chia sẻ với các tài khoản khối lượng công việc bằng cách sử dụng [AWS Resource Access Manager](https://aws.amazon.com/ram/) (AWS RAM) để kích hoạt chia sẻ mạng dịch vụ VPC Lattice.

Các tài khoản khối lượng công việc (dev, test, prod) thiết lập các liên kết VPC với mạng dịch vụ VPC Lattice được chia sẻ bằng cách tạo một liên kết mạng dịch vụ trong VPC của chúng. Khi một ứng dụng trong các tài khoản này thực hiện yêu cầu, nó đầu tiên truy vấn bộ phân giải VPC để phân giải DNS. Bộ phân giải định tuyến lưu lượng đến mạng dịch vụ VPC Lattice.

Kiểm soát truy cập được triển khai thông qua [chính sách xác thực VPC Lattice](https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html). Các chính sách mạng dịch vụ xác định tài khoản nào có thể truy cập mạng dịch vụ VPC Lattice, và các chính sách cấp dịch vụ kiểm soát truy cập vào các dịch vụ AI cụ thể và định nghĩa các hành động mà mỗi tài khoản có thể thực hiện.

Trong tài khoản dịch vụ AI trung tâm, chúng tôi tìm thấy lớp proxy, nơi chúng tôi tạo một dịch vụ VPC Lattice trỏ đến lớp proxy, đóng vai trò là điểm nhập duy nhất, cung cấp cho các tài khoản khối lượng công việc truy cập vào Amazon Bedrock. Lớp proxy này sau đó kết nối với Amazon Bedrock thông qua các điểm cuối VPC. Thông qua thiết lập này, nhóm AI có thể cấu hình các mô hình nền tảng (Foundation Models - FMs) nào có sẵn và quản lý quyền truy cập cho các tài khoản khối lượng công việc khác nhau. Sau khi các chính sách và kết nối cần thiết được triển khai, các tài khoản khối lượng công việc có thể truy cập các khả năng Amazon Bedrock thông qua đường dẫn an toàn đã được thiết lập. Thiết lập này kích hoạt truy cập liên tài khoản an toàn vào các dịch vụ AI trong khi duy trì kiểm soát và giám sát tập trung.

## Các Thành Phần Mạng

Chúng tôi sử dụng VPC Lattice, một dịch vụ mạng ứng dụng được quản lý hoàn toàn giúp đơn giản hóa kết nối mạng, bảo mật và giám sát cho các nhu cầu giao tiếp dịch vụ-đến-dịch vụ. Với VPC Lattice, các tổ chức có thể đạt được một mô hình kết nối tập trung để kiểm soát và giám sát truy cập vào các dịch vụ cần thiết cho việc xây dựng các ứng dụng AI sinh tạo.

Để biết chi tiết về VPC Lattice, hãy tham khảo [Hướng Dẫn Người Dùng Amazon VPC Lattice](https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html). Dưới đây là tổng quan về các cấu trúc có thể sử dụng trong việc thiết lập mô hình tập trung trong giải pháp này:

* Mạng dịch vụ VPC Lattice – Bạn có thể sử dụng mạng dịch vụ VPC Lattice để cung cấp kết nối và bảo mật tập trung vào tài khoản dịch vụ AI trung tâm. Mạng dịch vụ là một cơ chế nhóm logic đơn giản hóa cách thức kích hoạt kết nối trên các VPC hoặc tài khoản, và áp dụng các chính sách bảo mật chung cho các mô hình giao tiếp ứng dụng. Bạn có thể tạo một mạng dịch vụ trong một tài khoản và chia sẻ nó với các tài khoản khác trong hoặc ngoài [AWS Organizations](https://aws.amazon.com/organizations/) bằng cách sử dụng AWS RAM.
* Dịch vụ VPC Lattice – Trong một mạng dịch vụ, bạn có thể liên kết một dịch vụ VPC Lattice, bao gồm một bộ lắng nghe (giao thức và số cổng), các quy tắc định tuyến cho phép kiểm soát luồng ứng dụng (ví dụ: dựa trên đường dẫn, phương thức, tiêu đề hoặc định tuyến có trọng số), và nhóm mục tiêu định nghĩa cơ sở hạ tầng ứng dụng. Một dịch vụ có thể có nhiều bộ lắng nghe để đáp ứng các khả năng client khác nhau. Các giao thức được hỗ trợ bao gồm HTTP, HTTPS, gRPC và TLS. Định tuyến dựa trên đường dẫn cho phép kiểm soát đối với các FMs hiệu suất cao và các khả năng khác cần thiết để xây dựng ứng dụng AI sinh tạo.
* Lớp proxy – Bạn sử dụng lớp proxy cho nhóm mục tiêu của dịch vụ VPC Lattice. Lớp proxy có thể được xây dựng dựa trên sở thích dịch vụ AWS của tổ chức, chẳng hạn như [AWS Lambda](http://aws.amazon.com/lambda), [AWS Fargate](https://aws.amazon.com/fargate), hoặc [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/) (Amazon EKS). Mục đích của lớp proxy là cung cấp một điểm nhập duy nhất để truy cập LLMs, cơ sở tri thức và các khả năng khác đã được kiểm thử và phê duyệt theo yêu cầu tuân thủ của tổ chức.
* Chính sách xác thực VPC Lattice – Để bảo mật, bạn sử dụng chính sách xác thực VPC Lattice. Các chính sách xác thực VPC Lattice được chỉ định bằng cú pháp tương tự như chính sách IAM. Bạn có thể áp dụng chính sách xác thực cho mạng dịch vụ VPC Lattice cũng như cho dịch vụ VPC Lattice.
* Tên Miền Đầy Đủ Đủ (Fully Qualified Domain Names - FQDNs) – Để hỗ trợ khám phá dịch vụ, VPC Lattice hỗ trợ tên miền tùy chỉnh cho các dịch vụ và tài nguyên của bạn, và duy trì FQDN cho mỗi dịch vụ và tài nguyên VPC Lattice bạn định nghĩa. Bạn có thể sử dụng các FQDN này trong cấu hình vùng lưu trữ riêng [Amazon Route 53](https://aws.amazon.com/route53/), và trao quyền cho các đơn vị kinh doanh hoặc nhóm khám phá và truy cập dịch vụ và tài nguyên.
* VPC mạng dịch vụ – Các đơn vị kinh doanh hoặc nhóm có thể truy cập các dịch vụ AI sinh tạo trong một mạng dịch vụ bằng cách sử dụng liên kết VPC mạng dịch vụ hoặc điểm cuối VPC mạng dịch vụ.
* Giám sát – Bạn có thể chọn kích hoạt giám sát ở cấp độ mạng dịch vụ VPC Lattice và cấp độ dịch vụ VPC Lattice. VPC Lattice tạo ra các chỉ số và nhật ký cho các yêu cầu và phản hồi, giúp giám sát và khắc phục sự cố ứng dụng hiệu quả hơn.

Hướng dẫn trên áp dụng cách tiếp cận “an toàn theo mặc định” – bạn phải chỉ rõ các tính năng, mô hình, v.v. nào nên được truy cập bởi đơn vị kinh doanh nào. Thiết lập này cũng cho phép triển khai chiến lược phòng thủ sâu tại nhiều lớp mạng:

* Lớp phòng thủ đầu tiên là nhóm kinh doanh cần kết nối với mạng dịch vụ để truy cập dịch vụ AI sinh tạo qua tài khoản dịch vụ AI trung tâm.
* Lớp thứ hai bao gồm các bảo vệ bảo mật cấp mạng trong VPC của nhóm kinh doanh cho mạng dịch vụ, chẳng hạn như nhóm bảo mật và danh sách kiểm soát truy cập mạng (Network Access Control Lists - ACLs). Bằng cách sử dụng chúng, bạn có thể cho phép truy cập vào các khối lượng công việc hoặc nhóm cụ thể trong một VPC.
* Lớp thứ ba là qua chính sách xác thực VPC Lattice, mà bạn có thể áp dụng ở hai lớp: ở cấp độ mạng dịch vụ để cho phép các yêu cầu được xác thực trong tổ chức, và ở cấp độ dịch vụ để cho phép truy cập vào các mô hình và tính năng cụ thể.

## Chính Sách Xác Thực VPC Lattice

Giải pháp này làm cho việc quản lý tập trung truy cập vào các tài nguyên Amazon Bedrock trên toàn tổ chức trở nên khả thi. Cách tiếp cận này sử dụng chính sách xác thực VPC Lattice để kiểm soát tập trung các tài nguyên Amazon Bedrock và quản lý chúng từ một vị trí duy nhất trên tất cả các tài khoản tổ chức.

Thông thường, chính sách xác thực trên mạng dịch vụ được vận hành bởi quản trị viên mạng hoặc đám mây. Ví dụ, chỉ cho phép các yêu cầu được xác thực từ các khối lượng công việc hoặc nhóm cụ thể trong tổ chức AWS của bạn. Trong ví dụ sau, truy cập được cấp để kích hoạt dịch vụ AI sinh tạo cho các yêu cầu được xác thực và cho các nguyên tắc là phần của tổ chức `o-123456example`:

```
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": "*",
         "Action": "vpc-lattice-svcs:Invoke",
         "Resource": "*",
         "Condition": {
            "StringEquals": {
                "aws:PrincipalOrgID": [ 
                   "o-123456example"
                ]
            }
         }
      }
   ]
}
```

Chính sách xác thực ở cấp độ dịch vụ được quản lý bởi nhóm dịch vụ AI trung tâm để thiết lập các kiểm soát chi tiết, có thể hạn chế hơn so với ủy quyền thô ở cấp độ mạng dịch vụ. Ví dụ, chính sách sau hạn chế truy cập vào `claude-3-haiku` chỉ cho `business-team1`:

```
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect": "Allow",
         "Principal": {
            "AWS": [
               "arn:aws:iam::<account-number>:role/businss-team1"
            ]
         },
         "Action": "vpc-lattice-svcs:Invoke",
         "Resource": [
            "arn:aws:vpc-lattice:<aws-region>:<account-number>:service/svc-0123456789abcdef0/*"
         ],
         "Condition": {
            "StringEquals": {
                "vpc-lattice-svcs:RequestQueryString/modelid": "claude-3-haiku" 
            }
         }
      }
   ]
}
```

## Giám Sát Và Theo Dõi

Thiết kế này sử dụng ba cách tiếp cận giám sát, sử dụng [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/), [AWS CloudTrail](https://aws.amazon.com/cloudtrail/), và nhật ký truy cập VPC Lattice. Chiến lược này cung cấp cái nhìn về việc sử dụng dịch vụ, bảo mật và hiệu suất.

Các chỉ số CloudWatch cung cấp giám sát thời gian thực về hiệu suất và sử dụng dịch vụ VPC Lattice. CloudWatch theo dõi các chỉ số như số lượng yêu cầu và thời gian phản hồi cho các điểm cuối liên quan đến Amazon Bedrock, cho phép thiết lập cảnh báo để quản lý chủ động sức khỏe dịch vụ và dung lượng. Điều này kích hoạt giám sát các mô hình sử dụng tổng thể của các mô hình Amazon Bedrock trên các đơn vị kinh doanh khác nhau, hỗ trợ lập kế hoạch dung lượng và phân bổ tài nguyên. CloudTrail cung cấp kiểm toán cấp API chi tiết về các hành động liên quan đến Amazon Bedrock. Nó ghi nhật ký các nỗ lực truy cập liên tài khoản và tương tác với các dịch vụ Amazon Bedrock, cung cấp dấu vết kiểm toán tuân thủ và bảo mật. Việc theo dõi ai đang truy cập mô hình Amazon Bedrock nào, khi nào và từ tài khoản nào giúp các tổ chức tuân thủ các chính sách tổ chức của họ. Nhật ký truy cập VPC Lattice cung cấp cái nhìn chi tiết về các yêu cầu HTTP/HTTPS đến các dịch vụ Amazon Bedrock, ghi nhận các mô hình sử dụng cụ thể của các mô hình AI bởi các nhóm kinh doanh khác nhau. Các nhật ký này chứa thông tin cụ thể của client, ví dụ có thể được sử dụng để kích hoạt các khả năng như mô hình tính phí ngược. Điều này cho phép phân bổ chi phí sử dụng dịch vụ AI chính xác cho các nhóm hoặc bộ phận cụ thể, hỗ trợ phân bổ chi phí công bằng và sử dụng tài nguyên có trách nhiệm trên toàn tổ chức. Các dịch vụ này hoạt động cùng nhau để nâng cao bảo mật, tối ưu hóa hiệu suất và cung cấp các cái nhìn có giá trị để quản lý truy cập liên tài khoản vào Amazon Bedrock.

## Kết Luận

Trong bài viết này, chúng tôi đã khám phá tầm quan trọng của việc bảo mật và kiểm soát truy cập mạng vào các khả năng Amazon Bedrock trong vùng hạ tầng AWS của tổ chức. Chúng tôi đã thảo luận về các thách thức kinh doanh chính, chẳng hạn như nhu cầu bảo vệ thông tin nhạy cảm trong các cơ sở tri thức Amazon Bedrock, hạn chế truy cập vào các mô hình AI và tối ưu hóa chi phí đám mây bằng cách giám sát và kiểm soát các khả năng Amazon Bedrock. Để giải quyết các thách thức này, chúng tôi đã phác thảo một giải pháp mạng đa lớp sử dụng các dịch vụ mạng AWS, bao gồm chính sách xác thực VPC Lattice để hạn chế và giám sát truy cập vào các khả năng Amazon Bedrock. Hãy thử giải pháp này cho trường hợp sử dụng của bạn và chia sẻ phản hồi trong phần bình luận.

### Về Các Tác Giả

![Abdel-Rahman Awad](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abdel-rahman-awad.jpg)

### Abdel-Rahman Awad

Lãnh đạo Kỹ thuật tại AWS với gần hai thập kỷ kinh nghiệm trong ngành CNTT, ông hướng dẫn các tổ chức lớn qua hành trình đám mây của họ, làm việc với các bên liên quan từ nhóm kỹ thuật đến các lãnh đạo cấp C.

![Abeer Binzaid](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abeer-binzaid.jpg)

### Abeer Binzaid

Abeer Binzaid là Kiến trúc sư Giải pháp tại Amazon Web Services (AWS), hỗ trợ khách hàng trong khu vực MENAT như một phần của đội ngũ Trung tâm Bán hàng Đám mây. Abeer đam mê mạng đám mây, trí tuệ nhân tạo sinh tạo và hỗ trợ khách hàng đẩy nhanh chuyển đổi số bằng cách áp dụng các kiến trúc đám mây hiện đại.

![Ankit Gupta](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-ankit-gupta.jpg)

### Ankit Gupta

Ankit Gupta là Kiến trúc sư Giải pháp Cấp cao tại Amazon Web Services (AWS), nơi ông chuyên làm việc với khách hàng Dịch vụ Phần mềm Như Một Dịch vụ (SaaS). Ankit giúp khách hàng thiết kế và triển khai các giải pháp có khả năng mở rộng cao và kiên cường trên AWS. Là một chuyên gia mạng, Ankit làm việc rộng rãi với các dịch vụ mạng AWS, cung cấp hướng dẫn cho khách hàng trên khu vực EMEA trong việc xây dựng các kiến trúc mạng mạnh mẽ và có khả năng mở rộng. Khi không thiết kế giải pháp đám mây, Ankit có thể được tìm thấy trên sân cầu lông theo đuổi niềm đam mê với các môn thể thao vợt.


<!-- ### Về Các Tác Giả

![Abdel-Rahman Awad](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abdel-rahman-awad.jpg)

### Abdel-Rahman Awad

Lãnh đạo Kỹ thuật tại AWS với gần hai thập kỷ kinh nghiệm trong ngành CNTT, ông hướng dẫn các tổ chức lớn qua hành trình đám mây của họ, làm việc với các bên liên quan từ nhóm kỹ thuật đến các lãnh đạo cấp C.

![Abeer Binzaid](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-abeer-binzaid.jpg)

### Abeer Binzaid

Abeer Binzaid là Kiến trúc sư Giải pháp tại Amazon Web Services (AWS), hỗ trợ khách hàng trong khu vực MENAT như một phần của đội ngũ Trung tâm Bán hàng Đám mây. Abeer đam mê mạng đám mây, trí tuệ nhân tạo sinh tạo và hỗ trợ khách hàng đẩy nhanh chuyển đổi số bằng cách áp dụng các kiến trúc đám mây hiện đại.

![Ankit Gupta](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b1041e5a6a9d7c3f2087/2024/10/15/images/author-ankit-gupta.jpg)

### Ankit Gupta

Ankit Gupta là Kiến trúc sư Giải pháp Cấp cao tại Amazon Web Services (AWS), nơi ông chuyên làm việc với khách hàng Dịch vụ Phần mềm Như Một Dịch vụ (SaaS). Ankit giúp khách hàng thiết kế và triển khai các giải pháp có khả năng mở rộng cao và kiên cường trên AWS. Là một chuyên gia mạng, Ankit làm việc rộng rãi với các dịch vụ mạng AWS, cung cấp hướng dẫn cho khách hàng trên khu vực EMEA trong việc xây dựng các kiến trúc mạng mạnh mẽ và có khả năng mở rộng. Khi không thiết kế giải pháp đám mây, Ankit có thể được tìm thấy trên sân cầu lông theo đuổi niềm đam mê với các môn thể thao vợt. -->