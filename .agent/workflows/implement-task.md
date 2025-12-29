---
description: Thực thi một task cụ thể từ Implementation Plan
---

# Workflow: Implement Task

## Mục đích

Thực thi một task nhỏ nhất từ Implementation Plan một cách đầy đủ và chính xác.

---

## Input

| Tham số   | Mô tả                                                  | Bắt buộc |
| --------- | ------------------------------------------------------ | -------- |
| TASK_ID   | ID của task cần implement (VD: WP-INF-001-T001)        | ✅       |
| PLAN_FILE | Đường dẫn đến file plan chứa task (VD: phase-0-xxx.md) | ✅       |

**Ví dụ:**

```
Implement task WP-INF-001-T001 từ:
docs/SpeakPal/implementation-plan/phase-0-infrastructure.md
```

---

## Quy trình thực hiện

### Bước 1: Đọc và phân tích Task

1. Đọc file plan được chỉ định
2. Tìm task theo TASK_ID
3. Trích xuất thông tin task:
   - **ID**: Task ID
   - **Type**: setup | feature | integration | test | docs
   - **Description**: Mô tả chi tiết
   - **Commands**: Các lệnh cần chạy (nếu có)
   - **Files to Create/Modify**: Danh sách files
   - **Code Template**: Mẫu code (nếu có)
   - **Acceptance Criteria**: Tiêu chí hoàn thành
   - **Estimated Hours**: Thời gian ước tính
   - **DD Reference**: Tham chiếu đến Detailed Design

### Bước 2: XÁC NHẬN với người dùng (BẮT BUỘC)

**QUAN TRỌNG**: Trước khi thực thi, PHẢI hiển thị và hỏi người dùng:

````markdown
## 📋 Task cần implement

| Thuộc tính     | Giá trị       |
| -------------- | ------------- |
| **ID**         | [TASK_ID]     |
| **Tên**        | [Task Name]   |
| **Type**       | [Type]        |
| **Mô tả**      | [Description] |
| **Est. Hours** | [X hours]     |

### Các bước thực hiện:

1. [Bước 1]
2. [Bước 2]
   ...

### Files sẽ tạo/sửa:

- `path/to/file1` - [mô tả]
- `path/to/file2` - [mô tả]

### Commands sẽ chạy:

```bash
[command 1]
[command 2]
```
````

---

**Bạn có muốn implement task này không? (yes/no)**

```

CHỜ người dùng xác nhận. Chỉ tiếp tục khi nhận được "yes".

### Bước 3: Thực thi Task

Sau khi người dùng xác nhận, thực hiện TỪNG BƯỚC:

#### 3.1. Chạy Commands (nếu có)
```

// turbo-all

````
- Chạy tất cả commands được liệt kê trong task
- Kiểm tra output của mỗi command
- Dừng lại nếu có lỗi

#### 3.2. Tạo/Sửa Files
- Tạo mỗi file theo template trong task
- Đảm bảo code đầy đủ, không có placeholder
- Không bỏ sót bất kỳ file nào

#### 3.3. Verify hoàn thành
- Kiểm tra mỗi file đã được tạo/sửa
- Kiểm tra acceptance criteria
- Chạy test nếu có

### Bước 4: Báo cáo kết quả

Sau khi hoàn thành, hiển thị báo cáo:

```markdown
## ✅ Task [TASK_ID] đã hoàn thành!

### Kết quả thực hiện:

| Item | Status |
|------|--------|
| Commands | ✅ Đã chạy thành công |
| Files | ✅ Đã tạo/sửa đầy đủ |
| Verification | ✅ Đã kiểm tra |

### Files đã tạo/sửa:
- ✅ `path/to/file1` - [đã tạo]
- ✅ `path/to/file2` - [đã sửa]

### Commands đã chạy:
- ✅ `command 1` - Success
- ✅ `command 2` - Success

### Acceptance Criteria:
- [x] Criterion 1
- [x] Criterion 2

---

**Task [TASK_ID] hoàn thành 100%!**

Bước tiếp theo: Cập nhật CHECKLIST.md để đánh dấu hoàn thành.
````

### Bước 5: Cập nhật CHECKLIST.md

1. Mở file `implementation-plan/CHECKLIST.md`
2. Tìm task ID
3. Đánh dấu checkbox: `- [ ]` → `- [x]`
4. Cập nhật progress counter

---

## Lưu ý quan trọng

### 1. KHÔNG được bỏ sót nội dung

- Implement 100% những gì được mô tả trong task
- Nếu task yêu cầu tạo 5 files, phải tạo đủ 5 files
- Nếu có code template, sử dụng chính xác template đó

### 2. Đọc DD Reference

- Nếu task có DD Reference, đọc file DD tương ứng
- Lấy thêm chi tiết từ DD để implement đầy đủ

### 3. Error Handling

- Nếu lỗi xảy ra, dừng và báo cho người dùng
- Không tiếp tục nếu bước trước thất bại

### 4. Không Giả định

- Nếu thiếu thông tin, HỎI người dùng
- Không tự ý thêm/bớt chức năng ngoài task

### 5. Real Code Only

- Không dùng `// TODO` hoặc `// implement later`
- Tất cả code phải hoạt động được
- Test nếu có thể

---

## Ví dụ: Implement WP-INF-001-T001

### Input:

```
/implement-task
- TASK_ID: WP-INF-001-T001
- PLAN_FILE: docs/SpeakPal/implementation-plan/phase-0-infrastructure.md
```

### Flow:

**Bước 1**: Đọc task từ file

```
Task 1: Install PostgreSQL
- ID: WP-INF-001-T001
- Type: setup
- Commands: docker pull postgres:15
- Acceptance: PostgreSQL 15.x đã được cài đặt
```

**Bước 2**: Hỏi xác nhận

```
📋 Task cần implement: WP-INF-001-T001 - Install PostgreSQL
Commands: docker pull postgres:15
Bạn có muốn implement task này không? (yes/no)
```

**Bước 3**: Sau khi user confirm "yes"

```bash
# Chạy command
docker pull postgres:15
```

**Bước 4**: Báo cáo

```
✅ Task WP-INF-001-T001 đã hoàn thành!
- Docker image postgres:15 đã được pull
- Verify: docker images | grep postgres ✓
```

**Bước 5**: Cập nhật checklist

```markdown
- [x] WP-INF-001-T001: Install PostgreSQL
```

---

## Task Types và cách xử lý

### Type: setup

- Thường là chạy commands
- Tạo config files
- Verify installation

### Type: feature

- Tạo source code files
- Implement logic đầy đủ
- Có thể cần đọc DD Reference

### Type: integration

- Kết nối với external services
- Cấu hình API keys
- Implement service wrapper

### Type: test

- Tạo test files
- Implement test cases
- Chạy tests

### Type: docs

- Tạo documentation files
- README, API docs, etc.

---

## Troubleshooting

| Vấn đề              | Giải pháp                            |
| ------------------- | ------------------------------------ |
| Task không tìm thấy | Kiểm tra TASK_ID và PLAN_FILE        |
| Command failed      | Dừng, báo lỗi, hướng dẫn fix         |
| Missing file        | Kiểm tra path, tạo parent dirs trước |
| Missing info        | Đọc DD Reference hoặc hỏi user       |

---

_Workflow version: 1.0_
_Last updated: 2025-12-29_
