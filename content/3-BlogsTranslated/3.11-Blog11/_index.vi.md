---
title: "Blog 11"
weight: 2
chapter: false
pre: " <b> 3.11. </b> "
---

# Theo dõi, phân tích, và quản lý cách sử dụng công suất từ một giao diện duy nhất với Amazon EC2 Capacity Manager

Hôm nay, tôi rất vui khi giới thiệu về Amazon EC2 Capacity Manager, một giải pháp tập trung vào theo dõi, phân tích, và quản lý cách sử dụng công suất trên mọi tài khoản và AWS Regions từ một giao diện duy nhất. Dịch vụ này tổng hợp thông tin về công suất với tốc độ làm mới hàng giờ và cung cấp những lựa chọn tối ưu hóa được ưu tiên, đơn giản hóa quy trình quản lý công suất mà trước đây cần đến tự động hóa tùy chỉnh và thu thập dữ liệu thủ công từ nhiều dịch vụ AWS.

Các tổ chức sử dụng [Amazon Elastic Compute Cloud (Amazon EC2)](https://aws.amazon.com/ec2/) ở quy mô lớn vận hành hàng trăm loại phiên bản trên nhiều Availability Zone và nhiều tài khoản, sử dụng On-Demand Instances, Spot Instances, và Capacity Reservations. Sự phức tạp này có nghĩa rằng những khách hàng hiện nay phải truy cập dữ liệu công suất thông qua nhiều dịch vụ AWS bao gồm [AWS Management Console](https://aws.amazon.com/console/), [Cost and Usage Reports](https://aws.amazon.com/aws-cost-management/aws-cost-and-usage-reporting/), [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) và EC2 `describe` APIs. Cách tiếp cận phân tán này có thể làm tăng khối lượng công việc vận hành do phải thu thập dữ liệu thủ công, chuyển đổi ngữ cảnh giữa các công cụ, và xây dựng các quy trình tự động tùy chỉnh để tổng hợp thông tin phục vụ cho việc phân tích tối ưu hóa công suất.

EC2 Capacity Manager giúp bạn vượt qua những phức tạp trong vận hành bằng cách hợp nhất mọi công suất dữ liệu vào trong một bảng điều khiển thống nhất. Bạn bây giờ có thể xem số liệu công suất của cross-account và cross-Region cho các phiên bản On-Demand Instances, Spot Instances, và Capacity Reservations trên tất cả AWS Regions thương mại từ một vị trí duy nhất, loại bỏ nhu cầu phải xây dựng các công cụ thu thập dữ liệu tùy chỉnh hoặc điều hướng giữa nhiều dịch vụ AWS.

Khả năng hiển thị hợp nhất có thể giúp bạn khám phá cách tiết kiệm chi phí bằng cách làm nổi bật những Capacity Reservations chưa được sử dụng hiệu quả, phân tích các mẫu sử dụng giữa các loại phiên bản, và cung cấp thông tin chuyên sâu về mô hình gián đoạn Spot Instance. Bằng cách truy cập vào dữ liệu công suất toàn diện trên một vùng, bạn có thể đưa ra quyết định sáng suốt hơn về việc tối ưu kích thước hạ tầng và tối ưu hóa chi tiêu EC2.

Để tôi giới thiệu chi tiết về khả năng của EC2 Capacity Manager.

### Bắt đầu với EC2 Capacity Manager

Trên giao diện AWS Management Console, ta điều hướng đến Amazon EC2 và chọn Capacity Manager từ ngăn điều hướng. Ta kích hoạt EC2 Capacity Manager thông qua các cài đặt dịch vụ. Dịch vụ tổng hợp dữ liệu lịch sử từ 14 ngày trước đó trong quá trình thiết lập ban đầu.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_1.png)

Trên __bảng điều khiển__ chính hiển thị mức độ sử dụng công suất trên tất cả các loại phiên bản thông qua phần tổng quan toàn diện, nơi trình bày các chỉ số chính một cách trực quan. Các thẻ tổng quan công suất cho __Reservations__, __Usage__ và __Spot__ hiển thị xu hướng các chỉ số và sự thay đổi phần trăm để giúp bạn nhận dạng các mẫu công suất nhanh chóng. Bạn có thể áp dụng bộ lọc thông qua điều khiển bộ lọc theo ngày, bao gồm lựa chọn phạm vi ngày, cấu hình múi giờ, và thiết lập khoảng thời gian.

Bạn có thể chọn những đơn vị khác để phân tích dữ liệu theo vCPUS, số lượng phiên bản, hay ước lượng chi phí để hiểu hơn về các mẫu tiêu thụ tài nguyên. Ước lượng chi phí dựa vào mức giá On-Demand đã công bố và không bao gồm Savings Plans hay những phiếu giảm giá khác. Dựa vào mức giá này giúp bạn so sánh tác động tương đối của công suất chưa được tận dụng hết trên các loại phiên bản khác nhau - Ví dụ, 100 giờ vCPU của đặt trước p5 không sử dụng thể hiện tác động chi phí lớn hơn so với 100 giờ vCPU của đặt trước t3 không sử dụng.

Bảng điều khiển bao gồm chi tiết về __Usage metrics__ với cả trực quan hóa tổng thể mức sử dụng và biểu đồ mức sử dụng theo thời gian. Phần tổng thể mức sử dụng thể hiện sự phân tích chi tiết giữa mức sử dụng đã đặt trước, mức sử dụng chưa được đặt trước và Spot usage. Phần biểu đồ mức sử dụng theo thời gian cung cấp thể hiện hình ảnh trực quan hóa xu hướng công suất theo thời gian, giúp bạn nhận diện các mô hình sử dụng và những giai đoạn có nhu cầu cao điểm.

Trong mục __Reservation metrics__, __Reserved capacity trends__ trực quan hóa mức sử dụng và không sử dụng công suất đã được đặt trước dựa vào thời gian đã đưa ra, thể hiện tỉ lệ số giờ vCPU đã được đặt trước vẫn chưa được sử dụng so với lượng thời gian sử dụng thực tế, giúp bạn theo dõi các mẫu về hiệu quả sử dụng gói đặt trước và xác định các giai đoạn có mức sử dụng thấp kéo dài. Khả năng hiển thị này giúp bạn giảm bớt chi phí bằng cách xác định mức sử dụng tài nguyên đặt trước chưa sử dụng hiệu quả và giúp cho bạn đưa ra các quyết định hợp lý về điều chỉnh công suất.

Phần __Unused capacity__ liệt kê công suất đã được đặt trước mà chưa được sử dụng hiệu quả theo từng tổ hợp loại phiên bản và kết hợp Availability Zone ( AZ ), hiển thị cụ thể phần trăm khả năng và loại phiên bản trên những AZ khác. Danh sách được ưu tiên này giúp bạn nhận ra những khả năng tiết kiệm bằng cách hiển thị trực tiếp trên chi phí công suất chưa chưa được sử dụng.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_2.png)

Mục __Usage__ cung cấp xu hướng lịch sử và thống kê sử dụng chi tiết trên mọi AWS Regions cho Spot Instances, On-Demand Instance, và Capacity Reservation. Mức sử dụng Dedicated Hosts không được bao gồm. Dimension filter giúp bạn nhóm và lọc dữ liệu công suất bằng Account ID ( Mã tài khoản ), Region ( Vùng ), Instance Family ( Họ phiên bản ), AZ, và Instance Type ( Loại phiên bản ), tạo chế độ xem tùy chỉnh giúp làm rõ mẫu sử dụng trên các tài khoản của bạn và AWS Organizations. Điều này giúp bạn phân tích cấu hình cụ thể và so sánh hiệu suất trên các tài khoản hoặc các vùng ( Regions ).

Phần __Aggregations__ cung cấp một bảng sử dụng toàn diện trên EC2 và Spot Instances. Bạn có thể chọn các đơn vị phân tích dữ liệu khác nhau như vCPUS, số lượng phiên bản, hay chi phí ước tính để hiểu hơn về mẫu tiêu thụ tài nguyên. Bảng hiển thị phân tích chi tiết theo họ phiên bản với thống kê sử dụng tổng, số giờ sử dụng đặt trước, số giờ sử dụng không đặt trước, và dữ liệu sử dụng Spot. Mỗi hàng bao gồm một hành động __View breakdown__ để phân tích chi tiết.

Mục __Capacity usage or estimated cost trends__ trực quan hóa các xu hướng sử dụng, mức sử dụng đặt trước, mức sử dụng không đặt trước, và mức sử dụng Spot. Bạn có thể lọc dữ liệu hiển thị và đơn vị đo lường để xem mẫu lịch sử. Những công cụ lọc và phân tích giúp bạn xác định mức sử dụng xu hướng, so sánh chi phí giữa các chiều dữ liệu khác nhau, và đưa ra những quyết định sáng suốt cho việc lập kế hoạch và tối ưu hóa công suất.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_3.png)

Khi bạn chọn __View breakdown__ từ bảng __Aggregations__, bạn truy cập chi tiết __Usage breakdown__ dựa vào các bộ lọc theo chiều dữ liệu mà bạn đã chọn. Chế độ xem chi tiết này hiển thị các mẫu mức sử dụng cho từng loại phiên bản riêng lẻ trong phạm vi họ phiên bản và kết hợp AZ đã chọn.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_4.png)

Thẻ __Reservations__ hiển thị mức tận dụng của công suất đã được đặt trước với phân tích tự động khả năng mà tạo ra danh sách ưu tiên về các lựa chọn được tối ưu hóa. Tương tự như thẻ __Usage__, bạn có thể áp dụng bộ lọc theo chiều dữ liệu về Account ID ( Mã tài khoản ), Region ( Vùng ), Instance Family ( Họ phiên bản ), AZ, và Instance Type ( Loại phiên bản ) cùng với các lựa chọn bổ sung liên quan đến chi tiết của các gói được đặt trước. Trên mỗi thẻ, bạn có thể đi sâu vào để xem dữ liệu cho từng mục riêng lẻ. Cụ thể đối với các gói đặt trước, bạn có thể xem các gói đặt trước cụ thể và truy cập vào thông tin chi tiết về On-Demand Capacity Reservations ( ODCRs ), bao gồm lịch sử sử dụng, thông số cấu hình, và trạng thái hiện tại. Khi ODCR tồn tại trong cùng một tài khoản với Capacity Manager, bạn có thể thay đổi trực tiếp thông số gói được đặt trước trên giao diện này, loại bỏ nhu cầu điều hướng đến các phần riêng biệt trên bảng điều khiển EC2 để quản lý việc đặt trước.

Phần __Statistics__ cung cấp bảng số liệu tóm tắt, bao gồm tổng số lượng gói đặt trước, phần trăm tận dụng tổng thể, tổng mức công suất được đặt trước, số lượng mức công suất đã dùng và chưa dùng, số lượng đặt trước theo lịch trình trung bình, và số lượng tài khoản, họ phiên bản, và Regions ( Vùng ) mà có gói đặt trước.

Góc nhìn tổng thể này giúp bạn hiểu cách phân bổ gói đặt trước và các mẫu tận dụng trên cơ sở hạ tầng của bạn. Ví dụ, bạn có thể phát hiện các tài khoản phát triển của mình liên tục cho thấy mức tận dụng gói đặt trước là 30% trong khi các tài khoản production vượt quá 95%, chỉ ra lựa chọn để phân bổ lại hoặc sửa đổi gói đặt trước. Tương tự, bạn cũng có thể xác định các họ phiên bản cụ thể ở một số Region ( Vùng ) nhất định có tỉ lệ tận dụng thấp kéo dài, gợi ý những đối tượng cho việc điều chỉnh gói đặt trước hay tối ưu hóa khối lượng công việc. Những thông tin chuyên sâu này giúp bạn đưa ra các quyết định dựa trên dữ liệu về việc mua, sửa đổi, hoặc hủy bỏ các gói đặt trước để điều chỉnh mức công suất được đặt trước của bạn phù hợp hơn với các mẫu mức sử dụng thực tế.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_5.png)

Thẻ __Spot__ tập trung vào mức sử dụng Spot Instance và hiển thị lượng thời gian mà Spot Instance của bạn chạy trước khi bị gián đoạn. Việc phân tích mẫu mức sử dụng Spot Instance giúp bạn xác định được những cái lựa chọn tối ưu cho khối lượng công việc. Bạn có thể sử dụng các đề xuất về điểm xếp hạng Spot để cải thiện sự linh hoạt của khối lượng công việc.

Đối với các tổ chức yêu cầu khả năng xuất dữ liệu, Capacity Manager bao gồm tính năng xuất dữ liệu ra các bucket [Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) để phân tích công suất. Bạn có thể xem và quản lý tác vụ xuất dữ liệu của mình thông qua thẻ __Data exports__, giúp bạn tạo mới các tác vụ xuất, giám sát trạng thái vận chuyển, và cấu hình lịch trình xuất để phân tích dữ liệu công suất bền ngoài AWS Management Console.

Việc truy xuất dữ liệu mở rộng khả năng phân tích của bạn bằng cách lưu trữ dữ liệu công suất vượt quá thời gian lưu trữ 90 ngày có sẵn thông qua bảng điều khiển và APIs. Việc lưu trữ kéo dài này cho phép phân tích xu hướng dài hạn và lập kế hoạch mức công suất dựa trên dữ liệu lịch sử. Bạn cũng có thể tích hợp xuất dữ liệu với quy trình làm việc phân tích hiện có, các công cụ kinh doanh thông minh, hay hệ thống báo cáo cá tùy chỉnh để đưa ra số liệu công suất EC2 vào các quá trình phân tích cơ sở hạ tầng và ra quyết định ở phạm vi rộng hơn.

![](/images/3-BlogsTranslated/3.11-Blog11/IMG_6.png)

Phần __Settings__ cung cấp các lựa chọn cấu hình cho việc tích hợp AWS Organizations, cho phép quản lý công suất tập trung trên nhiều tài khoản. Quản trị viên của tổ chức có thể bật khả năng hiển thị công suất trên toàn doanh nghiệp hoặc ủy quyền truy cập cho những tài khoản cụ thể trong khi vẫn duy trì các quyền và kiểm soát truy cập phù hợp.

### Khả dụng hiện tại

EC2 Capacity Manager loại bỏ gánh nặng vận hàng của việc thu thập và phân tích dữ liệu công suất từ nhiều nguồn khác nhau. Dịch vụ cung cấp những lựa chọn tối ưu hóa tự động, khả năng hiển thị tập trung trên nhiều tài khoản, và quyền truy cập trực tiếp tới công cụ quản lý công suất. Bạn có thể giảm thời gian phân tích thủ công đồng thời cải thiện việc tận dụng công suất và tối ưu hóa chi phí trên cơ sở hạ tầng EC2.

Amazon EC2 Capacity Manager được cung cấp mà không cần chi phí bổ sung. Để bắt đầu sử dụng Amazon EC2 Capacity Manager, truy cập tới [Amazon EC2 console](https://console.aws.amazon.com/ec2/) hoặc trên APIs của dịch vụ. EC2 Capacity Manager khả dụng với tất cả [AWS Regions enabled by default](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html) thuộc về thương mại.

Tìm hiểu thêm tại [EC2 Capacity Manager documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/capacity-manager.html).