---
description: Review tài liệu thiết kế cơ bản (Basic Design) sử dụng checklist chuẩn
---

# Workflow: Review Basic Design Document

## 📝 Mô tả

Review tài liệu Basic Design theo checklist chuẩn, đối chiếu với SRS.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng:

```
Để review tài liệu Basic Design, tôi cần:
1. **Folder chứa BD** (ví dụ: ./docs/TênDựÁn)
```

Xác định đường dẫn:

- **BD Review**: `[folder]/基本設計書/`
- **SRS Ref**: `[folder]/システム要件定義書/`
- **Output**: `[folder]/basic-design-review-report.md`

---

## ✅ BƯỚC 2: Kiểm tra file tồn tại

- ❌ **BẮT BUỘC**: Folder BD phải tồn tại
- ⚠️ **TÙY CHỌN**: Folder SRS nếu không có → cảnh báo

---

## 🔄 BƯỚC 3: Chạy Validation Script

// turbo

```bash
node .ai-scripts/validate-bd-coverage.js [folder_path]
```

| Exit Code | Ý nghĩa            | Hành động            |
| --------- | ------------------ | -------------------- |
| 0 (PASS)  | Coverage đạt       | Tiếp tục             |
| 1 (FAIL)  | Coverage không đạt | Hỏi user             |
| 2 (ERROR) | Script lỗi         | Cảnh báo và tiếp tục |

---

## 📖 BƯỚC 4: Load tài liệu tham khảo

Load từ `.ai-instructions/`:

| File                          | Nội dung                       |
| ----------------------------- | ------------------------------ |
| `bd-file-folder-structure.md` | **Cấu trúc File/Folder chuẩn** |
| `bd-checklist-summary.md`     | Checklist tổng hợp             |
| `bd-review-steps-guide.md`    | Hướng dẫn review               |
| `bd-detail-coverage-check.md` | Coverage check                 |

---

## 🏗️ BƯỚC 5: Kiểm tra cấu trúc File/Folder

> 📄 **Chi tiết**: `.ai-instructions/bd-file-folder-structure.md`

### 5.1 Kiểm tra Main + Folder Existence

| #   | Check           | Path                      |
| --- | --------------- | ------------------------- |
| 1   | ☐ Main file     | `03-functional-design.md` |
| 2   | ☐ Detail folder | `03-functional-design/`   |
| 3   | ☐ Main file     | `04-screen-design.md`     |
| 4   | ☐ Detail folder | `04-screen-design/`       |
| 5   | ☐ Main file     | `05-data-design.md`       |
| 6   | ☐ Detail folder | `05-data-design/`         |
| 7   | ☐ Main file     | `06-api-design.md`        |
| 8   | ☐ Detail folder | `06-api-design/`          |
| 9   | ☐ Main file     | `07-batch-design.md`      |
| 10  | ☐ Detail folder | `07-batch-design/`        |

### 5.2 Kiểm tra \_index.md trong mỗi folder

| Folder                | \_index.md | Nội dung mong đợi             |
| --------------------- | ---------- | ----------------------------- |
| 03-functional-design/ | ☐          | UC patterns, common flows     |
| 04-screen-design/     | ☐          | Screen layouts, components    |
| 05-data-design/       | ☐          | ER diagrams, common columns   |
| 06-api-design/        | ☐          | Auth, response format, errors |
| 07-batch-design/      | ☐          | 排他制御, Cron 式             |

### 5.3 Kiểm tra Main File Sections

Mỗi main file phải có:

- ☐ 概要 với statistics
- ☐ ドキュメント構成 với links
- ☐ 一覧 với links đến detail files
- ☐ Coverage Summary = 100%

### 5.4 Kiểm tra DFD (Data Flow Diagram)

**DFD Level 0 & 1 (Bắt buộc trong 02-system-architecture):**

| Check | Nội dung cần có                                    |
| ----- | -------------------------------------------------- |
| ☐     | Section DFD Level 0 (Context Diagram)              |
| ☐     | External Entities đầy đủ (Users, External Systems) |
| ☐     | Data Flow List table (From/To/Content)             |
| ☐     | Section DFD Level 1 (System Overview)              |
| ☐     | Core Processes tương ứng với modules               |
| ☐     | Data Stores tương ứng với 05-data-design           |
| ☐     | Process/Data Store Definitions tables              |

**DFD Level 2 (Trong các `{module}-01.md` của core modules):**

| Check | Tiêu chí Module                                  |
| ----- | ------------------------------------------------ |
| ☐     | Core Business Modules có DFD Level 2             |
| ☐     | Transaction/Financial Modules có DFD Level 2     |
| ☐     | Data Processing Modules có DFD Level 2           |
| ☐     | Security/Compliance Modules có DFD Level 2       |
| ☐     | Mỗi DFD Level 2 có sub-process diagram (Mermaid) |
| ☐     | Mỗi DFD Level 2 có sub-process definition table  |
| ☐     | Mỗi DFD Level 2 có data store detail table       |

---

## 🚨 BƯỚC 6: Detail Coverage Check (CRITICAL)

> 📄 **Chi tiết**: `.ai-instructions/bd-detail-coverage-check.md`

### 6.1 Cách đếm với File/Folder Structure

```
Main file: Đếm items trong danh sách (一覧 section)
Detail files: Đếm sections "## [ID]:" trong các {module}-XX.md
Coverage = Detail sections / List items × 100%
```

### 6.2 Coverage Check Table

| Item   | Main File               | Detail Folder         | In List | Detailed | Coverage | OK? |
| ------ | ----------------------- | --------------------- | ------- | -------- | -------- | --- |
| UC     | 03-functional-design.md | 03-functional-design/ | \_\_\_  | \_\_\_   | \_\_\_%  | ☐   |
| Screen | 04-screen-design.md     | 04-screen-design/     | \_\_\_  | \_\_\_   | \_\_\_%  | ☐   |
| Table  | 05-data-design.md       | 05-data-design/       | \_\_\_  | \_\_\_   | \_\_\_%  | ☐   |
| API    | 06-api-design.md        | 06-api-design/        | \_\_\_  | \_\_\_   | \_\_\_%  | ☐   |
| Batch  | 07-batch-design.md      | 07-batch-design/      | \_\_\_  | \_\_\_   | \_\_\_%  | ☐   |

> ⚠️ **CẢNH BÁO**: Coverage < 100% = **FAIL** dù các tiêu chí khác OK!

---

## 🔍 BƯỚC 7: Review từng section

### 7.1 Review với checklists

| Chương     | Checklist                           |
| ---------- | ----------------------------------- |
| Functional | `bd-functional-design-checklist.md` |
| Screen     | `bd-screen-design-checklist.md`     |
| Data       | `bd-data-design-checklist.md`       |
| API        | `bd-api-design-checklist.md`        |
| Batch      | `bd-batch-design-checklist.md`      |

### 7.2 Cross-Reference Check

| From → To      | Kiểm tra               |
| -------------- | ---------------------- |
| FR → UC        | Tất cả FR có UC        |
| UC → Screen    | Tất cả UC có UI        |
| UC → API       | Tất cả UC có API       |
| Screen → Table | Input fields có column |
| FR → Batch     | Background FR có batch |

### 7.3 Link Integrity Check

| Check | Mô tả                                       |
| ----- | ------------------------------------------- |
| ☐     | Links trong main file trỏ đúng detail files |
| ☐     | Links trong detail files trỏ về main file   |
| ☐     | Links giữa detail files valid               |
| ☐     | Không có broken links                       |

### 7.4 DFD Quality Check

| Check | Mô tả                                           |
| ----- | ----------------------------------------------- |
| ☐     | DFD Level 0 có đủ external entities             |
| ☐     | DFD Level 1 processes khớp với modules          |
| ☐     | DFD Level 1 data stores khớp với 05-data-design |
| ☐     | DFD Level 2 có sub-process definitions          |
| ☐     | DFD Level 2 có data store details               |
| ☐     | Mermaid diagrams render được                    |

---

## 📝 BƯỚC 8: Tạo báo cáo

Tạo file: `[folder]/basic-design-review-report.md`

> **Template**: `.ai-instructions/bd-review-output-template.md`

---

## 📊 BƯỚC 9: Tổng kết

Hiển thị cho user:

```markdown
## BD Review Summary

### Structure Check

- Main Files: X/5 ✅
- Detail Folders: X/5 ✅
- \_index.md files: X/5 ✅

### Coverage

| Item   | List | Detail | Coverage | Status |
| ------ | ---- | ------ | -------- | ------ |
| UC     | X    | X      | 100%     | ✅     |
| Screen | X    | X      | 100%     | ✅     |
| Table  | X    | X      | 100%     | ✅     |
| API    | X    | X      | 100%     | ✅     |
| Batch  | X    | X      | 100%     | ✅     |

### Issues Found

- [List issues if any]

### DFD Check

| Level   | Location               | Content                             | Status |
| ------- | ---------------------- | ----------------------------------- | ------ |
| Level 0 | 02-system-architecture | Context Diagram + External Entities | ✅/❌  |
| Level 1 | 02-system-architecture | System DFD + Process/DataStore Defs | ✅/❌  |
| Level 2 | Core Business Module   | Sub-processes + Data Stores         | ✅/❌  |
| Level 2 | Transaction Module     | Sub-processes + Data Stores         | ✅/❌  |
| Level 2 | Data Processing Module | Sub-processes + Data Stores         | ✅/❌  |
| Level 2 | Security Module        | Sub-processes + Data Stores         | ✅/❌  |

### Verdict: ✅ PASS / ❌ FAIL
```

---

## 📚 Tài liệu tham khảo

Tất cả trong `.ai-instructions/`:

| File                           | Mô tả                    |
| ------------------------------ | ------------------------ |
| `bd-file-folder-structure.md`  | **Cấu trúc File/Folder** |
| `bd-detail-coverage-check.md`  | Kiểm tra coverage        |
| `bd-checklist-summary.md`      | Checklist tổng hợp       |
| `bd-review-steps-guide.md`     | Hướng dẫn review         |
| `bd-review-output-template.md` | Template báo cáo         |
| `bd-*-checklist.md`            | Checklists từng chương   |

---

## 💡 Lưu ý quan trọng

1. **File/Folder Structure First** - Kiểm tra cấu trúc TRƯỚC KHI review nội dung
2. **Main + Folder** - Chương 03-07 PHẢI dùng cấu trúc này
3. **\_index.md Required** - Mỗi detail folder PHẢI có \_index.md
4. **Coverage 100%** - Tất cả items phải có detail tương ứng
5. **Links Valid** - Tất cả links phải trỏ đúng
6. **Naming Convention** - Detail files theo format {module}-XX.md
7. **DFD Required** - PHẢI có DFD Level 0/1 trong Architecture, Level 2 trong core modules

---

## 📊 DFD Review Checklist

### DFD Level 0 & 1 (Bắt buộc - trong 02-system-architecture)

| Check | Nội dung kiểm tra                                  | Required |
| ----- | -------------------------------------------------- | -------- |
| ☐     | Context Diagram (Hệ thống như 1 process duy nhất)  | ✅ Must  |
| ☐     | External Entities đầy đủ (Users, External Systems) | ✅ Must  |
| ☐     | Data Flow List table (From/To/Content)             | ✅ Must  |
| ☐     | System DFD (Core Processes)                        | ✅ Must  |
| ☐     | Data Stores tương ứng với tài liệu Data Design     | ✅ Must  |
| ☐     | Process Definition table                           | ✅ Must  |
| ☐     | Data Store Definition table                        | ✅ Must  |

### DFD Level 2 (Theo loại module - trong 03-functional-design/)

| Tiêu chí Module            | Nội dung kiểm tra                     | Required  |
| -------------------------- | ------------------------------------- | --------- |
| Core Business Module       | Sub-process diagram + definitions     | ✅ Must   |
| Transaction/Financial      | Sub-process diagram + definitions     | ✅ Must   |
| Data Processing Module     | Sub-process diagram + definitions     | ✅ Must   |
| Security/Compliance Module | Sub-process diagram + definitions     | ✅ Must   |
| User Management Module     | Sub-process diagram (nếu đủ phức tạp) | ⚠️ Should |
| Reporting Module           | Sub-process diagram (nếu đủ phức tạp) | ⚠️ Should |
| Các module khác            | Tùy quyết định                        | Optional  |

> **Note**: Xác định module nào thuộc loại nào dựa trên đặc điểm của hệ thống đang review.
