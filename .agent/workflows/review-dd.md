---
description: Review tài liệu thiết kế chi tiết (Detailed Design) sử dụng checklist chuẩn
---

# Workflow: Review Detailed Design Document

## 📝 Mô tả

Workflow này thực hiện review tài liệu Detailed Design (DD) theo checklist chuẩn, đối chiếu với SRS và Basic Design.
**Đánh giá FAIL nếu thiếu nội dung bắt buộc** theo `dd-content-requirements.md`.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng: **Folder chứa input và output** (ví dụ: ./docs/TênDựÁn)
Hoặc nhận trực tiếp path đến file DD cần review.

---

## ✅ BƯỚC 2: Kiểm tra file tồn tại

- ❌ **BẮT BUỘC**: Folder `詳細設計書` phải tồn tại.
- ⚠️ **CẢNH BÁO**: Nếu không tìm thấy SRS hoặc BD, cảnh báo user về giới hạn traceability check.

---

## 🗂️ BƯỚC 2.5: Kiểm tra cấu trúc thư mục con (BẮT BUỘC)

> 🔴 **QUAN TRỌNG**: Xác định cấu trúc file trước khi review

### 2.5.1. Kiểm tra các chương có thư mục con

Các chương sau có thể sử dụng cấu trúc thư mục con:

| Chương | File Index                | Thư mục con             | Kiểm tra                        |
| :----- | :------------------------ | :---------------------- | :------------------------------ |
| 05     | `05-module-design.md`     | `05-module-design/`     | Có thư mục? Có file index?      |
| 06     | `06-component-design.md`  | `06-component-design/`  | Có thư mục? Có file index?      |
| 07     | `07-database-design.md`   | `07-database-design/`   | Có thư mục? Có file index?      |
| 08     | `08-api-design.md`        | `08-api-design/`        | Có thư mục? Có file index?      |
| 09     | `09-ui-specifications.md` | `09-ui-specifications/` | Có thư mục? Có file index?      |

### 2.5.2. Quy trình kiểm tra

```
1. Kiểm tra folder DD có các thư mục con không
2. Nếu CÓ thư mục con:
   - Kiểm tra file index tương ứng tồn tại
   - Kiểm tra tất cả links trong file index hoạt động
   - Ghi nhận danh sách file con cần review
3. Nếu KHÔNG có thư mục con:
   - Review file đơn như bình thường
```

### 2.5.3. Ghi nhận cấu trúc

Tạo bảng ghi nhận cấu trúc thực tế:

| Chương | Cấu trúc         | Số file con | Links OK? |
| :----- | :--------------- | :---------- | :-------- |
| 05     | Single/Folder    | ?           | ✅/❌     |
| 06     | Single/Folder    | ?           | ✅/❌     |
| 07     | Single/Folder    | ?           | ✅/❌     |
| 08     | Single/Folder    | ?           | ✅/❌     |
| 09     | Single/Folder    | ?           | ✅/❌     |

---

## 📖 BƯỚC 3: Load tài liệu tham khảo

Load các hướng dẫn và checklist từ `.ai-instructions/`:

| File                                  | Nội dung                        | Bắt buộc |
| :------------------------------------ | :------------------------------ | :------- |
| **`dd-content-requirements.md`**      | **Nội dung bắt buộc từng file** | 🔴 YES   |
| `dd-checklist-summary.md`             | Checklist tổng hợp              | YES      |
| `dd-review-steps-guide.md`            | Hướng dẫn review từng bước      | YES      |
| `dd-chapter-input-dependencies.md`    | Input deps check                | YES      |
| `detailed-design-checklist.md`        | Checklist chi tiết (Post-gen)   | YES      |
| `dd-element-coverage-requirements.md` | Coverage rules                  | YES      |

---

## 🔴 BƯỚC 4: Content Requirements Check (BẮT BUỘC - ƯU TIÊN CAO NHẤT)

> ⚠️ **QUAN TRỌNG**: Đây là bước kiểm tra chính, quyết định PASS/FAIL

**📄 Tham khảo:** `./.ai-instructions/dd-content-requirements.md`

### 4.1. Kiểm tra CRITICAL Items (Phải đủ 17/17)

Duyệt qua từng file và check các **CRITICAL** items:

| File                | CRITICAL Items                                              | Có? |
| :------------------ | :---------------------------------------------------------- | :-- |
| 00-bd-dd-mapping    | UC/Screen/Table/API/Batch coverage tables (5 items)         | ?   |
| 03-system-overview  | Doc info, Architecture diagram, Tech stack (3 items)        | ?   |
| 05-module-design    | Class diagrams, Package structure (2 items)                 | ?   |
| 06-component-design | Sequence diagrams, Pseudocode (2 items)                     | ?   |
| 07-database-design  | DDL cho TẤT CẢ tables, PKs, FKs (3 items)                   | ?   |
| 08-api-design       | OpenAPI cho TẤT CẢ APIs, Request/Response schemas (2 items) | ?   |

**Đánh giá:**

- ✅ 17/17 CRITICAL → PASS tiêu chí CRITICAL
- ❌ < 17 CRITICAL → **FAIL ngay** (không cần check thêm)

### 4.2. Kiểm tra REQUIRED Items (Phải ≥70%)

Duyệt qua từng file và check các **REQUIRED** items (tổng 76 items):

| File                      | REQUIRED Items | Có? | Thiếu? | Cấu trúc     |
| :------------------------ | :------------- | :-- | :----- | :----------- |
| 00-bd-dd-mapping          | 2              |     |        | Single       |
| 01-introduction           | 5              |     |        | Single       |
| 02-references-terminology | 5              |     |        | Single       |
| 03-system-overview        | 12             |     |        | Single       |
| 04-design-considerations  | 5              |     |        | Single       |
| 05-module-design          | 4              |     |        | Single/Multi |
| 06-component-design       | 4              |     |        | Single/Multi |
| 07-database-design        | 5              |     |        | Single/Multi |
| 08-api-design             | 5              |     |        | Single/Multi |
| 09-ui-specifications      | 5              |     |        | Single/Multi |
| 10-security-design        | 5              |     |        | Single       |
| 11-error-handling         | 5              |     |        | Single       |
| 12-logging-monitoring     | 5              |     |        | Single       |
| 13-deployment-design      | 5              |     |        | Single       |
| 15-checklist-results      | 4              |     |        | Single       |
| **TOTAL**                 | **76**         |     |        |              |

> 📁 **Lưu ý**: Các file có "Single/Multi" cần kiểm tra BƯỚC 2.5 để xác định cấu trúc thực tế.

**Đánh giá:**

- ✅ ≥53/76 (≥70%) → PASS tiêu chí REQUIRED
- ⚠️ 38-52/76 (50-69%) → WARNING, cần bổ sung
- ❌ < 38/76 (< 50%) → **FAIL**

### 4.3. Bảng chi tiết kiểm tra 03-system-overview (Ví dụ)

> Vì đây là file vừa được review, dùng làm template cho các file khác

| ID     | Nội dung yêu cầu               | Có? | Mô tả nếu thiếu             |
| :----- | :----------------------------- | :-- | :-------------------------- |
| 03-C01 | Document Information Section   |     | Cần section 3.0 với version |
| 03-C02 | Architecture Diagram           |     | Cần Mermaid/C4 diagram      |
| 03-C03 | Technology Stack Tables        |     | Cần bảng đủ categories      |
| 03-R01 | Phase Scope với số liệu        |     |                             |
| 03-R02 | Milestones Table               |     |                             |
| 03-R03 | Actor Definition Table         |     |                             |
| 03-R04 | Actor → Service Mapping        |     |                             |
| 03-R05 | Role → Permission Matrix       |     |                             |
| 03-R06 | Technology Selection Rationale |     |                             |
| 03-R07 | Design Decisions Section       |     |                             |
| 03-R08 | External Integration Table     |     |                             |
| 03-R09 | Design Patterns Table          |     |                             |
| 03-R10 | Cross-Reference Links          |     |                             |
| 03-R11 | Assumptions & Constraints      |     |                             |
| 03-R12 | Terminology Quick Reference    |     |                             |

---

## 🔍 BƯỚC 5: Traditional Review (Bổ sung)

> Thực hiện SAU KHI đã pass Content Requirements Check

**📄 Hướng dẫn chi tiết:** `./.ai-instructions/dd-review-steps-guide.md`

### 5.1. Review Foundation (00-04)

- Link Mapping 00 có hoạt động? Coverage 00 có 100% không?
- Intro và Overview có khớp SRS/BD không?

### 5.2. Review Core Logic (05-06)

- Module Design: Class diagrams, Dependencies.
- Component Design: Pseudocode cho complex Logic.
- **Nếu có thư mục con**: Review từng file con, kiểm tra links trong index.

### 5.3. Review Data & Interfaces (07-08)

- DB: DDL, Indexes, Constraints.
- API: OpenAPI specs, Validation rules.
- **Nếu có thư mục con**: Đảm bảo tất cả tables/APIs được cover trong các file con.

### 5.4. Review UI & Others (09-14)

- UI: State, Interactions.
- Quality: Security, Error, Log, Deploy.
- **Nếu có thư mục con (09)**: Kiểm tra tất cả screens được cover.

### 5.5. Review cấu trúc thư mục con (BẮT BUỘC nếu có)

> 🔴 Kiểm tra khi chương sử dụng cấu trúc thư mục con

| Tiêu chí                        | Kiểm tra                                           |
| :------------------------------ | :------------------------------------------------- |
| File index tồn tại              | `XX-chapter.md` có bảng mục lục không?             |
| Links hoạt động                 | Tất cả links trong index trỏ đúng file?            |
| Numbering nhất quán             | File con có prefix số (01-, 02-...)?               |
| Coverage đầy đủ                 | Tất cả elements từ BD được cover trong file con?   |
| Cross-reference đúng            | Links từ file khác trỏ đúng đến file con?          |

### 5.6. Cross-Reference Verification (BẮT BUỘC)

> 🔴 Kiểm tra tính nhất quán Top-Down theo `dd-review-steps-guide.md`

| Flow          | Kiểm tra                                                    |
| :------------ | :---------------------------------------------------------- |
| **Logic**     | BD UC → DD Comp Pseudocode (có thể trong file con)          |
| **Data**      | BD Table → DD DDL (có thể trong file con)                   |
| **Interface** | BD API → DD OpenAPI (có thể trong file con)                 |
| **UI**        | BD Screen → DD UI Validation (có thể trong file con)        |
| **E2E**       | UI → API → DB consistency (cross-check giữa các file con)   |

---

## 📝 BƯỚC 6: Tạo file kết quả

Tạo file: `[folder_path]/詳細設計書/dd-review-report.md`

**📄 Template:** `./.ai-instructions/dd-review-output-template.md`

### 6.1. Nội dung bắt buộc trong report

```markdown
# DD Review Report

## 1. Content Requirements Check

### 1.1. CRITICAL Items (17 items)

- Total: ?/17
- Status: ✅ PASS / ❌ FAIL
- Missing items: [list if any]

### 1.2. REQUIRED Items (76 items)

- Total: ?/76
- Percentage: ?%
- Status: ✅ PASS / ⚠️ WARNING / ❌ FAIL
- Missing items by file: [table]

## 2. File Structure Check

### 2.1. Thư mục con

| Chương | Cấu trúc | Số file con | Links OK? | Issues |
|--------|----------|-------------|-----------|--------|
| 05     | ?        | ?           | ?         | ?      |
| 06     | ?        | ?           | ?         | ?      |
| 07     | ?        | ?           | ?         | ?      |
| 08     | ?        | ?           | ?         | ?      |
| 09     | ?        | ?           | ?         | ?      |

## 3. Per-File Review

### 3.1. 00-bd-dd-mapping.md

- Content Requirements: PASS/FAIL
- Coverage: 100% / < 100%
- Issues: [list]

### 3.2. 03-system-overview.md

- Content Requirements: PASS/FAIL
- CRITICAL: ?/3
- REQUIRED: ?/12
- Issues: [list]

### 3.3. 06-component-design (Folder Structure)

- Index file: ✅/❌
- Total sub-files: ?
- Links working: ?/?
- Content Requirements: PASS/FAIL
- Issues: [list]

... (repeat for all 16 chapters)

## 4. Cross-Reference Check

- Logic Flow: PASS/FAIL
- Data Flow: PASS/FAIL
- Interface Flow: PASS/FAIL
- UI Flow: PASS/FAIL
- E2E Consistency: PASS/FAIL

## 5. Overall Assessment

| Criteria          | Result    | Status        |
| :---------------- | :-------- | :------------ |
| CRITICAL (17)     | ?/17      | ✅/❌         |
| REQUIRED (≥70%)   | ?/76 (?%) | ✅/⚠️/❌      |
| Coverage 100%     | Yes/No    | ✅/❌         |
| Cross-Reference   | PASS/FAIL | ✅/❌         |
| Folder Structure  | PASS/FAIL | ✅/❌         |
| **FINAL VERDICT** |           | **PASS/FAIL** |

## 6. Action Items (if FAIL)

1. [item 1]
2. [item 2]
   ...
```

---

## 📊 BƯỚC 7: Tổng kết & Đánh giá cuối cùng

### 7.1. Tiêu chí đánh giá

| Verdict           | Điều kiện                                              |
| :---------------- | :----------------------------------------------------- |
| ✅ **PASS**       | CRITICAL 17/17 + REQUIRED ≥70% + Coverage 100%         |
| ⚠️ **COND. PASS** | CRITICAL 17/17 + REQUIRED 50-69% (cần bổ sung)         |
| ❌ **FAIL**       | CRITICAL < 17 HOẶC REQUIRED < 50% HOẶC Coverage < 100% |

### 7.2. Hiển thị kết quả cho user

```
📊 DD REVIEW RESULT
═══════════════════════════════════════════════════
Status: [✅ PASS / ⚠️ CONDITIONAL PASS / ❌ FAIL]

📋 Content Requirements:
  - CRITICAL: [?]/17 [✅/❌]
  - REQUIRED: [?]/76 ([?]%) [✅/⚠️/❌]

📈 Coverage:
  - Mapping Coverage: [100%/?%] [✅/❌]

📁 File Structure:
  - Chapters with subfolders: [05/06/07/08/09]
  - All links working: [✅/❌]

🔗 Cross-Reference:
  - Consistency Check: [PASS/FAIL]

📁 Files Reviewed: 16/16 (+ ? sub-files)

🔴 High Priority Issues: [count]
🟡 Medium Priority Issues: [count]
🟢 Low Priority Issues: [count]

📝 Report saved to: [path]/dd-review-report.md
═══════════════════════════════════════════════════
```

### 7.3. Nếu FAIL

- Liệt kê chi tiết các mục thiếu (CRITICAL trước, REQUIRED sau)
- Nhóm theo file để dễ bổ sung
- Đề xuất priority cho việc fix

---

## 📚 Tài liệu tham khảo

| File                             | Nội dung                        |
| :------------------------------- | :------------------------------ |
| **`dd-content-requirements.md`** | **Nội dung bắt buộc từng file** |
| `dd-review-steps-guide.md`       | Hướng dẫn review                |
| `dd-checklist-summary.md`        | Checklist tổng hợp              |
| `dd-review-output-template.md`   | Template report                 |
| `detailed-design-checklist.md`   | Checklist chi tiết              |

---

## 💡 Lưu ý quan trọng

1. **Content Requirements First**: Luôn check `dd-content-requirements.md` TRƯỚC khi làm traditional review.
2. **FAIL ngay nếu thiếu CRITICAL**: Không cần check thêm nếu CRITICAL < 17.
3. **Lazy loading**: Chỉ load file SRS/BD khi cần verify item cụ thể.
4. **Review đủ 16 chapters**: Không bỏ sót intro, appendix, checklist results.
5. **Pseudocode**: Phải đủ chi tiết để code (if/else, loop, exception).
6. **Validation Rules**: Phải nhất quán từ UI xuống DB.
7. **Cross-Reference**: Là bước quan trọng để tìm lỗi logic.
8. **Cấu trúc thư mục con**: Kiểm tra BƯỚC 2.5 trước khi review các chương 05-09.
9. **Links trong file index**: Phải hoạt động và trỏ đúng file con.

---

## ⚠️ Điều kiện FAIL (BẮT BUỘC đánh giá FAIL)

| Điều kiện                                       | Verdict     |
| :---------------------------------------------- | :---------- |
| Thiếu bất kỳ CRITICAL item nào (< 17/17)        | ❌ **FAIL** |
| Thiếu > 50% REQUIRED items (< 38/76)            | ❌ **FAIL** |
| Coverage mapping < 100%                         | ❌ **FAIL** |
| DDL không đủ cho tất cả tables trong BD         | ❌ **FAIL** |
| OpenAPI specs không đủ cho tất cả APIs trong BD | ❌ **FAIL** |
| 03-system-overview thiếu Actor mapping          | ❌ **FAIL** |
| 03-system-overview thiếu Design Decisions       | ❌ **FAIL** |
| 03-system-overview thiếu Document Information   | ❌ **FAIL** |
| File index thiếu hoặc links không hoạt động     | ❌ **FAIL** |
| Thư mục con thiếu file được tham chiếu          | ❌ **FAIL** |

---

## 📋 Quick Checklist cho 03-system-overview

> Copy-paste để check nhanh file này

```
[ ] 3.0 Document Information (version, date, author)
[ ] 3.0.2 Revision History
[ ] 3.0.3 Approvers Table
[ ] 3.0.4 Reference Documents Links
[ ] 3.1 Phase Scope với số liệu functions
[ ] 3.1.2 Milestones Table
[ ] 3.2 Architecture Diagram (Mermaid/C4)
[ ] 3.2.2 C4 Context Diagram
[ ] 3.2.3 Component Table với DD links
[ ] 3.3 Actor Definition Table
[ ] 3.3.2 Actor → Service Mapping
[ ] 3.3.3 Role → Permission Matrix (CRUD)
[ ] 3.4 Technology Stack với "選定理由" column
[ ] 3.5 Design Decisions với IDs
[ ] 3.6 External Integration Table
[ ] 3.6.2 SAP Integration Sequence Diagram
[ ] 3.7 Design Patterns với implementation guide links
[ ] 3.7.2 Layer Dependency Rules
[ ] 3.8 Assumptions & Constraints
[ ] 3.9 Terminology Quick Reference
[ ] 3.10 Next Chapter Links
```
