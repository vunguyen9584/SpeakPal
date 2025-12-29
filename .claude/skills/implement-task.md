---
description: Thực thi một task cụ thể từ Implementation Plan. Skill này là subagent được điều phối bởi implement-phase hoặc có thể được gọi độc lập.
---

# Skill: Implement Task

## Mục đích

Skill này là một **subagent** để thực thi một task nhỏ nhất từ Implementation Plan một cách đầy đủ và chính xác. Skill có thể:
- Được gọi độc lập bởi người dùng
- Được điều phối bởi skill `implement-phase` (orchestrator)

## Workflow Reference

Chi tiết workflow tại: `.agent/workflows/implement-task.md`

## Input Parameters

| Tham số   | Mô tả                                                  | Bắt buộc |
| --------- | ------------------------------------------------------ | -------- |
| TASK_ID   | ID của task cần implement (VD: WP-INF-001-T001)        | ✅       |
| PLAN_FILE | Đường dẫn đến file plan chứa task (VD: phase-0-xxx.md) | ✅       |

## Quy trình thực hiện

### Bước 1: Thu thập thông tin
Nếu chưa có input, hỏi người dùng:
- Task ID cần implement
- Đường dẫn file Phase Plan

### Bước 2: Đọc và phân tích Task

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

### Bước 3: XÁC NHẬN với người dùng (BẮT BUỘC)

**QUAN TRỌNG**: Trước khi thực thi, PHẢI hiển thị và hỏi người dùng:

```markdown
## 📋 Task cần implement

| Thuộc tính     | Giá trị       |
| -------------- | ------------- |
| **ID**         | [TASK_ID]     |
| **Tên**        | [Task Name]   |
| **Type**       | [Type]        |
| **Mô tả**      | [Description] |

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

---

**Bạn có muốn implement task này không? (yes/no)**
```

CHỜ người dùng xác nhận. Chỉ tiếp tục khi nhận được "yes".

### Bước 4: Thực thi Task

Sau khi người dùng xác nhận, thực hiện TỪNG BƯỚC:

#### 4.1. Chạy Commands (nếu có)
- Chạy tất cả commands được liệt kê trong task
- Kiểm tra output của mỗi command
- Dừng lại nếu có lỗi

#### 4.2. Tạo/Sửa Files
- Tạo mỗi file theo template trong task
- Đảm bảo code đầy đủ, không có placeholder
- Không bỏ sót bất kỳ file nào

#### 4.3. Verify hoàn thành
- Kiểm tra mỗi file đã được tạo/sửa
- Kiểm tra acceptance criteria
- Chạy test nếu có

### Bước 5: Báo cáo kết quả

```markdown
## ✅ Task [TASK_ID] đã hoàn thành!

### Kết quả thực hiện:

| Item         | Status                 |
| ------------ | ---------------------- |
| Commands     | ✅ Đã chạy thành công   |
| Files        | ✅ Đã tạo/sửa đầy đủ    |
| Verification | ✅ Đã kiểm tra          |

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
```

### Bước 6: Cập nhật CHECKLIST.md (nếu được yêu cầu)

1. Mở file CHECKLIST.md
2. Tìm task ID
3. Đánh dấu checkbox: `- [ ]` → `- [x]`
4. Thêm ngày hoàn thành: `✅ (YYYY-MM-DD)`

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

## Error Handling

| Vấn đề              | Giải pháp                            |
| ------------------- | ------------------------------------ |
| Task không tìm thấy | Kiểm tra TASK_ID và PLAN_FILE        |
| Command failed      | Dừng, báo lỗi, hướng dẫn fix         |
| Missing file        | Kiểm tra path, tạo parent dirs trước |
| Missing info        | Đọc DD Reference hoặc hỏi user       |

## Ví dụ sử dụng

### Gọi độc lập:
```
/implement-task
- TASK_ID: WP-INF-001-T001
- PLAN_FILE: docs/project/implementation-plan/phase-0-infrastructure.md
```

### Được gọi bởi implement-phase:
Skill `implement-phase` sẽ tự động gọi skill này với các tham số phù hợp cho từng task trong phase.

## Related Skills

| Skill             | Mục đích                                       |
| ----------------- | ---------------------------------------------- |
| `implement-phase` | Orchestrator điều phối toàn bộ tasks trong phase |
