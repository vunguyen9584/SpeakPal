# DD Chapter Input Dependencies

> 📌 Hướng dẫn này liệt kê các tài liệu input BẮT BUỘC phải đọc trước khi tạo mỗi chương của Detailed Design (DD).

---

## 📊 Summary Matrix

| DD Chapter             | SRS Inputs | BD Inputs | Key Output                  |
| :--------------------- | :--------- | :-------- | :-------------------------- |
| **00-bd-dd-mapping**   | -          | **ALL**   | Mapping table 100% coverage |
| **01-introduction**    | SRS 01     | BD 01     | Mục đích, phạm vi           |
| **02-ref-term**        | SRS Gloss  | BD 01, 10 | Thuật ngữ, tài liệu         |
| **03-system-overview** | -          | BD 01, 02 | Overview, modules           |
| **04-design-con**      | -          | BD 02, 08 | Assumptions, constraints    |
| **05-module-design**   | -          | BD 02, 03 | Class diagrams, methods     |
| **06-comp-design**     | SRS 03     | BD 03, 07 | UC logic, algorithms        |
| **07-db-design**       | SRS 03     | BD 05     | Schema, indexes, DDL        |
| **08-api-design**      | -          | BD 06     | OpenAPI specs               |
| **09-ui-specs**        | SRS 04     | BD 04     | Screen flows, validations   |
| **10-security**        | SRS 05     | BD 08, 09 | Auth, encryption            |
| **11-error-handling**  | -          | BD 09     | Error codes, handling       |
| **12-logging**         | SRS 05     | BD 08     | Log format, metrics         |
| **13-deployment**      | SRS 05     | BD 02     | Configs, CI/CD              |
| **14-appendices**      | -          | BD 10     | Traceability, specs         |

---

## 📖 Chi tiết từng chương

### 1. BD-DD Mapping (00-bd-dd-mapping.md)

- **📥 Input (BD):** Toàn bộ file BD (`03`, `04`, `05`, `06`, `07`).
- **📋 Output:** Bảng mapping giữa BD Element ID (UC-xxx, SCR-xxx) và DD Section.
- **⚠️ Lưu ý:** Đây là file quan trọng nhất, phải tạo đầu tiên. Coverage phải đạt 100%.

### 2. Module Design (05-module-design.md)

- **📥 Input (BD):**
  - `02-system-architecture.md`: Lấy cấu trúc layer, package.
  - `03-functional-design.md`: Lấy danh sách modules và chức năng.
- **📋 Output:** Class diagrams (Mermaid), Method signatures (Input/Output), Dependencies.

### 3. Component Design (06-component-design.md)

- **📥 Input (BD):**
  - `03-functional-design.md`: Use Case flows (Sequence diagrams).
  - `07-batch-design.md`: Batch logic.
- **📋 Output:** Pseudocode, thuật toán chi tiết, Internal logic flows.
- **⚠️ Lưu ý:** Phải cover tất cả Business Rules từ BD.

### 4. Database Design (07-database-design.md)

- **📥 Input (BD):**
  - `05-data-design.md`: ERD, Table list, Column definitions.
- **📋 Output:** Physical Data Model, DDL (Create Table), Indexes, Partitions.

### 5. API Design (08-api-design.md)

- **📥 Input (BD):**
  - `06-api-design.md`: Endpoint list, Request/Response structures.
- **📋 Output:** OpenAPI/Swagger specs chi tiết, Validation rules cụ thể cho từng field.

### 6. UI Specifications (09-ui-specifications.md)

- **📥 Input (BD):**
  - `04-screen-design.md`: Layouts, Item interactions.
- **📋 Output:** Detailed behavior, State management (React/Vue states), Client-side validation.

### 7. Security Design (10-security-design.md)

- **📥 Input (BD):**
  - `08-non-functional.md`: Security requirements.
  - `09-error-handling.md`: Security error codes.
- **📋 Output:** Implementation details cho AuthN/AuthZ, Data Encryption, XSS/CSRF prevention.

---

## ✅ Checklist trước khi bắt đầu mỗi chương

Before creating `DD-XX`:

1. [ ] Đã đọc kỹ BD input tương ứng chưa?
2. [ ] Đã check `00-bd-dd-mapping.md` để biết scope chưa?
3. [ ] Có element nào trong BD bị thiếu detail không? (nếu có phải flag lại)
