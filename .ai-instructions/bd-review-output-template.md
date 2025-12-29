# BD Review Output Template

> Template cho báo cáo review Basic Design Document

---

## 📋 KẾT QUẢ REVIEW TÀI LIỆU BASIC DESIGN

## 📊 Thông tin Review

| Thông tin       | Giá trị                   |
| --------------- | ------------------------- |
| Ngày review     | [YYYY-MM-DD]              |
| Tài liệu BD     | [folder_path]/基本設計書/ |
| Người thực hiện | AI Assistant              |

---

## 📋 CHECKLIST ĐÁNH GIÁ

### 1. Cấu trúc tài liệu

- [ ] Có đủ 11 files theo cấu trúc chuẩn

### 2. Functional Design

- [ ] Coverage 100% cho tất cả FR
- [ ] Mỗi UC có sequence diagram
- [ ] Validation rules đầy đủ
- [ ] Business Rules từ SRS
- [ ] State Transition diagram

### 3. Screen Design

- [ ] Bảng 画面一覧 có cột 関連 UC
- [ ] Số màn hình = Số chi tiết
- [ ] Mỗi màn hình có Layout + Items + Events
- [ ] Tất cả UC được map đến Screen
- [ ] UC actions có UI element tương ứng
- [ ] Background UC có ghi chú
- [ ] Common UI components

### 4. Data Design

- [ ] Có ER Diagram
- [ ] Table List có cột 関連 FR
- [ ] Mỗi table có Overview + Columns + Indexes
- [ ] Common patterns đầy đủ (tags, cost, eval, delegation, settings)
- [ ] **FR→Table Mapping với Coverage = 100%**
- [ ] Cross-reference với Screen inputs

### 5. API Design

- [ ] Có Action List phân theo module
- [ ] Có AJAX API 詳細 với request/response schemas
- [ ] Có Form Submission 仕様 với validation rules
- [ ] Có Error Codes 一覧 với format thống nhất
- [ ] **Có UC ↔ API Traceability Matrix**
- [ ] Common patterns đầy đủ (escalation, cost-analysis, delegation, workflow, audit-log)
- [ ] **Coverage = 100%** cho non-background UCs

### 6. Batch Design

- [ ] Có Batch List với ID, tên, schedule, priority
- [ ] Mỗi batch có: 基本情報 + 処理フロー + エラー処理
- [ ] **FR Mapping Table với Coverage = 100%** cho background FRs
- [ ] Common patterns đầy đủ (email queue, reminder, escalation, cleanup, stats)
- [ ] Có 排他制御 section (concurrency control)

### 7. Đối chiếu danh sách vs chi tiết

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

---

## 📊 TỔNG KẾT

| Đánh giá       | Số lượng |
| -------------- | -------- |
| ✅ Đạt         | [X]      |
| ❌ Không đạt   | [Y]      |
| ⚠️ Cần xem xét | [Z]      |

---

## ⚠️ CÁC VẤN ĐỀ CẦN CẢI THIỆN

### Mức độ CAO (❌)

1. [Mục] - [Vấn đề] - [Đề xuất]

### Mức độ TRUNG BÌNH (⚠️)

1. [Mục] - [Vấn đề] - [Đề xuất]

---

## 📝 KẾT LUẬN

☐ **Đạt** / ☐ **Đạt có điều kiện** / ☐ **Không đạt**

---

## 📋 DANH SÁCH ITEMS CẦN BỔ SUNG

### Use Cases thiếu chi tiết:

- [ ] UC-XXX: [Tên UC] - Cần thêm sequence diagram

### Screens thiếu chi tiết:

- [ ] SCR-XXX: [Tên Screen] - Cần thêm Layout/Items/Events

### UC Actions thiếu UI element:

- [ ] UC-XXX: [Action] - Cần thêm button/element trong SCR-XXX

### Tables thiếu chi tiết:

- [ ] TBL-XXX: [Tên Table] - Cần thêm column definitions

### FR thiếu Table/Column mapping:

- [ ] FR-XXX: [Tên FR] - Cần thêm table hoặc column để lưu data

### Common patterns bị thiếu:

- [ ] [Pattern Type]: Cần thêm table `t_xxx` cho chức năng [Feature]

### Actions/APIs thiếu (UC không có API):

- [ ] UC-XXX: [Tên UC] - Cần thêm Action/API

### Common API patterns bị thiếu:

- [ ] Workflow/Approval actions - Cần thêm API cho [action name]
- [ ] Bulk operations - Cần thêm API cho [operation name]
- [ ] Admin settings - Cần thêm API cho [setting name]
- [ ] Audit/History - Cần thêm API cho [feature name]
- [ ] Export/Report - Cần thêm API cho [report name]
- [ ] Search/Autocomplete - Cần thêm API cho [search name]

### Batches thiếu chi tiết:

- [ ] BAT-XXX: [Tên Batch] - Cần thêm flowchart

### FR thiếu Batch mapping:

- [ ] FR-XXX: [Tên FR] - Cần thêm batch để xử lý background

### Common Batch patterns bị thiếu:

- [ ] Email queue processing - Cần batch cho メール通知
- [ ] Reminder notifications - Cần batch cho リマインダー
- [ ] Auto-escalation - Cần batch cho 自動エスカレーション
- [ ] Data cleanup - Cần batch cho notification/audit cleanup
- [ ] Statistics aggregation - Cần batch cho 統計計算
- [ ] Archive tables - Cần thêm h_xxx_archive trong Data Design
