# DD Content Requirements - Danh sách nội dung bắt buộc

> 📌 File này định nghĩa các nội dung **BẮT BUỘC** cho từng file trong Detailed Design Document.
> Nếu thiếu bất kỳ nội dung nào, đánh giá là **❌ FAIL**.
> 📎 **Tham khảo**: Dựa trên cấu trúc của `改善提案プラットフォーム/詳細設計書`

---

## 📋 Quy tắc kiểm tra

### Cấp độ đánh giá

| Cấp độ          | Ký hiệu | Quy tắc                               |
| :-------------- | :------ | :------------------------------------ |
| **CRITICAL**    | 🔴      | Thiếu → **FAIL** ngay, không tiếp tục |
| **REQUIRED**    | 🟠      | Thiếu → **FAIL** cho file đó          |
| **RECOMMENDED** | 🟡      | Thiếu → **WARNING**, không fail       |
| **OPTIONAL**    | 🟢      | Không bắt buộc                        |

### Đánh giá tổng thể

- **PASS**: Tất cả CRITICAL và REQUIRED đều có
- **CONDITIONAL PASS**: Tất cả CRITICAL có, thiếu một số REQUIRED nhưng có lý do hợp lệ
- **FAIL**: Thiếu bất kỳ CRITICAL nào, hoặc thiếu >30% REQUIRED

---

## 📁 \_index.md (MỤC LỤC - BẮT BUỘC)

### 🔴 CRITICAL Items

| ID      | Nội dung yêu cầu           | Kiểm tra                                   |
| :------ | :------------------------- | :----------------------------------------- |
| IDX-C01 | Document Information Table | Có bảng thông tin tài liệu (version, date) |
| IDX-C02 | Document Structure Table   | Có bảng liệt kê tất cả files DD với links  |

### 🟠 REQUIRED Items

| ID      | Nội dung yêu cầu         | Kiểm tra                            |
| :------ | :----------------------- | :---------------------------------- |
| IDX-R01 | Technology Stack Summary | Có bảng tóm tắt tech stack chính    |
| IDX-R02 | Module Summary           | Có bảng liệt kê modules và packages |
| IDX-R03 | Database Summary         | Có số lượng tables và loại          |
| IDX-R04 | API Summary              | Có số lượng APIs và auth method     |
| IDX-R05 | Related Documents Links  | Có links đến SRS và BD              |
| IDX-R06 | Change History           | Có bảng lịch sử thay đổi            |
| IDX-R07 | Design Patterns Summary  | Có bảng tóm tắt patterns sử dụng    |

---

## 📁 00-bd-dd-mapping.md

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu              | Kiểm tra                                   |
| :----- | :---------------------------- | :----------------------------------------- |
| 00-C01 | Coverage Table cho Use Cases  | Đếm số UC trong BD = số UC trong mapping   |
| 00-C02 | Coverage Table cho Screens    | Đếm số Screen trong BD = số Screen mapping |
| 00-C03 | Coverage Table cho Tables     | Đếm số Table trong BD = số Table mapping   |
| 00-C04 | Coverage Table cho APIs       | Đếm số API trong BD = số API mapping       |
| 00-C05 | Coverage Table cho Batch Jobs | Đếm số Batch trong BD = số Batch mapping   |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu                     | Kiểm tra                                  |
| :----- | :----------------------------------- | :---------------------------------------- |
| 00-R01 | Links đến DD sections phải hoạt động | Random check 5 links → phải trỏ đúng file |
| 00-R02 | Summary statistics table             | Phải có bảng tổng kết số lượng            |

---

## 📁 01-introduction.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu           | Kiểm tra                    |
| :----- | :------------------------- | :-------------------------- |
| 01-R01 | Document Information Table | Có bảng thông tin tài liệu  |
| 01-R02 | Revision History           | Có bảng lịch sử chỉnh sửa   |
| 01-R03 | Approvers Table            | Có bảng phê duyệt           |
| 01-R04 | Document Scope             | Có mô tả phạm vi tài liệu   |
| 01-R05 | Audience                   | Có định nghĩa đối tượng đọc |

---

## 📁 02-references-terminology.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu          | Kiểm tra                             |
| :----- | :------------------------ | :----------------------------------- |
| 02-R01 | External References Table | Có bảng tài liệu tham khảo bên ngoài |
| 02-R02 | Internal References Links | Có links đến SRS và BD               |
| 02-R03 | Business Terminology      | Có bảng thuật ngữ nghiệp vụ          |
| 02-R04 | Technical Terminology     | Có bảng thuật ngữ kỹ thuật           |
| 02-R05 | Abbreviations Table       | Có bảng viết tắt                     |

---

## 📁 03-system-overview.md

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu             | Kiểm tra                                 |
| :----- | :--------------------------- | :--------------------------------------- |
| 03-C01 | Document Information Section | Có section 3.0 với version, date, author |
| 03-C02 | Architecture Diagram         | Có Mermaid/C4 diagram                    |
| 03-C03 | Technology Stack Tables      | Có bảng tech stack đầy đủ categories     |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu               | Kiểm tra                                  |
| :----- | :----------------------------- | :---------------------------------------- |
| 03-R01 | Phase Scope với số liệu        | Có bảng scope với số lượng functions      |
| 03-R02 | Milestones Table               | Có bảng milestones với timeline           |
| 03-R03 | Actor Definition Table         | Có bảng định nghĩa actors                 |
| 03-R04 | Actor → Service Mapping Table  | Có bảng mapping actor với services        |
| 03-R05 | Role → Permission Matrix       | Có ma trận CRUD permissions               |
| 03-R06 | Technology Selection Rationale | Có cột "選定理由" trong tech stack        |
| 03-R07 | Design Decisions Section       | Có section Design Decisions với IDs       |
| 03-R08 | External Integration Table     | Có bảng liên kết hệ thống ngoài           |
| 03-R09 | Design Patterns Table          | Có bảng patterns với implementation guide |
| 03-R10 | Cross-Reference Links          | Có links đến BD và các file DD khác       |
| 03-R11 | Assumptions & Constraints      | Có section tiền đề và ràng buộc           |
| 03-R12 | Terminology Quick Reference    | Có hoặc có link đến 02-references         |

---

## 📁 04-design-considerations.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu            | Kiểm tra                                   |
| :----- | :-------------------------- | :----------------------------------------- |
| 04-R01 | Non-Functional Requirements | Có bảng NFRs (Performance, Security, etc.) |
| 04-R02 | Design Assumptions          | Có danh sách giả định thiết kế             |
| 04-R03 | Design Constraints          | Có danh sách ràng buộc                     |
| 04-R04 | Quality Attributes          | Có bảng quality attributes với metrics     |
| 04-R05 | Trade-off Decisions         | Có mô tả các trade-off đã chọn             |

---

## 📁 05-module-design.md (hoặc 04-module-design.md)

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu         | Kiểm tra                                         |
| :----- | :----------------------- | :----------------------------------------------- |
| 05-C01 | Class Diagrams (Mermaid) | Có ít nhất 1 class diagram cho MỖI module        |
| 05-C02 | Package Structure        | Có mô tả cấu trúc package/namespace đầy đủ       |
| 05-C03 | Module Overview Table    | Có bảng liệt kê TẤT CẢ modules với ID và package |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu             | Kiểm tra                                                    |
| :----- | :--------------------------- | :---------------------------------------------------------- |
| 05-R01 | Module Dependencies Table    | Có bảng mô tả "依存先/依存元" cho mỗi module                |
| 05-R02 | Service Interface per Module | Có interface definition cho services (<<interface>>)        |
| 05-R03 | Service Implementation Class | Có class Impl cho mỗi service interface                     |
| 05-R04 | DAO Interface per Module     | Có DAO interface với CRUD methods                           |
| 05-R05 | Entity Classes Definition    | Có định nghĩa các entity classes với fields đầy đủ          |
| 05-R06 | Enum Classes Definition      | Có định nghĩa các enum (Status, Type, etc.)                 |
| 05-R07 | Method Signatures Table      | Có bảng "メソッド/戻り値/説明" cho mỗi service              |
| 05-R08 | Dependencies Matrix          | Có bảng ma trận "呼び出し元 × 呼び出し先"                   |
| 05-R09 | Public Interface List        | Có bảng "公開インターフェース一覧" (Module/Service/Methods) |
| 05-R10 | Utility Classes              | Có mô tả utility classes (DateUtil, SecurityUtil, etc.)     |
| 05-R11 | Exception Classes            | Có định nghĩa custom exception classes                      |
| 05-R12 | BD Reference Links           | Có links/references đến BD (📋 BD Reference: ...)           |
| 05-R13 | Module Coverage Summary      | Có bảng tổng kết coverage của modules với DD sections       |
| 05-R14 | BD-UC Mapping per Module     | Có bảng mapping Module → Use Cases → Screens                |

---

## 📁 06-component-design.md (hoặc 05-component-design.md)

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu                | Kiểm tra                                                 |
| :----- | :------------------------------ | :------------------------------------------------------- |
| 06-C01 | Sequence Diagrams cho TẤT CẢ UC | Có sequence diagram cho MỖI Use Case (không bỏ sót)      |
| 06-C02 | Pseudocode cho business logic   | Có pseudocode với if/else/loop/exception cho UC phức tạp |
| 06-C03 | Batch Processing Design         | Có flowchart và pseudocode cho TẤT CẢ batch jobs         |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu              | Kiểm tra                                                              |
| :----- | :---------------------------- | :-------------------------------------------------------------------- |
| 06-R01 | 処理概要 per UC               | Có mô tả "処理概要" ở đầu mỗi UC section                              |
| 06-R02 | ビジネスロジック詳細          | Có section "ビジネスロジック詳細" với processing steps                |
| 06-R03 | Validation Rules Table per UC | Có bảng validation (フィールド/下書き/提出時/最大長)                  |
| 06-R04 | Business Rules Table          | Có bảng "ビジネスルール" với Rule ID và Rule content                  |
| 06-R05 | State Transition Rules        | Có bảng "ステータス遷移ルール" cho entities có status                 |
| 06-R06 | SQL Queries in Sequence       | Sequence diagram hiển thị SQL queries đầy đủ (SELECT, UPDATE, INSERT) |
| 06-R07 | Error Handling in Pseudocode  | Pseudocode có TRY/CATCH/THROW exceptions                              |
| 06-R08 | Search Conditions Table       | Có bảng "検索条件" (パラメータ/説明/クエリ条件)                       |
| 06-R09 | Notification Logic            | Có mô tả logic gửi notifications (DB insert + Email)                  |
| 06-R10 | Batch Flowcharts (Mermaid)    | Có flowchart cho mỗi batch job với decision nodes                     |
| 06-R11 | Batch SQL Scripts             | Có SQL scripts cho batch operations                                   |
| 06-R12 | UC Coverage Summary Table     | Có bảng "詳細設計済みユースケース" (UC ID/Name/DD Section/内容)       |
| 06-R13 | Reference UC Table            | Có bảng "参照ユースケース" cho UCs không cần detail riêng             |
| 06-R14 | Batch Coverage Summary Table  | Có bảng "詳細設計済みバッチ" (BAT ID/Name/DD Section/内容)            |
| 06-R15 | Alt/Loop/Opt in Sequence      | Sequence diagrams sử dụng alt/loop/opt fragments đúng cách            |
| 06-R16 | Actor Labels in Japanese      | Participants trong sequence có label tiếng Nhật (ユーザー, Manager)   |

---

## 📁 07-database-design.md

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu               | Kiểm tra                             |
| :----- | :----------------------------- | :----------------------------------- |
| 07-C01 | DDL cho TẤT CẢ tables trong BD | Đếm số DDL = số tables trong BD      |
| 07-C02 | Primary Keys defined           | Mọi table đều có PK                  |
| 07-C03 | Foreign Keys defined           | Các FK relationships được định nghĩa |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu             | Kiểm tra                                        |
| :----- | :--------------------------- | :---------------------------------------------- |
| 07-R01 | Data Types specified         | Có column types cụ thể (VARCHAR, INT, etc.)     |
| 07-R02 | Indexes defined              | Có indexes cho search/query columns             |
| 07-R03 | Constraints (CHECK, UNIQUE)  | Có constraints ngoài PK/FK                      |
| 07-R04 | Column Descriptions/Comments | Có COMMENT ON cho tables và columns quan trọng  |
| 07-R05 | ER Diagram                   | Có ER diagram (Mermaid hoặc ASCII)              |
| 07-R06 | Trigger Functions            | Có định nghĩa triggers nếu cần (updated_at etc) |
| 07-R07 | Sample/Initial Data          | Có INSERT cho master data và test data          |
| 07-R08 | Estimated Row Count          | Có dự kiến số lượng records cho mỗi table       |

---

## 📁 08-api-design.md (hoặc 07-api-design.md)

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu       | Kiểm tra                                              |
| :----- | :--------------------- | :---------------------------------------------------- |
| 08-C01 | API Overview Table     | Có bảng tổng quan (ベース URL, Protocol, Auth method) |
| 08-C02 | Action List per Module | Có bảng liệt kê TẤT CẢ actions với Path/Method/Auth   |
| 08-C03 | AJAX API Detail Specs  | Có chi tiết cho mỗi API: Request, Response, Errors    |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu              | Kiểm tra                                                        |
| :----- | :---------------------------- | :-------------------------------------------------------------- |
| 08-R01 | Action Tables per Category    | Có bảng riêng cho từng nhóm (認証系, 提案管理, 承認管理)        |
| 08-R02 | 認証/必要ロール Columns       | Mỗi Action có cột 認証 và 必要ロール                            |
| 08-R03 | Request JSON Schema           | Mỗi API có JSON request body với validation rules               |
| 08-R04 | Response JSON Schema          | Mỗi API có JSON response với data structure                     |
| 08-R05 | Business Logic per API        | Có section "処理ステップ" với numbered steps                    |
| 08-R06 | Pseudocode per Complex API    | Có pseudocode cho APIs phức tạp                                 |
| 08-R07 | SQL Queries in API            | Có SQL queries cho database operations                          |
| 08-R08 | Error Responses Table         | Có bảng Error (Status/Code/Description) cho mỗi API             |
| 08-R09 | Form Submission Specs         | Có section 7.4 với Form fields, Validation, Business rules      |
| 08-R10 | Form Fields Table             | Có bảng (フィールド/パラメータ名/型/必須/バリデーション)        |
| 08-R11 | API Coverage Summary Table    | Có bảng "AJAX API（詳細設計済み）" với API ID/Name/DD Section   |
| 08-R12 | Struts Actions Summary Table  | Có bảng "Struts Actions（詳細設計済み）" với Action/Methods/UC  |
| 08-R13 | Form Submission Summary Table | Có bảng "Form Submission Summary" với Form Name/UC/Content      |
| 08-R14 | UC→API Traceability Matrix    | Có bảng mapping UC → Action/API với Status ✅                   |
| 08-R15 | Error Code Master List        | Có section "エラーコード一覧" với Category/Code/HTTP/説明       |
| 08-R16 | Error Response JSON Format    | Có mẫu error JSON format (success, errorCode, message, details) |
| 08-R17 | File Upload Specs             | Có specs cho file upload (size, extensions, count limits)       |
| 08-R18 | Bulk Operation Pseudocode     | Có pseudocode cho bulk operations (一括承認 etc.)               |

---

## 📁 09-ui-specifications.md (hoặc 08-ui-specifications.md)

### � CRITICAL Items

| ID     | Nội dung yêu cầu                 | Kiểm tra                                                 |
| :----- | :------------------------------- | :------------------------------------------------------- |
| 09-C01 | Common Layout Specs              | Có sections 共通レイアウト (Header, Sidebar, Footer)     |
| 09-C02 | Screen Layouts (ASCII/Wireframe) | Có wireframe cho TẤT CẢ screens chính                    |
| 09-C03 | Component Specs per Screen       | Có bảng コンポーネント仕様 (ID/要素/属性/バリデーション) |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu                  | Kiểm tra                                                        |
| :----- | :-------------------------------- | :-------------------------------------------------------------- |
| 09-R01 | Responsive Breakpoints            | Có bảng breakpoints (xs/sm/md/lg/xl) với pixel values           |
| 09-R02 | Header Components Table           | Có bảng liệt kê header elements (Logo, Notification, User menu) |
| 09-R03 | Sidebar Menu Table                | Có bảng menu items với Icon, 表示条件, リンク先                 |
| 09-R04 | Screen Info Table                 | Mỗi screen có bảng (画面 ID/画面名/URL/認証/権限)               |
| 09-R05 | Validation Rules Table per Screen | Có bảng (フィールド/条件/エラーメッセージ)                      |
| 09-R06 | Events Table per Screen           | Có bảng (イベント/トリガー/アクション)                          |
| 09-R07 | Screen Coverage Summary Table     | Có bảng "詳細設計済み画面" (SCR ID/Name/DD Section/Content)     |
| 09-R08 | Reference Screen Table            | Có bảng "参照画面" với BD Reference và 類似画面                 |
| 09-R09 | Loading States Specs              | Có section "ローディング状態" với loại/表示方法/使用場面        |
| 09-R10 | Spinner CSS Code                  | Có CSS code cho loading spinner                                 |
| 09-R11 | Error States Specs                | Có section "エラー状態" (Inline, Toast, Page errors)            |
| 09-R12 | Error HTML Example                | Có HTML example cho error state                                 |
| 09-R13 | Empty States Specs                | Có bảng "空状態" cho từng screen type                           |
| 09-R14 | Success Feedback Specs            | Có bảng "成功状態" với feedback method và display time          |
| 09-R15 | Confirm Dialog Specs              | Có section với Dialog Types và Dialog Messages Table            |
| 09-R16 | Dialog Layout (ASCII)             | Có wireframe cho confirmation dialogs                           |
| 09-R17 | Keyboard Navigation Table         | Có bảng (キー/動作/対象要素)                                    |
| 09-R18 | Focus CSS Code                    | Có CSS code cho focus states (:focus, :focus-visible)           |
| 09-R19 | ARIA Guidelines Table             | Có bảng (場面/必須 ARIA 属性/例)                                |
| 09-R20 | Color Contrast Requirements       | Có bảng contrast ratio requirements (WCAG 2.1 AA)               |
| 09-R21 | Touch Target Size Specs           | Có bảng minimum touch target size per device                    |
| 09-R22 | BD Reference Matrix               | Có bảng mapping DD Section → BD Reference → Coverage Status     |
| 09-R23 | Button Disabled Rules             | Có bảng (状況/ボタン状態/視覚的表現)                            |

---

## 📁 10-security-design.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu              | Kiểm tra                                |
| :----- | :---------------------------- | :-------------------------------------- |
| 10-R01 | Authentication Implementation | Có hướng dẫn implementation cụ thể      |
| 10-R02 | Authorization (RBAC)          | Có mô tả RBAC implementation            |
| 10-R03 | Encryption Specs              | Có chỉ định algorithms (AES, JWT, etc.) |
| 10-R04 | Security Headers              | Có danh sách HTTP security headers      |
| 10-R05 | Input Validation              | Có mô tả input sanitization             |

---

## 📁 11-error-handling.md (hoặc 10-error-handling.md)

### 🔴 CRITICAL Items

| ID     | Nội dung yêu cầu             | Kiểm tra                                           |
| :----- | :--------------------------- | :------------------------------------------------- |
| 11-C01 | Error Code Format Definition | Có định nghĩa format [SERVICE]-[CATEGORY]-[NUMBER] |
| 11-C02 | Error Code List per Module   | Có bảng error codes cho TẤT CẢ modules             |
| 11-C03 | Exception Class Hierarchy    | Có class diagram (Mermaid) cho exception classes   |

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu                   | Kiểm tra                                                                |
| :----- | :--------------------------------- | :---------------------------------------------------------------------- |
| 11-R01 | Service Codes Table                | Có bảng (コード/サービス名/説明) cho tất cả services                    |
| 11-R02 | Category Codes Table               | Có bảng (コード/カテゴリ名/説明) - VAL/BIZ/SEC/SYS/DAT                  |
| 11-R03 | Error Table per Module             | Mỗi module có bảng (エラーコード/HTTP ステータス/メッセージ/原因・対処) |
| 11-R04 | Exception Classes Java Code        | Có Java code cho TẤT CẢ exception classes                               |
| 11-R05 | Base Exception Class               | Có KaizenException base class với errorCode, args                       |
| 11-R06 | BusinessException Implementation   | Có class với httpStatus field                                           |
| 11-R07 | ValidationException Implementation | Có class với Map<String, String> fieldErrors                            |
| 11-R08 | SystemException Implementation     | Có class cho database, file, mail, external service                     |
| 11-R09 | Error Handling Flow Diagram        | Có ASCII diagram cho レイヤー別エラー処理フロー                         |
| 11-R10 | ExceptionInterceptor Code          | Có Java code cho Struts/Spring exception interceptor                    |
| 11-R11 | AJAX Error Response Code           | Có Java code cho JSON error response methods                            |
| 11-R12 | Validation Error Display HTML      | Có HTML/JSP code cho field error và global error display                |
| 11-R13 | Error CSS Styles                   | Có CSS code cho .has-error, .error-message, .alert                      |
| 11-R14 | Error Pages List                   | Có bảng (HTTP/JSP ファイル/表示内容) cho 400,401,403,404,500,503        |
| 11-R15 | Error Page Layout (ASCII)          | Có wireframe cho error page layout                                      |
| 11-R16 | web.xml Error Page Config          | Có XML config cho error-page mappings                                   |
| 11-R17 | Error Log Format                   | Có log format example với timestamp, user, session, request             |
| 11-R18 | Log Level per Exception Type       | Có bảng (例外タイプ/ログレベル/出力内容)                                |
| 11-R19 | Logback/Log4j Config               | Có XML config cho error logging                                         |
| 11-R20 | BD Reference Matrix                | Có bảng mapping BD Section → DD Section → Coverage Status               |
| 11-R21 | Design Decisions                   | Có notes về checked vs unchecked exceptions etc.                        |

---

## 📁 12-logging-monitoring.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu       | Kiểm tra                             |
| :----- | :--------------------- | :----------------------------------- |
| 12-R01 | Log Levels Definition  | Có định nghĩa INFO/WARN/ERROR/DEBUG  |
| 12-R02 | Log Format             | Có mẫu log format (JSON, structured) |
| 12-R03 | Sensitive Data Masking | Có quy định masking PII/passwords    |
| 12-R04 | Metrics Definition     | Có danh sách metrics cần thu thập    |
| 12-R05 | Alerting Rules         | Có quy tắc alert khi threshold vượt  |

---

## 📁 13-deployment-design.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu          | Kiểm tra                       |
| :----- | :------------------------ | :----------------------------- |
| 13-R01 | Environment Configuration | Có bảng config cho DEV/STG/PRD |
| 13-R02 | Environment Variables     | Có danh sách env vars          |
| 13-R03 | Config Files Template     | Có template hoặc ví dụ config  |
| 13-R04 | Deployment Diagram        | Có sơ đồ deployment            |
| 13-R05 | Rollback Procedures       | Có quy trình rollback          |

---

## 📁 14-appendices.md

### 🟡 RECOMMENDED Items

| ID     | Nội dung yêu cầu      | Kiểm tra                      |
| :----- | :-------------------- | :---------------------------- |
| 14-W01 | Glossary Index        | Có index cho thuật ngữ        |
| 14-W02 | Additional References | Có tài liệu tham khảo bổ sung |
| 14-W03 | Sample Data           | Có dữ liệu mẫu nếu cần        |

---

## 📁 15-checklist-results.md

### 🟠 REQUIRED Items

| ID     | Nội dung yêu cầu            | Kiểm tra                              |
| :----- | :-------------------------- | :------------------------------------ |
| 15-R01 | Checklist Completion Status | Có status cho từng mục checklist      |
| 15-R02 | Issues Found                | Có danh sách issues được tìm thấy     |
| 15-R03 | Resolution Status           | Có status resolved/pending cho issues |
| 15-R04 | Coverage Statistics         | Có thống kê % coverage                |

---

## 📊 Tổng kết yêu cầu

| File                         | CRITICAL | REQUIRED | Total Checks |
| :--------------------------- | :------- | :------- | :----------- |
| \_index.md                   | 2        | 7        | 9            |
| 00-bd-dd-mapping.md          | 5        | 2        | 7            |
| 01-introduction.md           | 0        | 5        | 5            |
| 02-references-terminology.md | 0        | 5        | 5            |
| 03-system-overview.md        | 3        | 12       | 15           |
| 04-design-considerations.md  | 0        | 5        | 5            |
| 05-module-design.md          | 3        | 14       | 17           |
| 06-component-design.md       | 3        | 16       | 19           |
| 07-database-design.md        | 3        | 8        | 11           |
| 08-api-design.md             | 3        | 18       | 21           |
| 09-ui-specifications.md      | 3        | 23       | 26           |
| 10-security-design.md        | 0        | 5        | 5            |
| 11-error-handling.md         | 3        | 21       | 24           |
| 12-logging-monitoring.md     | 0        | 5        | 5            |
| 13-deployment-design.md      | 0        | 5        | 5            |
| 14-appendices.md             | 0        | 0        | 0 (+ 3 WARN) |
| 15-checklist-results.md      | 0        | 4        | 4            |
| **TOTAL**                    | **28**   | **155**  | **183**      |

---

## 📝 Cách sử dụng

### Khi tạo DD (create-dd workflow)

1. Sau khi tạo mỗi file, check ngay theo bảng requirements
2. Nếu thiếu CRITICAL → Không tiếp tục, bổ sung ngay
3. Nếu thiếu REQUIRED → Warning, liệt kê vào 15-checklist-results.md

### Khi review DD (review-dd workflow)

1. Load file này đầu tiên
2. Check từng file theo bảng requirements
3. Đánh giá:
   - Thiếu CRITICAL → ❌ **FAIL** cho file đó
   - Thiếu REQUIRED → ⚠️ **WARNING** nhưng vẫn có thể fail nếu >30% thiếu
4. Tổng kết Pass/Fail cho toàn bộ DD

---

_Cập nhật: 2024-12-24_
