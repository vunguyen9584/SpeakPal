# BD Review Steps Guide

> Hướng dẫn chi tiết các bước review từng section của Basic Design

---

## 1. Review Functional Design (03-functional-design.md)

**📄 Sử dụng Checklist:** `bd-functional-design-checklist.md`

Kiểm tra:

- [ ] Coverage 100% cho tất cả FR (Must/Should/Could)
- [ ] Mỗi UC có sequence diagram
- [ ] UC có form input → có 入力検証 (validation rules)
- [ ] Business Rules đầy đủ từ SRS
- [ ] State Transition có flowchart + matrix
- [ ] Side Actions có section giải thích riêng

---

## 2. Review Screen Design (04-screen-design.md)

**📄 Sử dụng Checklist:** `bd-screen-design-checklist.md`

> 🔴 **BẮT BUỘC** - Đây là phần thường bị thiếu sót nhất

Kiểm tra:

- [ ] Bảng 画面一覧 có cột 関連 UC
- [ ] Số màn hình trong bảng = Số màn hình có chi tiết
- [ ] Mỗi màn hình có đủ 3 phần: Layout + Item Definition + Event/Action
- [ ] **Tất cả UC đều được map đến ít nhất 1 màn hình hoặc phân loại Background**
- [ ] **UC actions đều có UI element tương ứng trong màn hình** (quan trọng!)
- [ ] Background UC (batch, notification) có ghi chú trong bảng
- [ ] Common UI components đầy đủ (colors, fonts, buttons, modals)
- [ ] Error states và validation message design

---

## 3. Review Data Design (05-data-design.md)

**📄 Sử dụng Checklist:** `bd-data-design-checklist.md`

> 🔴 **BẮT BUỘC** - Data Design PHẢI cover 100% FRs và có FR Mapping Table

Kiểm tra:

- [ ] Có ER Diagram
- [ ] Có Table List với cột Related FR
- [ ] Mỗi table có đủ: Overview + Column Definitions + Indexes
- [ ] **Với mỗi FR có UI input → có table/column lưu data**
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Tag/Keyword features → junction table
  - [ ] Cost/ROI analysis → dedicated table
  - [ ] Evaluation/Rating → dedicated table
  - [ ] Delegation/Proxy → dedicated table
  - [ ] Settings/Config → settings table
  - [ ] Password Reset → token storage
  - [ ] Audit/History → history tables
  - [ ] Archive (Batch) → h_xxx_archive table
  - [ ] Cache (Batch) → t_statistics_cache
- [ ] **Có FR Mapping Table với Coverage = 100%** cho cả Must/Should/Could
- [ ] Cross-reference với Screen Design (mọi input field có column)

---

## 4. Review API Design (06-api-design.md)

**📄 Sử dụng Checklist:** `bd-api-design-checklist.md`

> 🔴 **BẮT BUỘC** - API Design PHẢI cover 100% UCs và có Traceability Matrix

Kiểm tra:

- [ ] Có Action/Endpoint List phân theo module
- [ ] Có API Details với request/response schemas
- [ ] Có Form Submission Specs với validation rules (nếu có)
- [ ] Có Security Design (Auth, Authorization, Input Validation)
- [ ] Có Error Codes với format thống nhất
- [ ] **Có UC ↔ API Traceability Matrix**
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Workflow/Approval actions (ngoài approve/reject còn gì?)
  - [ ] Bulk operations (bulk update/delete?)
  - [ ] Admin settings/configuration
  - [ ] Audit log/History viewing
  - [ ] Export/Report generation
  - [ ] Search/Autocomplete APIs
- [ ] **Coverage = 100%** cho tất cả non-background UCs
- [ ] Cross-reference với Screen actions (mọi UI action có API)

---

## 5. Review Batch Design (07-batch-design.md)

**📄 Sử dụng Checklist:** `bd-batch-design-checklist.md`

> 🔴 **BẮT BUỘC** - Batch Design PHẢI cover tất cả background processing FRs

Kiểm tra:

- [ ] Có Batch List với ID, tên, schedule, priority
- [ ] Mỗi batch có đủ 3 phần: 基本情報 + 処理フロー (flowchart) + エラー処理
- [ ] **Có FR Mapping Table với Coverage = 100%** cho background FRs
- [ ] Kiểm tra common patterns không bị thiếu:
  - [ ] Email queue processing → batch cho FR-035
  - [ ] Reminder notifications → batch cho FR-036
  - [ ] Auto-escalation → batch cho FR-019, FR-039
  - [ ] Data cleanup/archive → batch cho audit logs, notifications
  - [ ] Statistics aggregation → batch cho FR-027~032
- [ ] Có 排他制御 section (concurrency control)
- [ ] Archive tables được define trong Data Design
- [ ] Cron configuration cho tất cả batches
- [ ] Cross-reference với Data Design (đủ archive tables, cache tables)

---

## 6. Review System Overview (01-system-overview.md)

Kiểm tra:

- [ ] Có mục đích và phạm vi hệ thống
- [ ] Có danh sách Actors với mô tả rõ ràng
- [ ] Có Scope In/Out
- [ ] Có Glossary (Business + Technical terms)
- [ ] Có tiền đề và ràng buộc

---

## 7. Review Architecture (02-system-architecture.md)

Kiểm tra:

- [ ] Có System Context Diagram
- [ ] Có Component Diagram
- [ ] Có Layer Structure
- [ ] Có Technology Stack với version cụ thể
- [ ] Có Deployment Diagram
- [ ] Có Package/Directory Structure

---

## 8. Review Non-functional (08-non-functional.md)

Kiểm tra:

- [ ] Có Performance Design với cột "Thiết kế đáp ứng"
- [ ] Có Security Design (Authentication, Authorization, Encryption)
- [ ] Có Availability Design (Backup, Recovery)
- [ ] Có Monitoring & Alerting
- [ ] Mỗi NFR từ SRS đều có mục "Thiết kế đáp ứng"

---

## 9. Review Error Handling (09-error-handling.md)

Kiểm tra:

- [ ] Có Error Code System (format: [SERVICE]-[CATEGORY]-[NUMBER])
- [ ] Có Error Code List phân theo module
- [ ] Có Exception hierarchy
- [ ] Có Error Response Format
- [ ] Cover các category: VAL, BIZ, SEC, SYS, DAT
- [ ] Mỗi validation rule trong UC có error code tương ứng

---

## 10. Review Appendix (10-appendix.md)

Kiểm tra:

- [ ] Có FR→UC Traceability Matrix
- [ ] Có UC→Screen Traceability Matrix
- [ ] Có Screen→API→Table Traceability Matrix
- [ ] Có Permission Matrix (Role-based access)
- [ ] Có Decision Log
- [ ] Có Open Issues (với Deadline và Owner)

---

## 11. Cross-Reference Verification (⚠️ QUAN TRỌNG)

> 🔴 **BẮT BUỘC**: Kiểm tra tính nhất quán giữa các chương

| From → To             | Kiểm tra                             |
| --------------------- | ------------------------------------ |
| FR → UC               | Tất cả FR đều có UC tương ứng        |
| UC → Screen           | Tất cả UC actions có UI element      |
| UC → API              | Tất cả UC actions có API endpoint    |
| Screen Input → Table  | Mọi input field có column lưu trữ    |
| Screen Action → API   | Mọi button/action có API để xử lý    |
| Background FR → Batch | FR background có batch xử lý         |
| Batch → Table         | Batch có archive/cache table phù hợp |
| Validation → Error    | Mỗi validation rule có error code    |

## 12. Đếm và đối chiếu (⚠️ QUAN TRỌNG)

> 🔴 **BẮT BUỘC**: Phải đếm và so sánh số lượng items

| Loại       | Trong danh sách | Có chi tiết | Thiếu | Đánh giá |
| ---------- | --------------- | ----------- | ----- | -------- |
| Use Cases  | X               | Y           | X-Y   | ✅/❌    |
| Screens    | X               | Y           | X-Y   | ✅/❌    |
| Tables     | X               | Y           | X-Y   | ✅/❌    |
| FR→Table   | X               | Y           | X-Y   | ✅/❌    |
| Actions    | X               | Y           | X-Y   | ✅/❌    |
| UC→API     | X               | Y           | X-Y   | ✅/❌    |
| AJAX APIs  | X               | Y           | X-Y   | ✅/⚠️    |
| Form Specs | X               | Y           | X-Y   | ✅/⚠️    |
| Batches    | X               | Y           | X-Y   | ✅/❌    |
| FR→Batch   | X               | Y           | X-Y   | ✅/❌    |
