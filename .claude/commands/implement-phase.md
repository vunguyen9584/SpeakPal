---
description: Điều phối và thực thi toàn bộ các task trong một Phase
---

Execute the Phase Implementation workflow following the steps in `.agent/workflows/implement-phase.md`.

**Workflow Overview:**

**Phase 1: Thu thập thông tin**
- Hỏi đường dẫn đến file Phase Plan (VD: `docs/project/implementation-plan/phase-0-infrastructure.md`)
- Hỏi đường dẫn đến CHECKLIST.md

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
- Hỏi người dùng xác nhận trước khi bắt đầu

**Phase 5: Thực thi từng Task**
Với mỗi task chưa hoàn thành:
- Hiển thị progress: "Task [X/Y]: [TASK_ID] - [Task Name]"
- Gọi skill `implement-task` để thực thi task
- Kiểm tra kết quả và cập nhật CHECKLIST.md
- Xử lý lỗi: Retry / Skip / Abort

**Phase 6: Báo cáo hoàn thành Phase**
- Thống kê: Tổng tasks, Thành công, Bỏ qua, Thất bại
- Danh sách tasks đã hoàn thành
- Hướng dẫn bước tiếp theo

**Error Handling:**
- Task Dependency Error: Hỏi người dùng có muốn bỏ qua không
- Command Failure: Retry / Skip / Manual fix / Abort
- Pause & Resume: Sử dụng CHECKLIST.md để track state

**Important Notes:**
- Luôn hoàn thành Phase trước khi chuyển sang Phase sau
- Commit thường xuyên sau mỗi Work Package hoàn thành
- Test sau mỗi Work Package
- Document issues nếu gặp vấn đề

Start by asking for the Phase Plan file path and CHECKLIST.md path.
