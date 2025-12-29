---
description: Điều phối và thực thi toàn bộ các task trong một Phase
---

Execute the Phase Implementation workflow following the steps in `.agent/workflows/implement-phase.md`.

**Workflow Overview:**

**Phase 1: Thu thập thông tin**
- Hỏi đường dẫn đến file Phase Plan (VD: `docs/project/implementation-plan/phase-0-infrastructure.md`)
- Hỏi đường dẫn đến CHECKLIST.md
- **HỎI CHẾ ĐỘ CHẠY**: Manual (confirm từng task) hoặc Auto (tự động chạy hết phase)

**Phase 2: Đọc và phân tích Phase Plan**
- Đọc file phase plan
- Trích xuất thông tin phase: Phase number, name, danh sách Work Packages
- Xây dựng danh sách tasks theo thứ tự

**Phase 3: Đọc CHECKLIST.md**
- Xác định trạng thái từng task: `[ ]` = chưa hoàn thành, `[x]` = đã hoàn thành
- Xác định tasks cần thực hiện

**Phase 4: Hiển thị tổng quan và XÁC NHẬN**
- Hiển thị bảng thống kê: Tổng Work Packages, Tổng Tasks, Đã hoàn thành, Còn lại
- Hiển thị danh sách tasks với status
- **Nếu Manual mode**: Hỏi người dùng xác nhận trước khi bắt đầu
- **Nếu Auto mode**: Bỏ qua, tự động bắt đầu

**Phase 5: Thực thi từng Task**
Với mỗi task chưa hoàn thành:
- Hiển thị progress: "Task [X/Y]: [TASK_ID] - [Task Name]"
- **Nếu Manual mode**: Gọi `/implement-task` (có confirm từ người dùng)
- **Nếu Auto mode**: Tự động thực thi task KHÔNG qua `/implement-task`:
  - Đọc thông tin task từ phase plan
  - Hiển thị task info (ID, Type, Description)
  - Tự động chạy commands
  - Tự động tạo/sửa files
  - Verify acceptance criteria
  - Cập nhật CHECKLIST.md
  - Tiếp tục task tiếp theo
- Kiểm tra kết quả
- **Chỉ ở Auto mode**: Nếu lỗi → Log lỗi, tiếp tục task tiếp theo (không dừng)
- **Chỉ ở Manual mode**: Nếu lỗi → Hỏi: Retry / Skip / Abort

**Phase 6: Báo cáo hoàn thành Phase**
- Thống kê: Tổng tasks, Thành công, Bỏ qua, Thất bại
- Danh sách tasks đã hoàn thành
- Hướng dẫn bước tiếp theo

**Error Handling:**
- **Manual mode**: Task Dependency Error → Hỏi người dùng có muốn bỏ qua không
- **Manual mode**: Command Failure → Retry / Skip / Manual fix / Abort
- **Auto mode**: Task Dependency Error → Log warning, skip task
- **Auto mode**: Command Failure → Log error, skip task, continue
- Pause & Resume: Sử dụng CHECKLIST.md để track state

**Important Notes:**
- Luôn hoàn thành Phase trước khi chuyển sang Phase sau
- **Auto mode**: Tự động chạy hết tất cả tasks, không hỏi confirm
- **Manual mode**: Confirm từng task qua `/implement-task`
- Commit thường xuyên sau mỗi Work Package hoàn thành
- Test sau mỗi Work Package
- Document issues nếu gặp vấn đề

Start by asking for the Phase Plan file path, CHECKLIST.md path, and execution mode (Manual/Auto).
