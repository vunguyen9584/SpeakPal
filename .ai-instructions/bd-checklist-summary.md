# Checklist tổng hợp cho Basic Design Document

> 📌 File này chứa tóm tắt checklist cho tất cả các chương BD
> Chi tiết mỗi phần được tách vào file checklist riêng

---

## 6.1. Cấu trúc tài liệu

Kiểm tra đủ 11 files:

- [ ] `_index.md`
- [ ] `01-system-overview.md`
- [ ] `02-system-architecture.md`
- [ ] `03-functional-design.md`
- [ ] `04-screen-design.md`
- [ ] `05-data-design.md`
- [ ] `06-api-design.md`
- [ ] `07-batch-design.md`
- [ ] `08-non-functional.md`
- [ ] `09-error-handling.md`
- [ ] `10-appendix.md`

---

## 6.2. Functional Design (03-functional-design.md)

**📄 Checklist chi tiết:** `./.ai-instructions/bd-functional-design-checklist.md`

Tóm tắt các điểm chính:

- [ ] Coverage 100% cho tất cả FR
- [ ] Mỗi UC có sequence diagram
- [ ] UC có form input → có 入力検証 (validation rules)
- [ ] Business Rules đầy đủ từ SRS
- [ ] State Transition có flowchart + matrix
- [ ] Side Actions có section giải thích riêng

---

## 6.3. Screen Design (04-screen-design.md)

> 🔴 **BẮT BUỘC** - Mỗi màn hình trong danh sách PHẢI có đầy đủ chi tiết

**📄 Checklist chi tiết:** `./.ai-instructions/bd-screen-design-checklist.md`

Tóm tắt các điểm chính:

- [ ] Bảng 画面一覧 có cột 関連 UC
- [ ] Số màn hình trong bảng = Số màn hình có chi tiết
- [ ] Mỗi màn hình có: Layout + Item Definition + Event/Action
- [ ] **Tất cả UC đều được map đến ít nhất 1 màn hình hoặc phân loại Background**
- [ ] Background UC (batch, notification) có ghi chú trong bảng
- [ ] Common UI components đầy đủ (colors, fonts, buttons, modals)
- [ ] Error states và validation message design

---

## 6.4. Data Design (05-data-design.md)

> 🔴 **BẮT BUỘC** - Data Design PHẢI cover 100% FRs và có Mapping Table

**📄 Checklist chi tiết:** `./.ai-instructions/bd-data-design-checklist.md`

Tóm tắt các điểm chính:

- [ ] Có ER Diagram
- [ ] Có Table List với Related FR column
- [ ] Mỗi table có: Overview + Column Definitions + Indexes
- [ ] **Với mỗi FR có UI input → có table/column lưu data**
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Tag/Keyword features → junction table
  - [ ] Cost/ROI analysis → dedicated table
  - [ ] Evaluation/Rating → dedicated table
  - [ ] Delegation/Proxy → dedicated table
  - [ ] Settings/Config → settings table
  - [ ] Password Reset → token storage
  - [ ] Audit/History → history tables
- [ ] **FR Mapping Table với Coverage = 100%**
- [ ] Cross-reference với Screen Design (mọi input field có column)

---

## 6.5. API Design (06-api-design.md)

> 🔴 **BẮT BUỘC** - API Design PHẢI cover 100% UCs và có UC Mapping

**📄 Checklist chi tiết:** `./.ai-instructions/bd-api-design-checklist.md`

Tóm tắt các điểm chính:

- [ ] Có Action/Endpoint List phân theo module
- [ ] Có API Details với request/response schemas
- [ ] Có Form Submission Specs với validation rules (nếu có forms)
- [ ] Có Security Design (Auth, Authorization, Input Validation)
- [ ] Có Error Codes với format thống nhất
- [ ] **Có UC ↔ API Traceability Matrix**
- [ ] **Coverage = 100%** cho tất cả non-background UCs
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Workflow/Approval actions (ngoài approve/reject còn gì?)
  - [ ] Bulk operations (bulk update/delete?)
  - [ ] Admin settings/configuration
  - [ ] Audit log/History viewing
  - [ ] Export/Report generation
  - [ ] Search/Autocomplete APIs

---

## 6.6. Batch Design (07-batch-design.md)

> 🔴 **BẮT BUỘC** - Batch Design PHẢI cover tất cả background processing FRs

**📄 Checklist chi tiết:** `./.ai-instructions/bd-batch-design-checklist.md`

Tóm tắt các điểm chính:

- [ ] Có Batch List với ID, tên, schedule, priority
- [ ] Mỗi batch có: 基本情報 + 処理フロー (flowchart) + エラー処理
- [ ] **Có FR Mapping Table với Coverage = 100%** cho background FRs
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Email queue processing → BAT cho FR-035
  - [ ] Reminder notifications → BAT cho FR-036
  - [ ] Auto-escalation → BAT cho FR-019, FR-039
  - [ ] Data cleanup/archive → BAT cho audit logs, notifications
  - [ ] Statistics aggregation → BAT cho FR-027~032
- [ ] Có 排他制御 section (concurrency control)
- [ ] Archive tables có định nghĩa trong Data Design

---

## 6.7. Các file khác

**System Overview (01):**

- [ ] Có mục đích và phạm vi
- [ ] Có danh sách Actors
- [ ] Có Glossary

**Architecture (02):**

- [ ] Có System Context Diagram
- [ ] Có Component Diagram
- [ ] Có Layer Structure
- [ ] Có Deployment Diagram

**Non-functional (08):**

- [ ] Có Performance Design với cột "Thiết kế đáp ứng"
- [ ] Có Security Design
- [ ] Có Availability Design

**Error Handling (09):**

- [ ] Có Error Code System
- [ ] Có Error Code List phân theo module
- [ ] Có Exception handling strategy

**Appendix (10):**

- [ ] Có FR→UC Traceability Matrix
- [ ] Có UC→Screen Traceability Matrix
- [ ] Có Permission Matrix
- [ ] Có Decision Log

---

## 6.8. Cross-Reference Verification (⚠️ QUAN TRỌNG)

> 🔴 Kiểm tra tính nhất quán giữa các chương

| Kiểm tra                      | Status |
| ----------------------------- | ------ |
| FR → UC: Tất cả FR có UC      | [ ]    |
| UC → Screen: UC actions có UI | [ ]    |
| UC → API: UC actions có API   | [ ]    |
| Screen Input → Table column   | [ ]    |
| Screen Action → API endpoint  | [ ]    |
| Background FR → Batch         | [ ]    |
| Batch → Archive/Cache Table   | [ ]    |
| Validation Rule → Error Code  | [ ]    |

---

## 6.9. Lưu kết quả

Lưu checklist vào: `[folder_path]/basic-design-checklist.md`
