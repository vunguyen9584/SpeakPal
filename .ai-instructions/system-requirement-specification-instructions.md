# HƯỚNG DẪN TOÀN DIỆN: AI TẠO TÀI LIỆU ĐẶC TẢ YÊU CẦU HỆ THỐNG (SRS)

---

## 📋 MỤC LỤC

1. [Tổng quan](#1-tổng-quan)
2. [Cấu trúc thư mục tài liệu](#2-cấu-trúc-thư-mục)
3. [Quy trình tạo SRS](#3-quy-trình-tạo-srs)
4. [Hướng dẫn xử lý câu hỏi "Chưa biết"](#4-xử-lý-câu-hỏi-chưa-biết)
5. [Template nội dung từng section](#5-template-nội-dung)
6. [Decision Log Guidelines](#6-decision-log-guidelines)
7. [Checklist & Quality Assurance](#7-quality-assurance)

---

## 1. TỔNG QUAN

### 1.1. Mục đích

Hướng dẫn này giúp AI tạo tài liệu **System Requirement Specification (SRS)** chuyên nghiệp, đầy đủ và có chất lượng cao dựa trên thông tin thu thập từ form.

### 1.2. Input cần thiết

```
┌─────────────────────────────────────────────────────────────────┐
│                    INPUT CHO AI                                  │
├─────────────────────────────────────────────────────────────────┤
│  1. Form thu thập thông tin (Bắt buộc)                          │
│     - Mục đích hệ thống (⭐ Bắt buộc)                            │
│     - Chức năng mong muốn (⭐ Bắt buộc)                          │
│     - Các mục khác (có thể "[Chưa biết]")                       │
│                                                                  │
│  2. Tài liệu tham khảo (Tùy chọn)                               │
│     - Business documents                                         │
│     - Existing system documentation                              │
│     - Wireframe/Mockup                                          │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3. Output

- Tài liệu SRS hoàn chỉnh theo cấu trúc chuẩn
- Decision Log ghi nhận các quyết định
- Traceability Matrix (nếu cần)

---

## 2. CẤU TRÚC THƯ MỤC TÀI LIỆU

### 2.1. Cấu trúc chuẩn

```
📁 [Tên SRS Document]/
├── 📄 _index.md                    # Tổng quan & mục lục
├── 📄 01-introduction.md           # Giới thiệu
├── 📄 02-overall-description.md    # Mô tả tổng quan
├── 📄 03-functional-requirements.md # Yêu cầu chức năng
├── 📄 04-external-interfaces.md    # Giao diện bên ngoài
├── 📄 05-non-functional-requirements.md # Yêu cầu phi chức năng
├── 📄 06-other-requirements.md     # Yêu cầu khác
└── 📄 07-appendix.md               # Phụ lục
```

### 2.2. Quy tắc đặt tên thư mục

| Ngôn ngữ   | Tên thư mục                        |
| ---------- | ---------------------------------- |
| Tiếng Việt | `Tài liệu Đặc tả Yêu cầu Hệ thống` |
| Tiếng Anh  | `System Requirement Specification` |
| Tiếng Nhật | `システム要件定義書`               |

### 2.3. Template \_index.md

```markdown
# [TÊN DỰ ÁN] - TÀI LIỆU ĐẶC TẢ YÊU CẦU HỆ THỐNG

## Thông tin tài liệu

| Thuộc tính | Giá trị                   |
| ---------- | ------------------------- |
| Dự án      | [Tên dự án]               |
| Phiên bản  | 1.0                       |
| Ngày tạo   | [DD/MM/YYYY]              |
| Trạng thái | Draft / Review / Approved |

## Tóm tắt

[Mô tả ngắn gọn 3-5 câu về hệ thống]

## Cấu trúc tài liệu

| STT | File                                                                     | Nội dung              |
| --- | ------------------------------------------------------------------------ | --------------------- |
| 1   | [01-introduction.md](./01-introduction.md)                               | Giới thiệu            |
| 2   | [02-overall-description.md](./02-overall-description.md)                 | Mô tả tổng quan       |
| 3   | [03-functional-requirements.md](./03-functional-requirements.md)         | Yêu cầu chức năng     |
| 4   | [04-external-interfaces.md](./04-external-interfaces.md)                 | Giao diện             |
| 5   | [05-non-functional-requirements.md](./05-non-functional-requirements.md) | Yêu cầu phi chức năng |
| 6   | [06-other-requirements.md](./06-other-requirements.md)                   | Yêu cầu khác          |
| 7   | [07-appendix.md](./07-appendix.md)                                       | Phụ lục               |

## Thông tin AI Context

### Actors/Users

[Liệt kê các actors chính]

### Core Features

[Liệt kê các feature chính]

### Key Constraints

[Liệt kê các ràng buộc quan trọng]
```

---

## 3. QUY TRÌNH TẠO SRS

### 3.1. Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 1: PHÂN TÍCH FORM THU THẬP THÔNG TIN                       │
├─────────────────────────────────────────────────────────────────┤
│ • Đọc và hiểu mục đích hệ thống (Bắt buộc)                      │
│ • Phân tích danh sách chức năng (Bắt buộc)                      │
│ • Xác định các mục "[Chưa biết]" cần AI đề xuất                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 2: ĐỀ XUẤT CHO CÁC MỤC "CHƯA BIẾT"                         │
├─────────────────────────────────────────────────────────────────┤
│ • Phân tích context từ mục đích và chức năng                    │
│ • Đưa ra đề xuất hợp lý cho từng mục                            │
│ • Ghi nhận vào Decision Log với lý do                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 3: TẠO CẤU TRÚC TÀI LIỆU                                   │
├─────────────────────────────────────────────────────────────────┤
│ • Tạo thư mục theo ngôn ngữ                                     │
│ • Tạo file _index.md                                            │
│ • Tạo các file section theo template                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 4: VIẾT NỘI DUNG CHI TIẾT                                  │
├─────────────────────────────────────────────────────────────────┤
│ • Viết theo template từng section                               │
│ • Đảm bảo traceability giữa các yêu cầu                         │
│ • Sử dụng Requirement ID nhất quán                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 5: CẬP NHẬT DECISION LOG                                   │
├─────────────────────────────────────────────────────────────────┤
│ • Ghi nhận tất cả quyết định AI đã thực hiện                    │
│ • Đánh dấu trạng thái chờ xác nhận                              │
│ • Tính toán thống kê                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ BƯỚC 6: KIỂM TRA CHẤT LƯỢNG                                     │
├─────────────────────────────────────────────────────────────────┤
│ • Verify với checklist                                          │
│ • Cross-reference giữa các sections                             │
│ • Đảm bảo nhất quán về thuật ngữ                                │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2. Quy tắc gán Requirement ID

| Loại                       | Prefix | Ví dụ            |
| -------------------------- | ------ | ---------------- |
| Functional Requirement     | FR     | FR-001, FR-002   |
| Non-Functional Requirement | NFR    | NFR-001, NFR-002 |
| Business Rule              | BR     | BR-001, BR-002   |
| Use Case                   | UC     | UC-001, UC-002   |
| User Story                 | US     | US-001, US-002   |

---

## 4. XỬ LÝ CÂU HỎI "CHƯA BIẾT"

### 4.1. Nguyên tắc chung

Khi người dùng chọn **[Chưa biết]**, AI cần:

1. **Phân tích context** từ mục đích và chức năng đã cung cấp
2. **Đưa ra đề xuất hợp lý** dựa trên best practices
3. **Ghi nhận vào Decision Log** với lý do rõ ràng
4. **Đánh dấu chờ xác nhận** để người dùng review

### 4.2. Bảng hướng dẫn đề xuất

| Hạng mục              | Cách xử lý khi "[Chưa biết]"                        |
| --------------------- | --------------------------------------------------- |
| **Đối tượng sử dụng** | Phân tích từ chức năng → xác định roles cần thiết   |
| **Phạm vi**           | Dựa vào chức năng → xác định in/out scope           |
| **Loại ứng dụng**     | Phân tích tính chất → đề xuất Web/Mobile/Desktop    |
| **Công nghệ**         | Dựa vào loại app + quy mô → đề xuất stack phổ biến  |
| **Hiệu năng**         | Mức tiêu chuẩn: CCU 100-500, Response < 2s          |
| **Bảo mật**           | Mức trung bình cho hầu hết hệ thống                 |
| **Tương thích**       | Chrome, Firefox, Safari, Edge (2 versions gần nhất) |
| **Tích hợp**          | Không có nếu không mention trong chức năng          |
| **Timeline**          | Không đề xuất, để người dùng quyết định             |

### 4.3. Template Decision Log Entry

```markdown
### DEC-XXX: [Hạng mục]

| Thuộc tính     | Giá trị         |
| -------------- | --------------- |
| **Nguồn**      | 🤖 AI           |
| **Trạng thái** | ⏳ Chờ xác nhận |

**Đề xuất:** [Nội dung đề xuất]

**Lý do:**

- Phân tích context: [Giải thích]
- Best practice: [Tham chiếu]
- Trade-off: [Ưu/Nhược điểm]

**Phương án khác:**

1. [Phương án A] - [Lý do không chọn]
2. [Phương án B] - [Lý do không chọn]
```

---

## 5. TEMPLATE NỘI DUNG TỪNG SECTION

### 5.1. 01-introduction.md

```markdown
# 1. GIỚI THIỆU

## 1.1. Mục đích tài liệu

[Mô tả mục đích của tài liệu SRS này]

## 1.2. Phạm vi hệ thống

### 1.2.1. Trong phạm vi (In Scope)

[Liệt kê]

### 1.2.2. Ngoài phạm vi (Out of Scope)

[Liệt kê]

## 1.3. Định nghĩa và thuật ngữ

| Thuật ngữ | Định nghĩa |
| --------- | ---------- |
|           |            |

## 1.4. Tài liệu tham khảo

[Liệt kê các tài liệu liên quan]

## 1.5. Tổng quan tài liệu

[Mô tả cấu trúc tài liệu]
```

### 5.2. 02-overall-description.md

```markdown
# 2. MÔ TẢ TỔNG QUAN

## 2.1. Bối cảnh sản phẩm

[Mô tả context của hệ thống]

## 2.2. Chức năng chính của sản phẩm

[Tóm tắt các chức năng chính]

## 2.3. Đặc điểm người dùng

| Role | Mô tả | Trình độ kỹ thuật |
| ---- | ----- | ----------------- |
|      |       |                   |

## 2.4. Ràng buộc

### 2.4.1. Ràng buộc kỹ thuật

### 2.4.2. Ràng buộc pháp lý

### 2.4.3. Ràng buộc nghiệp vụ

## 2.5. Giả định và phụ thuộc

### 2.5.1. Giả định

### 2.5.2. Phụ thuộc
```

### 5.3. 03-functional-requirements.md

```markdown
# 3. YÊU CẦU CHỨC NĂNG

## 3.1. Tổng quan chức năng

| ID     | Tên chức năng | Mô tả | Độ ưu tiên        |
| ------ | ------------- | ----- | ----------------- |
| FR-001 |               |       | Must/Should/Could |

## 3.2. Chi tiết từng chức năng

### FR-001: [Tên chức năng]

#### Mô tả

[Mô tả chi tiết]

#### Actors

[Liệt kê actors liên quan]

#### Preconditions

- [Điều kiện 1]

#### Main Flow

1. [Bước 1]
2. [Bước 2]

#### Alternative Flows

**AF-001:** [Tên flow]

1. [Bước]

#### Exception Flows

**EF-001:** [Tên exception]

1. [Xử lý]

#### Postconditions

- [Kết quả]

#### Business Rules

- BR-XXX: [Rule]

#### Validation Rules

| Field | Type | Required | Validation |
| ----- | ---- | -------- | ---------- |
|       |      |          |            |
```

### 5.4. 04-external-interfaces.md

```markdown
# 4. GIAO DIỆN BÊN NGOÀI

## 4.1. Giao diện người dùng (UI)

### 4.1.1. Danh sách màn hình

### 4.1.2. Screen Flow

### 4.1.3. Wireframe/Mockup

## 4.2. Giao diện phần cứng

[Mô tả nếu có]

## 4.3. Giao diện phần mềm

### 4.3.1. Hệ thống liên quan

### 4.3.2. API Integration

## 4.4. Giao diện truyền thông

[Protocols, formats, ...]
```

### 5.5. 05-non-functional-requirements.md

```markdown
# 5. YÊU CẦU PHI CHỨC NĂNG

## 5.1. Hiệu năng (Performance)

| Metric        | Yêu cầu         |
| ------------- | --------------- |
| Response Time | < X giây        |
| Throughput    | X requests/giây |
| CCU           | X users         |

## 5.2. Độ sẵn sàng (Availability)

[Uptime requirement]

## 5.3. Bảo mật (Security)

### 5.3.1. Authentication

### 5.3.2. Authorization

### 5.3.3. Data Protection

## 5.4. Khả năng mở rộng (Scalability)

[Scalability requirements]

## 5.5. Tương thích (Compatibility)

### 5.5.1. Browsers

### 5.5.2. Devices

### 5.5.3. OS

## 5.6. Khả năng bảo trì (Maintainability)

[Coding standards, documentation]

## 5.7. Usability

[UX requirements, accessibility]

## 5.8. Compliance

[Legal, regulatory requirements]
```

### 5.6. 06-other-requirements.md

```markdown
# 6. YÊU CẦU KHÁC

## 6.1. Database Requirements

[Data requirements nếu chưa nằm trong functional]

## 6.2. Localization

[Multi-language, timezone]

## 6.3. Documentation

[User manual, training materials]

## 6.4. Installation & Deployment

[Deployment requirements]
```

### 5.7. 07-appendix.md

```markdown
# 7. PHỤ LỤC

## 7.1. Traceability Matrix

| Req ID | Use Case | Design | Test Case |
| ------ | -------- | ------ | --------- |
|        |          |        |           |

## 7.2. Decision Log Reference

[Link to Decision Log]

## 7.3. Open Issues

| ID  | Issue | Status | Owner |
| --- | ----- | ------ | ----- |
|     |       |        |       |

## 7.4. Revision History

| Version | Date | Author | Changes |
| ------- | ---- | ------ | ------- |
| 1.0     |      |        | Initial |
```

---

## 6. DECISION LOG GUIDELINES

### 6.1. Khi nào cần ghi vào Decision Log

| Tình huống                              | Cần ghi | Nguồn |
| --------------------------------------- | ------- | ----- |
| Người dùng cung cấp thông tin rõ ràng   | ✅      | 👤    |
| AI đề xuất cho mục "[Chưa biết]"        | ✅      | 🤖    |
| AI suy luận thông tin không được nêu rõ | ✅      | 🤖    |
| Thông tin mặc định (date, version)      | ❌      | -     |

### 6.2. Format ghi nhận

Mỗi quyết định cần có:

- **ID**: DEC-XXX
- **Hạng mục**: Tên category
- **Nguồn**: 👤 hoặc 🤖
- **Nội dung**: Quyết định cụ thể
- **Lý do**: Giải thích tại sao
- **Trạng thái**: ⏳/✅/❌

---

## 7. QUALITY ASSURANCE

### 7.1. Checklist trước khi hoàn thành

- [ ] Tất cả sections đã được viết đầy đủ
- [ ] Requirement IDs nhất quán và unique
- [ ] Không có mâu thuẫn giữa các requirements
- [ ] Thuật ngữ được định nghĩa và sử dụng nhất quán
- [ ] Traceability matrix đã được cập nhật
- [ ] Decision Log đã ghi nhận đầy đủ các quyết định AI
- [ ] Tất cả quyết định AI đều có lý do rõ ràng

### 7.2. Common Mistakes to Avoid

| Mistake                          | Solution                       |
| -------------------------------- | ------------------------------ |
| Sử dụng từ mơ hồ                 | Dùng số liệu cụ thể            |
| Thiếu precondition/postcondition | Luôn định nghĩa đầy đủ         |
| Không có exception handling      | Định nghĩa error cases         |
| Requirement không testable       | Định nghĩa acceptance criteria |
| Thiếu priority                   | Luôn gán MoSCoW priority       |

---

## 🔗 TÀI LIỆU LIÊN QUAN

- [Form thu thập thông tin](./system-requirement-specification-form-template.md)
- [Decision Log Template](./system-requirement-specification-decision-log.md)
- [Checklist](./system-requirement-specification-checklist.md)

---

## 🔴 CRITICAL: KIỂM TRA TÍNH ĐẦY ĐỦ (COMPLETENESS VERIFICATION)

> ⚠️ **QUAN TRỌNG NHẤT**: Sau khi hoàn thành việc tạo tài liệu, **BẮT BUỘC** phải kiểm tra và đảm bảo rằng **MỌI ITEM TRONG DANH SÁCH ĐỀU CÓ MÔ TẢ CHI TIẾT TƯƠNG ỨNG**.

### Nguyên tắc vàng

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   SỐ LƯỢNG ITEMS TRONG DANH SÁCH = SỐ LƯỢNG PHẦN CHI TIẾT              │
│                                                                         │
│   Nếu có 15 FRs trong danh sách → PHẢI có 15 FR chi tiết               │
│   Nếu có 10 NFRs trong danh sách → PHẢI có 10 NFR chi tiết             │
│   Nếu có 8 Use Cases trong danh sách → PHẢI có 8 UC chi tiết           │
│   Nếu có 5 User Stories → PHẢI có 5 US chi tiết                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Quy trình kiểm tra bắt buộc

#### 1. Kiểm tra Functional Requirements (03-functional-requirements.md)

| Kiểm tra | Mô tả                                                                                                                       |
| -------- | --------------------------------------------------------------------------------------------------------------------------- |
| □        | Đếm số FR trong **bảng tổng quan**                                                                                          |
| □        | Đếm số **phần chi tiết FR** (có Main Flow, Actors, Preconditions)                                                           |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                                                                           |
| □        | Mỗi FR PHẢI có: Mô tả, Actors, Preconditions, Main Flow, Alternative Flows, Exception Flows, Postconditions, Business Rules |

#### 2. Kiểm tra Non-Functional Requirements (05-non-functional-requirements.md)

| Kiểm tra | Mô tả                                                             |
| -------- | ----------------------------------------------------------------- |
| □        | Mỗi NFR category phải có số liệu cụ thể (không có "nhanh", "tốt") |
| □        | Performance: Response time, Throughput, CCU                       |
| □        | Availability: Uptime percentage                                   |
| □        | Security: Authentication method, Authorization model              |

#### 3. Kiểm tra Use Cases (nếu có)

| Kiểm tra | Mô tả                                                 |
| -------- | ----------------------------------------------------- |
| □        | Đếm số UC trong **danh sách Use Cases**               |
| □        | Đếm số **UC chi tiết** (có diagram hoặc mô tả đầy đủ) |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                     |

#### 4. Kiểm tra External Interfaces (04-external-interfaces.md)

| Kiểm tra | Mô tả                                                     |
| -------- | --------------------------------------------------------- |
| □        | Nếu có **danh sách màn hình**, mỗi màn hình phải có mô tả |
| □        | Nếu có **API Integration**, mỗi API phải có specs cơ bản  |

### Ví dụ về lỗi thường gặp

```markdown
❌ SAI - Có danh sách nhưng thiếu chi tiết:

## 3.1. Tổng quan chức năng

| FR-001 | Đăng ký | Must |
| FR-002 | Đăng nhập | Must |
| FR-003 | Quản lý hồ sơ | Should |
| FR-004 | Tìm kiếm | Must |
| FR-005 | Thanh toán | Must |

## 3.2. Chi tiết từng chức năng

### FR-001: Đăng ký

(Chi tiết đầy đủ)

### FR-002: Đăng nhập

(Chi tiết đầy đủ)

→ THIẾU: FR-003, FR-004, FR-005
```

```markdown
✅ ĐÚNG - Mỗi FR đều có chi tiết:

## 3.1. Tổng quan chức năng

| FR-001 | Đăng ký | Must |
| FR-002 | Đăng nhập | Must |

## 3.2. Chi tiết từng chức năng

### FR-001: Đăng ký

(Chi tiết đầy đủ)

### FR-002: Đăng nhập

(Chi tiết đầy đủ)
```

### Checklist cuối cùng trước khi hoàn thành

- [ ] **Functional Requirements**: Số FR trong bảng = Số FR chi tiết
- [ ] **Non-Functional Requirements**: Tất cả metrics có số liệu cụ thể
- [ ] **Use Cases**: Số UC trong danh sách = Số UC chi tiết
- [ ] **External Interfaces**: Tất cả interfaces được mô tả
- [ ] **Không có placeholder** (TODO, TBD, ..., "[Chưa biết]" còn sót)
- [ ] **Tất cả requirements có Priority** (MoSCoW)
- [ ] **Decision Log đầy đủ** cho tất cả quyết định AI đưa ra

> 📌 **Tham khảo thêm**: Xem file `system-requirement-specification-checklist.md` để có checklist chi tiết hơn.
