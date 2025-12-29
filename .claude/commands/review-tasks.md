---
description: Review Task List đã được tạo ra, kiểm tra độ phủ và tính nhất quán với Detailed Design
---

Execute the Task List review workflow following the steps in `.agent/workflows/review-tasks.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa dự án
2. **Kiểm tra file**: Xác nhận TaskList, Master_Plan.md, Detailed Design tồn tại
3. **Load checklist**: Đọc `.ai-instructions/task-list-review-checklist.md`
4. **Review 6 categories**:
   - Coverage Check: Module, Database, API, Screen, Batch, Sequence
   - Consistency Check: Naming, Logic, Flow
   - Completeness Check: Infrastructure, Testing, Non-Functional
   - Quality Check: Task Size, Dependencies, Details
   - Traceability Check
   - Format Check
5. **Tạo kết quả**: Output file `tasklist-checklist.md`
6. **Tổng kết**: Điểm tổng thể, Rating, Issues, Top 5 action items

**Important Notes:**
- Lazy loading: Chỉ load DD file khi cần
- Đối chiếu chính xác: Đếm Modules/Tables/APIs/Screens
- Ghi rõ discrepancies: DD content vs Task content

Start by asking for the folder path containing the project documents.
