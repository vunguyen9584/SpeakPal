# Hướng dẫn tạo Test Case

## 📋 Tổng quan

Tài liệu này hướng dẫn cách tạo bộ test case toàn diện để kiểm tra các chức năng của hệ thống từ các tài liệu dự án (SRS, Basic Design, Detailed Design).

---

## 🎯 Mục tiêu

1. Tạo bộ test case **bao phủ 100%** các chức năng được mô tả trong tài liệu
2. Đảm bảo test case có tính **hệ thống và có thể truy vết** (traceable)
3. Bao gồm cả **unit test, integration test và end-to-end test**
4. Tạo checklist để **kiểm tra tính đầy đủ** của test case

---

## 📂 Cấu trúc đầu vào

### Thư mục dự án điển hình:

```
[project_folder]/
├── システム要件定義書/        # SRS (System Requirement Specification)
│   ├── _index.md
│   ├── 01-introduction.md
│   ├── 02-overall-description.md
│   ├── 03-functional-requirements.md
│   ├── 04-external-interfaces.md
│   ├── 05-non-functional-requirements.md
│   └── ...
├── 基本設計書/                # Basic Design
│   ├── _index.md
│   └── ...
├── 詳細設計書/                # Detailed Design
│   ├── _index.md
│   └── ...
└── TaskList/                  # Task List (nếu có)
    └── ...
```

---

## 📤 Cấu trúc đầu ra

### Thư mục test case (xác định tên theo ngôn ngữ SRS):

| Ngôn ngữ SRS | Tên thư mục test  |
| ------------ | ----------------- |
| Tiếng Nhật   | アプリ全体テスト  |
| Tiếng Việt   | Kiem-Tra-He-Thong |
| Tiếng Anh    | System-Testing    |

### Cấu trúc output:

```
[project_folder]/
├── [テスト_folder]/           # Thư mục test case
│   ├── _index.md              # Mục lục và tổng quan
│   ├── TC_[Group1].md         # Test case theo nhóm chức năng 1
│   ├── TC_[Group2].md         # Test case theo nhóm chức năng 2
│   ├── ...
│   └── TC_Integration.md      # Test tổng hợp (integration test)
└── application-testing-checklist.md  # Checklist đầy đủ
```

---

## 🔍 Quy trình tạo Test Case

### PHASE 1: Phân tích tài liệu (Document Analysis)

#### Bước 1.1: Xác định tài liệu có sẵn

```
1. Kiểm tra thư mục SRS (システム要件定義書 hoặc tương đương)
2. Kiểm tra thư mục Basic Design (基本設計書 hoặc tương đương)
3. Kiểm tra thư mục Detailed Design (詳細設計書 hoặc tương đương)
4. Kiểm tra thư mục TaskList (nếu có)
```

#### Bước 1.2: Xác định ngôn ngữ tài liệu

- Đọc file `_index.md` của SRS
- Xác định ngôn ngữ chính (Nhật/Việt/Anh)
- Đặt tên thư mục output phù hợp

#### Bước 1.3: Load tài liệu theo thứ tự ưu tiên

```
Thứ tự ưu tiên load:
1. SRS/_index.md (BẮT BUỘC) - để hiểu scope hệ thống
2. SRS/03-functional-requirements.md (BẮT BUỘC) - chi tiết chức năng
3. Basic Design/_index.md (NÊN CÓ) - hiểu kiến trúc
4. Detailed Design/_index.md (TÙY CHỌN) - detail level
5. Các file khác chỉ load KHI CẦN
```

> ⚠️ **QUAN TRỌNG**: Để tránh tràn context window, chỉ load tài liệu KHI CẦN THIẾT. Bắt đầu với \_index.md để có overview, sau đó load chi tiết từng section khi cần.

### PHASE 2: Xác định nhóm chức năng (Feature Grouping)

#### Bước 2.1: Trích xuất Functional Requirements từ SRS

```
Từ file 03-functional-requirements.md, xác định:
- Danh sách Use Cases / User Stories
- Nhóm theo module/feature area
- Mức độ ưu tiên (Priority)
```

#### Bước 2.2: Phân nhóm test case

```
Ví dụ nhóm:
- TC_Authentication.md      - Đăng nhập, đăng ký, xác thực
- TC_UserManagement.md      - Quản lý người dùng
- TC_CoreFeature1.md        - Chức năng chính 1
- TC_CoreFeature2.md        - Chức năng chính 2
- TC_DataManagement.md      - Quản lý dữ liệu
- TC_Settings.md            - Cài đặt
- TC_Integration.md         - Test tổng hợp
```

### PHASE 3: Viết Test Case

#### Template Test Case cho mỗi file:

```markdown
# [Tên nhóm chức năng] - Test Cases

## 📋 Thông tin chung

| Item                | Value                           |
| ------------------- | ------------------------------- |
| Module              | [Tên module]                    |
| Tài liệu tham chiếu | SRS Section X.X, BD Section Y.Y |
| Số lượng test case  | [N]                             |
| Version             | 1.0                             |
| Ngày tạo            | [YYYY-MM-DD]                    |

---

## 🎯 Phạm vi test

### Các chức năng được test:

- [ ] Chức năng 1 (REQ-XXX)
- [ ] Chức năng 2 (REQ-YYY)
- [ ] ...

### Các chức năng KHÔNG nằm trong phạm vi:

- Chức năng Z (thuộc module khác)

---

## 📝 Test Cases

### TC-[ModuleCode]-001: [Tên test case]

| Field        | Value                      |
| ------------ | -------------------------- |
| **ID**       | TC-[ModuleCode]-001        |
| **Tên**      | [Mô tả ngắn gọn test case] |
| **Ưu tiên**  | HIGH / MEDIUM / LOW        |
| **Loại**     | Unit / Integration / E2E   |
| **Truy vết** | REQ-XXX, US-YYY            |

#### Preconditions:

1. [Điều kiện trước khi test]
2. [Điều kiện 2]

#### Test Steps:

| Step | Action        | Expected Result      |
| ---- | ------------- | -------------------- |
| 1    | [Hành động 1] | [Kết quả mong đợi 1] |
| 2    | [Hành động 2] | [Kết quả mong đợi 2] |
| 3    | [Hành động 3] | [Kết quả mong đợi 3] |

#### Test Data:
```

[Data cần thiết cho test]

```

#### Postconditions:
- [Trạng thái sau khi test hoàn thành]

---

### TC-[ModuleCode]-002: [Tên test case tiếp theo]
...
```

### PHASE 4: Viết Test Case tổng hợp (Integration Test)

#### File TC_Integration.md phải bao gồm:

```markdown
# Integration Test Cases / 総合テストケース

## 📋 Thông tin chung

[...]

## 🔗 Các luồng nghiệp vụ (Business Flows)

### Flow 1: [Tên luồng nghiệp vụ chính]
```

sequenceDiagram
participant User
participant System
participant Database
...

```

#### Test Cases cho Flow 1:
- TC-INT-001: Happy path
- TC-INT-002: Error handling path
- TC-INT-003: Edge case

### Flow 2: [Luồng nghiệp vụ 2]
...

## 🔄 Cross-module Test Cases

### TC-INT-XXX: [Test cross-module]
- Kiểm tra tương tác giữa Module A và Module B
- ...
```

### PHASE 5: Tạo Checklist

#### File application-testing-checklist.md:

```markdown
# Application Testing Checklist / テスト完了チェックリスト

## 📋 Thông tin

| Item              | Value        |
| ----------------- | ------------ |
| Dự án             | [Tên dự án]  |
| Version           | 1.0          |
| Ngày tạo          | [YYYY-MM-DD] |
| Tổng số test case | [N]          |

---

## ✅ Checklist bao phủ yêu cầu (Requirements Coverage)

### Functional Requirements

| REQ ID  | Tên yêu cầu | Test Case IDs          | Đã cover? |
| ------- | ----------- | ---------------------- | --------- |
| REQ-001 | [Tên]       | TC-XXX-001, TC-XXX-002 | ✅/❌     |
| REQ-002 | [Tên]       | TC-YYY-001             | ✅/❌     |
| ...     | ...         | ...                    | ...       |

**Tỷ lệ bao phủ FR:** [X/Y] = [Z%]

### Non-Functional Requirements

| NFR ID  | Loại        | Mô tả   | Test Case IDs | Đã cover? |
| ------- | ----------- | ------- | ------------- | --------- |
| NFR-001 | Performance | [Mô tả] | TC-PERF-001   | ✅/❌     |
| NFR-002 | Security    | [Mô tả] | TC-SEC-001    | ✅/❌     |
| ...     | ...         | ...     | ...           | ...       |

**Tỷ lệ bao phủ NFR:** [X/Y] = [Z%]

---

## ✅ Checklist theo loại test

### Unit Test

- [ ] Tất cả các function/method chính đã có unit test
- [ ] Edge cases đã được cover
- [ ] Error handling đã được test

### Integration Test

- [ ] Tất cả các API endpoints đã được test
- [ ] Database integration đã được test
- [ ] External service integration đã được test

### End-to-End Test

- [ ] Tất cả các user flow chính đã được test
- [ ] Cross-browser testing (nếu áp dụng)
- [ ] Mobile responsive testing (nếu áp dụng)

### Security Test

- [ ] Authentication flows đã được test
- [ ] Authorization (permission) đã được test
- [ ] Input validation đã được test
- [ ] XSS, CSRF protection đã được test

### Performance Test

- [ ] Load testing đã được thực hiện
- [ ] Response time đã được đo lường
- [ ] Memory/CPU usage đã được monitor

---

## ✅ Checklist theo module

| Module          | Số TC       | Bao phủ    | Status   |
| --------------- | ----------- | ---------- | -------- |
| Authentication  | [N]         | [X%]       | ✅/⚠️/❌ |
| User Management | [N]         | [X%]       | ✅/⚠️/❌ |
| [Module 3]      | [N]         | [X%]       | ✅/⚠️/❌ |
| ...             | ...         | ...        | ...      |
| **TỔNG**        | **[Total]** | **[Avg%]** | -        |

---

## 📊 Tổng kết

### Coverage Summary

- **Functional Requirements:** [X%]
- **Non-Functional Requirements:** [X%]
- **Overall Coverage:** [X%]

### Gaps Identified

1. [Gap 1 - chưa có test cho feature X]
2. [Gap 2 - thiếu test edge case cho Y]
3. ...

### Recommendations

1. [Đề xuất bổ sung test 1]
2. [Đề xuất bổ sung test 2]
3. ...
```

---

## 📏 Quy tắc đặt tên

### Test Case ID Format:

```
TC-[MODULE]-[NUMBER]

Trong đó:
- TC: Test Case prefix
- MODULE: Viết tắt của module (3-5 ký tự)
  - AUTH: Authentication
  - USER: User Management
  - CORE: Core Features
  - DATA: Data Management
  - SET: Settings
  - INT: Integration
  - PERF: Performance
  - SEC: Security
- NUMBER: Số thứ tự 3 chữ số (001, 002, ...)
```

### Ví dụ:

- TC-AUTH-001: Đăng nhập thành công
- TC-AUTH-002: Đăng nhập thất bại với sai mật khẩu
- TC-USER-001: Tạo user mới
- TC-INT-001: Flow đăng ký và xác thực email

---

## 🛡️ Test Case cho các loại test đặc biệt

### Boundary Testing (Test giá trị biên)

```
- Min value
- Min - 1
- Max value
- Max + 1
- Empty/Null
- Special characters
```

### Negative Testing (Test trường hợp lỗi)

```
- Invalid input
- Missing required fields
- Unauthorized access
- Network failure simulation
- Database connection failure
```

### Regression Testing

```
- Các bug đã fix trước đó
- Core functionality sau mỗi release
- Integration points
```

---

## ⚠️ Lưu ý quan trọng

1. **Truy vết (Traceability)**: Mỗi test case PHẢI được liên kết với ít nhất 1 requirement (REQ-XXX) hoặc user story (US-XXX)

2. **Tính độc lập**: Mỗi test case nên độc lập, không phụ thuộc vào kết quả của test case khác

3. **Có thể lặp lại**: Test case phải có thể chạy lại nhiều lần với cùng kết quả

4. **Atomic**: Mỗi test case chỉ test MỘT chức năng/behavior cụ thể

5. **Clear Expected Results**: Kết quả mong đợi phải rõ ràng, không mơ hồ

---

## 📝 Các loại Test Case cần có

### Bắt buộc (Must Have):

- ✅ Happy path / Success scenarios
- ✅ Basic error handling
- ✅ Authentication/Authorization tests
- ✅ Core business logic tests

### Nên có (Should Have):

- 🔶 Edge cases
- 🔶 Boundary testing
- 🔶 Performance baseline tests
- 🔶 Security basic tests

### Có thể có (Nice to Have):

- 💡 Stress testing
- 💡 Compatibility testing
- 💡 Usability testing
- 💡 Accessibility testing

---

## 🔄 Quy trình cập nhật

1. **Khi có requirement mới**: Thêm test case tương ứng
2. **Khi fix bug**: Thêm regression test case
3. **Khi refactor**: Review và update test case nếu cần
4. **Trước release**: Chạy full regression test
