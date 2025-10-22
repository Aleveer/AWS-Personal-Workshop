---
title: "Blog 1"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# Caching ngoại tuyến với AWS Amplify, Tanstack, AppSync và MongoDB Atlas

Trong blog này, chúng tôi trình bày cách tạo một ứng dụng offline-first với giao diện người dùng lạc quan (optimistic UI) sử dụng [AWS Amplify](https://aws.amazon.com/amplify/), [AWS AppSync](https://aws.amazon.com/appsync/), và [MongoDB Atlas](https://www.mongodb.com/products/platform/atlas-cloud-providers/aws). Các nhà phát triển thiết kế ứng dụng offline-first để hoạt động mà không cần kết nối internet đang hoạt động. Optimistic UI sau đó được xây dựng trên nền tảng phương pháp offline-first bằng cách cập nhật giao diện người dùng với những thay đổi dữ liệu dự kiến, mà không phụ thuộc vào phản hồi từ máy chủ. Phương pháp này thường sử dụng chiến lược cache cục bộ.

Các ứng dụng sử dụng offline-first với optimistic UI mang lại nhiều cải tiến cho người dùng. Những cải tiến này bao gồm giảm nhu cầu triển khai màn hình tải, hiệu suất tốt hơn do truy cập dữ liệu nhanh hơn, độ tin cậy của dữ liệu khi ứng dụng ngoại tuyến, và hiệu quả chi phí. Mặc dù việc triển khai khả năng offline thủ công có thể tốn nhiều công sức, bạn có thể sử dụng các công cụ đơn giản hóa quá trình này.

Chúng tôi cung cấp một [ứng dụng mẫu to-do](https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline) hiển thị kết quả của các thao tác CRUD MongoDB Atlas ngay lập tức trên giao diện người dùng trước khi vòng lặp yêu cầu hoàn tất, cải thiện trải nghiệm người dùng. Nói cách khác, chúng tôi triển khai optimistic UI giúp dễ dàng hiển thị trạng thái tải và lỗi, đồng thời cho phép các nhà phát triển hoàn tác các thay đổi trên giao diện người dùng khi các lời gọi API không thành công. Việc triển khai tận dụng [TanStack Query](https://tanstack.com/query/latest/docs/react/overview) để xử lý các cập nhật optimistic UI cùng với [AWS Amplify](https://docs.amplify.aws/react/build-a-backend/data/optimistic-ui/). Biểu đồ trong Hình 1 minh họa sự tương tác giữa giao diện người dùng và backend.

TanStack Query là một thư viện quản lý trạng thái bất đồng bộ cho TypeScript/JavaScript, React, Solid, Vue, Svelte, và Angular. Nó đơn giản hóa việc tìm nạp, caching, đồng bộ hóa và cập nhật trạng thái máy chủ trong các ứng dụng web. Bằng cách tận dụng các cơ chế caching của TanStack Query, ứng dụng đảm bảo tính khả dụng của dữ liệu ngay cả khi không có kết nối mạng đang hoạt động. AWS Amplify đơn giản hóa quá trình phát triển, trong khi AWS AppSync cung cấp một lớp API GraphQL mạnh mẽ, và MongoDB Atlas cung cấp giải pháp cơ sở dữ liệu có thể mở rộng. Sự tích hợp này cho thấy cách caching ngoại tuyến của TanStack Query có thể được sử dụng hiệu quả trong kiến trúc ứng dụng full-stack.

![](/images/3-BlogsTranslated/3.1-Blog1/TanstackWithAtlas-793x1024.png)

**Hình 1. Biểu đồ Tương tác**

Ứng dụng mẫu triển khai chức năng to-do cổ điển và kiến trúc ứng dụng chính xác được hiển thị trong **Hình 2.** Stack bao gồm:

* MongoDB Atlas cho các dịch vụ cơ sở dữ liệu.
* AWS Amplify framework ứng dụng full-stack.
* AWS AppSync để quản lý API GraphQL.
* AWS Lambda Resolver cho điện toán serverless.
* Amazon Cognito để quản lý người dùng và xác thực.

![](/images/3-BlogsTranslated/3.1-Blog1/architecture-1024x557.png)

**Hình 2. Kiến trúc**

### Triển khai Ứng dụng

Để triển khai ứng dụng trong tài khoản AWS của bạn, hãy làm theo các bước bên dưới. Sau khi triển khai, bạn có thể tạo người dùng, xác thực bản thân và tạo các mục to-do – xem Hình 8.

#### Thiết lập cluster MongoDB Atlas

1. Làm theo [liên kết](https://www.mongodb.com/docs/atlas/tutorial/create-atlas-account/) để thiết lập [cluster MongoDB Atlas](https://www.mongodb.com/docs/atlas/tutorial/deploy-free-tier-cluster/), Cơ sở dữ liệu, [Người dùng](https://www.mongodb.com/docs/atlas/tutorial/create-mongodb-user-for-cluster/) và [Truy cập mạng](https://www.mongodb.com/docs/atlas/security/add-ip-address-to-list/)
2. Thiết lập người dùng

  1. [Cấu hình Người dùng](https://www.mongodb.com/docs/atlas/security-add-mongodb-users/)

#### Clone Repository GitHub

1. Clone ứng dụng mẫu với lệnh sau

 `git clone https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline`

#### Thiết lập thông tin xác thực AWS CLI (tùy chọn nếu bạn cần debug ứng dụng cục bộ)

1. Nếu bạn muốn kiểm tra ứng dụng cục bộ bằng [môi trường sandbox](https://docs.amplify.aws/react/deploy-and-host/sandbox-environments/setup/), bạn có thể thiết lập thông tin xác thực AWS tạm thời cục bộ:

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```

#### Triển khai Ứng dụng Todo trong AWS Amplify

1. Mở console AWS Amplify và Chọn tùy chọn Github

![](/images/3-BlogsTranslated/3.1-Blog1/fig3-github-1024x317.png)

**Hình 3. Chọn tùy chọn Github**

2. Cấu hình Repository GitHub

![](/images/3-BlogsTranslated/3.1-Blog1/fig4-permissions-1024x254.png)

**Hình 4. Cấu hình quyền repository**

3. Chọn Repository GitHub và nhấp Next

![](/images/3-BlogsTranslated/3.1-Blog1/fig5-branch-1024x472.png)

**Hình 5. Chọn repository và branch**

4. Đặt tất cả các tùy chọn khác thành mặc định và triển khai

![](/images/3-BlogsTranslated/3.1-Blog1/fig6-deploy-1024x362.png)

**Hình 6. Triển khai ứng dụng**

#### **Cấu hình Biến Môi trường**

Cấu hình các biến môi trường sau khi triển khai thành công

![](/images/3-BlogsTranslated/3.1-Blog1/fig7-envs.png)

**Hình 7. Cấu hình biến môi trường**

#### Mở ứng dụng và kiểm tra

Mở ứng dụng thông qua URL được cung cấp và kiểm tra ứng dụng.

![](/images/3-BlogsTranslated/3.1-Blog1/fig8-test-1024x521.png)

**Hình 8. Các mục todo mẫu**

Kết quả MongoDB Atlas

![](/images/3-BlogsTranslated/3.1-Blog1/fig9-mongo-914x1024.png)

**Hình 9. Dữ liệu trong Mongo**

### Xem xét Ứng dụng

Bây giờ ứng dụng đã được triển khai, hãy thảo luận về những gì xảy ra bên dưới và những gì đã được cấu hình cho chúng ta. Chúng tôi đã sử dụng quy trình làm việc dựa trên git của Amplify để lưu trữ ứng dụng web full-stack, serverless với triển khai liên tục. Amplify hỗ trợ nhiều framework khác nhau, bao gồm các framework server side rendered (SSR) như Next.js và Nuxt, các framework single page application (SPA) như React và Angular, và các trình tạo trang tĩnh (SSG) như Gatsby và Hugo. Trong trường hợp này, chúng tôi đã triển khai một ứng dụng dựa trên React SPA. Chúng ta có thể bao gồm các nhánh tính năng, tên miền tùy chỉnh, xem trước pull request, kiểm tra end-to-end, và chuyển hướng/viết lại. Amplify Hosting cung cấp quy trình làm việc dựa trên Git cho phép triển khai nguyên tử đảm bảo rằng các cập nhật chỉ được áp dụng sau khi toàn bộ triển khai hoàn tất.

Để triển khai ứng dụng của chúng tôi, chúng tôi đã sử dụng AWS Amplify Gen 2, đây là một công cụ được thiết kế để đơn giản hóa việc phát triển và triển khai các ứng dụng full-stack bằng TypeScript. Nó tận dụng [AWS Cloud Development Kit](https://aws.amazon.com/cdk/) (CDK) để quản lý tài nguyên đám mây, đảm bảo khả năng mở rộng và dễ sử dụng.

Trước khi kết luận, điều quan trọng là hiểu tính đồng thời cập nhật của ứng dụng chúng ta. Chúng tôi đã triển khai một cơ chế giải quyết xung đột đơn giản optimistic first-come first-served. Cluster MongoDB Atlas lưu trữ các cập nhật theo thứ tự nó nhận được chúng. Trong trường hợp có xung đột cập nhật, cập nhật đến sau cùng sẽ ghi đè các cập nhật trước đó. Cơ chế này hoạt động tốt trong các ứng dụng nơi xung đột cập nhật hiếm khi xảy ra. Điều quan trọng là đánh giá cách này có thể hoặc không thể phù hợp với nhu cầu sản xuất của bạn, yêu cầu các phương pháp phức tạp hơn. TanStack cung cấp khả năng cho các cơ chế phức tạp hơn để xử lý các kịch bản kết nối khác nhau. Theo mặc định, TanStack Query cung cấp chế độ mạng "online", nơi Queries và Mutations sẽ không được kích hoạt trừ khi bạn có kết nối mạng. Nếu một query chạy vì bạn đang online, nhưng bạn ngoại tuyến trong khi fetch vẫn đang diễn ra, TanStack Query cũng sẽ tạm dừng cơ chế thử lại. Các query bị tạm dừng sau đó sẽ tiếp tục chạy một khi bạn lấy lại kết nối mạng. Để cập nhật optimistic UI với các giá trị mới hoặc đã thay đổi, chúng ta cũng có thể cập nhật cache cục bộ với những gì chúng ta mong đợi phản hồi sẽ là. Phương pháp này hoạt động tốt cùng với chế độ mạng "online" của TanStack, nơi nếu ứng dụng không có kết nối mạng, các mutations sẽ không được kích hoạt, nhưng sẽ được thêm vào hàng đợi, nhưng cache cục bộ của chúng ta có thể được sử dụng để cập nhật UI. Dưới đây là một ví dụ chính về cách ứng dụng mẫu của chúng tôi cập nhật optimistic UI với mutation dự kiến.

```
const createMutation = useMutation({
    mutationFn: async (input: { content: string }) => {
    // Sử dụng client Amplify để thực hiện yêu cầu đến AppSync
      const { data } = await amplifyClient.mutations.addTodo(input);
      return data;
    },
    // Khi mutate được gọi:
    onMutate: async (newTodo) => {
      // Hủy bỏ bất kỳ refetch nào đang diễn ra
      // để chúng không ghi đè cập nhật optimistic của chúng ta
      await tanstackClient.cancelQueries({ queryKey: ["listTodo"] });

      // Chụp ảnh giá trị trước đó
      const previousTodoList = tanstackClient.getQueryData(["listTodo"]);

      // Cập nhật optimistic với giá trị mới
      if (previousTodoList) {
        tanstackClient.setQueryData(["listTodo"], (old: Todo[]) => [
          ...old,
          newTodo,
        ]);
      }

      // Trả về một đối tượng context với giá trị đã chụp ảnh
      return { previousTodoList };
    },
    // Nếu mutation thất bại,
    // sử dụng context được trả về từ onMutate để hoàn tác
    onError: (err, newTodo, context) => {
      console.error("Error saving record:", err, newTodo);
      if (context?.previousTodoList) {
        tanstackClient.setQueryData(["listTodo"], context.previousTodoList);
      }
    },
    // Luôn refetch sau lỗi hoặc thành công:
    onSettled: () => {
      tanstackClient.invalidateQueries({ queryKey: ["listTodo"] });
    },
    onSuccess: () => {
      tanstackClient.invalidateQueries({ queryKey: ["listTodo"] });
    },
  });
```

Chúng tôi hoan nghênh mọi [PR](https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline/pulls) triển khai các chiến lược giải quyết xung đột bổ sung.

* Thử MongoDB Atlas trên [AWS MarketPlace](https://aws.amazon.com/marketplace/pp/prodview-pp445qepfdy34).
* Làm quen với [AWS Amplify](https://aws.amazon.com/amplify/), [Amplify Gen2](https://docs.amplify.aws/react/how-amplify-works/) và [AppSync](https://aws.amazon.com/pm/appsync/).
* Để có hướng dẫn chi tiết về việc triển khai ứng dụng, tham khảo [phần triển khai](https://docs.amplify.aws/react/start/quickstart/#deploy-a-fullstack-app-to-aws) trong tài liệu của chúng tôi.
* Gửi PR với các cải tiến của bạn.