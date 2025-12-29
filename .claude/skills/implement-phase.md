---
description: Điều phối và thực thi toàn bộ các task trong một Phase. Sử dụng khi cần implement một phase đầy đủ từ Implementation Plan với orchestration tự động.
---

# Skill: Implement Phase

## Mục đích

Skill này là một **orchestrator** để điều phối việc thực thi toàn bộ các task trong một Phase của Implementation Plan. Skill sẽ:
1. Liệt kê tất cả tasks trong phase
2. Gọi skill `implement-task` cho từng task
3. Kiểm tra kết quả mỗi task
4. Cập nhật CHECKLIST.md

## Workflow Reference

Chi tiết workflow tại: `.agent/workflows/implement-phase.md`

## Input Parameters

| Tham số        | Mô tả                                          | Bắt buộc |
| -------------- | ---------------------------------------------- | -------- |
| PHASE_PLAN     | Đường dẫn đến file plan của phase              | ✅       |
| CHECKLIST_FILE | Đường dẫn đến file CHECKLIST.md                | ✅       |
| START_FROM     | Task ID để bắt đầu (nếu muốn tiếp tục từ giữa) | Optional |
| SKIP_COMPLETED | Bỏ qua các task đã hoàn thành (default: true)  | Optional |

## Quy trình thực hiện

### Bước 1: Thu thập thông tin
Nếu chưa có input, hỏi người dùng:
- Đường dẫn file Phase Plan
- Đường dẫn file CHECKLIST.md

### Bước 2: Đọc và phân tích Phase Plan
1. Đọc file phase plan
2. Trích xuất: Phase number, name, danh sách Work Packages
3. Xây dựng danh sách tasks theo thứ tự

### Bước 3: Đọc CHECKLIST.md
1. Tìm section tương ứng với phase
2. Xác định trạng thái từng task:
   - `[ ]` = chưa hoàn thành
   - `[x]` = đã hoàn thành

### Bước 4: Hiển thị tổng quan và XÁC NHẬN

**BẮT BUỘC** hiển thị và hỏi người dùng trước khi bắt đầu:

```markdown
## 📋 Phase Implementation Plan

### Phase: [Phase Number] - [Phase Name]

| Thống kê           | Giá trị |
| ------------------ | ------- |
| Tổng Work Packages | [N]     |
| Tổng Tasks         | [M]     |
| Đã hoàn thành      | [X]     |
| Còn lại            | [Y]     |

### Danh sách Tasks:

| # | Task ID | Task Name | Status |
|---|---------|-----------|--------|
| 1 | WP-XXX-T001 | [Name] | ⬜/✅ |
...

**Bạn có muốn bắt đầu implement Phase này không?**
- Nhập `yes` để bắt đầu từ task đầu tiên
- Nhập `skip to [TASK_ID]` để bắt đầu từ task cụ thể
- Nhập `no` để hủy
```

### Bước 5: Thực thi từng Task

Với mỗi task chưa hoàn thành:

1. **Hiển thị progress**:
   ```
   🔄 Task [X/Y]: [TASK_ID] - [Task Name]
   ```

2. **Gọi skill implement-task**:
   - Sử dụng Skill tool với skill: "implement-task"
   - Truyền TASK_ID và PLAN_FILE
   - Skill implement-task sẽ:
     - Hỏi xác nhận
     - Thực thi task
     - Báo cáo kết quả

3. **Kiểm tra kết quả**:
   - **THÀNH CÔNG**: Cập nhật CHECKLIST.md, tiếp tục task tiếp theo
   - **THẤT BẠI**: Hiển thị lỗi, hỏi: Retry / Skip / Abort

4. **Cập nhật CHECKLIST.md**:
   - Đánh dấu `[x]` task đã hoàn thành
   - Thêm ngày hoàn thành: `✅ (YYYY-MM-DD)`

### Bước 6: Xử lý kết quả mỗi Task

**Task thành công:**
```markdown
✅ Task [TASK_ID] hoàn thành!
Progress: [X/Y] tasks ([Z%])

Tiếp tục với task tiếp theo...
```

**Task thất bại:**
```markdown
❌ Task [TASK_ID] thất bại!

Lỗi: [Error message]

Bạn muốn làm gì?
- `retry` - Thử lại task này
- `skip` - Bỏ qua, tiếp tục task tiếp theo
- `abort` - Dừng toàn bộ phase
```

### Bước 7: Báo cáo hoàn thành Phase

```markdown
## 🎉 Phase [N] đã hoàn thành!

### Kết quả:

| Thống kê   | Giá trị   |
| ---------- | --------- |
| Tổng tasks | [M]       |
| Thành công | [X] ✅    |
| Bỏ qua     | [Y] ⏭️    |
| Thất bại   | [Z] ❌    |

### Tasks đã hoàn thành:
- ✅ [TASK_ID]: [Task Name]
...

**Bước tiếp theo**: Chạy `/implement-phase` cho Phase tiếp theo
```

## Cập nhật CHECKLIST.md

**Trước:**
```markdown
### WP-XXX: Work Package Name (N tasks)
- [ ] WP-XXX-T001: Task 1 Name
- [ ] WP-XXX-T002: Task 2 Name
```

**Sau:**
```markdown
### WP-XXX: Work Package Name (N tasks)
- [x] WP-XXX-T001: Task 1 Name ✅ (2025-12-29)
- [ ] WP-XXX-T002: Task 2 Name
```

## Error Handling

### Task Dependency Error
```
⚠️ Task [TASK_ID] phụ thuộc vào [PREV_TASK_ID] chưa hoàn thành.
Bạn có muốn bỏ qua task này không? (yes/no)
```

### Command Failure
```
❌ Command failed: [command]
Error: [error message]

Options:
1. Retry command
2. Skip this step
3. Manual fix then continue
4. Abort phase
```

## Pause & Resume

**Pause:** Nhập `pause` khi được hỏi xác nhận task.

**Resume:** Chạy lại với SKIP_COMPLETED=true - workflow tự động bỏ qua tasks đã hoàn thành.

## Best Practices

1. **Chạy theo thứ tự**: Hoàn thành Phase trước khi chuyển sang Phase sau
2. **Commit thường xuyên**: Sau mỗi WP hoàn thành
3. **Test sau mỗi WP**: Verify các components hoạt động đúng
4. **Document issues**: Ghi lại vấn đề gặp phải

## Related Skills

| Skill            | Mục đích                         |
| ---------------- | -------------------------------- |
| `implement-task` | Thực thi một task cụ thể (subagent) |
