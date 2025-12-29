---
description: Review việc thực hiện các task có được làm đúng với yêu cầu hay không
---

# Workflow: Review Task Execution

## 📝 Mô tả

Workflow này thực hiện review việc thực hiện các task, kiểm tra xem code được tạo ra có đúng với yêu cầu trong TaskList hay không.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng các tham số:

```
Để review việc thực hiện task, tôi cần thông tin sau:

1. **Thư mục TaskList:** Thư mục chứa Master_Plan.md và các Task Groups
   Ví dụ: `docs/LexiGo/TaskList`

2. **Thư mục Codebase:** Thư mục gốc hoặc thư mục con chứa code cần review
   Ví dụ: `src/` hoặc `apps/web/src/`

3. **Phạm vi review (tùy chọn):**
   - Một task cụ thể: Nhập Task ID (VD: `TASK-001`)
   - Một nhóm: Nhập tên Group (VD: `Group_01_Setup`)
   - Tất cả: Nhập `all` (mặc định)
```

---

## ✅ BƯỚC 2: Kiểm tra file tồn tại

- ❌ **BẮT BUỘC**: TaskList folder và Master_Plan.md phải tồn tại
- ❌ **BẮT BUỘC**: Codebase folder phải tồn tại và có code
- ⚠️ **TÙY CHỌN**: Execution_Report.md nếu có thì load để biết status hiện tại

---

## 📖 BƯỚC 3: Load hướng dẫn review

Đọc file hướng dẫn tại:

```
.ai-instructions/execution-review-instructions.md
```

File này chứa:

- Quy trình review chi tiết từng bước
- Các tiêu chí đánh giá (Output Files, Implementation, Acceptance Criteria, Tests)
- Cách tính verdict (PASSED/PARTIAL/FAILED/NEEDS REVIEW)
- Quy tắc cập nhật status
- Template output checklist
- Xử lý các trường hợp đặc biệt

> ⚠️ **QUAN TRỌNG:** Phải đọc và hiểu hướng dẫn TRƯỚC khi thực hiện review!

---

## 🔍 BƯỚC 4: Thực hiện Review

1. **Xác định danh sách task cần review** từ Master_Plan.md
2. **Với mỗi task**, thực hiện 4 checks theo hướng dẫn:
   - CHECK 1: Kiểm tra Output Files
   - CHECK 2: Kiểm tra Code Implementation
   - CHECK 3: Verify Acceptance Criteria
   - CHECK 4: Kiểm tra Test Cases
3. **Tính Task Verdict** dựa trên kết quả các checks
4. **Cập nhật status** trong file task theo quy tắc

---

## 📝 BƯỚC 5: Tạo Output

### 5.1 Execution Review Checklist

Tạo file: `[tasklist_folder]/Execution_Review_Checklist.md`

Sử dụng template trong file hướng dẫn, bao gồm:

- Thông tin review
- Tổng kết kết quả
- Chi tiết từng task
- Issues phân loại theo priority
- Recommended actions

### 5.2 Cập nhật Task Files

- Thêm section "Review Notes" vào cuối mỗi file task đã review
- Cập nhật status theo verdict

### 5.3 Cập nhật Master Plan

Cập nhật phần "Trạng thái tổng quan" trong Master_Plan.md

---

## 📊 BƯỚC 6: Tổng kết

Hiển thị tóm tắt cho người dùng:

```
✅ EXECUTION REVIEW COMPLETE

📊 Summary:
- Tổng task reviewed: N
- ✅ PASSED: X (X%)
- ⚠️ PARTIAL: Y (Y%)
- ❌ FAILED: Z (Z%)
- ❓ NEEDS REVIEW: W (W%)

📈 Status Changes:
- Upgraded: A tasks
- Unchanged: B tasks
- Downgraded: C tasks

📁 Output Files:
- Review Checklist: [tasklist_folder]/Execution_Review_Checklist.md
- Updated Master Plan: [tasklist_folder]/Master_Plan.md

🔴 High Priority Issues: N items
```

---

## 💡 Lưu ý

1. **KHÔNG modify code**: Workflow này chỉ review, KHÔNG sửa code
2. **Cập nhật status chính xác**: Downgrade status nếu code không match yêu cầu
3. **Tham chiếu hướng dẫn**: Chi tiết xem tại `.ai-instructions/execution-review-instructions.md`
