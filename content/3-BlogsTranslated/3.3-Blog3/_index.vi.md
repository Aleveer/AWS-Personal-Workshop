---
title: "Blog 3"
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---
# Bảo mật API ứng dụng Express trong 5 phút với Cedar

Hôm nay, dự án mã nguồn mở [Cedar](https://www.cedarpolicy.com/) đã công bố phiên bản [`authorization-for-expressjs`](https://github.com/cedar-policy/authorization-for-expressjs), một gói mã nguồn mở giúp đơn giản hóa việc sử dụng ngôn ngữ chính sách Cedar và công cụ phân quyền để xác minh quyền truy cập ứng dụng. Phiên bản này cho phép các nhà phát triển thêm phân quyền dựa trên chính sách vào API framework web Express của họ trong vài phút, và không cần thực hiện bất kỳ cuộc gọi dịch vụ từ xa nào.

[Express](https://expressjs.com/) là một framework ứng dụng web Node.js tối giản và linh hoạt cung cấp một bộ tính năng mạnh mẽ cho các ứng dụng web và di động. Tích hợp chuẩn hóa này với Cedar yêu cầu ít hơn 90% mã so với việc các nhà phát triển tự viết các mẫu tích hợp, giúp tiết kiệm thời gian và công sức cho các nhà phát triển và cải thiện tư thế bảo mật ứng dụng bằng cách giảm lượng mã tích hợp tùy chỉnh.

Ví dụ, nếu bạn đang xây dựng một ứng dụng cửa hàng thú cưng sử dụng framework Express, sử dụng tính năng authorization-for-expressjs bạn có thể tạo các chính sách phân quyền để chỉ nhân viên cửa hàng mới có thể truy cập API để thêm thú cưng. Triển khai chuẩn hóa này cho middleware phân quyền Express thay thế nhu cầu về mã tùy chỉnh và tự động ánh xạ các yêu cầu khách hàng thành các thành phần principal, action và resource của chúng, sau đó thành các yêu cầu phân quyền Cedar.

## Tại sao nên tách biệt phân quyền với Cedar?

Truyền thống, các nhà phát triển triển khai phân quyền trong ứng dụng của họ bằng cách nhúng logic phân quyền trực tiếp vào mã ứng dụng. Logic phân quyền được nhúng này được thiết kế để hỗ trợ một vài quyền, nhưng khi ứng dụng phát triển, thường có nhu cầu hỗ trợ các trường hợp sử dụng phức tạp hơn với các yêu cầu phân quyền bổ sung. Các nhà phát triển cập nhật từng bước logic phân quyền được nhúng để hỗ trợ các trường hợp sử dụng phức tạp này, dẫn đến mã phức tạp và khó bảo trì. Khi độ phức tạp của mã tăng lên, việc phát triển thêm mô hình bảo mật và thực hiện kiểm toán quyền trở nên khó khăn hơn, dẫn đến một ứng dụng liên tục trở nên khó bảo trì hơn trong suốt vòng đời của nó.

Cedar cho phép bạn tách biệt logic phân quyền khỏi ứng dụng của bạn. Việc tách biệt phân quyền khỏi mã ứng dụng mang lại nhiều lợi ích bao gồm giải phóng các nhóm phát triển để tập trung vào logic ứng dụng và đơn giản hóa việc kiểm toán ứng dụng và truy cập tài nguyên. Cedar là một [ngôn ngữ mã nguồn mở và bộ công cụ phát triển phần mềm (SDK)](https://github.com/cedar-policy/) để viết và thực thi các chính sách phân quyền cho ứng dụng của bạn. Bạn chỉ định các quyền chi tiết như các chính sách Cedar, và ứng dụng của bạn phân quyền các yêu cầu truy cập bằng cách gọi Cedar SDK. Ví dụ, bạn có thể sử dụng chính sách Cedar bên dưới để cho phép người dùng nhân viên gọi API `POST /pets` trong ứng dụng PetStore mẫu.

```
permit (
    principal,
    action in [Action::"POST /pets"], 
    resource
) when {
    principal.jobLevel = "employee"
};
```

Một thách thức tiềm ẩn trong việc áp dụng Cedar có thể là nỗ lực ban đầu cần thiết để định nghĩa các chính sách Cedar và cập nhật mã ứng dụng của bạn để gọi Cedar SDK để phân quyền các yêu cầu API. Bài đăng blog này cho thấy cách các nhà phát triển ứng dụng web sử dụng framework Express có thể dễ dàng triển khai phân quyền cấp API với Cedar—chỉ thêm vài chục dòng mã trong ứng dụng của bạn, thay vì hàng trăm dòng.

Hướng dẫn từng bước này sử dụng ứng dụng PetStore mẫu để cho thấy cách truy cập vào API có thể được hạn chế dựa trên các nhóm người dùng. Bạn có thể tìm thấy ứng dụng Pet Store mẫu trong [kho lưu trữ cedar-policy](https://github.com/cedar-policy/authorization-for-expressjs/tree/main/examples) trên GitHub.

## Tổng quan API ứng dụng Pet Store

Ứng dụng PetStore được sử dụng để quản lý một cửa hàng thú cưng. Cửa hàng thú cưng được xây dựng bằng Express trên Node.js và expose các API sau:

1. **GET /pets** – trả về một trang các thú cưng có sẵn trong PetStore.
2. **POST /pets** – thêm thú cưng được chỉ định vào PetStore.
3. **GET /pets/{petId}** – trả về thú cưng được chỉ định tìm thấy trong PetStore.
4. **POST /pets/{petId}/sale** – đánh dấu một thú cưng là đã bán.

Ứng dụng này không cho phép tất cả người dùng truy cập tất cả API. Thay vào đó, nó thực thi các quy tắc sau:

Cả người dùng khách hàng và nhân viên đều được phép thực hiện các thao tác đọc.

`GET /pets`

`GET /pets/{petId}`

Chỉ nhân viên mới được phép thực hiện các thao tác ghi.

`POST /pets`

`POST /pets/{petId}/sale`

## Triển khai phân quyền cho API Pet Store

Hãy cùng đi qua cách bảo mật API ứng dụng của bạn bằng Cedar sử dụng gói mới cho Express. Ứng dụng ban đầu, không có phân quyền, có thể được tìm thấy trong thư mục `start`; sử dụng cái này để theo dõi cùng với blog. Bạn có thể tìm thấy ứng dụng hoàn chỉnh, với phân quyền đã được thêm vào, trong thư mục `finish`.

### Thêm gói Cedar Authorization Middleware

Gói Cedar Authorization Middleware sẽ được sử dụng để tạo schema Cedar, tạo các chính sách phân quyền mẫu và thực hiện phân quyền trong ứng dụng của bạn.

Chạy lệnh `npm` này để thêm dependency `@cedar-policy/authorization-for-expressjs` vào ứng dụng của bạn.

```
npm i --save @cedar-policy/authorization-for-expressjs 
```

### Tạo Schema Cedar từ API của bạn

Schema Cedar định nghĩa mô hình phân quyền cho một ứng dụng, bao gồm các loại thực thể trong ứng dụng và các hành động mà người dùng được phép thực hiện. Các chính sách của bạn được xác thực với schema này khi bạn chạy ứng dụng.

Gói `authorization-for-expressjs` có thể phân tích [đặc tả OpenAPI](https://swagger.io/specification/) của ứng dụng của bạn và tạo schema Cedar. Cụ thể, đối tượng `paths` là bắt buộc trong đặc tả của bạn.

Lưu ý: Nếu bạn không có đặc tả OpenAPI, bạn có thể tạo một cái bằng công cụ bạn chọn. Có một số thư viện mã nguồn mở để làm điều này cho Express; bạn có thể cần thêm một số mã vào ứng dụng của bạn, tạo đặc tả OpenAPI, và sau đó xóa mã đó. Ngoài ra, một số công cụ dựa trên AI sinh tạo như CLI [Amazon Q Developer](https://aws.amazon.com/q/developer/) rất hiệu quả trong việc tạo các tài liệu đặc tả OpenAPI. Bất kể bạn tạo đặc tả như thế nào, hãy đảm bảo xác thực đầu ra chính xác từ công cụ.

Đối với ứng dụng mẫu, một tài liệu đặc tả OpenAPI có tên `openapi.json` đã được bao gồm.

Với đặc tả OpenAPI, bạn có thể tạo schema Cedar bằng cách chạy lệnh `generateSchema` được liệt kê ở đây.

```
// schema được lưu trữ trong file v4.cedarschema.json trong root của package.

npx @cedar-policy/authorization-for-expressjs generate-schema --api-spec openapi.json --namespace PetStoreApp --mapping-type SimpleRest
```

### Định nghĩa các chính sách phân quyền

Nếu không có chính sách nào được cấu hình, Cedar sẽ từ chối tất cả các yêu cầu phân quyền. Chúng ta sẽ thêm các chính sách cấp quyền truy cập vào API chỉ trong các nhóm người dùng được ủy quyền.

Chạy lệnh này để tạo các chính sách Cedar mẫu. Sau đó bạn có thể tùy chỉnh các chính sách này dựa trên trường hợp sử dụng của bạn.

```
npx @cedar-policy/authorization-for-expressjs generate-policies --schema v4.cedarschema.json
```

Trong ứng dụng PetStore, hai chính sách mẫu được tạo, `policy_1.cedar` và `policy_2.cedar`.

policy_1.cedar cung cấp quyền cho người dùng trong nhóm người dùng admin để thực hiện bất kỳ hành động nào trên bất kỳ tài nguyên nào.

```
// policy_1.cedar
// Cho phép nhóm người dùng admin truy cập mọi thứ
permit (
    principal in PetStoreApp::UserGroup::"admin",
    action,
    resource
);
```

policy_2.cedar cung cấp quyền truy cập chi tiết hơn cho tất cả các hành động riêng lẻ được định nghĩa trong schema Cedar với một placeholder cho một nhóm cụ thể.

```
// policy_2.cedar
// Cho phép kiểm soát nhóm người dùng chi tiết hơn, thay đổi hành động theo nhu cầu
permit (
    principal in PetStoreApp::UserGroup::"ENTER_THE_USER_GROUP_HERE",
    action in
        [PetStoreApp::Action::"GET /pets",
         PetStoreApp::Action::"POST /pets",
         PetStoreApp::Action::"GET /pets/{petId}",
         PetStoreApp::Action::"POST /pets/{petId}/sale"],
    resource
);
```

Lưu ý rằng nếu bạn chỉ định một `operationId` trong đặc tả OpenAPI, tên hành động được định nghĩa trong Schema Cedar sẽ sử dụng `operationId` đó thay vì định dạng mặc định "<HTTP Method> /<PATH>". Trong trường hợp này, đảm bảo việc đặt tên Actions trong Chính sách Cedar của bạn khớp với việc đặt tên Actions trong Schema Cedar của bạn.

Ví dụ, nếu bạn muốn gọi hành động của bạn là `AddPet` thay vì `POST /pets`, bạn có thể đặt `operationId` trong đặc tả OpenAPI của bạn thành `AddPet`. Hành động kết quả trong chính sách Cedar sẽ là `PetStoreApp::Action::"AddPet"`

Vì chúng ta không có người dùng `admin` trong trường hợp sử dụng của chúng ta, chúng ta có thể chỉ thay thế nội dung của `policy_1.cedar` bằng các chính sách được sử dụng cho nhóm người dùng `customer`.

Trong trường hợp sử dụng thực tế, hãy cân nhắc đổi tên các file chính sách Cedar của bạn dựa trên nội dung của chúng. Ví dụ, `allow_customer_group.cedar`

```
// policy_1.cedar
// Cho phép nhóm người dùng customer truy cập getAllPets và getPetById
permit (
    principal in PetStoreApp::UserGroup::"customer",
    action in
        [PetStoreApp::Action::"GET /pets",
         PetStoreApp::Action::"GET /pets/{petId}"],
    resource
);
```

Người dùng `employee` có quyền truy cập tất cả các thao tác API. Chúng ta có thể chỉ cần thêm nhóm `employee` vào file `policy_2.cedar` để đáp ứng các yêu cầu phân quyền cho người dùng `employee`.

```
// policy_2.cedar
// Cho phép nhóm người dùng employee truy cập tất cả các hành động API
permit (
    principal in PetStoreApp::UserGroup::"employee",
    action in
        [PetStoreApp::Action::"GET /pets",
         PetStoreApp::Action::"POST /pets",
         PetStoreApp::Action::"GET /pets/{petId}",
         PetStoreApp::Action::"POST /pets/{petId}/sale"],
    resource
);
```

Lưu ý: Đối với các ứng dụng lớn với các chính sách phân quyền phức tạp, có thể khó khăn để phân tích và kiểm toán các quyền thực tế được cung cấp bởi nhiều chính sách khác nhau. Chúng tôi cũng gần đây đã mã nguồn mở [Cedar Analysis CLI](https://github.com/cedar-policy/cedar-spec) để giúp các nhà phát triển thực hiện phân tích chính sách trên các chính sách của họ. Bạn có thể tìm hiểu thêm về công cụ mới này trong bài đăng blog [Introducing Cedar Analysis: Open Source Tools for Verifying Authorization Policies.](https://aws.amazon.com/blogs/opensource/introducing-cedar-analysis-open-source-tools-for-verifying-authorization-policies)

### Cập nhật mã ứng dụng để gọi Cedar và phân quyền truy cập API

Ứng dụng sẽ sử dụng middleware Cedar để phân quyền mọi yêu cầu với các chính sách Cedar. Trước đó chúng ta đã cài đặt dependency, bây giờ chúng ta cần cập nhật mã.

Đầu tiên thêm gói vào dự án và định nghĩa `CedarInlineAuthorizationEngine` và `ExpressAuthorizationMiddleware`. Khối mã này có thể được thêm vào đầu file `app.js`.

```
const { ExpressAuthorizationMiddleware, CedarInlineAuthorizationEngine } = require ('@cedar-policy/authorization-for-expressjs');


const policies = [
    fs.readFileSync(path.join(__dirname, 'policies', 'policy_1.cedar'), 'utf8'),
    fs.readFileSync(path.join(__dirname, 'policies', 'policy_2.cedar'), 'utf8')
];



const cedarAuthorizationEngine = new CedarInlineAuthorizationEngine({
    staticPolicies: policies.join('\n'),
    schema: {
        type: 'jsonString',
        schema: fs.readFileSync(path.join(__dirname, 'v4.cedarschema.json'), 'utf8'),
    }
});


const expressAuthorization = new ExpressAuthorizationMiddleware({
    schema: {
        type: 'jsonString',
        schema: fs.readFileSync(path.join(__dirname, 'v4.cedarschema.json'), 'utf8'),
    },
    authorizationEngine: cedarAuthorizationEngine,
    principalConfiguration: {
        type: 'custom',
        getPrincipalEntity: principalEntityFetcher
    },
    skippedEndpoints: [
        {httpVerb: 'get', path: '/login'},
        {httpVerb: 'get', path: '/api-spec/v3'},
    ],
    logger: {
        debug: s => console.log(s),
        log: s => console.log(s),
    }
});
```

Tiếp theo thêm middleware Express Authorization vào ứng dụng

```
const app = express();

app.use(express.json());
app.use(verifyToken())   // xác thực token người dùng
// ... các middleware pre-authz khác

app.use(expressAuthorization.middleware);

// ... các middleware pre-authz khác
```

### Thêm mã ứng dụng để cấu hình người dùng

Công cụ phân quyền Cedar yêu cầu các nhóm người dùng và thuộc tính để phân quyền các yêu cầu. Middleware phân quyền dựa vào hàm được truyền cho `getPrincipalEntity` trong cấu hình ban đầu để tạo thực thể principal. Bạn cần triển khai hàm này để tạo thực thể người dùng.

Mã ví dụ này cung cấp một hàm để tạo thực thể người dùng. Nó giả định rằng người dùng đã được xác thực bởi một middleware trước đó và thông tin liên quan được lưu trữ trong đối tượng request. Nó cũng giả định rằng user sub đã được lưu trữ trong trường `req.user.sub` và các nhóm người dùng đã được lưu trữ trong trường `req.user.groups`.

```

async function principalEntityFetcher(req) {
       
       const user = req.user;   // đây là thực hành phổ biến cho middleware authn để lưu trữ thông tin người dùng từ token đã giải mã ở đây
       const userGroups = user["groups"].map(userGroupId => ({
           type: 'PetStoreApp::UserGroup',
           id: userGroupId       
       }));
       return {
            uid: {
                type: 'PetStoreApp::User',
                id: user.sub
            },
            attrs: {
                ...user,
            },
            parents: userGroups 
        };
} 
```

## Cập nhật middleware xác thực

Đối với ứng dụng PetStore mẫu, middleware xác thực được cung cấp bởi mã trong `middleware/authnMiddleware.js` phân tích một JSON web token (JWT) được bao gồm trong header Authorization của yêu cầu và lưu trữ các giá trị liên quan trong đối tượng request.

Lưu ý: authnMiddleware.js chỉ được sử dụng cho mục đích minh họa và không nên thay thế middleware xác thực token thực tế của bạn trong ứng dụng thực tế.

Để cập nhật middleware xác thực để sử dụng nhà cung cấp danh tính OpenID Connect (OIDC) của riêng bạn, cập nhật `jwksUri` trong khối mã sau của `middleware/authnMiddleware.js` để bao gồm JSON web key set (JWKS) uri của nhà cung cấp danh tính của bạn.

```
const client = jwksClient({
  jwksUri: '<jwks uri cho nhà cung cấp danh tính oidc của bạn>',
  cache: true,
  cacheMaxEntries: 5,
  cacheMaxAge: 600000 // 10 phút
}); 
```

Tiếp theo cập nhật `issuer` trong khối mã sau để bao gồm issuer uri của nhà cung cấp danh tính của bạn.

```
 jwt.verify(token, getSigningKey, {
    algorithms: ['RS256'],
    issuer: `<issuer uri cho nhà cung cấp danh tính oidc của bạn>`
  }, (err, decoded) => {
    if (err) {
      console.error('JWT verification error:', err);
      return res.status(401).json({ message: 'Invalid token' });
    }
    
    // Thêm token đã giải mã vào đối tượng request
    req.user = decoded;
    next();
  });
```

Nếu bạn không có quyền truy cập vào nhà cung cấp danh tính OIDC để sử dụng với mẫu này, để mục đích kiểm tra, bạn có thể thay thế toàn bộ hàm `verifyToken` và chỉ ánh xạ một thực thể người dùng mẫu vào đối tượng request. Ví dụ, thay thế `verifyToken` bằng cái này:

```
const verifyToken = (req, res, next) => {

    // Thêm thực thể người dùng mẫu vào đối tượng request
    // Để kiểm tra nhóm employee, thay đổi "customer" thành "employee"
    req.user = {
        "sub": "some-user-id",
        "groups": "customer"
    };

};
```

## Xác thực bảo mật API

Bạn có thể xác thực các chính sách và quyền truy cập API của bạn bằng cách gọi ứng dụng sử dụng các lệnh `curl` dựa trên terminal. Chúng tôi giả định rằng ứng dụng đang sử dụng nhà cung cấp danh tính OIDC để quản lý người dùng và JWT token được truyền trong header authorization cho các yêu cầu API.

Để dễ đọc, một bộ biến môi trường được sử dụng để đại diện cho các giá trị thực tế. `TOKEN_CUSTOMER` chứa các token danh tính hợp lệ cho người dùng trong nhóm employee. `API_BASE_URL` là URL cơ sở cho PetStore API nhỏ.

Để kiểm tra rằng một khách hàng được phép gọi `GET /pets`, chạy lệnh `curl` này. Yêu cầu sẽ hoàn thành thành công.

```
curl -H "Authorization: Bearer ${TOKEN_CUSTOMER}" -X GET ${API_BASE_URL}/pets
```

Yêu cầu thành công sẽ trả về danh sách thú cưng. Ban đầu, Pet Store có một thú cưng và trả về phản hồi tương tự như này.

```
[{"id":"6da5d01b-89fd-49b9-acb2-b457b79669d5","name":"Fido","species":"Dog","breed":null,"age":null,"sold":false}]
```

Để kiểm tra rằng một khách hàng không được phép gọi `POST /pets`, chạy lệnh `curl` này. Bạn sẽ nhận được thông báo lỗi rằng yêu cầu không được ủy quyền.

```
curl -H "Authorization: Bearer ${TOKEN_CUSTOMER}" -X POST ${API_BASE_URL}/pets
```

Yêu cầu không được ủy quyền sẽ trả về Not authorized with explicit deny

## Kết luận

Gói `authorization-for-expressjs` mới cho phép các nhà phát triển tích hợp ứng dụng của họ với Cedar để tách biệt logic phân quyền khỏi mã chỉ trong vài phút. Bằng cách tách biệt logic phân quyền và tích hợp ứng dụng của bạn với Cedar, bạn có thể vừa cải thiện năng suất của nhà phát triển, vừa đơn giản hóa việc kiểm toán quyền và truy cập.

Các gói framework là mã nguồn mở và có sẵn trên GitHub dưới giấy phép Apache 2.0, với phân phối thông qua NPM. Để tìm hiểu thêm về Cedar và thử nghiệm nó bằng playground ngôn ngữ, hãy truy cập [https://www.cedarpolicy.com/](https://www.cedarpolicy.com/). Hãy thoải mái gửi câu hỏi, nhận xét và đề xuất thông qua không gian làm việc Cedar Slack công khai, [https://cedar-policy.slack.com](https://cedar-policy.slack.com).
