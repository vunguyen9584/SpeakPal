# BD Reference Handling Guide

> Hướng dẫn xử lý các items có BD Reference trong Detailed Design

---

## 1. BD Reference là gì?

Trong Detailed Design (DD), một số items không được chi tiết đầy đủ mà chỉ có entry trong coverage table với link tham chiếu về Basic Design (BD).

**Ví dụ trong DD:**

```markdown
## Coverage Matrix

| UC ID  | UC Name    | DD Section | BD Reference | Notes       |
| ------ | ---------- | ---------- | ------------ | ----------- |
| UC-001 | Login      | §5.2       | -            | Chi tiết DD |
| UC-021 | Escalation | §5.9 table | BD 03#UC-021 | Xem BD      |
```

- **UC-001**: Có chi tiết trong DD → Sử dụng DD
- **UC-021**: Chỉ có trong table, BD Reference → **PHẢI đọc BD**

---

## 2. Cách nhận biết BD Reference items

Tìm kiếm trong DD coverage tables/matrices:

1. **Cột "BD Reference"** không rỗng
2. **Notes** có "Xem BD", "参照先 BD", "See BD"
3. **DD Section** trỏ đến coverage table thay vì section chi tiết

---

## 3. Quy trình xử lý BD Reference

### Bước 1: Xác định tất cả BD Reference items

Đọc các coverage tables trong DD:

- 04-module-design.md → Module Reference Matrix
- 05-component-design.md → UC/Batch Coverage Matrix
- 07-api-design.md → API Coverage Matrix
- 08-ui-specifications.md → Screen Coverage Matrix

### Bước 2: Đọc BD sections

Với mỗi BD Reference item:

```
Item: UC-021
BD Reference: BD 03-functional-design.md#UC-021

→ Mở BD 03-functional-design.md
→ Tìm section UC-021
→ Extract:
  - Sequence diagram
  - Pseudocode / Logic
  - Business rules
  - Error handling
```

### Bước 3: Tạo task với dual references

```markdown
### Task: Implement UC-021 (Escalation)

- **DD Reference:** 05-component-design.md#5.9 (coverage table only)
- **BD Reference:** BD 03-functional-design.md#UC-021 (full details)
- **Source for Implementation:** BD
- **Requirements:**
  - [Extract từ BD section]
  - [Logic and flow từ BD]
  - [Error handling từ BD]
```

---

## 4. Component Categories với BD Reference

| Category       | DD Source               | BD Source (khi có ref)  |
| -------------- | ----------------------- | ----------------------- |
| Modules        | 04-module-design.md     | BD 03-functional-design |
| Use Cases      | 05-component-design.md  | BD 03-functional-design |
| Batches        | 05-component-design.md  | BD 07-batch-design      |
| Tables         | 06-database-design.md   | BD 05-data-design       |
| APIs/Actions   | 07-api-design.md        | BD 06-api-design        |
| Screens        | 08-ui-specifications.md | BD 04-screen-design     |
| Security       | 09-security-design.md   | BD 08-non-functional    |
| Error Handling | 10-error-handling.md    | BD 09-error-handling    |

---

## 5. Tracking BD Reference items

Trong `_module_overview.md`:

```markdown
## Components

| #   | Component | Type | DD Section | BD Reference | Status |
| --- | --------- | ---- | ---------- | ------------ | ------ |
| 1   | UC-001    | UC   | §5.2       | -            | ⬜     |
| 2   | UC-021    | UC   | §5.9 table | BD 03#UC-021 | ⬜     |
```

Trong `CHECKLIST.md`:

```markdown
## Module 3: Approval

- [ ] 3.1 UC-008 Approve/Reject
- [ ] 3.2 UC-009 Return for revision
- [ ] 3.3 UC-021 Escalation (BD Ref: BD 03#UC-021) ← Đánh dấu rõ
```

---

## 6. Verification

### Before Implementation

- [ ] Đã xác định TẤT CẢ BD Reference items
- [ ] Đã đọc TẤT CẢ BD sections được tham chiếu
- [ ] Mỗi BD Reference item có task tương ứng

### During Implementation

- [ ] Implement theo BD details (không phải DD summary)
- [ ] Cross-reference cả DD và BD khi coding

### After Implementation

- [ ] Verify code matches BD specifications
- [ ] Update CHECKLIST đánh dấu BD Reference items

---

## 7. Common Mistakes to Avoid

❌ **Bỏ qua BD Reference items** vì nghĩ DD đã đủ
❌ **Chỉ đọc DD coverage table** mà không mở BD
❌ **Implement theo DD summary** thay vì BD details
❌ **Quên track BD Reference items** trong CHECKLIST

✅ **Luôn kiểm tra** cột BD Reference trong coverage tables
✅ **Đọc BD section** khi có BD Reference link
✅ **Tạo task với dual references** (DD + BD)
✅ **Đánh dấu rõ** BD Reference items trong CHECKLIST

---

_Created: 2025-12-21_
_For use with: /make-plan và /implement workflows_
