---
description: Review việc thực hiện các task có được làm đúng với yêu cầu hay không
---

Execute the Task Execution review workflow following the steps in `.agent/workflows/review-execution.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi thư mục TaskList, Codebase, và phạm vi review
2. **Kiểm tra file**: Xác nhận TaskList và Codebase tồn tại
3. **Load hướng dẫn**: Đọc `.ai-instructions/execution-review-instructions.md`
4. **Thực hiện Review** cho mỗi task:
   - CHECK 1: Kiểm tra Output Files
   - CHECK 2: Kiểm tra Code Implementation
   - CHECK 3: Verify Acceptance Criteria
   - CHECK 4: Kiểm tra Test Cases
5. **Tính Task Verdict**: PASSED/PARTIAL/FAILED/NEEDS REVIEW
6. **Tạo Output**: `Execution_Review_Checklist.md`, cập nhật task files và Master Plan

**Important Notes:**
- KHÔNG modify code - chỉ review
- Cập nhật status chính xác, downgrade nếu code không match yêu cầu
- Thêm "Review Notes" vào cuối mỗi file task đã review

Start by asking for the TaskList folder, Codebase folder, and review scope.
