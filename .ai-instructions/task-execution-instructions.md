# Hướng dẫn thực thi Task

## Mục đích

Hướng dẫn này cung cấp chi tiết về cách AI thực thi từng task trong Task List, đảm bảo không bỏ sót bất kỳ nội dung nào và thực hiện đúng theo thiết kế.

---

## 1. Nguyên tắc cốt lõi

### 1.1 Tính độc lập của Task

Mỗi task được thiết kế để có thể thực thi **ĐỘC LẬP**, không cần nhớ context từ task trước. Điều này có nghĩa:

- AI chỉ cần đọc file task hiện tại
- Tất cả thông tin cần thiết đã có trong file task
- Dependency chỉ yêu cầu task trước đã **hoàn thành** (có code), không yêu cầu AI phải **nhớ** task trước đã làm gì
- Nếu cần tham chiếu code từ task trước, AI có thể đọc từ codebase

### 1.2 Tính đầy đủ (Completeness)

> ⚠️ **NGUYÊN TẮC VÀNG:** Task chỉ được coi là hoàn thành khi TẤT CẢ nội dung trong task đã được thực hiện.

**Checklist bắt buộc:**

| #   | Mục kiểm tra        | Mô tả                                      |
| --- | ------------------- | ------------------------------------------ |
| 1   | Mô tả               | Đã implement đúng mục đích được mô tả      |
| 2   | Output              | TẤT CẢ files trong phần Output đã được tạo |
| 3   | Acceptance Criteria | TẤT CẢ criteria đã được đáp ứng            |
| 4   | Hướng dẫn thực hiện | TẤT CẢ các bước đã được thực hiện          |
| 5   | Test Cases          | TẤT CẢ test cases đã pass                  |
| 6   | Ghi chú             | Đã xử lý tất cả các lưu ý đặc biệt         |

### 1.3 Tính chính xác (Accuracy)

- Code phải tuân theo thiết kế chi tiết được tham chiếu
- UI phải tuân theo wireframe (nếu có)
- Nếu có conflict, ưu tiên: **Wireframe > Thiết kế chi tiết > Task description**

---

## 2. Quy trình thực thi một Task

### Bước 1: Đọc và phân tích Task File

```
PHẢI ĐỌC TẤT CẢ CÁC SECTION:

1. Thông tin cơ bản
   └── Task ID, Group, Priority, Ước tính, Phụ thuộc, Status

2. Mô tả
   └── Hiểu mục tiêu tổng quan của task

3. Yêu cầu chi tiết
   ├── Input: Những gì cần có trước khi bắt đầu
   ├── Output: Danh sách files/artifacts cần tạo ra
   └── Acceptance Criteria: Các tiêu chí chấp nhận (phải đạt hết)

4. Hướng dẫn thực hiện
   └── Các bước cụ thể với code mẫu

5. Tham chiếu thiết kế
   └── Link đến tài liệu thiết kế chi tiết

6. Wireframe Reference (nếu có)
   └── Link đến wireframe cho UI tasks

7. Test Cases
   └── Các scenarios cần verify

8. Ghi chú
   └── Lưu ý đặc biệt, rủi ro, edge cases
```

### Bước 2: Kiểm tra Dependency

```python
# Pseudo-code cho dependency check
def check_dependency(task):
    dependencies = task.get_dependencies()

    if dependencies == "-":
        return True  # No dependency

    for dep_id in dependencies.split(","):
        dep_task = find_task(dep_id.strip())
        if dep_task.status != "Done":
            raise DependencyError(f"{dep_id} chưa hoàn thành")

    return True
```

### Bước 3: Đọc tài liệu tham chiếu

**Quy trình:**

1. Mở link trong phần "Tham chiếu thiết kế"
2. Đọc section được chỉ định (thường có format `#section-name`)
3. Trích xuất các thông tin quan trọng:
   - Class/Interface definitions
   - Method signatures
   - Business logic rules
   - Data structures
   - Validation rules

**Ví dụ:**

```markdown
## Tham chiếu thiết kế

- **Module:** DeckModule
- **Section:** 5.3 MOD-003 デッキ管理
- **Link:** [Xem thiết kế](../../詳細設計書/05-module-design.md#53-mod-003-デッキ管理)

→ AI cần mở file `05-module-design.md` và đọc section 5.3
```

### Bước 4: Xem Wireframe (Cho UI Tasks)

**Quy trình:**

1. Mở file wireframe được chỉ định
2. Phân tích các yếu tố UI:
   - Layout structure (grid, flex, positioning)
   - Component hierarchy
   - Spacing & sizing
   - Color scheme
   - Typography
   - Interactive states (hover, active, disabled)
3. Ghi chú các chi tiết quan trọng trước khi code

**Lưu ý:**

- Wireframe là **BẮT BUỘC** phải tuân theo cho UI tasks
- Nếu wireframe không có, sử dụng design system của project
- Nếu không có cả hai, implement theo best practices

### Bước 5: Thực hiện Implementation

**Quy trình từng bước:**

```
FOR EACH step IN "Hướng dẫn thực hiện":
    1. Đọc mô tả của bước
    2. Xem code mẫu (nếu có)
    3. Implement code thực tế dựa trên mẫu
    4. Điều chỉnh để phù hợp với project context
    5. Verify bước đã hoàn thành

FOR EACH file IN "Output":
    1. Tạo file tại đường dẫn được chỉ định
    2. Implement nội dung theo hướng dẫn
    3. Verify file đã được tạo và có nội dung đúng
```

**Lưu ý khi implement:**

- Code mẫu trong task là **hướng dẫn**, không phải copy-paste
- Phải điều chỉnh để phù hợp với:
  - Project structure hiện tại
  - Naming conventions của project
  - Dependencies đã cài đặt
  - Existing code patterns

### Bước 6: Verify Acceptance Criteria

```
FOR EACH criterion IN "Acceptance Criteria":
    1. Đọc mô tả criterion
    2. Verify rằng implementation đáp ứng criterion
    3. Nếu có test case liên quan, chạy test
    4. Đánh dấu criterion là ✅ khi passed

IF any criterion không đạt:
    1. Fix implementation
    2. Re-verify
    3. Repeat until all passed
```

### Bước 7: Run Test Cases

```
FOR EACH test_case IN "Test Cases":
    1. Setup test environment (nếu cần)
    2. Thực hiện test với Input được mô tả
    3. Verify Expected Output
    4. Ghi nhận kết quả

IF any test fails:
    1. Debug và fix code
    2. Re-run test
    3. Repeat until passed
```

### Bước 8: Xử lý Ghi chú

```
FOR EACH note IN "Ghi chú":
    1. Đọc và hiểu note
    2. Xác định action cần thực hiện:
       - Configuration change
       - Edge case handling
       - Performance consideration
       - Security measure
    3. Implement action
    4. Document nếu cần
```

### Bước 9: Final Verification

```
FINAL CHECKLIST:
□ All Output files created?
□ All Acceptance Criteria passed?
□ All Test Cases passed?
□ All Ghi chú addressed?
□ Code compiles/runs without errors?
□ Code follows project conventions?
□ No regressions introduced?

IF all checks passed:
    → Mark task as "Done"
ELSE:
    → Fix issues and re-verify
```

---

## 3. Xử lý các trường hợp đặc biệt

### 3.1 Khi Output file đã tồn tại

```
IF file already exists:
    1. Đọc nội dung hiện tại
    2. Xác định cần:
       - Thêm code mới (append)
       - Sửa code hiện tại (modify)
       - Thay thế hoàn toàn (replace)
    3. Merge changes cẩn thận
    4. Preserve existing functionality
```

### 3.2 Khi thiếu thông tin trong Task

```
IF information missing:
    1. Tìm trong tài liệu thiết kế tham chiếu
    2. Tìm trong wireframe (nếu có)
    3. Suy luận từ context và project patterns
    4. Implement với best effort
    5. Ghi chú: "[NEED_REVIEW] Implemented based on assumptions"
```

### 3.3 Khi có conflict giữa sources

**Thứ tự ưu tiên:**

1. Wireframe (cao nhất)
2. Thiết kế chi tiết
3. Thiết kế cơ bản
4. Task description (thấp nhất)

```
IF conflict detected:
    1. Chọn source có priority cao hơn
    2. Implement theo source đó
    3. Ghi chú conflict trong report
    4. Thông báo cho người dùng nếu cần
```

### 3.4 Khi code mẫu không phù hợp

```
IF sample code incompatible:
    1. Hiểu ý đồ của code mẫu
    2. Adapt để phù hợp với:
       - Current project structure
       - Installed dependencies
       - Existing patterns
    3. Preserve functionality intent
    4. Document changes made
```

---

## 4. Tracking và Reporting

### 4.1 Cập nhật Task Status

Sau khi hoàn thành task, cập nhật trong file task:

```markdown
| **Status** | Done | <!-- Changed from "Not Started" -->
```

### 4.2 Cập nhật Execution Report

Thêm entry vào `Execution_Report.md`:

```markdown
| {#} | {TASK-ID} | {Tên Task} | ✅ Done | {Start Time} | {End Time} | {Notes} |
```

### 4.3 Files được tạo/sửa đổi

Ghi lại tất cả files đã thay đổi:

```markdown
## Files Changed

### Created

- `src/modules/deck/deck.service.ts`
- `src/modules/deck/deck.repository.ts`

### Modified

- `src/app.module.ts` - Added DeckModule import
```

---

## 5. Best Practices

### 5.1 Đọc task kỹ trước khi code

- Đừng vội vàng bắt đầu code
- Hiểu rõ scope và requirements
- Plan approach trước khi implement

### 5.2 Verify liên tục

- Test sau mỗi bước quan trọng
- Không đợi đến cuối mới verify
- Catch bugs sớm

### 5.3 Document changes

- Ghi chú những gì đã làm khác với task description
- Document assumptions made
- Log issues encountered

### 5.4 Code quality

- Follow project conventions
- Write clean, readable code
- Add comments khi cần thiết
- Handle errors properly

---

## 6. Troubleshooting

### Q: Task dependency chưa done, nhưng tôi cần test code?

A: Có thể mock dependency để test. Document rằng đây là temporary solution và cần update khi dependency hoàn thành.

### Q: Wireframe không match với thiết kế chi tiết?

A: Ưu tiên wireframe. Báo cáo conflict để team review.

### Q: Code mẫu trong task quá đơn giản?

A: Expand code mẫu để đáp ứng đầy đủ requirements. Code mẫu chỉ là starting point, không phải complete solution.

### Q: Không tìm thấy file thiết kế tham chiếu?

A: Tìm trong các thư mục liên quan. Nếu không có, implement dựa trên task description và ghi chú rằng không có thiết kế chi tiết.

---

## 7. Template cho Task Completion Notes

Khi hoàn thành task, tạo notes theo template:

```markdown
## Task Completion Notes - {TASK-ID}

### Summary

{Mô tả ngắn gọn những gì đã implement}

### Files Created

- {list of new files}

### Files Modified

- {list of modified files with description of changes}

### Deviations from Task Description

- {If any, explain why}

### Known Issues / TODOs

- {If any}

### Verification Status

- [x] All output files created
- [x] All acceptance criteria passed
- [x] All test cases passed
- [x] Code compiles without errors
```

---

_Phiên bản: 1.0 | Cập nhật: 2025-12-13_
