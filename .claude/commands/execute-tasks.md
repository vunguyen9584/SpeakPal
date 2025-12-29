---
description: Thực thi các task từ Task List đã được tạo ra
---

Execute the Task List execution workflow following the steps in `.agent/workflows/execute-tasks.md`.

**Workflow Overview:**

1. **Thu thập thông tin**: Hỏi đường dẫn TaskList và phạm vi thực thi (Single/Group/All)
2. **Load hướng dẫn**: Đọc `.ai-instructions/task-execution-instructions.md`
3. **Khởi tạo Execution Report**: Tạo file tracking tại `TaskList/Execution_Report.md`
4. **Task Execution Loop**:
   - Đọc và phân tích task
   - Kiểm tra dependency
   - Đọc tài liệu thiết kế tham chiếu
   - Implement code
   - Verify và cập nhật status
5. **Hoàn thành**: Cập nhật Master_Plan.md và output báo cáo

**Execution Modes:**
- **Single Task**: Thực thi một task cụ thể (VD: `TASK-001`)
- **Task Group**: Thực thi tất cả task trong một nhóm (VD: `Group_01_Setup`)
- **All Tasks**: Thực thi tất cả task trong TaskList

**Important Notes:**
- KHÔNG BỎ SÓT TASK hoặc NỘI DUNG
- TUÂN THỦ DEPENDENCY
- VERIFY TRƯỚC KHI ĐÁNH DẤU DONE
- Đọc tất cả sections trong task file trước khi code

Start by asking for the TaskList path and execution scope.
