---
title: "Blog 8"
weight: 1
chapter: false
pre: " <b> 3.8. </b> "
---

# Tận dụng các Mô hình Ngôn ngữ lớn (LLM) như 1 Sự bổ sung cho Việc điều chỉnh Siêu tham số Truyền thống

Khi tìm cách cải thiện hiệu suất mô hình máy học ,việc điều chỉnh siêu tham số thường là khuyến nghị hàng đầu . Tuy nhiên , việc tiếp cận này đối mặt với nhiều hạn chế đáng kể, đặc biệt đối với những mô hình phức tạp yêu cầu thời gian huấn luyện kéo dài . Trong bài viết này , chúng ta sẽ khám phá một cách tiếp cận mới ,kết hợp phân tích độ chuẩn gradient với hướng dẫn từ Mô hình Ngôn Ngữ Lớn (LLM) để thiết kế lại mô hình mạng nơ-ron 1 cách thông minh . Phương pháp này có thể xác định và giải quyết nút thắt hiệu suất mà không có gánh nặng tính toán của việc điều chỉnh siêu tham số truyền thống . Thông qua những ví dụ thực tiễn , chúng tôi sẽ chỉ ra kỹ thuật của mình tận dụng LLM như những cố vấn kiến trúc , cung cấp những khuyến nghị trọng tâm , giải quyết trực tiếp những điểm yếu đã được xác định trong thiết kế mạng .

## Bối cảnh

Tinh chỉnh siêu tham số truyền thống thường sử dụng [Tối ưu hóa Bayesian](https://en.wikipedia.org/wiki/Bayesian_optimization), xây dựng một mô hình toán học về mối quan hệ giữa tham số và hiệu suất để tìm ra lời giải tối ưu một cách hiệu quả, với số lần đánh giá ít hơn so với các phương pháp như giải thuật di truyền.

Tuy nhiên, tồn tại nhiều hạn chế thực tế đáng kể. Nếu không có điện toán hiệu năng cao , việc thực thi tuần tự sẽ mất rất nhiều thời gian — trong khi các mô hình nhẹ có thể hoàn thành tối ưu hóa trong 24 giờ, thì các bài toán phức tạp như học tăng cường (reinforcement learning) hoặc tập dữ liệu thị giác máy tính lớn thường khiến phương pháp truyền thống trở nên không khả thi trên phần cứng cục bộ. Các giải pháp Cloud như [AWS Batch](https://aws.amazon.com/vi/batch/), [AWS Parallel Computing Service](https://aws.amazon.com/vi/pcs/), hoặc [AWS ParallelCluster](https://aws.amazon.com/vi/hpc/parallelcluster/) cho phép song song hóa ở quy mô lớn, có thể mang lại ROI đáng kể cho các mô hình phức tạp dù tốn thêm chi phí.

Việc tinh chỉnh truyền thống cũng đòi hỏi phải tham số hóa rõ ràng tất cả những gì cần tối ưu. Trong khi các tham số đơn giản như tốc độ học (learning rate) dễ dàng được tích hợp, việc cải tiến toàn bộ cấu trúc kiến trúc  đem lại nhiều thách thức lớn khi triển khai. Các phương pháp như Neuroevolution of Augmented Topologies ([NEAT](https://en.wikipedia.org/wiki/Neuroevolution_of_augmenting_topologies)) có thể giải quyết việc tối ưu hóa kiến trúc nhưng thường hy sinh hiệu quả mẫu.

Đây chính là nơi mà các Mô hình ngôn ngữ lớn (LLM) mang đến một lựa chọn hấp dẫn. LLM hoạt động như những chuyên gia tổng hợp, kết hợp tri thức trên toàn bộ phổ phát triển mạng nơ-ron — thực chất là nội suy hàng thập kỷ tri thức của con người trên các lĩnh vực chuyên biệt như thị giác máy tính, NLP, và học tăng cường. Chúng đưa ra khuyến nghị kiến trúc dựa trên trí tuệ tập thể được mã hóa trong tài liệu kỹ thuật, thay vì dựa vào các tìm kiếm thực nghiệm tiêu tốn nhiều tài nguyên.

Phương pháp của chúng tôi tập trung cụ thể vào việc sử dụng LLM để thiết kế và điều chỉnh kiến trúc mạng nơ-ron dựa trên phân tích độ chuẩn gradient, bổ sung cho các framework như [Liu et al. (2022) AgentHPO](https://arxiv.org/abs/2402.01881), vốn cung cấp khả năng tối ưu siêu tham số tổng quát hơn cho nhiều tác vụ ML đa dạng.

## Một quy trình tác nhân cho thiết kế mạng nơ-ron

Trong quá trình khảo sát của chúng tôi về sự chỉnh sửa mã dựa trên LLM , chúng tôi đã triển khai 1 quy trình tác nhân để quản lý các quá trình suy luận lặp và thực thi . Hình 1 minh họa mô hình hoàn chỉnh cho hệ thống của chúng tôi , tận dụng LangGraph cho điều phối  quy trình và định tuyến quyết định giữa các tác nhân . Việc triển khai của chúng tôi chạy trên các máy ảo EC2 g6.24xlarge được trang bị 4x NVIDIA L4 Tensor Core GPUs để xử lý quá trình huấn luyện mạng nơ-ron . Các tương tác với LLM diễn ra thông qua các lời gọi Python API đến Amazon Bedrock sử dụng [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html). Chúng tôi sử dụng triệt để các mô hình Claude khác nhau cho các công việc cụ thể : Claude 3.7 Sonnet cho các tác nhân kiểm thử, Claude 3.7 Sonnet với khả năng kích hoạt suy luận cho việc viết mã code , và các mô hình nhỏ hơn/nhanh hơn như Claude 3.0 Haiku cho việc tạo ra báo cáo và kiểm tra tính hợp lệ của mã code .

![Quy trình đa tác nhân cho thiết kế mạng nơ-ron tại chỗ. LLM icon dùng trong Amazon Bedrock API](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig1.png)
_Hình 1 : Quy trình đa tác nhân cho thiết kế mạng nơ-ron tại chỗ. LLM icon dùng trong Amazon Bedrock API._

Quy trình của chúng tôi bắt đầu (bước 1) với sự huấn luyện theo lô nhỏ tiêu chuẩn trong khi triển khai cơ chế xử lý lỗi mạnh mẽ - các lỗi trong thời gian chạy được phát hiện và chuyển tiếp tới tác nhân giám sát cho phân tích và sửa mã code .

Theo chu kỳ cố định ( mỗi 50-100 epoch ) , chúng tôi trích ra (bước 2) các thông tin then chốt trong huấn luyện bao gồm độ chuẩn gradient (sẽ thảo luận trong đoạn sau ) và các chỉ số tiêu chuẩn như độ mất mát (loss) và độ chuẩn xác(accuracy) . Dạng biểu diễn trạng thái này được định dạng thành 1 prompt(bước 3) cho 1 LLM để đánh giá tình trạng , sự ổn định huấn luyện và phát hiện vấn đề .

[LangGraph](https://www.langchain.com/langgraph) là 1 framework dùng để tạo ra những quy trình có trạng thái và nhiều bước với các mô hình ngôn ngữ . Định tuyến quyết định (bước 4) dựa trên LangGraph phân tích đánh giá sức khỏe và điều hướng quy trình tới 1 trong 3 con đường : tối ưu hóa siêu tham số , chỉnh sửa cấu trúc mạng nơ-ron , hoặc sự hoàn tất huấn luyện với việc tạo báo cáo . Đối với việc điều chỉnh siêu tham số , LLM cung cấp các khuyến nghị như cấu trúc JSON có thể áp dụng 1 cách trực tiếp vào huấn luyện .

Đối với những chỉnh sửa về kiến trúc, chúng tôi sử dụng hai LLM cộng tác: một LLM chính tạo ra các module Python mới định nghĩa kiến trúc mạng đã sửa đổi, trong khi LLM thứ hai đóng vai trò kiểm tra/sửa lỗi bằng cách cố gắng thực thi đoạn mã code đã tạo. Thông qua quy trình lặp đi lặp lại giữa người viết mã và người kiểm tra/sửa lỗi mã, các lỗi được phát hiện, phân tích và sửa chữa trước khi lưu lại mã cuối cùng. Sau khi được xác thực thành công với dữ liệu đầu vào giả lập, quá trình huấn luyện sẽ khởi động lại (bước 5) với kiến trúc đã được cải thiện.

## Thiết kế mạng nơ-ron thông qua lăng kính của độ chuẩn gradient

Trong khi các số liệu truyền thống như hàm mất mát và độ chính xác cung cấp những hiểu biết cơ bản, phân tích chuẩn gradient (gradient norm analysis) tiết lộ sự hiểu biết sâu sắc hơn về hiệu quả của kiến trúc. Chuẩn gradient—độ lớn của các tín hiệu cập nhật trọng số trong quá trình huấn luyện—đóng vai trò là các công cụ chẩn đoán mạnh mẽ, cho thấy liệu một mạng có quá sâu, không đủ rộng, được chuẩn hóa kém hay đang sử dụng các hàm kích hoạt không tối ưu hay không. Chuẩn gradient quá lớn hoặc quá nhỏ thường báo hiệu các vấn đề kiến trúc cụ thể mà các LLM có thể diễn giải dựa trên các mô hình quan sát được trong suốt hàng thập kỷ nghiên cứu về mạng nơ-ron.
Để chứng minh khả năng này, chúng tôi sẽ thử nghiệm với một mô hình phân loại thị giác máy tính (được hiển thị bên dưới) được huấn luyện trên tập dữ liệu CIFAR , kết hợp các thiết kế lỗi có chủ ý với tốc độ học cực kì cao (0.1) và thuật toán tối ưu hóa SGD cơ bản mà không có quán tính hoặc các thành phần thích ứng.
Bằng cách xem xét cách LLM diễn giải những mô hình chuẩn gradient này trong suốt các epochs huấn luyện, chúng ta sẽ quan sát được khả năng của nó trong việc chẩn đoán các khiếm khuyết kiến trúc cụ thể và đề xuất các sửa đổi phù hợp—tận dụng hiệu quả các tín hiệu dựa trên gradient tương tự mà những người có kinh nghiệm sử dụng để gỡ lỗi các thiết kế mạng.

```Python
import torch
import torch.nn as nn

class CNN(nn.Module):
    """
    An extremely simple CNN with a single convolutional layer
    followed by a fully connected layer for classification.
    Uses sigmoid activation instead of ReLU.
    """
    def __init__(self):
        super(CNN, self).__init__()

        # Single convolutional layer
        self.conv1 = nn.Conv2d(3, 16, kernel_size=15, padding=1)

        # With no pooling, feature size remains 32x32, so: 32x32x16 = 16384
        self.fc = nn.Linear(16384, 10)

    def forward(self, x):
        # Single convolutional layer with sigmoid activation
        x = torch.sigmoid(self.conv1(x))

        # No pooling, so dimensions stay the same

        # Flatten for fully connected layer
        x = torch.flatten(x, 1)

        # Classification layer
        x = self.fc(x)

        return x
```

Sau khi cho phép quá trình huấn luyện tiến triển trong khoảng 50-100 epochs, chúng tôi đã cho bộ tối ưu hóa đủ thời gian để xác định một thung lũng tối ưu  phù hợp vượt ra khỏi sự hỗn loạn ban đầu của việc khởi tạo trọng số. Tại thời điểm kiểm tra này, chúng tôi đã cung cấp lịch sử huấn luyện và chuẩn gradient cho Claude 3.7 thông qua Amazon Bedrock, yêu cầu một bản đánh giá về hiệu suất và tính ổn định của mô hình ( xem dòng 219 ở đây) . LLM đã phản hồi bằng một đề xuất thay đổi kiến trúc mạng nơ-ron , đồng thời đưa ra phân tích sau.

```
"Explanation: While the model shows some minimal improvement (validation accuracy from 17.6% to 19.4% over 50 epochs), progress is extremely slow and erratic. The loss isn't consistently decreasing, and the model appears to be struggling with fundamental architectural issues. The high learning rate (0.1) combined with SGD optimizer is likely causing training instability given the complex architecture. The lack of batch normalization is also problematic."
```

Bước đánh giá này đóng vai trò như một điểm định tuyến quan trọng trong quy trình LangGraph của chúng tôi. LLM đã xác định rằng cần thiết phải đại tu toàn bộ kiến trúc, tạo ra mã PyTorch mới làm tăng đáng kể độ phức tạp và sửa đổi hàm mất mát. Khối mã tiếp theo hiển thị mô hình mạng nơ-ron đã được sửa đổi hoàn toàn này, mô hình này đã được LLM thứ cấp xác thực và kiểm tra lỗi trước khi triển khai.

```Python
class ConvBlock(nn.Module):
    """
    A convolutional block with batch normalization and residual connection
    to improve gradient flow and training stability
    """
    def __init__(self, in_channels, out_channels, kernel_size=3, stride=1):
        super(ConvBlock, self).__init__()
        self.conv = nn.Conv2d(in_channels, out_channels, kernel_size=kernel_size, 
                             stride=stride, padding=kernel_size//2, bias=False)
        self.bn = nn.BatchNorm2d(out_channels)
        
        # FIX: More explicit handling of skip connection to ensure dimension matching
        if in_channels == out_channels and stride == 1:
            # Identity shortcut when dimensions match
            self.residual = nn.Identity()
        else:
            # 1x1 conv to match both channel dimensions and spatial dimensions (if stride > 1)
            self.residual = nn.Conv2d(in_channels, out_channels, kernel_size=1, 
                                     stride=stride, bias=False)
        
    def forward(self, x):
        identity = x
        
        # Main branch
        out = self.conv(x)
        out = self.bn(out)
        out = F.relu(out)
        
        # Add residual connection
        out = out + self.residual(identity)
        
        # FIX: Added ReLU after addition (standard in ResNet blocks)
        out = F.relu(out)
        
        return out

class CNN(nn.Module):
    """
    Improved CNN architecture that addresses gradient flow issues:
    1. Replaces large kernel sizes (15x15) with smaller, more efficient 3x3 kernels
    2. Adds batch normalization to stabilize gradients
    3. Uses multiple smaller convolutional layers with residual connections
    4. Balances FC layers to prevent bottlenecks
    5. Implements proper pooling strategy to reduce parameter count
    6. Uses ReLU activations instead of sigmoid for better gradient flow
    7. Adds dropout for regularization
    """
    def __init__(self, num_classes=10):
        super(CNN, self).__init__()
        
        # Initial convolution with moderate number of filters
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(32)
        
        # Convolutional blocks with gradually increasing filters
        # Input: 16x16x32, Output: 16x16x64
        self.block1 = ConvBlock(32, 64)
        
        # Input: 8x8x64, Output: 8x8x128
        self.block2 = ConvBlock(64, 128)
        
        # Input: 4x4x128, Output: 4x4x256
        self.block3 = ConvBlock(128, 256)
        
        # Pooling layers to reduce spatial dimensions
        self.pool = nn.MaxPool2d(2, 2)
        
        # More balanced FC layer architecture
        # After 3 pooling operations (32 -> 16 -> 8 -> 4), feature map is 4x4x256 = 4096
        self.fc1 = nn.Linear(4096, 512)
        self.fc2 = nn.Linear(512, 128)
        self.fc3 = nn.Linear(128, num_classes)
        
        # Dropout for regularization
        self.dropout = nn.Dropout(0.3)  # Reduced from 0.5 to prevent too much regularization
        
        # Proper weight initialization for better gradient flow
        self._initialize_weights()
        
    def _initialize_weights(self):
        """Initialize weights using Kaiming initialization for ReLU activations"""
        for m in self.modules():
            if isinstance(m, nn.Conv2d):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
            elif isinstance(m, nn.BatchNorm2d):
                nn.init.constant_(m.weight, 1)
                nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.Linear):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)
        
    def forward(self, x):
        """
        Forward pass with explicit shape tracking comments
        Input shape: [batch_size, 3, 32, 32]
        """
        # Initial convolution: [batch_size, 3, 32, 32] -> [batch_size, 32, 32, 32]
        x = self.conv1(x)
        x = self.bn1(x)
        x = F.relu(x)
        
        # First pooling: [batch_size, 32, 32, 32] -> [batch_size, 32, 16, 16]
        x = self.pool(x)
        
        # Block 1: [batch_size, 32, 16, 16] -> [batch_size, 64, 16, 16]
        x = self.block1(x)
        
        # Second pooling: [batch_size, 64, 16, 16] -> [batch_size, 64, 8, 8]
        x = self.pool(x)
        
        # Block 2: [batch_size, 64, 8, 8] -> [batch_size, 128, 8, 8]
        x = self.block2(x)
        
        # Third pooling: [batch_size, 128, 8, 8] -> [batch_size, 128, 4, 4]
        x = self.pool(x)
        
        # Block 3: [batch_size, 128, 4, 4] -> [batch_size, 256, 4, 4]
        x = self.block3(x)
        
        # Flatten: [batch_size, 256, 4, 4] -> [batch_size, 4096]
        x = torch.flatten(x, 1)
        
        # FC layers with dropout
        x = F.relu(self.fc1(x))  # [batch_size, 4096] -> [batch_size, 512]
        x = self.dropout(x)
        
        x = F.relu(self.fc2(x))  # [batch_size, 512] -> [batch_size, 128]
        x = self.dropout(x)
        
        # Output: [batch_size, 128] -> [batch_size, num_classes]
        x = self.fc3(x)
        
        return x
        
    def loss_function(self, outputs, targets):
        """
        Custom loss function that helps with gradient scaling.
        Uses label smoothing to prevent overconfidence and improve gradient flow.
        """
        return nn.CrossEntropyLoss(label_smoothing=0.1)(outputs, targets)
```

Thật thú vị là, khi quy trình làm việc chủ động (một quy trình tự động, tự định hướng, nơi hệ thống AI đưa ra các quyết định độc lập mà không cần sự can thiệp của con người) bắt đầu quá trình huấn luyện với mô hình đã được sửa đổi của nó, chúng ta quan sát thấy hàm mất mát (loss) tăng vọt ngay lập tức, làm trì trệ tiến trình. LLM phát hiện ra sự mất ổn định này và tự động thực hiện các sửa đổi quan trọng đối với chiến lược tối ưu hóa, bao gồm điều chỉnh tốc độ học (learning rate) và chuyển sang bộ tối ưu hóa Adam. Từ thời điểm này trở đi, LLM liên tục (cứ sau mỗi 50 – 100 epoch) giám sát động lực học của quá trình huấn luyện, thực hiện các điều chỉnh lặp đi lặp lại đối với các tham số tối ưu hóa hoặc kiến trúc mạng nơ-ron cho đến khi nó xác định rằng quá trình huấn luyện đã đủ ổn định để việc triển khai LangGraph hoàn thành quy trình mà không cần sự can thiệp thêm của LLM.

Hình 2 trình bày một phân tích toàn diện về hiệu suất của mô hình cơ sở trên 600 vòng huấn luyện (epochs). Phần trên bên trái của hình cho thấy sai số huấn luyện giảm mạnh trong 25 vòng huấn luyện đầu tiên, từ khoảng 10² xuống 10¹, sau đó hoàn toàn đi ngang quanh mức 10⁰, cho thấy mô hình đã ngừng học một cách có ý nghĩa mặc dù tiếp tục được huấn luyện. Sự hội tụ sớm này còn được thể hiện rõ hơn ở phần trên bên phải của hình, nơi độ chính xác huấn luyện (màu xanh lam) dao động mạnh giữa 7-14%, trong khi độ chính xác kiểm định (màu cam) vẫn cố định ở mức xấp xỉ 10% trong suốt quá trình huấn luyện, xác nhận rằng không có sự học hỏi thực sự nào đang diễn ra.

Các đồ thị phía dưới cung cấp thông tin chi tiết về hành vi của gradient (độ dốc). Chuẩn gradient tổng (phía dưới bên trái) ban đầu tăng vọt lên trên 10² trước khi giảm nhanh chóng và ổn định xung quanh 10⁻¹ trong thời gian còn lại của quá trình huấn luyện. Chuẩn gradient riêng cho từng lớp (phía dưới bên phải) cũng ổn định tương tự sau các epoch (lượt) huấn luyện ban đầu, với gradient của các lớp khác nhau ổn định ở các độ lớn khác nhau trong khoảng từ 10⁻³ đến 10⁻¹. Mặc dù các mô hình gradient này có vẻ ổn định về mặt số học, nhưng chúng không thể thúc đẩy các cập nhật tham số có ý nghĩa để cải thiện hiệu suất của mô hình, cho thấy các vấn đề tối ưu hóa vượt ra ngoài sự bất ổn gradient đơn thuần.

![Kết quả khi sử dụng CNN cơ bản mà không điều chỉnh LLM](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig2.png)
_Hình 2 : Kết quả khi sử dụng CNN cơ bản mà không điều chỉnh LLM_

Ngược lại, Hình 3 cho thấy hiệu suất vượt trội đáng kể của mạng neural được thiết kế bởi LLM với các siêu tham số tối ưu hóa được lựa chọn cẩn thận. Sau khoảng 4 lần lặp thiết kế bởi LLM, mô hình này đạt được độ chính xác xác thực (validation accuracy) khoảng 83%, thể hiện một sự cải thiện đáng kể so với mô hình cơ sở. Mặc dù đây là một tiến bộ đáng kể, nhưng cần lưu ý rằng các mô hình hiện đại (state-of-the-art) để phân loại CIFAR hiện đang đạt được độ chính xác trên 99% ([EfficientNet-L2](https://arxiv.org/pdf/2010.01412)) , cho thấy vẫn còn dư địa để tối ưu hóa hơn nữa. Khoảng cách giữa kết quả của chúng tôi và khả năng tinh chỉnh thủ công tiên tiến nhất có thể xuất phát từ các kỹ thuật tiên tiến mà LLM của chúng tôi có thể chưa kết hợp hoặc chưa biết đến. Ví dụ, các phương pháp tối ưu hóa như Sharpness Aware Minimization (SAM) đã đẩy EfficientNet-L2 đạt độ chính xác kỷ lục bằng cách cải thiện khả năng khái quát hóa thông qua tối ưu hóa cực tiểu phẳng. Các kỹ thuật chuyên biệt như vậy có thể nằm ngoài dữ liệu huấn luyện của LLM hoặc không được xem xét trong các ràng buộc thử nghiệm của chúng tôi. Điều này cho thấy phương pháp của chúng tôi có thể được hưởng lợi đáng kể từ việc bổ sung hệ thống RAG kết hợp các tiến bộ học thuật gần đây, cho phép LLM tận dụng các nghiên cứu tiên tiến có thể đã xuất hiện sau thời điểm cắt kiến thức của nó. Tuy nhiên, sự khác biệt về hiệu suất nhấn mạnh tính hiệu quả của việc cho phép LLM điều chỉnh linh hoạt thiết kế mạng nơ-ron và các tham số huấn luyện để đáp ứng với các động lực huấn luyện được quan sát.

![Kết quả khi sử dụng thiết kế CNN do LLM và các tham số tối ưu hóa được chọn bởi LLM](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig3.png)
_Hình 3 : Kết quả khi sử dụng thiết kế CNN do LLM và các tham số tối ưu hóa được chọn bởi LLM ._

## Kết luận

Các LLM cung cấp một giải pháp thay thế mạnh mẽ cho việc điều chỉnh siêu tham số truyền thống, tận dụng kiến thức tổng hợp để cải thiện mạng nơ-ron mà không cần tìm kiếm tham số một cách triệt để. Kiến trúc được thiết kế bởi LLM trong thử nghiệm của chúng tôi đã đạt được độ chính xác xác thực là 83% trên CIFAR, vượt trội đáng kể so với mô hình cơ sở. Cách tiếp cận này đặc biệt có giá trị cho những người thực hành có nguồn lực tính toán hạn chế hoặc những người làm việc với các mô hình đòi hỏi chu kỳ huấn luyện dài.

Một chiến lược mang tính bổ trợ có thể kết hợp việc sử dụng các mô hình ngôn ngữ lớn (LLMs) cho các quyết định kiến trúc quan trọng với việc điều chỉnh siêu tham số truyền thống tập trung cho việc tinh chỉnh cuối cùng, có khả năng mang lại những ưu điểm tốt nhất của cả hai. Toàn bộ mã nguồn cho dự án này, bao gồm cả việc triển khai quy trình làm việc LangGraph đa tác nhân và tất cả các mô hình mạng nơ-ron, đều có sẵn trong [AWS Samples repository trên GitHub](https://github.com/aws-samples/sample-Leveraging-LLMs-Augmentation-Traditional-Hyperparameter-Tuning/). 

Chúng tôi khuyến khích các nhà nghiên cứu và những người thực hành khám phá và xây dựng dựa trên những phát hiện này.