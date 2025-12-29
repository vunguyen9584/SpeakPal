# Hướng dẫn Review việc thực hiện Task (Execution Review Instructions)

## 📝 Mục đích

Tài liệu này hướng dẫn chi tiết cách review việc thực hiện các task, kiểm tra xem code được tạo ra có đúng với yêu cầu trong TaskList hay không.

---

## 🎯 Mục tiêu Review

1. **Kiểm tra code implementation** có đúng theo task description
2. **Verify Acceptance Criteria** - các tiêu chí chấp nhận có được đáp ứng
3. **Cập nhật trạng thái** task về đúng thực tế

---

## 📥 Xác định Input

### Các đường dẫn cần thiết

| Mục              | Đường dẫn                                       |
| ---------------- | ----------------------------------------------- |
| Task List        | [tasklist_folder]/                              |
| Master Plan      | [tasklist_folder]/Master_Plan.md                |
| Codebase         | [codebase_folder]/                              |
| Execution Report | [tasklist_folder]/Execution_Report.md           |
| Output Checklist | [tasklist_folder]/Execution_Review_Checklist.md |

### Kiểm tra file tồn tại

- ❌ **BẮT BUỘC**: TaskList folder phải tồn tại
- ❌ **BẮT BUỘC**: Master_Plan.md phải tồn tại
- ❌ **BẮT BUỘC**: Codebase folder phải tồn tại và có code
- ⚠️ **TÙY CHỌN**: Execution_Report.md nếu có thì load để biết status hiện tại

---

## 📖 Xác định danh sách task cần review

### Load Master_Plan.md

Trích xuất:

- Danh sách tất cả Groups
- Danh sách tất cả Tasks (ID, tên, status hiện tại)
- File paths của từng task

### Lọc theo phạm vi

| Phạm vi        | Lọc                                                    |
| -------------- | ------------------------------------------------------ |
| Single Task    | Chỉ lấy task cụ thể theo ID                            |
| Task Group     | Lấy tất cả tasks trong group được chỉ định             |
| All (mặc định) | Lấy tất cả tasks có status = "Done" hoặc "In Progress" |

> ⚠️ **LƯU Ý**: Mặc định chỉ review các task đã được đánh dấu Done hoặc In Progress

---

## 🔍 Quy trình Review từng Task

### 1. Load Task File

Đọc file task và trích xuất:

| Section                 | Mục đích                 |
| ----------------------- | ------------------------ |
| **Mô tả**               | Hiểu mục tiêu của task   |
| **Output**              | Danh sách files cần tạo  |
| **Acceptance Criteria** | Các tiêu chí cần đáp ứng |
| **Hướng dẫn thực hiện** | Logic/code cần implement |
| **Test Cases**          | Các test cần verify      |

### 2. Kiểm tra Output Files

```
CHECK 1: Kiểm tra files được tạo

Với mỗi file trong phần "Output":
1. Kiểm tra file có tồn tại trong codebase
2. Nếu tồn tại → ✅ File Exists
3. Nếu không → ❌ File Missing

Kết quả:
- ✅ All files exist: Passed
- ⚠️ Some files missing: Partial
- ❌ No files found: Failed
```

### 3. Kiểm tra Code Implementation

```
CHECK 2: Kiểm tra nội dung code

Với mỗi file output tồn tại:
1. Mở file và đọc nội dung
2. So sánh với "Hướng dẫn thực hiện" trong task:
   - Các functions/methods được yêu cầu có được implement?
   - Logic xử lý có đúng mô tả?
   - Code structure có đúng pattern được yêu cầu?

Đánh giá:
- ✅ Fully Implemented: Code hoàn chỉnh theo yêu cầu
- ⚠️ Partially Implemented: Thiếu một số phần
- ❌ Not Implemented: Không match với yêu cầu
- ⏭️ Unable to Verify: Không thể kiểm tra tự động
```

### 4. Verify Acceptance Criteria

```
CHECK 3: Kiểm tra Acceptance Criteria

Với mỗi acceptance criteria trong task:
1. Xác định cách verify (code check / runtime check / manual)
2. Thực hiện verification:
   - Code check: Tìm pattern trong code
   - Runtime check: Nếu có test -> chạy test
   - Manual: Đánh dấu cần review thủ công

Đánh giá cho mỗi AC:
- ✅ Met: Đáp ứng hoàn toàn
- ⚠️ Partially Met: Đáp ứng một phần
- ❌ Not Met: Chưa đáp ứng
- ❓ Cannot Verify: Cần kiểm tra thủ công
```

### 5. Kiểm tra Test Cases (nếu có)

```
CHECK 4: Kiểm tra Tests

1. Tìm test files liên quan đến task output
2. Nếu có tests:
   - Đếm số test cases
   - Nếu có thể chạy → chạy tests
   - Ghi nhận kết quả pass/fail

Đánh giá:
- ✅ All Tests Pass: Tất cả tests đều pass
- ⚠️ Some Tests Fail: Có test fail
- ❌ No Tests Found: Không có test
- ⏭️ Tests Not Runnable: Không thể chạy test
```

### 6. Tổng hợp đánh giá cho Task

```
TASK VERDICT:

Dựa trên 4 checks trên, xác định verdict:

| Check           | Weight | Status |
| --------------- | ------ | ------ |
| Output Files    | 25%    | ?      |
| Implementation  | 35%    | ?      |
| Acceptance Criteria | 30% | ?      |
| Test Cases      | 10%    | ?      |

Verdict:
- ✅ PASSED (>=80%): Task được hoàn thành đúng yêu cầu
- ⚠️ PARTIAL (50-79%): Task hoàn thành một phần, cần bổ sung
- ❌ FAILED (<50%): Task chưa hoàn thành hoặc sai yêu cầu
- ❓ NEEDS REVIEW: Cần review thủ công
```

---

## 📝 Cập nhật trạng thái Task

### Cập nhật Task File

Dựa vào verdict, cập nhật status trong file task:

```markdown
| Thuộc tính | Giá trị                      |
| ---------- | ---------------------------- | ------------------------------ |
| **Status** | Done/In Progress/Not Started | <!-- Cập nhật theo verdict --> |
```

Quy tắc cập nhật:

| Verdict hiện tại | Status ban đầu | Status mới               |
| ---------------- | -------------- | ------------------------ |
| ✅ PASSED        | Done           | Done (giữ nguyên)        |
| ✅ PASSED        | In Progress    | Done (upgrade)           |
| ⚠️ PARTIAL       | Done           | In Progress (downgrade)  |
| ⚠️ PARTIAL       | In Progress    | In Progress (giữ nguyên) |
| ❌ FAILED        | Done           | Not Started (downgrade)  |
| ❌ FAILED        | In Progress    | Not Started (downgrade)  |

### Thêm Review Notes vào Task

Thêm section "Review Notes" vào cuối file task:

```markdown
---

## 📋 Review Notes

**Reviewed on:** [YYYY-MM-DD HH:mm]
**Verdict:** [PASSED/PARTIAL/FAILED/NEEDS REVIEW]

### Files Check

| File     | Status     |
| -------- | ---------- |
| file1.ts | ✅ Exists  |
| file2.ts | ❌ Missing |

### Acceptance Criteria Check

| #   | Criteria        | Status     |
| --- | --------------- | ---------- |
| 1   | AC1 description | ✅ Met     |
| 2   | AC2 description | ⚠️ Partial |

### Issues Found

1. [Issue description]
2. [Issue description]

### Actions Required

1. [Action needed]
2. [Action needed]
```

---

## 📊 Template: Execution Review Checklist

```markdown
# 📋 EXECUTION REVIEW CHECKLIST

## 📊 Thông tin Review

| Thông tin      | Giá trị            |
| -------------- | ------------------ |
| Ngày review    | [YYYY-MM-DD HH:mm] |
| Task List      | [tasklist_folder]  |
| Codebase       | [codebase_folder]  |
| Phạm vi review | [Single/Group/All] |
| Tổng task      | [N]                |

---

## 📈 TỔNG KẾT

### Kết quả tổng quan

| Verdict         | Số lượng | Tỷ lệ |
| --------------- | -------- | ----- |
| ✅ PASSED       | X        | X%    |
| ⚠️ PARTIAL      | X        | X%    |
| ❌ FAILED       | X        | X%    |
| ❓ NEEDS REVIEW | X        | X%    |
| **TOTAL**       | N        | 100%  |

### Status Changes

| Change Type | Count | Từ → Đến                       |
| ----------- | ----- | ------------------------------ |
| Upgraded    | X     | In Progress → Done             |
| Unchanged   | X     | -                              |
| Downgraded  | X     | Done → In Progress/Not Started |

---

## 📝 CHI TIẾT TỪNG TASK

### Group: [Group_01_Name]

| Task ID  | Task Name | Old Status | Verdict    | New Status  | Issues   |
| -------- | --------- | ---------- | ---------- | ----------- | -------- |
| TASK-001 | Name      | Done       | ✅ PASSED  | Done        | -        |
| TASK-002 | Name      | Done       | ⚠️ PARTIAL | In Progress | 2 issues |

#### TASK-002 Issues:

1. File `src/auth.ts` missing
2. AC #3 not fully implemented

---

## 🔴 HIGH PRIORITY ISSUES

| #   | Task ID  | Issue Description           | Action Required |
| --- | -------- | --------------------------- | --------------- |
| 1   | TASK-005 | Core module not implemented | Re-implement    |
| 2   | TASK-012 | Database connection failed  | Fix connection  |

---

## 🟡 MEDIUM PRIORITY ISSUES

| #   | Task ID  | Issue Description  | Action Required |
| --- | -------- | ------------------ | --------------- |
| 1   | TASK-008 | Missing validation | Add validation  |

---

## 🟢 MINOR ISSUES

| #   | Task ID | Issue Description | Action Required |
| --- | ------- | ----------------- | --------------- |

---

## ✅ RECOMMENDED ACTIONS

### Immediate (Must Fix)

1. [Action with Task ID reference]

### Next Sprint

1. [Action with Task ID reference]

---

## 🔄 STATUS UPDATES APPLIED

| Task ID  | File Path                 | Old Status | New Status  |
| -------- | ------------------------- | ---------- | ----------- |
| TASK-001 | Group_01/Task_001_Name.md | Done       | Done        |
| TASK-002 | Group_01/Task_002_Name.md | Done       | In Progress |
```

---

## 💡 Lưu ý quan trọng

### ⚠️ Nguyên tắc Review

1. **KHÔNG modify code**: Workflow này chỉ review, KHÔNG sửa code
2. **Cập nhật status chính xác**: Downgrade status nếu code không match
3. **Ghi chú chi tiết**: Mô tả rõ issues để dễ fix
4. **Không bỏ sót task**: Review TẤT CẢ tasks trong phạm vi

### 🔄 Khi cần re-review

1. Sau khi fix issues, có thể chạy lại workflow để verify lần nữa
2. Workflow sẽ đọc review notes cũ và append review mới

### 📋 Checklist trước khi kết thúc

- [ ] Tất cả tasks trong phạm vi đã được review
- [ ] Status của các tasks đã được cập nhật đúng
- [ ] Execution_Review_Checklist.md được tạo đầy đủ
- [ ] Master_Plan.md đã được cập nhật trạng thái
- [ ] Các issues được phân loại rõ ràng theo priority

---

## 🛠️ Xử lý các trường hợp đặc biệt

### Case 1: Không tìm thấy code

```
Scenario: Task đánh dấu Done nhưng không tìm thấy files

Action:
1. Đánh dấu verdict = FAILED
2. Downgrade status = Not Started
3. Ghi issue: "Output files not found in codebase"
```

### Case 2: Code ở vị trí khác

```
Scenario: Files tồn tại nhưng ở path khác với task mô tả

Action:
1. Search trong toàn bộ codebase
2. Nếu tìm thấy → Cập nhật path trong task file
3. Tiếp tục review với path mới
```

### Case 3: Partial Implementation

```
Scenario: Một số functions/features được implement, một số chưa

Action:
1. Liệt kê chi tiết cái nào có, cái nào thiếu
2. Đánh giá % completion
3. Set verdict = PARTIAL
4. Status = In Progress
```

### Case 4: Code style khác nhưng logic đúng

```
Scenario: Code không match exactly với hướng dẫn nhưng functionality đúng

Action:
1. Ưu tiên đánh giá Acceptance Criteria
2. Nếu ACs pass → verdict = PASSED
3. Ghi note về code style difference (minor issue)
```
