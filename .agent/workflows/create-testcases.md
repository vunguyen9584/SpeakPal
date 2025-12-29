---
description: Tạo Test Case để kiểm tra toàn diện các chức năng của hệ thống từ tài liệu dự án
---

# Workflow: Tạo Test Cases

## 📝 Mô tả

Workflow này tạo bộ test case toàn diện để kiểm tra các chức năng của hệ thống dựa trên tài liệu SRS, Basic Design, và Detailed Design.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng tham số sau:

```
Để tạo Test Cases, tôi cần thông tin sau:

1. **Thư mục dự án:** Thư mục chứa các tài liệu SRS, Basic Design, Detailed Design
   Ví dụ: `docs/LexiGo`

2. **Phạm vi tạo test (tùy chọn):**
   - Toàn bộ hệ thống: Nhập `all` (mặc định)
   - Một module cụ thể: Nhập tên module
   - Một nhóm chức năng: Nhập tên nhóm
```

---

## ✅ BƯỚC 2: Kiểm tra tài liệu có sẵn

### 2.1. Liệt kê nội dung thư mục dự án

```
Sử dụng list_dir để xem các thư mục/file có sẵn
```

### 2.2. Xác định các tài liệu nguồn

Kiểm tra sự tồn tại của các thư mục sau (theo thứ tự ưu tiên):

| Thứ tự | Thư mục                                                 | Mức độ       |
| ------ | ------------------------------------------------------- | ------------ |
| 1      | システム要件定義書/ hoặc SRS/ hoặc System-Requirements/ | **BẮT BUỘC** |
| 2      | 基本設計書/ hoặc Basic-Design/                          | Nên có       |
| 3      | 詳細設計書/ hoặc Detailed-Design/                       | Tùy chọn     |
| 4      | TaskList/                                               | Tùy chọn     |

> ⚠️ Nếu không tìm thấy thư mục SRS, thông báo lỗi và dừng workflow.

### 2.3. Xác định ngôn ngữ tài liệu

Đọc file `_index.md` trong thư mục SRS để xác định ngôn ngữ:

- Tiếng Nhật → Thư mục output: `アプリ全体テスト`
- Tiếng Việt → Thư mục output: `Kiem-Tra-He-Thong`
- Tiếng Anh → Thư mục output: `System-Testing`

---

## 📖 BƯỚC 3: Load hướng dẫn

Đọc file hướng dẫn tại:

```
.ai-instructions/test-case-generation-instructions.md
```

Hiểu rõ:

- Cấu trúc output mong muốn
- Template test case
- Quy tắc đặt tên
- Các loại test cần có

---

## 🔍 BƯỚC 4: Phân tích tài liệu (Lazy Loading)

### 4.1. Load SRS Index

```
Đọc: [project_folder]/[SRS_folder]/_index.md
Mục đích: Hiểu scope tổng quan của hệ thống
```

### 4.2. Load Functional Requirements

```
Đọc: [project_folder]/[SRS_folder]/03-functional-requirements.md (hoặc file tương ứng)
Mục đích: Xác định danh sách chức năng cần test
```

### 4.3. Xây dựng Feature Map

```
Từ tài liệu đã đọc, tạo bảng:

| ID | Tên chức năng | Module/Group | Priority |
|----|---------------|--------------|----------|
| REQ-001 | ... | ... | ... |
| ... | ... | ... | ... |
```

### 4.4. Load thêm tài liệu chi tiết (chỉ khi cần)

> ⚠️ **QUAN TRỌNG - Nguyên tắc Lazy Loading:**
>
> - Chỉ load Basic Design khi cần hiểu rõ hơn về kiến trúc
> - Chỉ load Detailed Design khi cần hiểu rõ hơn về implementation
> - Không load toàn bộ tài liệu cùng lúc để tránh tràn context

---

## 🎯 BƯỚC 5: Xác định cấu trúc Test Case

### 5.1. Phân nhóm chức năng

Dựa trên Feature Map ở bước 4.3, nhóm các chức năng theo modules:

```
Ví dụ:
- TC_Authentication.md    → Đăng nhập, đăng ký, xác thực, quên mật khẩu
- TC_UserManagement.md    → CRUD users, roles, permissions
- TC_[Feature1].md        → Các test cho feature 1
- TC_[Feature2].md        → Các test cho feature 2
- ...
- TC_Integration.md       → Test luồng tổng hợp
```

### 5.2. Xác nhận với người dùng

```markdown
### 📋 Cấu trúc Test Case dự kiến:

| File                 | Mô tả               | Số chức năng |
| -------------------- | ------------------- | ------------ |
| TC_Authentication.md | Xác thực người dùng | X            |
| TC_UserManagement.md | Quản lý người dùng  | Y            |
| ...                  | ...                 | ...          |
| TC_Integration.md    | Test tổng hợp       | Z            |

Tổng cộng: [N] nhóm test case

Bạn có muốn điều chỉnh cấu trúc này không? (y/n)
```

---

## 🚀 BƯỚC 6: Tạo Test Cases

### 6.1. Tạo thư mục output

```
Tạo thư mục: [project_folder]/[テスト_folder]/
(Nếu thư mục đã tồn tại, hỏi người dùng có muốn ghi đè không)
```

### 6.2. Tạo file \_index.md

```markdown
# [Tên dự án] - Test Cases / テストケース

## 📋 Thông tin

| Item           | Value             |
| -------------- | ----------------- |
| Dự án          | [Tên dự án]       |
| Version        | 1.0               |
| Ngày tạo       | [YYYY-MM-DD]      |
| Tài liệu nguồn | SRS v[X], BD v[Y] |

---

## 📂 Danh sách Test Case Files

| File                                     | Mô tả         | Số TC |
| ---------------------------------------- | ------------- | ----- |
| [TC_Module1.md](./TC_Module1.md)         | [Mô tả]       | [N]   |
| [TC_Module2.md](./TC_Module2.md)         | [Mô tả]       | [N]   |
| ...                                      | ...           | ...   |
| [TC_Integration.md](./TC_Integration.md) | Test tổng hợp | [N]   |

---

## 📊 Thống kê

- **Tổng số Test Cases:** [Total]
- **Test Cases theo loại:**
  - Unit: [N]
  - Integration: [N]
  - E2E: [N]
- **Coverage:** [X%] requirements

---

## 🔗 Tài liệu liên quan

- [SRS]([path])
- [Basic Design]([path])
- [Checklist](../application-testing-checklist.md)
```

### 6.3. Tạo các file Test Case theo nhóm

Với MỖI nhóm chức năng:

1. Đọc chi tiết chức năng từ SRS (load thêm tài liệu nếu cần)
2. Tạo test case theo template trong hướng dẫn
3. Đảm bảo:
   - Mỗi requirement có ít nhất 1 test case
   - Bao gồm happy path và error cases
   - Test data rõ ràng
   - Expected result cụ thể

### 6.4. Tạo file TC_Integration.md

Bao gồm:

- Các luồng nghiệp vụ chính (main business flows)
- Cross-module test cases
- End-to-end scenarios

---

## 📋 BƯỚC 7: Tạo Checklist

### 7.1. Tạo file application-testing-checklist.md

Đặt tại: `[project_folder]/application-testing-checklist.md`

Bao gồm:

- Checklist bao phủ Functional Requirements
- Checklist bao phủ Non-Functional Requirements
- Checklist theo loại test
- Checklist theo module
- Tổng kết coverage
- Gaps identified
- Recommendations

### 7.2. Tính toán Coverage

```
Với mỗi requirement trong SRS:
- Kiểm tra có test case tương ứng không
- Đánh dấu ✅ hoặc ❌
- Tính phần trăm coverage
```

---

## ✅ BƯỚC 8: Validation

### 8.1. Self-check

Kiểm tra:

- [ ] Mỗi file có đúng format theo template
- [ ] Tất cả test case có ID unique
- [ ] Tất cả test case có truy vết đến requirement
- [ ] Expected results rõ ràng, không mơ hồ
- [ ] \_index.md có liên kết đến tất cả các file

### 8.2. Coverage check

```
Functional Requirements Coverage: [X/Y] = [Z%]
Non-Functional Requirements Coverage: [X/Y] = [Z%]
```

> ⚠️ Nếu coverage < 90%, cần review và bổ sung test case.

---

## 📊 BƯỚC 9: Tổng kết

Hiển thị tổng kết cho người dùng:

```markdown
## ✨ Hoàn thành tạo Test Cases

### 📂 Files đã tạo:

**Thư mục Test Cases:** `[project_folder]/[テスト_folder]/`

- \_index.md
- TC_Authentication.md (N test cases)
- TC_UserManagement.md (N test cases)
- ... (liệt kê tất cả files)
- TC_Integration.md (N test cases)

**Checklist:** `[project_folder]/application-testing-checklist.md`

### 📊 Thống kê:

| Metric             | Value |
| ------------------ | ----- |
| Tổng số test cases | [N]   |
| Số nhóm test       | [N]   |
| FR Coverage        | [X%]  |
| NFR Coverage       | [X%]  |
| Overall Coverage   | [X%]  |

### ⚠️ Gaps cần chú ý:

[Liệt kê các requirement chưa có test case hoặc thiếu test case]

### 💡 Recommendations:

[Đề xuất bổ sung test case nếu cần]
```

---

## 💡 Lưu ý

1. **Lazy Loading**: Chỉ load tài liệu khi cần thiết để tránh tràn context window

2. **Traceability**: Mỗi test case PHẢI được liên kết với requirement ID

3. **Ngôn ngữ**: Tạo test case bằng ngôn ngữ của tài liệu SRS

4. **Scope**: Nếu người dùng chỉ định module cụ thể, chỉ tạo test case cho module đó

5. **Reference**: Chi tiết xem tại `.ai-instructions/test-case-generation-instructions.md`
