---
title: "Blog 5"
weight: 1
chapter: false
pre: " <b> 3.5. </b> "
---

# Hiện Đại Hóa Các Quy Trình Mua Sắm SAP Với Amazon AppFlow, SAP BTP Integration Suite Và Amazon Bedrock

bởi Simon Cunningham, Diego Lombardini, John Gray và Sridhar Mahadevan trên [Permalink](https://aws.amazon.com/blogs/awsforsap/modernizing-sap-procurement-processes-with-aws-appflow-sap-btp-integration-suite-and-amazon-bedrock/) [Chia sẻ](#)

Nhiều khách hàng của chúng tôi đang tìm kiếm hướng dẫn về cách trí tuệ nhân tạo sinh tạo có thể hỗ trợ chiến lược hiện đại hóa toàn doanh nghiệp của họ. [Amazon Bedrock](https://aws.amazon.com/bedrock/) là một dịch vụ được quản lý hoàn toàn cung cấp truy cập vào một loạt các mô hình nền tảng (Foundation Models - FMs) hiệu suất cao từ các công ty AI hàng đầu như [Anthropic](https://www.anthropic.com/), [AI21 Labs](https://www.ai21.com/), [Cohere](https://cohere.com/), [Stability AI](https://stability.ai/), [Mistral](https://aws.amazon.com/bedrock/mistral/), [Meta Llama](https://aws.amazon.com/bedrock/llama/), [Amazon Nova](https://aws.amazon.com/ai/generative-ai/nova/?gclid=EAIaIQobChMI97Keq4HkigMVxJVQBh1uWQx-EAAYASAAEgJatvD_BwE&trk=42edd3ad-f9d1-4bec-98be-19a453395a44&sc_channel=ps&ef_id=EAIaIQobChMI97Keq4HkigMVxJVQBh1uWQx-EAAYASAAEgJatvD_BwE:G:s&s_kwcid=AL!4422!3!691967596755!e!!g!!amazon%20nova!21048269259!166106444064) và [Amazon Titan](https://aws.amazon.com/bedrock/titan/).

Amazon Bedrock cung cấp một bộ khả năng toàn diện để xây dựng các ứng dụng trí tuệ nhân tạo sinh tạo, đơn giản hóa phát triển trong khi duy trì quyền riêng tư và bảo mật. Các tính năng chính bao gồm tùy chỉnh mô hình với dữ liệu riêng của bạn, tinh chỉnh cho các nhiệm vụ cụ thể và [Tăng Cường Truy Vấn Trả Lời (Retrieval Augmented Generation - RAG)](https://aws.amazon.com/what-is/retrieval-augmented-generation/) để nâng cao độ chính xác phản hồi bằng cách sử dụng cơ sở tri thức của công ty bạn. Bedrock cũng hỗ trợ xây dựng các tác nhân thông minh có thể tự động hóa các nhiệm vụ bằng cách tương tác với các hệ thống doanh nghiệp của bạn.

Các doanh nghiệp có kỳ vọng cao về bảo mật và độ tin cậy cơ sở hạ tầng, đặc biệt đối với các khối lượng công việc quan trọng như những khối lượng chạy trên SAP. Amazon Bedrock đáp ứng các kỳ vọng này bằng cách tích hợp các biện pháp bảo mật mạnh mẽ, bao gồm mã hóa dữ liệu và tuân thủ các tiêu chuẩn như [SOC](https://aws.amazon.com/compliance/soc-faqs/) và [ISO](https://aws.amazon.com/compliance/iso-27001-faqs/). Điều này tạo điều kiện cho một môi trường an toàn, làm cho Bedrock trở thành lựa chọn lý tưởng để phát triển các ứng dụng AI sáng tạo đáp ứng các yêu cầu nghiêm ngặt của các giải pháp cấp doanh nghiệp.

## Nâng Cao Mua Sắm: Sức Mạnh Của Trí Tuệ Nhân Tạo Sinh Tạo Trong Nguồn Cung Ứng Bền Vững

Các thực hành mua sắm ngày nay đối mặt với những thách thức đáng kể, đặc biệt là trong quy trình tốn thời gian của việc xem xét nhiều báo giá nhà cung cấp và nhiệm vụ phức tạp của việc thu thập dữ liệu bền vững từ các nguồn khác nhau. Trí tuệ nhân tạo sinh tạo đang nổi lên như một giải pháp biến đổi, với các ví dụ như Trợ Lý Nguồn Cung Ứng Bền Vững (được hỗ trợ bởi Amazon Bedrock) chứng minh cách AI có thể tận dụng cả dữ liệu SAP & Không Phải SAP để biến đổi các quy trình mua sắm và nâng cao các sáng kiến bền vững xuyên suốt chuỗi cung ứng. Sử dụng Amazon Bedrock, khách hàng SAP có thể cung cấp các lệnh ngôn ngữ tự nhiên để phân tích thông tin báo giá từ các hệ thống SAP. Sau đó, nó kết hợp dữ liệu này với các chỉ số bền vững không phải SAP để khuyến nghị báo giá tối ưu dựa trên các tiêu chí bền vững cụ thể của doanh nghiệp. Hệ thống cũng cho phép người dùng tạo đơn đặt hàng mua trong SAP bằng các lệnh ngôn ngữ tự nhiên, đơn giản hóa toàn bộ quy trình mua sắm.

Ví dụ này giải quyết các thách thức chính mà các chuyên gia nguồn cung ứng bền vững phải đối mặt, bao gồm:

* Các đánh giá báo giá tốn thời gian, nhu cầu truy cập nhiều nguồn dữ liệu bên ngoài.
* Khó khăn trong việc thu thập thông tin bền vững toàn diện.
* Khó khăn trong việc phù hợp báo giá với các mục tiêu tổ chức cụ thể (trong trường hợp này, bền vững).

## Tổng Quan Giải Pháp

### Khám Phá Tiềm Năng Của AI Trong Mua Sắm: Một Trường Hợp Sử Dụng Trợ Lý Nguồn Cung Ứng Bền Vững

Trong bài viết blog này, chúng tôi sẽ khám phá một ví dụ sáng tạo về cách AI có thể biến đổi các quy trình kinh doanh thông qua một trợ lý được hỗ trợ bởi AI khái niệm. Điều quan trọng cần lưu ý là đây không phải là một sản phẩm hoặc dịch vụ sẵn sàng sử dụng, mà là một minh họa về cách các công nghệ khác nhau có thể được kết hợp để giải quyết các thách thức kinh doanh phổ biến trong mua sắm. Trường hợp sử dụng này đóng vai trò là nguồn cảm hứng cho cách các cách tiếp cận tương tự có thể được áp dụng và tùy chỉnh cho các lĩnh vực chức năng khác nhau trong tổ chức của bạn, dù là sản xuất, tài chính, nguồn nhân lực hoặc các hoạt động kinh doanh khác.

Xuyên suốt bài viết blog này, chúng tôi sẽ thảo luận về các tùy chọn kiến trúc khác nhau và các dịch vụ AWS có thể được triển khai thông qua sự kết hợp của công nghệ chatbot, xử lý ngôn ngữ tự nhiên, Tác Nhân Amazon Bedrock và tích hợp với [SAP BTP Integration Suite](https://www.sap.com/products/technology-platform/integration-suite.html). Trong khi chúng tôi tập trung vào một ví dụ cụ thể, sự linh hoạt này cho phép các tổ chức chọn các thành phần phù hợp nhất với yêu cầu của họ, cơ sở hạ tầng hiện có và sở thích kỹ thuật, làm cho các nguyên tắc và công nghệ cơ bản có thể thích ứng với một loạt các quy trình kinh doanh và trường hợp sử dụng rộng rãi.

### Lợi Ích Tiềm Năng Của Mua Sắm Được Hỗ Trợ Bởi AI

Trong trường hợp sử dụng ví dụ của chúng tôi, chúng tôi minh họa cách trí tuệ nhân tạo sinh tạo có thể được sử dụng để:

1. Đơn Giản Hóa Đánh Giá: Tự động hóa quy trình đánh giá báo giá, có khả năng giảm thời gian dành cho đánh giá.
2. Tích Hợp Dữ Liệu: Khai thác cả nguồn dữ liệu nội bộ và bên ngoài, cung cấp thông tin toàn diện hơn cho việc ra quyết định.
3. Nâng Cao Tính Khách Quan: Sử dụng các cách tiếp cận được hỗ trợ bởi Trí Tuệ Nhân Tạo Sinh Tạo để hỗ trợ các quy trình lựa chọn không thiên vị tuân thủ các nguyên tắc được định nghĩa trước.
4. Quy Trình Đơn Giản Hóa: Trí tuệ nhân tạo sinh tạo có thể giúp tự động hóa các bước tiếp theo, chẳng hạn như tạo đơn đặt hàng mua, chuyển tiếp liền mạch từ Yêu Cầu Báo Giá (Request for Quotation - RFQ) đến tạo đơn đặt hàng mua.
5. Giảm Lỗi Con Người: Trí tuệ nhân tạo sinh tạo có thể nâng cao độ chính xác và tính nhất quán trong các quy trình kinh doanh bằng cách tự động xác thực đầu vào dữ liệu, xác định mô hình lỗi và cung cấp hướng dẫn thời gian thực cho người dùng trước khi lỗi xảy ra.

Bây giờ hãy đi sâu vào kiến trúc kỹ thuật đằng sau trường hợp sử dụng trợ lý mua sắm được hỗ trợ bởi AI khái niệm của chúng tôi. Ví dụ này minh họa cách các dịch vụ AWS và công nghệ SAP khác nhau có thể được kết hợp để tạo ra một công cụ mạnh mẽ cho các quy trình mua sắm. Chúng tôi sẽ sử dụng giao diện kiểu chatbot để truy vấn RFQ theo thời gian thực gần, bổ sung dữ liệu SAP này với dữ liệu bền vững bên thứ ba, và cuối cùng tạo đơn đặt hàng mua bằng trợ lý. Một lần nữa, điều quan trọng cần lưu ý là đây không phải là một sản phẩm sẵn sàng sử dụng, mà là một minh họa về những gì có thể thực hiện khi tận dụng các công nghệ này.

## Kiến Trúc Chi Tiết:

![các bước cấp cao & sơ đồ kiến trúc](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Screenshot-2025-06-16-at-20.46.19.png)

**các bước cấp cao & sơ đồ kiến trúc**

Giải pháp này đã được xây dựng và kiểm thử trên [SAP S/4HANA 2023](https://help.sap.com/doc/e2048712f0ab45e791e6d15ba5e20c68/2023/en-US/FSD_OP2023_latest.pdf) và có thể được triển khai trên các tùy chọn triển khai khác nhau bao gồm RISE with SAP, SAP on AWS, các cài đặt AWS Bản Địa hoặc môi trường tại chỗ. Kiến trúc giải pháp minh họa một cách tiếp cận linh hoạt để triển khai, cho phép các tổ chức điều chỉnh các thành phần dựa trên nhu cầu cụ thể và cảnh quan công nghệ hiện có của họ. Trong khi ví dụ của chúng tôi thể hiện một sự kết hợp cụ thể của các dịch vụ AWS và SAP, điều quan trọng là hiểu rằng có ba lớp chính nơi các công nghệ thay thế có thể được sử dụng mà không làm ảnh hưởng đến chức năng tổng thể của giải pháp.

### Các Thành Phần Cốt Lõi Và Các Lựa Chọn Thay Thế:

1. **Lớp Tích Hợp Dữ Liệu**
   - Ví Dụ Của Chúng Tôi: Amazon AppFlow với Kết Nối SAP OData
   - Lựa Chọn Thay Thế [Kết Nối AWS Glue Cho SAP](https://aws.amazon.com/blogs/big-data/scaling-rise-with-sap-data-and-aws-glue/) (sử dụng ODATA)
   - Mục Đích: Xử lý trích xuất dữ liệu thời gian thực gần từ các hệ thống SAP
2. **Lớp Xử Lý & Trí Tuệ**
3. **Lớp Giao Diện Người Dùng**

### Luồng Kiến Trúc (Được Tham Chiếu Trong Sơ Đồ Các Bước Cấp Cao & Kiến Trúc):

1. Trích Xuất Dữ Liệu: Amazon AppFlow kết nối với Kết Nối SAP OData để trích xuất dữ liệu thời gian thực gần
2. Lưu Trữ Dữ Liệu: Amazon S3 lưu trữ dữ liệu được trích xuất ở định dạng JSON
3. Giao Diện Người Dùng: Một trợ lý chatbot nhận đầu vào ngôn ngữ tự nhiên từ người dùng
4. Xử Lý: Tác Nhân Bedrock diễn giải đầu vào người dùng, tận dụng lịch sử trò chuyện và Mô Hình Nền Tảng cơ bản
5. Điều Phối Hành Động: Tác Nhân Bedrock được cấu hình với Các Nhóm Hành Động để quản lý các bước xử lý
6. Truy Vấn Dữ Liệu: Các hàm Lambda dịch ngôn ngữ tự nhiên thành các truy vấn SQL cho cơ sở dữ liệu Athena
7. Tích Hợp SAP: AWS Lambda kích hoạt [API BTP](https://developers.sap.com/tutorials/api-mgmt-isuite-initial-setup..html) để tạo Đơn Đặt Hàng Mua Trong SAP
8. Kết Nối An Toàn: [SAP Cloud Connector](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/cloud-connector?locale=en-US) tạo một đường hầm an toàn giữa các tài khoản AWS và BTP
9. Nâng Cao Kiến Thức: Cơ Sở Kiến Thức Amazon Bedrock cung cấp RAG được quản lý cho ngữ cảnh bổ sung
10. Chuẩn Bị Dữ Liệu: Dữ liệu thùng S3 được đồng bộ hóa và biến đổi thành các embedding cho sử dụng học máy
11. Tạo Phản Hồi: Tác nhân biên soạn phản hồi cuối cùng, được giao qua ứng dụng Streamlit

### Cơ Sở Hạ Tầng Hỗ Trợ:

* Lưu Trữ Dữ Liệu: Amazon S3 (định dạng JSON)
* Xử Lý Truy Vấn: AWS Lambda với Amazon Athena
* Thành Phần Tích Hợp: SAP BTP Integration Suite, SAP Cloud Connector
* Quản Lý Kiến Thức: Cơ Sở Kiến Thức Amazon Bedrock cho RAG
* Chuẩn Bị Dữ Liệu: Thùng S3 với biến đổi embedding

Cách tiếp cận mô-đun này cho phép các tổ chức kết hợp và khớp các thành phần dựa trên ngăn xếp công nghệ hiện có, sở thích và yêu cầu của họ trong khi duy trì chức năng cốt lõi của giải pháp.

Hãy khám phá các dịch vụ AWS chính cung cấp năng lượng cho giải pháp này và vai trò cụ thể của chúng, trước khi chúng tôi minh họa Trợ Lý trong hành động thông qua các ví dụ thực tế.

* Amazon S3
* Amazon AppFlow
* AWS Glue
* Amazon Athena
* AWS Lambda
* Amazon Bedrock

### Amazon S3: 
S3 hoạt động như một hồ dữ liệu trung tâm, nhận dữ liệu trực tiếp từ S/4HANA qua AppFlow và lưu trữ nó ở các định dạng được tối ưu hóa phân tích bao gồm CSV, JSON hoặc Parquet. Giải pháp kết hợp AppFlow cho việc hấp thụ dữ liệu, S3 cho lưu trữ có khả năng mở rộng và Athena cho phân tích dựa trên SQL, với AWS Glue lập danh mục dữ liệu để dễ dàng khám phá hơn.

### Amazon AppFlow: 
[Amazon AppFlow](https://aws.amazon.com/appflow/) trích xuất dữ liệu báo giá và RFQ từ SAP vào Amazon S3 theo thời gian thực gần, sử dụng một kết nối SAP an toàn mà không yêu cầu tích hợp tùy chỉnh. Nó sử dụng Bắt Ghi Thay Đổi Dữ Liệu (Change Data Capture) để phát hiện và chuyển chỉ các bản ghi mới hoặc đã sửa đổi, đảm bảo hồ dữ liệu S3 duy trì thông tin hiện tại nhất.

### AWS Glue: 
Trình thu thập dữ liệu AWS Glue tự động khám phá, lập danh mục và tổ chức dữ liệu được lưu trữ trong các thùng S3, làm cho nó dễ dàng tìm kiếm và phân tích. Đây là một dịch vụ ETL được quản lý hoàn toàn đơn giản hóa chuẩn bị và tải dữ liệu cho mục đích phân tích.

### Amazon Athena: 
Athena là một dịch vụ truy vấn không máy chủ phân tích dữ liệu trực tiếp trong S3 sử dụng SQL tiêu chuẩn, hỗ trợ các định dạng dữ liệu khác nhau và tự động song song hóa các truy vấn cho thực thi phân tán. Nó tích hợp với AWS Glue Data Catalog và hỗ trợ phân tích phức tạp trong khi duy trì mô hình giá trả theo truy vấn.

### AWS Lambda: 
Các hàm Lambda hoạt động như một trung gian giữa Tác Nhân Amazon Bedrock và API SAP, xử lý tích hợp kỹ thuật cho xử lý đơn đặt hàng mua. Nó quản lý xác thực, biến đổi dữ liệu và xử lý lỗi, kích hoạt xử lý có khả năng mở rộng, tiết kiệm chi phí cho các yêu cầu đơn đặt hàng mua được hỗ trợ bởi AI.

### Amazon Bedrock: 
Bedrock, sử dụng Claude 3 Sonnet v1, cung cấp các khả năng xử lý ngôn ngữ tự nhiên tiên tiến để phân tích báo giá dựa trên giá cả và bền vững. Nó cung cấp kiến trúc không máy chủ cho triển khai dễ dàng và bao gồm các tính năng Đánh Giá Mô Hình để đảm bảo độ chính xác trong các nhiệm vụ như phân tích báo giá.

### Các Cân Nhắc Bảo Mật:

Trong ví dụ blog này, chúng tôi đã giả định các nhóm LDAP qua Đăng Nhập Đơn (Single Sign-On) để hạn chế truy cập cho người dùng mua sắm được ủy quyền. Đối với môi trường sản xuất, chúng tôi khuyến nghị triển khai lan truyền danh tính để nâng cao bảo mật.

### Các Cân Nhắc Chi Phí:

Mặc dù chi phí chính xác sẽ thay đổi dựa trên sử dụng và chi tiết triển khai cụ thể, dưới đây là tổng quan chung:

* SAP Integration Suite: [Thử Nghiệm Miễn Phí 90 Ngày](https://help.sap.com/docs/integration-suite/sap-integration-suite/using-free-service-plans), sau đó dựa trên đăng ký. [Liên Kết](https://www.sap.com/products/technology-platform/integration-suite/pricing.html#:~:text=SAP%20Integration%20Suite%2C%20additional%20messages,USD%2077.04) đến giá SAP.
* Dịch Vụ AWS: Ước Tính 900 USD mỗi tháng cho xử lý 30.000 đơn đặt hàng mua

Điều quan trọng cần lưu ý là các chi phí này là minh họa và nên được đánh giá cẩn thận cho trường hợp sử dụng cụ thể của bạn. AWS khuyến nghị giám sát chặt chẽ chi phí trong bất kỳ bằng chứng khái niệm nào và mở rộng tương ứng.

### Tối Ưu Hóa Chi Phí:

Để tối đa hóa giá trị, hãy cân nhắc tận dụng [SAP Integration Suite](https://help.sap.com/docs/integration-suite/sap-integration-suite/what-s-new-for-sap-integration-suite) trên nhiều trường hợp sử dụng trong tổ chức của bạn. Cách tiếp cận này có thể giúp đạt được quy mô kinh tế và giúp biện minh cho đầu tư.

## Tổng Quan Minh Họa

Hãy kiểm tra Trợ Lý Nguồn Cung Ứng Bền Vững trong hoạt động. Thông qua một loạt các truy vấn tương tác sử dụng ngôn ngữ tự nhiên, chúng tôi sẽ minh họa cách trợ lý xử lý và phản hồi các câu hỏi liên quan khác nhau. Hệ thống tích hợp dữ liệu SAP, được kéo theo thời gian thực gần qua Amazon AppFlow vào hồ dữ liệu Amazon S3, trong khi làm phong phú phản hồi với các chỉ số bền vững bên thứ ba từ Cơ Sở Kiến Thức Bedrock thông qua điều phối Tác Nhân Amazon Bedrock.

Bằng cách nhập các lệnh nhắc sau, bắt đầu với “Please List RFQs”, bạn có thể xem đầu ra.

1. Hãy liệt kê RFQ?

![Hình Ảnh 1](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-2-1.png)

2. Có RFQ nào được tạo vào ngày 2024-09-03 không?

![Hình Ảnh 2](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-3-2.png)

3. Có bao nhiêu báo giá được nhận cho RFQ 7000000026 và từ ai và tổng chi phí là bao nhiêu?

![Hình Ảnh 3](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-4-2.png)

4. Bạn có chi tiết bền vững và các điều khoản thanh toán khác cho các nhà cung cấp này không?

![Hình Ảnh 4](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-5.png)

5. Khuyến nghị nhà cung cấp tốt nhất cho RFQ 7000000026 dựa trên giá cả và điểm bền vững.

![Hình Ảnh 5](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-6.png)

6. Tạo đơn đặt hàng mua cho nhà cung cấp được khuyến nghị.

![Hình Ảnh 6](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/Picture-7.png)

## Kết Luận

Trợ Lý Nguồn Cung Ứng Bền Vững minh họa cách trí tuệ nhân tạo sinh tạo, được hỗ trợ bởi Amazon Bedrock, có thể cách mạng hóa các quy trình mua sắm bằng cách tích hợp dữ liệu SAP với các chỉ số bền vững bên ngoài. Giải pháp khái niệm này minh họa tiềm năng cho việc tự động hóa phân tích báo giá, nâng cao ra quyết định với các tiêu chí khách quan và đơn giản hóa tạo đơn đặt hàng mua—tất cả trong khi duy trì bảo mật và khả năng mở rộng cấp doanh nghiệp.

Các tổ chức đang tìm cách hiện đại hóa luồng công việc mua sắm SAP của họ có thể bắt đầu bằng cách khám phá các khả năng của Amazon Bedrock để xây dựng các tác nhân AI tùy chỉnh. Kết hợp với các dịch vụ AWS như Amazon AppFlow cho tích hợp dữ liệu liền mạch và SAP BTP Integration Suite cho kết nối an toàn, cách tiếp cận này cung cấp một nền tảng linh hoạt cho đổi mới trên các chức năng kinh doanh khác nhau.

Chúng tôi khuyến khích bạn thử nghiệm các công nghệ này trong môi trường của riêng bạn, điều chỉnh kiến trúc theo nhu cầu cụ thể của bạn. Dù nâng cao các sáng kiến bền vững hay tối ưu hóa các khía cạnh mua sắm khác, trí tuệ nhân tạo sinh tạo mang lại lời hứa lớn lao cho việc thúc đẩy hiệu quả và giá trị chiến lược trong hoạt động của bạn.

<!-- ### Về Các Tác Giả

![Simon Cunningham](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-simon-cunningham.png)

**Simon Cunningham** là Kiến Trúc Sư Giải Pháp Chuyên Gia Chính cho SAP trên AWS. Với hơn 25 năm trong phần mềm doanh nghiệp và đám mây, ông tập trung vào việc giúp khách hàng đạt được giá trị kinh doanh thông qua các giải pháp SAP và AI sáng tạo trên AWS.

![Diego Lombardini](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-diego-lombardini.png)

**Diego Lombardini** là Kiến Trúc Sư Giải Pháp Cấp Cao tại AWS, chuyên về các khối lượng công việc SAP. Ông hỗ trợ khách hàng thiết kế các kiến trúc có khả năng mở rộng, an toàn cho SAP trên AWS, tận dụng chuyên môn của mình trong di chuyển đám mây và tối ưu hóa.

![John Gray](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-john-gray.png)

**John Gray** là Kiến Trúc Sư Giải Pháp Cấp Cao tập trung vào Trí Tuệ Nhân Tạo Sinh Tạo và tích hợp SAP. Ông giúp khách hàng xây dựng các ứng dụng AI sáng tạo nâng cao các quy trình SAP, thúc đẩy chuyển đổi số.

![Sridhar Mahadevan](https://d2908q01vomqb2.cloudfront.net/17ba0791499db908433b80f37c5fbc89b870084b/2025/06/16/author-sridhar-mahadevan.png)

**Sridhar Mahadevan** là Kiến Trúc Sư Giải Pháp Chuyên Gia Chính cho SAP trên AWS, với chuyên môn sâu về di chuyển SAP S/4HANA và tích hợp AI. Ông hướng dẫn khách hàng tận dụng AWS cho các chiến lược hiện đại hóa SAP. -->