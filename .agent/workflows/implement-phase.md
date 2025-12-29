---
description: Điều phối và thực thi toàn bộ các task trong một Phase
---

# Workflow: Implement Phase

## Mục đích

Điều phối việc thực thi toàn bộ các task trong một Phase của Implementation Plan. Workflow này sẽ:

1. Liệt kê tất cả tasks trong phase
2. Gọi `/implement-task` cho từng task
3. Kiểm tra kết quả mỗi task
4. Cập nhật CHECKLIST.md

---

## Input

| Tham số        | Mô tả                                                         | Bắt buộc |
| -------------- | ------------------------------------------------------------- | -------- |
| PHASE_PLAN     | Đường dẫn đến file plan của phase                             | ✅       |
| CHECKLIST_FILE | Đường dẫn đến file CHECKLIST.md                               | ✅       |
| START_FROM     | Task ID để bắt đầu (nếu muốn tiếp tục từ giữa)                | Optional |
| SKIP_COMPLETED | Bỏ qua các task đã hoàn thành trong checklist (default: true) | Optional |

**Ví dụ:**

```
Implement Phase 0 từ:
- PHASE_PLAN: docs/SpeakPal/implementation-plan/phase-0-infrastructure.md
- CHECKLIST_FILE: docs/SpeakPal/implementation-plan/CHECKLIST.md
```

---

## Quy trình thực hiện

### Bước 1: Đọc và phân tích Phase Plan

1. Đọc file phase plan
2. Trích xuất thông tin phase:
   - Phase number và name
   - Danh sách Work Packages
   - Tổng số tasks
3. Xây dựng danh sách tasks theo thứ tự

### Bước 2: Đọc CHECKLIST.md

1. Đọc file CHECKLIST.md
2. Tìm section tương ứng với phase
3. Xác định trạng thái từng task:
   - `[ ]` = chưa hoàn thành
   - `[x]` = đã hoàn thành

### Bước 3: Hiển thị tổng quan và XÁC NHẬN

**BẮT BUỘC**: Hiển thị và hỏi người dùng trước khi bắt đầu:

```markdown
## 📋 Phase Implementation Plan

### Phase: [Phase Number] - [Phase Name]

| Thống kê           | Giá trị |
| ------------------ | ------- |
| Tổng Work Packages | [N]     |
| Tổng Tasks         | [M]     |
| Đã hoàn thành      | [X]     |
| Còn lại            | [Y]     |
| Est. Hours         | [Z]     |

### Danh sách Tasks:

| #   | Task ID         | Task Name          | Status | Est. Hours |
| --- | --------------- | ------------------ | ------ | ---------- |
| 1   | WP-INF-001-T001 | Install PostgreSQL | ⬜     | 1          |
| 2   | WP-INF-001-T002 | Create Database    | ⬜     | 0.5        |
| 3   | WP-INF-001-T003 | Configure Access   | ⬜     | 0.5        |
| ... | ...             | ...                | ...    | ...        |

### Thứ tự thực hiện:

1. WP-INF-001 (4 tasks) → PostgreSQL Setup
2. WP-INF-002 (3 tasks) → Redis Setup
3. ...

---

**Bạn có muốn bắt đầu implement Phase này không?**

- Nhập `yes` để bắt đầu từ task đầu tiên
- Nhập `skip to [TASK_ID]` để bắt đầu từ task cụ thể
- Nhập `no` để hủy
```

CHỜ người dùng xác nhận trước khi tiếp tục.

### Bước 4: Thực thi từng Task

Với mỗi task chưa hoàn thành:

```
┌─────────────────────────────────────────────────────────┐
│ 4.1. Hiển thị progress                                  │
│     "🔄 Task [X/Y]: [TASK_ID] - [Task Name]"            │
└────────────────────────┬────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ 4.2. Gọi /implement-task                                │
│     - TASK_ID: [current task]                           │
│     - PLAN_FILE: [phase plan file]                      │
│     → Workflow implement-task sẽ hỏi xác nhận           │
│     → Thực thi task                                     │
│     → Báo cáo kết quả                                   │
└────────────────────────┬────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ 4.3. Kiểm tra kết quả                                   │
│     → Nếu THÀNH CÔNG:                                   │
│        - Cập nhật CHECKLIST.md                          │
│        - Tiếp tục task tiếp theo                        │
│     → Nếu THẤT BẠI:                                     │
│        - Hiển thị lỗi                                   │
│        - Hỏi: Retry / Skip / Abort?                     │
└────────────────────────┬────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ 4.4. Cập nhật CHECKLIST.md                              │
│     - Đánh dấu [x] task đã hoàn thành                   │
│     - Cập nhật progress counter                         │
└─────────────────────────────────────────────────────────┘
```

### Bước 5: Xử lý kết quả mỗi Task

#### 5.1. Task thành công

```markdown
✅ Task [TASK_ID] hoàn thành!
Progress: [X/Y] tasks ([Z%])

Tiếp tục với task tiếp theo...
```

#### 5.2. Task thất bại

```markdown
❌ Task [TASK_ID] thất bại!

Lỗi: [Error message]

Bạn muốn làm gì?

- `retry` - Thử lại task này
- `skip` - Bỏ qua, tiếp tục task tiếp theo
- `abort` - Dừng toàn bộ phase
```

### Bước 6: Báo cáo hoàn thành Phase

Sau khi tất cả tasks hoàn thành:

```markdown
## 🎉 Phase [N] đã hoàn thành!

### Kết quả:

| Thống kê   | Giá trị   |
| ---------- | --------- |
| Tổng tasks | [M]       |
| Thành công | [X] ✅    |
| Bỏ qua     | [Y] ⏭️    |
| Thất bại   | [Z] ❌    |
| Thời gian  | [T] hours |

### Tasks đã hoàn thành:

- ✅ WP-INF-001-T001: Install PostgreSQL
- ✅ WP-INF-001-T002: Create Database
- ✅ WP-INF-001-T003: Configure Access
- ...

### CHECKLIST.md đã được cập nhật:

- Phase 0 Progress: [X/Y] tasks completed

---

**Bước tiếp theo**: Chạy `/implement-phase` cho Phase tiếp theo
```

---

## Chi tiết Implementation

### Cập nhật CHECKLIST.md

Sau mỗi task hoàn thành, cập nhật file CHECKLIST:

**Trước:**

```markdown
### WP-INF-001: PostgreSQL Database Setup (4 tasks)

- [ ] WP-INF-001-T001: Install PostgreSQL
- [ ] WP-INF-001-T002: Create Database
```

**Sau:**

```markdown
### WP-INF-001: PostgreSQL Database Setup (4 tasks)

- [x] WP-INF-001-T001: Install PostgreSQL ✅ (2025-12-29)
- [ ] WP-INF-001-T002: Create Database
```

### Cập nhật Progress Counter

```markdown
## Progress

- **Total Tasks**: 293
- **Completed**: 17 ← Cập nhật
- **Progress**: 5.8% ← Cập nhật
```

---

## Error Handling

### Task Dependency Error

Nếu task phụ thuộc vào task trước chưa hoàn thành:

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

### File Creation Error

```
❌ Cannot create file: [path]
Error: [error message]

Kiểm tra:
- Thư mục cha có tồn tại không?
- Quyền ghi file?
```

---

## Pause & Resume

### Pause

Nếu người dùng cần dừng giữa chừng:

```
Để tạm dừng, nhập `pause` khi được hỏi xác nhận task.

State sẽ được lưu dựa trên CHECKLIST.md:
- Tasks đã đánh dấu [x] = đã hoàn thành
- Tasks còn [ ] = chưa hoàn thành
```

### Resume

Chạy lại workflow với SKIP_COMPLETED=true:

```
/implement-phase
- PHASE_PLAN: docs/SpeakPal/implementation-plan/phase-0-infrastructure.md
- CHECKLIST_FILE: docs/SpeakPal/implementation-plan/CHECKLIST.md
- SKIP_COMPLETED: true

→ Workflow tự động bỏ qua các task đã hoàn thành
→ Tiếp tục từ task tiếp theo chưa hoàn thành
```

---

## Ví dụ: Implement Phase 0

### Input:

```
/implement-phase
- PHASE_PLAN: docs/SpeakPal/implementation-plan/phase-0-infrastructure.md
- CHECKLIST_FILE: docs/SpeakPal/implementation-plan/CHECKLIST.md
```

### Execution Flow:

```
📋 Phase 0: Infrastructure Setup
   5 Work Packages, 17 Tasks

Bắt đầu implement? (yes/no) → yes

🔄 Task [1/17]: WP-INF-001-T001 - Install PostgreSQL
   → Gọi /implement-task
   → User confirms "yes"
   → Chạy: docker pull postgres:15
   → ✅ Hoàn thành! Cập nhật CHECKLIST.md

🔄 Task [2/17]: WP-INF-001-T002 - Create Database
   → Gọi /implement-task
   → User confirms "yes"
   → Chạy: CREATE DATABASE speakpal_dev
   → ✅ Hoàn thành! Cập nhật CHECKLIST.md

... (tiếp tục cho 15 tasks còn lại)

🎉 Phase 0 hoàn thành!
   17/17 tasks ✅
   Thời gian: ~14.5 hours
```

---

## Best Practices

### 1. Chạy theo thứ tự

- Luôn hoàn thành Phase trước khi chuyển sang Phase sau
- Trong Phase, hoàn thành WP theo thứ tự dependency

### 2. Commit thường xuyên

- Sau mỗi WP hoàn thành, commit code
- Message: `feat(phase-0): complete WP-INF-001 PostgreSQL setup`

### 3. Test sau mỗi WP

- Verify các components hoạt động đúng
- Chạy test nếu có

### 4. Document issues

- Nếu gặp vấn đề, ghi lại trong file notes
- Sẽ giúp cho các lần sau hoặc người khác

---

## Related Workflows

| Workflow               | Mục đích                                       |
| ---------------------- | ---------------------------------------------- |
| `/implement-task`      | Thực thi một task cụ thể                       |
| `/implement-next-task` | Tìm và thực thi task tiếp theo chưa hoàn thành |
| `/review-execution`    | Review kết quả thực thi                        |

---

_Workflow version: 1.0_
_Last updated: 2025-12-29_
