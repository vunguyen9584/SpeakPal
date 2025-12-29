# 📋 CHECKLIST ĐÁNH GIÁ TASK LIST

## Mục đích

Checklist này dùng để đánh giá chất lượng của Task List đã được sinh ra từ tài liệu thiết kế chi tiết (Detailed Design), đảm bảo:

1. Task List **cover đầy đủ** tất cả các chức năng trong thiết kế
2. Nội dung task **không sai khác** so với thiết kế
3. Task List có thể thực thi được và đủ chi tiết

---

## 📋 CHECKLIST

### 1. COVERAGE CHECK (Kiểm tra độ phủ)

#### 1.1 Module/Component Coverage

| Kiểm tra                                                                 | Đánh giá | Ghi chú |
| ------------------------------------------------------------------------ | -------- | ------- |
| Tất cả Modules trong DD (05-module-design.md) có task tương ứng          | ⬜       |         |
| Mỗi Module có đủ các task: Entity/Model, Repository, Service, Controller | ⬜       |         |
| Không có Module nào bị bỏ sót                                            | ⬜       |         |

**Chi tiết đối chiếu Module → Task:**

| Module ID | Tên Module | Tasks liên quan    | Status |
| --------- | ---------- | ------------------ | ------ |
| MOD-001   | {Tên}      | TASK-XXX, TASK-YYY | ⬜     |
| MOD-002   | {Tên}      | TASK-XXX, TASK-YYY | ⬜     |
| ...       | ...        | ...                | ...    |

---

#### 1.2 Database/Entity Coverage

| Kiểm tra                                                                | Đánh giá | Ghi chú |
| ----------------------------------------------------------------------- | -------- | ------- |
| Tất cả Tables trong DD (06-database-design.md) có task tạo Entity/Model | ⬜       |         |
| Tất cả Tables có task tạo Repository/DAO tương ứng                      | ⬜       |         |
| Migration/DDL scripts có task riêng                                     | ⬜       |         |
| Indexes, Constraints được đề cập trong task                             | ⬜       |         |

**Chi tiết đối chiếu Table → Task:**

| Table Name | Entity Task | Repository Task | Migration Task | Status |
| ---------- | ----------- | --------------- | -------------- | ------ |
| users      | TASK-XXX    | TASK-YYY        | TASK-ZZZ       | ⬜     |
| ...        | ...         | ...             | ...            | ...    |

---

#### 1.3 API Coverage

| Kiểm tra                                                           | Đánh giá | Ghi chú |
| ------------------------------------------------------------------ | -------- | ------- |
| Tất cả API endpoints trong DD (07-api-design.md) có task implement | ⬜       |         |
| Mỗi API Group có Service và Controller tasks tương ứng             | ⬜       |         |
| Validation logic có task hoặc được đề cập trong task               | ⬜       |         |
| Error handling cho APIs được cover                                 | ⬜       |         |

**Chi tiết đối chiếu API → Task:**

| API ID  | Endpoint | Method | Controller Task | Service Task | Status |
| ------- | -------- | ------ | --------------- | ------------ | ------ |
| API-001 | /api/xxx | GET    | TASK-XXX        | TASK-YYY     | ⬜     |
| ...     | ...      | ...    | ...             | ...          | ...    |

---

#### 1.4 Screen/UI Coverage

| Kiểm tra                                                        | Đánh giá | Ghi chú |
| --------------------------------------------------------------- | -------- | ------- |
| Tất cả Screens trong DD (08-screen-design.md) có task implement | ⬜       |         |
| Components/Shared UI có task riêng                              | ⬜       |         |
| Navigation/Routing được cover                                   | ⬜       |         |
| Responsive design được đề cập                                   | ⬜       |         |

**Chi tiết đối chiếu Screen → Task:**

| Screen ID | Tên Screen | UI Task(s) | Component Tasks | Status |
| --------- | ---------- | ---------- | --------------- | ------ |
| SCR-001   | {Tên}      | TASK-XXX   | TASK-YYY        | ⬜     |
| ...       | ...        | ...        | ...             | ...    |

---

#### 1.5 Batch/Background Job Coverage

| Kiểm tra                                     | Đánh giá | Ghi chú |
| -------------------------------------------- | -------- | ------- |
| Tất cả Batch Jobs trong DD có task implement | ⬜       |         |
| Scheduler/Cron configuration có task         | ⬜       |         |
| Error handling và retry logic được đề cập    | ⬜       |         |

---

#### 1.6 Sequence Diagram Coverage

| Kiểm tra                                                          | Đánh giá | Ghi chú |
| ----------------------------------------------------------------- | -------- | ------- |
| Các flows phức tạp trong Sequence Diagrams đều có tasks tương ứng | ⬜       |         |
| Integration points được cover bởi Integration tasks               | ⬜       |         |

---

### 2. CONSISTENCY CHECK (Kiểm tra tính nhất quán)

#### 2.1 Naming Consistency

| Kiểm tra                                               | Đánh giá | Ghi chú |
| ------------------------------------------------------ | -------- | ------- |
| Tên Entity trong task khớp với Table name trong DD     | ⬜       |         |
| Tên Service trong task khớp với Module name trong DD   | ⬜       |         |
| Tên API endpoint trong task khớp với API Design        | ⬜       |         |
| Tên Screen/Component trong task khớp với Screen Design | ⬜       |         |

---

#### 2.2 Logic Consistency

| Kiểm tra                                          | Đánh giá | Ghi chú |
| ------------------------------------------------- | -------- | ------- |
| Business logic trong task khớp với mô tả trong DD | ⬜       |         |
| Validation rules trong task khớp với DD           | ⬜       |         |
| Error codes trong task khớp với DD                | ⬜       |         |
| Data types trong task khớp với Database Design    | ⬜       |         |

---

#### 2.3 Flow Consistency

| Kiểm tra                                            | Đánh giá | Ghi chú |
| --------------------------------------------------- | -------- | ------- |
| Luồng xử lý trong task khớp với Sequence Diagram    | ⬜       |         |
| State transitions trong task khớp với State Diagram | ⬜       |         |
| Error handling flow khớp với DD                     | ⬜       |         |

---

### 3. COMPLETENESS CHECK (Kiểm tra tính đầy đủ)

#### 3.1 Infrastructure Tasks

| Kiểm tra                                      | Đánh giá | Ghi chú |
| --------------------------------------------- | -------- | ------- |
| Có task khởi tạo project structure            | ⬜       |         |
| Có task cấu hình database connection          | ⬜       |         |
| Có task cấu hình authentication/authorization | ⬜       |         |
| Có task cấu hình logger, error handler        | ⬜       |         |
| Có task cấu hình CI/CD (nếu cần)              | ⬜       |         |

---

#### 3.2 Testing Tasks

| Kiểm tra                             | Đánh giá | Ghi chú |
| ------------------------------------ | -------- | ------- |
| Có Unit Test tasks cho Services      | ⬜       |         |
| Có Integration Test tasks cho APIs   | ⬜       |         |
| Có E2E Test tasks cho critical flows | ⬜       |         |
| Test coverage được định nghĩa        | ⬜       |         |

---

#### 3.3 Non-Functional Tasks

| Kiểm tra                                        | Đánh giá | Ghi chú |
| ----------------------------------------------- | -------- | ------- |
| Security measures có tasks (nếu DD có yêu cầu)  | ⬜       |         |
| Performance optimization có tasks (nếu cần)     | ⬜       |         |
| Logging/Monitoring có tasks (nếu DD có yêu cầu) | ⬜       |         |
| Caching có tasks (nếu DD có yêu cầu)            | ⬜       |         |

---

### 4. QUALITY CHECK (Kiểm tra chất lượng)

#### 4.1 Task Size

| Kiểm tra                                               | Đánh giá | Ghi chú |
| ------------------------------------------------------ | -------- | ------- |
| Không có task nào ước tính > 8 giờ                     | ⬜       |         |
| Không có task nào ước tính < 30 phút                   | ⬜       |         |
| Mỗi task có output rõ ràng (file, function, component) | ⬜       |         |

---

#### 4.2 Task Dependencies

| Kiểm tra                           | Đánh giá | Ghi chú |
| ---------------------------------- | -------- | ------- |
| Dependencies được xác định rõ ràng | ⬜       |         |
| Không có circular dependencies     | ⬜       |         |
| Dependency graph hợp lý            | ⬜       |         |
| Critical path được xác định        | ⬜       |         |

---

#### 4.3 Task Details

| Kiểm tra                                              | Đánh giá | Ghi chú |
| ----------------------------------------------------- | -------- | ------- |
| Mỗi task có Acceptance Criteria                       | ⬜       |         |
| Mỗi task có Tham chiếu thiết kế (link đến DD section) | ⬜       |         |
| Mỗi task có Test Cases cơ bản                         | ⬜       |         |
| Mỗi task có Hướng dẫn thực hiện                       | ⬜       |         |

---

### 5. TRACEABILITY CHECK (Kiểm tra tính truy vết)

| Kiểm tra                                       | Đánh giá | Ghi chú |
| ---------------------------------------------- | -------- | ------- |
| Mỗi task có reference đến DD section tương ứng | ⬜       |         |
| Master_Plan.md có link đến tất cả task files   | ⬜       |         |
| Có thể trace từ DD requirement → Task          | ⬜       |         |
| Có thể trace ngược từ Task → DD requirement    | ⬜       |         |

---

### 6. FORMAT CHECK (Kiểm tra định dạng)

| Kiểm tra                                       | Đánh giá | Ghi chú |
| ---------------------------------------------- | -------- | ------- |
| Task ID theo format chuẩn (TASK-XXX)           | ⬜       |         |
| File name theo format chuẩn (Task_XXX_Name.md) | ⬜       |         |
| Group folder theo format chuẩn (Group_XX_Name) | ⬜       |         |
| Master_Plan.md có đủ các sections              | ⬜       |         |
| Mermaid dependency graph có trong Master_Plan  | ⬜       |         |

---

## 📊 TỔNG KẾT

| Category           | Passed  | Failed | N/A |
| ------------------ | ------- | ------ | --- |
| Coverage Check     | /20     |        |     |
| Consistency Check  | /10     |        |     |
| Completeness Check | /12     |        |     |
| Quality Check      | /10     |        |     |
| Traceability Check | /4      |        |     |
| Format Check       | /5      |        |     |
| **TOTAL**          | **/61** |        |     |

---

## 📝 ISSUES FOUND (Các vấn đề phát hiện)

### High Priority 🔴

| #   | Description | DD Reference | Task(s) Affected | Action Required |
| --- | ----------- | ------------ | ---------------- | --------------- |
| 1   |             |              |                  |                 |

### Medium Priority 🟡

| #   | Description | DD Reference | Task(s) Affected | Action Required |
| --- | ----------- | ------------ | ---------------- | --------------- |
| 1   |             |              |                  |                 |

### Low Priority 🟢

| #   | Description | DD Reference | Task(s) Affected | Action Required |
| --- | ----------- | ------------ | ---------------- | --------------- |
| 1   |             |              |                  |                 |

---

## 📋 MISSING ITEMS (Các mục bị thiếu)

### Modules không có Task

| Module ID | Module Name | Tasks cần tạo |
| --------- | ----------- | ------------- |
|           |             |               |

### Tables không có Task

| Table Name | Tasks cần tạo |
| ---------- | ------------- |
|            |               |

### APIs không có Task

| API ID | Endpoint | Tasks cần tạo |
| ------ | -------- | ------------- |
|        |          |               |

### Screens không có Task

| Screen ID | Screen Name | Tasks cần tạo |
| --------- | ----------- | ------------- |
|           |             |               |

---

## 🔄 DISCREPANCIES (Các điểm sai khác)

| #   | Category     | DD Content          | Task Content       | Correction Needed              |
| --- | ------------ | ------------------- | ------------------ | ------------------------------ |
| 1   | Entity field | DD: `user.fullName` | Task: `user.name`  | Update task to use `fullName`  |
| 2   | API path     | DD: `/api/v1/users` | Task: `/api/users` | Update task to include version |

---

## ✅ CHECKLIST SỬ DỤNG

### Cách sử dụng Checklist này

1. **Chuẩn bị:**

   - Có sẵn tài liệu Detailed Design (DD)
   - Có sẵn Task List (Master_Plan.md và các Task files)

2. **Thực hiện review:**

   - Duyệt từng mục trong checklist
   - Đánh dấu ✅ (đạt), ❌ (không đạt), hoặc N/A (không áp dụng)
   - Ghi chú các vấn đề phát hiện

3. **Tổng hợp kết quả:**

   - Điền vào bảng Issues Found
   - Điền vào bảng Missing Items
   - Điền vào bảng Discrepancies

4. **Đánh giá tổng thể:**
   - Tính tổng điểm
   - Xác định mức độ đạt/không đạt
   - Liệt kê các action items cần thực hiện

---

## 📊 THANG ĐIỂM ĐÁNH GIÁ

| Score Range | Rating       | Description                                     |
| ----------- | ------------ | ----------------------------------------------- |
| 90-100%     | ✅ Excellent | Task List đầy đủ, chính xác, sẵn sàng implement |
| 75-89%      | ⚠️ Good      | Cần bổ sung một số mục nhỏ                      |
| 50-74%      | ⚠️ Fair      | Cần review và bổ sung đáng kể                   |
| < 50%       | ❌ Poor      | Cần tạo lại Task List                           |

---

_Template version: 1.0_
_Last updated: 2025-12-13_
