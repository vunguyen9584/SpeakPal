---
description: Tạo Task List từ tài liệu thiết kế (Hybrid Approach)
---

# Workflow: Tạo Task List (Hybrid Approach)

## Mô tả

Workflow sử dụng **Hybrid Approach** kết hợp 5 phương pháp:

```
1️⃣ Implementation Plan → 2️⃣ Chia Modules → 3️⃣ TDD → 4️⃣ CHECKLIST → 5️⃣ Integration
```

**Đảm bảo:** ✅ Không bỏ sót feature | ✅ Test coverage đầy đủ | ✅ Tracking rõ ràng

---

## Phase 0: Thu thập thông tin

### Bước 0.1: Hỏi thư mục làm việc

```
Vui lòng cung cấp thư mục làm việc (ví dụ: docs/LexiGo, docs/MindSpark)
```

### Bước 0.2: Tìm tài liệu

| Loại            | Thư mục                            | Bắt buộc |
| --------------- | ---------------------------------- | -------- |
| Detailed Design | `詳細設計書/`, `detailed-design/`  | ✅ Yes   |
| Basic Design    | `基本設計書/`, `basic-design/`     | ✅ Yes   |
| BD-DD Mapping   | `bd-dd-mapping.md`                 | ⬜ No    |
| Wireframe       | `ワイヤーフレーム/`, `wireframes/` | ⬜ No    |

> ⚠️ **QUAN TRỌNG**: Phải có **CẢ BD VÀ DD** vì DD có thể tham chiếu về BD!

---

## Phase 1: Tạo Implementation Plan

// turbo

### Bước 1.1: Load hướng dẫn

Đọc các files:

- `.ai-instructions/task-list-generation-instructions.md`
- `.ai-instructions/bd-reference-handling-guide.md`

### Bước 1.2: Phân tích DD và BD Reference

1. Đọc TOÀN BỘ Detailed Design
2. Extract components theo categories:

| Category       | DD Source               |
| -------------- | ----------------------- |
| Modules        | 04-module-design.md     |
| Use Cases      | 05-component-design.md  |
| Batches        | 05-component-design.md  |
| Tables         | 06-database-design.md   |
| APIs/Actions   | 07-api-design.md        |
| Screens        | 08-ui-specifications.md |
| Security       | 09-security-design.md   |
| Error Handling | 10-error-handling.md    |

3. **Xử lý BD Reference items** (xem guide)
4. Tạo `{working_dir}/TaskList/Implementation_Plan.md`

### Bước 1.3: Tạo Interface Contracts

Tạo `{working_dir}/TaskList/Interface_Contracts.md`:

- Shared Types (từ DD)
- Module Interfaces
- Cross-Module Dependencies

> Template: xem `.ai-instructions/make-plan-templates.md`

---

## Phase 2: Chia thành Modules

### Bước 2.1: Tạo cấu trúc

```
{working_dir}/TaskList/
├── Implementation_Plan.md
├── Interface_Contracts.md
├── CHECKLIST.md
├── Master_Plan.md
├── Module_01_Foundation/
│   ├── _module_overview.md
│   └── test_cases.md
├── Module_XX_xxx/
├── Module_99_Batch/           ← TẤT CẢ batch jobs
└── Module_99_Integration/
```

### Bước 2.2: Tạo module files

Với mỗi module, tạo `_module_overview.md`:

- Module scope và dependencies
- Components list với **DD Reference** và **BD Reference**
- File structure gợi ý

> Template: xem `.ai-instructions/make-plan-templates.md`

### Bước 2.3: Verify modules

```markdown
- [ ] Đếm modules trong DD: \_\_\_\_ modules
- [ ] Đếm folders Module_XX: \_\_\_\_ folders
- [ ] Module_99_Batch/ có TẤT CẢ batch jobs
- [ ] Module cho Security có
- [ ] Module cho Error Handling có
```

---

## Phase 3: TDD Approach

### Bước 3.1: Tạo test_cases.md

Với mỗi module:

1. Đọc requirements từ DD (và BD nếu có BD Reference)
2. Tạo test cases: Unit, API, UI tests
3. Link đến DD/BD sections

### Bước 3.2: Tạo tasks

Mỗi task PHẢI có:

- Acceptance criteria từ test_cases.md
- DD Reference
- **BD Reference** (nếu có)

---

## Phase 4: CHECKLIST Tracking

### Bước 4.1: Tạo CHECKLIST.md

```markdown
# Implementation Checklist

## Progress Summary

| Module | Tasks | Done | BD Ref Items |
| ------ | ----- | ---- | ------------ |
| ...    | ...   | ...  | X/Y          |

## Module 1: xxx

- [ ] 1.1 Task name
- [ ] 1.2 Task name (BD Ref: BD 03#UC-XXX)
```

### Bước 4.2: Tạo Master_Plan.md

> Template: xem `.ai-instructions/make-plan-templates.md`

---

## Phase 5: Integration

### Bước 5.1: Tạo Module_99_Batch

Bao gồm TẤT CẢ batch jobs từ DD/BD.

### Bước 5.2: Tạo Module_99_Integration

- Integration tests
- E2E tests
- Screen-API mapping

> Template: xem `.ai-instructions/make-plan-templates.md#screen-api-mapping`

---

## Final Validation

// turbo

Đọc và verify theo: `.ai-instructions/make-plan-validation-checklist.md`

**Báo cáo cuối:**

```
✅ Modules created: X/X
✅ BD Reference items: X items (all read from BD)
✅ Batch jobs: X jobs included
✅ Screen-API mapping: X screens
✅ Ready for implementation
```

---

## Output Files

| File                            | Mô tả                       | Bắt buộc |
| ------------------------------- | --------------------------- | -------- |
| `Implementation_Plan.md`        | Plan tổng thể + BD coverage | ✅ Yes   |
| `Interface_Contracts.md`        | Interface contracts         | ✅ Yes   |
| `CHECKLIST.md`                  | Tracking tiến độ            | ✅ Yes   |
| `CHECKLIST_Validation.md`       | Verify coverage             | ✅ Yes   |
| `Master_Plan.md`                | Task list tổng quan         | ✅ Yes   |
| `Module_XX/_module_overview.md` | Module scope                | ✅ Yes   |
| `Module_XX/test_cases.md`       | Test cases                  | ✅ Yes   |

---

## Tài liệu tham khảo

| Document                                                | Purpose            |
| ------------------------------------------------------- | ------------------ |
| `.ai-instructions/task-list-generation-instructions.md` | Hướng dẫn chi tiết |
| `.ai-instructions/make-plan-templates.md`               | Templates          |
| `.ai-instructions/make-plan-validation-checklist.md`    | Final validation   |
| `.ai-instructions/bd-reference-handling-guide.md`       | BD Reference guide |
| `.ai-instructions/task-list-review-checklist.md`        | Review checklist   |

---

_Updated: 2025-12-21_
_Version: 2.1 - Refactored to use external instruction files_
