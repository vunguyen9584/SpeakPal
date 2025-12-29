# Input Dependencies cho các chương Basic Design Document

> 📌 **Mục đích**: Hướng dẫn này chỉ rõ mỗi chương trong tài liệu Basic Design cần những tài liệu đầu vào nào để đảm bảo tính đầy đủ và nhất quán.

---

## 📊 Ma trận Input Dependencies

### Bảng tổng hợp

| Chương BD                 | SRS Required   | BD Internal Dependencies |
| ------------------------- | -------------- | ------------------------ |
| 01-system-overview.md     | SRS 01, 02     | -                        |
| 02-system-architecture.md | SRS 05, 06     | 01                       |
| 03-functional-design.md   | SRS 03         | 01, 02                   |
| 04-screen-design.md       | SRS 03, 04     | 01, 02, 03               |
| 05-data-design.md         | SRS 03         | 03, 04                   |
| 06-api-design.md          | SRS 03, 04, 05 | 03, 04, 05               |
| 07-batch-design.md        | SRS 03, 05     | 03, 05                   |
| 08-non-functional.md      | SRS 05         | 02, 05                   |
| 09-error-handling.md      | SRS 03, 05     | 03, 04, 06               |
| 10-appendix.md            | SRS 03, 04, 05 | 03, 04, 05, 06           |

---

## 📝 Hướng dẫn chi tiết từng chương

### 01-system-overview.md - Tổng quan hệ thống

**📥 Input từ SRS:**

| File SRS                    | Nội dung cần trích xuất                   |
| --------------------------- | ----------------------------------------- |
| `01-introduction.md`        | Mục đích, phạm vi, thuật ngữ, viết tắt    |
| `02-overall-description.md` | Actors, user characteristics, constraints |

**🔗 BD Internal Dependencies:** Không có (chương đầu tiên)

**📋 Output cần tạo:**

- Mục đích và phạm vi hệ thống
- Danh sách Actors với mô tả chi tiết
- Bảng thuật ngữ (business + technical)
- Tiền đề và ràng buộc
- Scope In/Out

---

### 02-system-architecture.md - Kiến trúc hệ thống

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất                          |
| ----------------------------------- | ------------------------------------------------ |
| `05-non-functional-requirements.md` | Performance, security, availability requirements |
| `06-other-requirements.md`          | Technology constraints, deployment env           |

**🔗 BD Internal Dependencies:**

| File BD                 | Nội dung tham chiếu        |
| ----------------------- | -------------------------- |
| `01-system-overview.md` | Scope, actors, constraints |

**📋 Output cần tạo:**

- System Context Diagram
- Component Diagram
- Layer Structure
- Technology Stack (với version)
- Deployment Diagram
- Package/Directory Structure

---

### 03-functional-design.md - Thiết kế chức năng

**📥 Input từ SRS:**

| File SRS                        | Nội dung cần trích xuất                       |
| ------------------------------- | --------------------------------------------- |
| `03-functional-requirements.md` | TẤT CẢ FR (Must/Should/Could), business rules |

**🔗 BD Internal Dependencies:**

| File BD                     | Nội dung tham chiếu |
| --------------------------- | ------------------- |
| `01-system-overview.md`     | Actors, scope       |
| `02-system-architecture.md` | Layers, components  |

**📋 Output cần tạo:**

- FR→UC Mapping với 100% coverage
- Use Case List với Related FR
- Use Case Details (sequence diagrams)
- Business Rules
- State Transition diagrams
- Validation Rules cho mỗi UC có form input

**⚠️ Lưu ý quan trọng:**

- PHẢI đảm bảo 100% FR được map đến UC
- Mỗi UC có form input PHẢI có validation rules

---

### 04-screen-design.md - Thiết kế giao diện

**📥 Input từ SRS:**

| File SRS                        | Nội dung cần trích xuất     |
| ------------------------------- | --------------------------- |
| `03-functional-requirements.md` | FR với UI implications      |
| `04-external-interfaces.md`     | User interface requirements |

**🔗 BD Internal Dependencies:**

| File BD                     | Nội dung tham chiếu                         |
| --------------------------- | ------------------------------------------- |
| `01-system-overview.md`     | Actors (để xác định màn hình cho từng role) |
| `02-system-architecture.md` | Frontend technology (để design phù hợp)     |
| `03-functional-design.md`   | UC list → Screen mapping, validation rules  |

**📋 Output cần tạo:**

- Screen Transition Diagram
- Screen List với Related UC column
- Common UI Components (colors, fonts, buttons, modals)
- Screen Specifications (Layout + Items + Events)
- Responsive breakpoints
- Error states & validation message design

**⚠️ Lưu ý quan trọng:**

- Số màn hình trong bảng = Số màn hình có chi tiết
- TẤT CẢ UC phải được map đến ít nhất 1 màn hình (hoặc Background)
- Mỗi action trong UC phải có button/link tương ứng trên màn hình

---

### 05-data-design.md - Thiết kế dữ liệu

**📥 Input từ SRS:**

| File SRS                        | Nội dung cần trích xuất     |
| ------------------------------- | --------------------------- |
| `03-functional-requirements.md` | Data requirements từ mỗi FR |

**🔗 BD Internal Dependencies:**

| File BD                   | Nội dung tham chiếu           |
| ------------------------- | ----------------------------- |
| `03-functional-design.md` | UC → Data entities needed     |
| `04-screen-design.md`     | Form fields → Columns mapping |

**📋 Output cần tạo:**

- ER Diagram (Mermaid)
- Table List với Related FR column
- Table Definitions (columns, types, constraints)
- Index Design
- FR→Table Mapping với 100% coverage

**⚠️ Lưu ý quan trọng:**

- Với mỗi FR có UI input → PHẢI có table/column lưu data
- Kiểm tra common patterns:
  - Tag/Keyword → junction table
  - Cost/ROI → dedicated table
  - Evaluation/Rating → dedicated table
  - Delegation/Proxy → dedicated table
  - Settings/Config → settings table
  - Password Reset → token storage
  - Audit/History → history tables
  - Archive → archive tables (cho batch cleanup)
  - Cache → cache tables (cho statistics)

---

### 06-api-design.md - Thiết kế API

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất    |
| ----------------------------------- | -------------------------- |
| `03-functional-requirements.md`     | Functional requirements    |
| `04-external-interfaces.md`         | External system interfaces |
| `05-non-functional-requirements.md` | Security requirements      |

**🔗 BD Internal Dependencies:**

| File BD                   | Nội dung tham chiếu                |
| ------------------------- | ---------------------------------- |
| `03-functional-design.md` | UC → API mapping, validation rules |
| `04-screen-design.md`     | Screen events → API calls          |
| `05-data-design.md`       | Tables → API response structure    |

**📋 Output cần tạo:**

- API List phân theo module
- API Details (endpoint, method, request/response schemas)
- Form Submission Specs với validation rules
- Security Design (Auth, Authorization)
- Error Codes với format thống nhất
- UC↔API Traceability Matrix với 100% coverage

**⚠️ Lưu ý quan trọng:**

- Kiểm tra common patterns:
  - Workflow/Approval actions (approve, reject, revision, escalate, cancel)
  - Bulk operations (bulk update, bulk delete)
  - Admin settings/configuration
  - Audit log/History viewing
  - Export/Report generation
  - Search/Autocomplete APIs

---

### 07-batch-design.md - Thiết kế Batch

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất                            |
| ----------------------------------- | -------------------------------------------------- |
| `03-functional-requirements.md`     | Background processing FRs (notification, reminder) |
| `05-non-functional-requirements.md` | Batch performance requirements                     |

**🔗 BD Internal Dependencies:**

| File BD                   | Nội dung tham chiếu                         |
| ------------------------- | ------------------------------------------- |
| `03-functional-design.md` | Background UCs, escalation rules            |
| `05-data-design.md`       | Tables for batch processing, archive tables |

**📋 Output cần tạo:**

- Batch List với ID, name, schedule, priority
- Batch Details (処理フロー flowchart, エラー処理)
- FR Mapping Table với 100% coverage cho background FRs
- 排他制御 section (concurrency control)

**⚠️ Lưu ý quan trọng:**

- Kiểm tra common patterns:
  - Email queue processing → BAT cho notification FR
  - Reminder notifications → BAT cho reminder FR
  - Auto-escalation → BAT cho escalation FR
  - Data cleanup/archive → BAT cho audit logs, notifications
  - Statistics aggregation → BAT cho statistics FRs
  - Session cleanup → BAT cho security

---

### 08-non-functional.md - Thiết kế phi chức năng

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất                           |
| ----------------------------------- | ------------------------------------------------- |
| `05-non-functional-requirements.md` | TẤT CẢ NFRs (performance, security, availability) |

**🔗 BD Internal Dependencies:**

| File BD                     | Nội dung tham chiếu              |
| --------------------------- | -------------------------------- |
| `02-system-architecture.md` | Architecture decisions           |
| `05-data-design.md`         | Index design, query optimization |

**📋 Output cần tạo:**

- Performance Design (response time, throughput, caching)
- Security Design (authentication, authorization, encryption)
- Availability Design (backup, recovery, monitoring)
- Scalability Design (future expansion)

**⚠️ Lưu ý quan trọng:**

- Mỗi NFR PHẢI có cột "Thiết kế đáp ứng"
- Phải có backup strategy và recovery procedures

---

### 09-error-handling.md - Thiết kế xử lý lỗi

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất          |
| ----------------------------------- | -------------------------------- |
| `03-functional-requirements.md`     | Business rules → Error scenarios |
| `05-non-functional-requirements.md` | Logging requirements             |

**🔗 BD Internal Dependencies:**

| File BD                   | Nội dung tham chiếu                  |
| ------------------------- | ------------------------------------ |
| `03-functional-design.md` | Validation rules → Validation errors |
| `04-screen-design.md`     | Form fields → Field-level errors     |
| `06-api-design.md`        | API errors → Error response format   |

**📋 Output cần tạo:**

- Error Code System (format: [SERVICE]-[CATEGORY]-[NUMBER])
- Error Code List phân theo module
- Error Handling Strategy (Exception hierarchy)
- Error Response Format
- Logging Strategy

**⚠️ Lưu ý quan trọng:**

- Cover các category: VAL (validation), BIZ (business), SEC (security), SYS (system), DAT (data)
- Mỗi validation rule trong UC PHẢI có error code tương ứng

---

### 10-appendix.md - Phụ lục

**📥 Input từ SRS:**

| File SRS                            | Nội dung cần trích xuất     |
| ----------------------------------- | --------------------------- |
| `03-functional-requirements.md`     | FR list cho traceability    |
| `04-external-interfaces.md`         | Interface specifications    |
| `05-non-functional-requirements.md` | Decision log justifications |

**🔗 BD Internal Dependencies:**

| File BD                   | Nội dung tham chiếu          |
| ------------------------- | ---------------------------- |
| `03-functional-design.md` | UC list cho traceability     |
| `04-screen-design.md`     | Screen list cho traceability |
| `05-data-design.md`       | Table list cho traceability  |
| `06-api-design.md`        | API list cho traceability    |

**📋 Output cần tạo:**

- FR→UC Traceability Matrix
- UC→Screen Traceability Matrix
- Screen→API→Table Traceability Matrix
- Permission Matrix (Role-based access)
- Extended Glossary
- Decision Log
- Open Issues (với Deadline và Owner)

---

## 🔄 Thứ tự tạo các chương (Recommended)

Để đảm bảo dependencies được đáp ứng đầy đủ, nên tạo các chương theo thứ tự sau:

```
Giai đoạn 1 (Foundation):
├── 01-system-overview.md      ← Đọc SRS 01, 02
├── 02-system-architecture.md  ← Đọc SRS 05, 06 + BD 01

Giai đoạn 2 (Core Design):
├── 03-functional-design.md    ← Đọc SRS 03 + BD 01, 02
├── 04-screen-design.md        ← Đọc SRS 03, 04 + BD 01, 02, 03

Giai đoạn 3 (Technical Design):
├── 05-data-design.md          ← Đọc SRS 03 + BD 03, 04
├── 06-api-design.md           ← Đọc SRS 03, 04, 05 + BD 03, 04, 05
├── 07-batch-design.md         ← Đọc SRS 03, 05 + BD 03, 05

Giai đoạn 4 (Quality & Support):
├── 08-non-functional.md       ← Đọc SRS 05 + BD 02, 05
├── 09-error-handling.md       ← Đọc SRS 03, 05 + BD 03, 04, 06
├── 10-appendix.md             ← Đọc SRS 03, 04, 05 + BD 03, 04, 05, 06
└── _index.md                  ← Tổng hợp từ tất cả các chương
```

---

## ✅ Checklist trước khi tạo mỗi chương

Trước khi bắt đầu tạo một chương BD, hãy kiểm tra:

1. **SRS Inputs đã được đọc:**

   - [ ] Đã load tất cả file SRS cần thiết theo bảng trên
   - [ ] Đã hiểu rõ nội dung và requirements

2. **BD Dependencies đã có sẵn:**

   - [ ] Các chương BD trước đó đã được tạo
   - [ ] Đã cross-reference để đảm bảo consistency

3. **Coverage đảm bảo:**
   - [ ] Tất cả requirements từ SRS đều được address
   - [ ] Mapping tables có coverage 100%
