# Hướng dẫn tạo Task List từ tài liệu thiết kế (Hybrid Approach)

## Mục đích

Hướng dẫn này giúp AI chuyển đổi tài liệu đầu vào (Thiết kế chi tiết, Wireframe, Thiết kế cơ bản) thành danh sách công việc lập trình (Task List) có cấu trúc rõ ràng, **đảm bảo không bỏ sót** và **có test coverage đầy đủ**.

---

## 1. Tài liệu đầu vào

### Bắt buộc

- **Thiết kế chi tiết (Detailed Design):** Chứa thông tin về module, API, database, UI specifications
- **Thiết kế cơ bản (Basic Design):** Cần thiết khi DD có "BD Reference" items

> ⚠️ **QUAN TRỌNG:** DD thường có các Coverage Matrix/Reference Table liệt kê items với "BD Reference" link. Những items này CHỈ có chi tiết trong BD, DO ĐÓ PHẢI đọc BD section được tham chiếu. Thiếu BD = Bỏ sót features!

### Tùy chọn (Optional)

- **Wireframe:** Bản phác thảo giao diện người dùng
- **BD-DD Mapping file:** File mapping giữa BD và DD (nếu có)

### Checklist đánh giá

- **Task List Review Checklist:** [.ai-instructions/task-list-review-checklist.md](./task-list-review-checklist.md)
- **DD Element Coverage:** [.ai-instructions/dd-element-coverage-requirements.md](./dd-element-coverage-requirements.md)

---

## 2. Hybrid Approach - 5 Phases

```
┌─────────────────────────────────────────────────────────┐
│                    HYBRID APPROACH                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1️⃣  Tạo Implementation Plan                           │
│      • Liệt kê TẤT CẢ components từ DD                 │
│      • Verify không bỏ sót feature nào                 │
│      ↓                                                  │
│  2️⃣  Chia thành Modules                                │
│      • Group theo domain/feature                        │
│      • Mỗi module có _module_overview.md               │
│      ↓                                                  │
│  3️⃣  TDD Approach cho mỗi Module                       │
│      • Tạo test_cases.md TRƯỚC                         │
│      • Task acceptance criteria từ test cases          │
│      ↓                                                  │
│  4️⃣  CHECKLIST.md Tracking                             │
│      • Update sau mỗi task hoàn thành                  │
│      • Track test coverage                             │
│      ↓                                                  │
│  5️⃣  Integration Test cuối cùng                        │
│      • Cross-module tests                              │
│      • E2E tests                                       │
│      • Final verification với DD                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Phase 1: Tạo Implementation Plan

### 3.1 Mục tiêu

- Đọc và hiểu TOÀN BỘ tài liệu thiết kế
- Liệt kê TẤT CẢ components cần implement
- Xác định thứ tự và dependencies
- **Verify không bỏ sót bất kỳ feature nào**

### 3.2 Quy trình

1. **Đọc toàn bộ Detailed Design** - Từng section một
2. **Extract components** theo categories sau:

| Category        | DD Source                | BD Reference for        |
| --------------- | ------------------------ | ----------------------- |
| Modules         | 04-module-design.md      | Classes, Services       |
| Use Cases       | 05-component-design.md   | Sequence, Pseudocode    |
| Batches         | 05-component-design.md   | Flowchart, Processing   |
| Database Tables | 06-database-design.md    | DDL, Indexes            |
| APIs/Actions    | 07-api-design.md         | Endpoints, Validation   |
| UI Screens      | 08-ui-specifications.md  | Components, Events      |
| Security        | 09-security-design.md    | Auth, Authz, Encryption |
| Error Handling  | 10-error-handling.md     | Error codes, Exceptions |
| Logging         | 11-logging-monitoring.md | Log format, Metrics     |

3. **Xác định BD Reference items**:
   - Tìm các entry có "BD Reference", "参照先 BD", "Xem BD section"
   - **ĐỌC BD section được tham chiếu**
   - Extract requirements từ BD
4. **Tạo dependency graph**
5. **Estimate effort** cho mỗi component

### 3.3 Template: Implementation_Plan.md

```markdown
# Implementation Plan - {Tên dự án}

## 1. Thông tin chung

- **Ngày tạo:** {YYYY-MM-DD}
- **Nguồn:** {Link đến Detailed Design}
- **Tech Stack:** {Liệt kê}

## 2. Danh sách TẤT CẢ Components

### 2.1 Database & Models

| #   | Component   | DD Reference      | Priority | Estimate |
| --- | ----------- | ----------------- | -------- | -------- |
| 1   | User Entity | 06-database, §2.1 | High     | 2h       |

### 2.2 Backend Services

| #   | Service     | APIs        | DD Reference    |
| --- | ----------- | ----------- | --------------- |
| 1   | UserService | CRUD /users | 05-module, §3.1 |

### 2.3 Frontend UI

| #   | Screen    | Wireframe | DD Reference     |
| --- | --------- | --------- | ---------------- |
| 1   | LoginForm | WF-001    | 08-ui-spec, §2.1 |

## 3. Implementation Phases

### Phase 1: Foundation (Est. X days)

- [ ] Project setup
- [ ] Database schema
      ...

## 4. Coverage Verification

> Đảm bảo mọi item trong DD đều có trong plan

| DD Section       | Items      | Covered in Plan | Status  |
| ---------------- | ---------- | --------------- | ------- |
| 05-module-design | 15 modules | 15              | ✅ 100% |
| 07-api-design    | 45 APIs    | 45              | ✅ 100% |
```

### 3.4 Verification Checklist

- [ ] Mỗi module trong DD có trong plan
- [ ] Mỗi API endpoint có task
- [ ] Mỗi database table có task
- [ ] Mỗi UI screen có task
- [ ] **Mỗi Batch job có task**
- [ ] **Security requirements có task**
- [ ] **Error handling requirements có task**
- [ ] **TẤT CẢ BD Reference items đã được đọc từ BD**
- [ ] Không có feature nào bị bỏ sót

### 3.5 BD Reference Items Handling

> ⚠️ **QUAN TRỌNG:** Items có BD Reference trong DD Coverage Matrix VẪN CẦN ĐƯỢC IMPLEMENT!

**Cách nhận biết BD Reference items:**

```markdown
## Coverage Matrix (trong DD)

| UC ID  | UC Name    | DD Section | BD Reference | Notes       |
| ------ | ---------- | ---------- | ------------ | ----------- |
| UC-001 | Login      | §5.2       | -            | Chi tiết DD |
| UC-021 | Escalation | §5.9       | BD 03#UC-021 | Xem BD      |
```

**Quy trình xử lý:**

1. Tìm tất cả entries có "BD Reference" không rỗng
2. Mở BD section được tham chiếu
3. Extract: Sequence diagram, Pseudocode, Business rules
4. Tạo task với cả DD Reference và BD Reference

**Template cho BD Reference task:**

```markdown
### Task: Implement UC-XXX

- **DD Reference:** 05-component-design.md#5.9 (coverage table only)
- **BD Reference:** BD 03-functional-design.md#UC-XXX (full details)
- **Source for Implementation:** BD
- **Requirements:**
  - (Extract từ BD section)
```

---

## 4. Phase 2: Chia thành Modules

### 4.1 Nguyên tắc chia module

- **Cohesion:** Tasks trong cùng module nên liên quan chặt chẽ
- **Independence:** Module có thể implement độc lập (sau khi dependencies hoàn thành)
- **Testability:** Module có thể test riêng

### 4.2 Cấu trúc thư mục

```
{working_directory}/TaskList/
├── Implementation_Plan.md
├── CHECKLIST.md
├── Master_Plan.md
│
├── Module_01_Foundation/
│   ├── _module_overview.md
│   ├── test_cases.md
│   └── tasks/
│       ├── Task_001_Project_Init.md
│       └── ...
│
├── Module_02_UserManagement/
│   ├── _module_overview.md
│   ├── test_cases.md
│   └── tasks/
│       └── ...
│
└── Module_99_Integration/
    ├── _module_overview.md
    ├── integration_test_cases.md
    └── tasks/
        └── ...
```

### 4.3 Template: \_module_overview.md

```markdown
# Module: {Tên Module}

## Thông tin

| Thuộc tính       | Giá trị             |
| ---------------- | ------------------- |
| Module ID        | MOD-{XX}            |
| Priority         | High / Medium / Low |
| Dependencies     | MOD-{YY}, MOD-{ZZ}  |
| Estimated Effort | X man-days          |
| DD Reference     | {link}              |

## Scope

### Bao gồm

- {Feature 1}
- {Feature 2}

### Không bao gồm

- {Feature excluded}

## Components

| #   | Component      | Type       | DD Section | Status |
| --- | -------------- | ---------- | ---------- | ------ |
| 1   | UserEntity     | Model      | §6.2.1     | ⬜     |
| 2   | UserRepository | Repository | §5.3.1     | ⬜     |
| 3   | UserService    | Service    | §5.3.2     | ⬜     |
| 4   | UserController | API        | §7.2       | ⬜     |
| 5   | UserForm       | UI         | §8.3       | ⬜     |

## Dependencies

- Cần: MOD-01 (Foundation) hoàn thành trước
- Được cần bởi: MOD-05 (Order Management)
```

---

## 5. Phase 3: TDD Approach

### 5.1 Nguyên tắc TDD

> **Test First:** Tạo test cases TRƯỚC khi tạo implementation tasks

1. Đọc requirements từ DD
2. Viết test cases (descriptions, expected outputs)
3. Tạo tasks với acceptance criteria = test cases
4. Implement để pass tests

### 5.2 Template: test_cases.md

```markdown
# Test Cases - Module {Tên}

## 1. Unit Tests

### 1.1 Entity Tests

| ID     | Description               | Setup | Input               | Expected        | Priority |
| ------ | ------------------------- | ----- | ------------------- | --------------- | -------- |
| UT-001 | Create user valid         | -     | {email, pass, name} | User object     | High     |
| UT-002 | Create user invalid email | -     | {bad email}         | ValidationError | High     |

### 1.2 Service Tests

| ID     | Description        | Mock | Input            | Expected       |
| ------ | ------------------ | ---- | ---------------- | -------------- |
| UT-010 | Register new user  | Repo | {user data}      | Success + ID   |
| UT-011 | Register duplicate | Repo | {existing email} | DuplicateError |

### 1.3 Repository Tests

| ID     | Description | Input       | Expected          |
| ------ | ----------- | ----------- | ----------------- |
| UT-020 | Save user   | User entity | Persisted with ID |

## 2. API Tests

| ID     | Method | Endpoint       | Request Body | Expected Status | Expected Body |
| ------ | ------ | -------------- | ------------ | --------------- | ------------- |
| AT-001 | POST   | /api/users     | {valid user} | 201             | {user + id}   |
| AT-002 | POST   | /api/users     | {invalid}    | 400             | {errors}      |
| AT-003 | GET    | /api/users/1   | -            | 200             | {user}        |
| AT-004 | GET    | /api/users/999 | -            | 404             | {error}       |

## 3. UI Tests

| ID     | Screen | Action         | Expected Result       |
| ------ | ------ | -------------- | --------------------- |
| UI-001 | Login  | Submit valid   | Redirect to dashboard |
| UI-002 | Login  | Submit invalid | Show error            |

## 4. Coverage Summary

| Category   | Count | Coverage Target    |
| ---------- | ----- | ------------------ |
| Unit Tests | 20    | 80%+ code coverage |
| API Tests  | 15    | 100% endpoints     |
| UI Tests   | 10    | 100% user flows    |
```

### 5.3 Task với Test-Based Acceptance Criteria

```markdown
## Acceptance Criteria

> ⚠️ Criteria dựa trên test cases từ test_cases.md

- [ ] ✅ Pass UT-001: Create user with valid data
- [ ] ✅ Pass UT-002: Reject invalid email
- [ ] ✅ Pass UT-003: Password hashing works
- [ ] ✅ Pass AT-001: POST /api/users returns 201
- [ ] 📊 Code coverage >= 80%
- [ ] 📝 All tests documented
```

---

## 6. Phase 4: CHECKLIST.md Tracking

### 6.1 Mục đích

- Track tiến độ real-time
- Biết session trước làm đến đâu
- Identify bottlenecks
- Track test coverage

### 6.2 Template: CHECKLIST.md

```markdown
# Implementation Checklist

> **Hướng dẫn:**
>
> - AI đọc file này TRƯỚC khi bắt đầu làm việc
> - Update sau MỖI task hoàn thành
> - [x] Done, [ ] Not started, [~] In progress

## Progress Summary

| Module     | Total Tasks | Done  | In Progress | Coverage |
| ---------- | ----------- | ----- | ----------- | -------- |
| Foundation | 5           | 5     | 0           | 100% ✅  |
| User Mgmt  | 10          | 3     | 1           | 30%      |
| Order      | 8           | 0     | 0           | 0%       |
| **TOTAL**  | **23**      | **8** | **1**       | **35%**  |

Last Updated: YYYY-MM-DD HH:MM

---

## Module 1: Foundation ✅

- [x] 1.1 Project initialization
- [x] 1.2 Database setup
- [x] 1.3 Core configurations
- [x] 1.4 Base classes/utilities
- [x] 1.5 Unit test setup

## Module 2: User Management (IN PROGRESS)

- [x] 2.1 User Entity
  - [x] Entity class
  - [x] Migrations
  - [x] Unit tests (5/5 pass)
- [x] 2.2 User Repository
  - [x] Interface
  - [x] Implementation
  - [x] Unit tests (3/3 pass)
- [~] 2.3 User Service ← CURRENT
  - [x] createUser()
  - [ ] getUser()
  - [ ] updateUser()
  - [ ] deleteUser()
  - [ ] Unit tests (2/6 pass)
- [ ] 2.4 User Controller/API
- [ ] 2.5 User UI Components
- [ ] 2.6 API Integration

## Module 99: Integration

- [ ] 99.1 Integration tests
- [ ] 99.2 E2E tests
- [ ] 99.3 Final verification

---

## Test Coverage

| Module     | Unit | API | UI  | Overall |
| ---------- | ---- | --- | --- | ------- |
| Foundation | 95%  | -   | -   | 95%     |
| User Mgmt  | 60%  | 0%  | 0%  | 20%     |

---

## Session Log

| Date       | Duration | Tasks Completed    | Next         |
| ---------- | -------- | ------------------ | ------------ |
| 2024-01-15 | 2h       | 1.1, 1.2, 1.3      | 1.4          |
| 2024-01-16 | 3h       | 1.4, 1.5, 2.1, 2.2 | 2.3          |
| 2024-01-17 | 1h       | 2.3 (partial)      | Continue 2.3 |
```

### 6.3 Quy tắc Update

1. **Sau mỗi task:** Mark [x] và update summary table
2. **Khi bắt đầu task:** Mark [~] để biết in progress
3. **Cuối session:** Log session với tasks completed
4. **Track failures:** Ghi chú nếu test fail

---

## 7. Phase 5: Integration Test

### 7.1 Module Integration (Module_99)

Module cuối cùng, chỉ implement SAU khi tất cả modules khác hoàn thành.

### 7.2 Components

1. **Cross-module integration tests**
   - User + Order interaction
   - Auth + API protection
2. **E2E tests**
   - Complete user journeys
   - Critical paths
3. **Performance tests**
   - Load testing
   - Response time
4. **Security tests**
   - Authentication
   - Authorization
   - Input validation

### 7.3 Final Verification

```markdown
## Final Verification Checklist

### Coverage Check

- [ ] Mỗi module trong DD đã implement
- [ ] Mỗi API đã implement và test
- [ ] Mỗi UI screen đã implement
- [ ] Mỗi business rule đã implement

### Test Results

- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Coverage >= 80%

### Comparison with DD

| DD Section | Expected | Implemented | Match |
| ---------- | -------- | ----------- | ----- |
| Modules    | 15       | 15          | ✅    |
| APIs       | 45       | 45          | ✅    |
| UI Screens | 20       | 20          | ✅    |

### Sign-off

- [ ] All features match DD
- [ ] No missing functionality
- [ ] Ready for deployment
```

---

## 8. Templates - Task Detail

### 8.1 Standard Task Template

````markdown
# Task {ID}: {Tên Task}

## Thông tin

| Thuộc tính       | Giá trị             |
| ---------------- | ------------------- |
| **Task ID**      | TASK-{XXX}          |
| **Module**       | {Tên Module}        |
| **Priority**     | High / Medium / Low |
| **Estimate**     | {X} giờ             |
| **Dependencies** | TASK-{YYY}          |
| **Status**       | ⬜ Not Started      |

## Mô tả

{Mô tả ngắn gọn}

## DD Reference

- **Section:** {link đến section trong DD}
- **API Spec:** {link nếu có}
- **Database:** {link nếu có}

## Acceptance Criteria (từ test_cases.md)

- [ ] Pass UT-XXX: {description}
- [ ] Pass UT-YYY: {description}
- [ ] Pass AT-ZZZ: {description}
- [ ] Code coverage >= 80%

## Implementation Guide

### Step 1: {Name}

```{language}
// Code example
```
````

### Step 2: {Name}

...

## Test Cases (Summary)

| ID     | Type | Description | Status |
| ------ | ---- | ----------- | ------ |
| UT-XXX | Unit | {desc}      | ⬜     |
| AT-YYY | API  | {desc}      | ⬜     |

## Wireframe (cho UI tasks)

- **File:** {path}
- **Screen:** {name}

## Notes

- {Important notes}

```

---

## 9. Quy tắc đặt tên

### Task ID
- Format: `TASK-{XXX}` (3 digits, zero-padded)
- Range by module: 001-099 (Foundation), 100-199 (Module 2), etc.

### File names
- `Task_{XXX}_{Short_Name}.md`
- Underscore thay space
- PascalCase cho tên

### Module folders
- `Module_{XX}_{Name}/`
- Number = execution order
- `Module_99_Integration` luôn cuối

---

## 10. Workflow Execution

### Bước 1: Khởi tạo
```

1. Xác định thư mục làm việc
2. Đọc toàn bộ DD
3. Tạo Implementation_Plan.md
4. Verify coverage 100%

```

### Bước 2: Setup modules
```

1. Chia thành modules
2. Tạo \_module_overview.md cho mỗi module
3. Tạo test_cases.md cho mỗi module

```

### Bước 3: Tạo tasks
```

1. Từ test_cases.md, tạo tasks
2. Mỗi task có acceptance criteria từ tests
3. Link đến DD sections

```

### Bước 4: Generate tracking files
```

1. Tạo CHECKLIST.md từ tất cả tasks
2. Tạo Master_Plan.md tổng hợp

```

### Bước 5: Validation
```

1. Load task-list-review-checklist.md
2. Verify all criteria
3. Fix any gaps

```

---

## 11. Anti-patterns to Avoid

❌ **Không tạo test cases trước** → Thiếu acceptance criteria rõ ràng

❌ **Không update CHECKLIST** → Mất track tiến độ

❌ **Bỏ qua Phase 1 verification** → Có thể bỏ sót features

❌ **Module quá lớn** → Khó manage, tách thành modules nhỏ hơn

❌ **Không reference DD** → Tasks không traceability

❌ **Skip integration tests** → Modules không work together

---

## 12. Success Criteria

✅ Implementation Plan covers 100% của DD

✅ Mỗi module có _module_overview.md và test_cases.md

✅ Mỗi task có acceptance criteria từ test cases

✅ CHECKLIST.md tracks tất cả tasks

✅ Module_99_Integration có đầy đủ integration tests

✅ Final verification matches 100% với DD
```
