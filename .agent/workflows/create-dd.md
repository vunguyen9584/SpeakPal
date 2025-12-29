---
description: Tạo Detailed Design Document (DD) từ SRS và Basic Design đã có
---

# Workflow: Tạo Detailed Design Document

## 📝 Mô tả

Workflow này hướng dẫn tạo Detailed Design Document (DD) từ SRS và Basic Design.
Các hướng dẫn chi tiết được tách vào `.ai-instructions/`.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng: **Folder chứa input và output** (ví dụ: ./docs/TênDựÁn)

---

## ✅ BƯỚC 2: Kiểm tra tham số

1. Xác nhận folder path với người dùng
2. Kiểm tra file tồn tại:
   - `[folder_path]/システム要件定義書/_index.md`
   - `[folder_path]/基本設計書/_index.md`

---

## 🔄 BƯỚC 2.5: Kiểm tra Progress & Resume (BẮT BUỘC)

> 🔴 **QUAN TRỌNG** - Cho phép tiếp tục từ session trước

**📄 Hướng dẫn chi tiết:** `./.ai-instructions/dd-progress-guide.md`

1. Kiểm tra file: `[folder_path]/dd-progress.md`
2. Nếu CHƯA TỒN TẠI → Copy từ template, tạo mới
3. Nếu ĐÃ TỒN TẠI → Đọc progress, hỏi user tiếp tục hay reset
4. **SAU MỖI CHƯƠNG** → Cập nhật progress file

---

## 📖 BƯỚC 3: Load tài liệu

1. Load hướng dẫn: `./.ai-instructions/detailed-design-instructions.md`
2. Load SRS: `[folder_path]/システム要件定義書/_index.md`
3. Load BD: `[folder_path]/基本設計書/_index.md`
4. **🔴 Load content requirements:** `./.ai-instructions/dd-content-requirements.md`

---

## 📋 BƯỚC 3.2: Tham khảo Input Dependencies (BẮT BUỘC)

> 🔴 **QUAN TRỌNG** - Đảm bảo đọc đúng input cho mỗi chương

**📄 Hướng dẫn chi tiết:** `./.ai-instructions/dd-chapter-input-dependencies.md`

**Thứ tự tạo các chương:**

```
Giai đoạn 1: 00-mapping → 01~04 (Foundation)
Giai đoạn 2: 05-module → 06-component (Core Logic)
Giai đoạn 3: 07-db → 08-api → 09-ui (Data & Interfaces)
Giai đoạn 4: 10~13 (Quality) → 14-appendix
```

---

## 📊 BƯỚC 3.5: Tạo BD-to-DD Mapping (BẮT BUỘC)

> 🔴 **QUAN TRỌNG**: File `00-bd-dd-mapping.md` phải được tạo ĐẦU TIÊN với 100% coverage.

1. Trích xuất danh sách tất cả elements từ BD (UC, Screen, Table, API, Batch).
2. Tạo mapping file xác định element đó sẽ được thiết kế chi tiết ở đâu trong DD.
3. Xin xác nhận user trước khi tiếp tục.

---

## 🚀 BƯỚC 4: Tạo Detailed Design Document

Tham khảo `dd-chapter-input-dependencies.md` để biết input cụ thể cho từng chương.
Đảm bảo tuân thủ yêu cầu coverage trong `dd-element-coverage-requirements.md`.

**Cấu trúc 16 files:**
`00` Mapping, `01` Intro, `02` Ref, `03` Overview, `04` Consider, `05` Module, `06` Component, `07` DB, `08` API, `09` UI, `10` Sec, `11` Err, `12` Log, `13` Deploy, `14` Appx, `15` Checklist.

---

## 🗂️ BƯỚC 4.2: Tổ chức file cho thiết kế lớn (BẮT BUỘC)

> 🔴 **QUAN TRỌNG**: Áp dụng cho các chương có nội dung lớn

### 4.2.1. Đối tượng áp dụng

Các chương sau **BẮT BUỘC** sử dụng cấu trúc thư mục con khi nội dung lớn:

| Chương | File Index                 | Thư mục con              | Điều kiện áp dụng                |
| :----- | :------------------------- | :----------------------- | :------------------------------- |
| 05     | `05-module-design.md`      | `05-module-design/`      | > 500 dòng hoặc > 5 modules      |
| 06     | `06-component-design.md`   | `06-component-design/`   | > 500 dòng hoặc > 10 UCs         |
| 07     | `07-database-design.md`    | `07-database-design/`    | > 500 dòng hoặc > 20 tables      |
| 08     | `08-api-design.md`         | `08-api-design/`         | > 500 dòng hoặc > 15 APIs        |
| 09     | `09-ui-specifications.md`  | `09-ui-specifications/`  | > 500 dòng hoặc > 10 screens     |

### 4.2.2. Cấu trúc file Index

File index (ví dụ: `06-component-design.md`) chỉ chứa:

```markdown
# 6. コンポーネント設計

> 📋 このドキュメントはコンポーネント設計の概要と各セクションへのリンクを提供します。

## 目次

| セクション | ファイル | 内容 |
|------------|----------|------|
| 6.1 | [PLM ユースケース詳細](./06-component-design/01-plm-usecase.md) | PLM モジュールのシーケンス図、ロジック |
| 6.2 | [APS ユースケース詳細](./06-component-design/02-aps-usecase.md) | APS モジュールのシーケンス図 |
| ... | ... | ... |

---
_このドキュメントはコンポーネント設計の索引ファイルです。_
_最終更新: YYYY-MM-DD_
```

### 4.2.3. Cấu trúc thư mục con theo chương

**05-module-design/**
```
01-plm-module.md          # PLM module classes, dependencies
02-aps-module.md          # APS module classes
03-common-module.md       # Common/shared modules
04-class-diagrams.md      # All class diagrams
05-package-structure.md   # Package organization
```

**06-component-design/**
```
01-plm-usecase.md         # PLM UC sequences, logic
02-aps-usecase.md         # APS UC sequences
03-batch.md               # Batch processing details
04-processing-summary.md  # UC processing summary
05-validation-rules.md    # All validation rules
06-business-rules.md      # Business rules
07-search-conditions.md   # Search query params
08-sql-queries.md         # Complex SQL queries
09-notification.md        # Notification logic
10-reference-uc.md        # Reference UC list
11-uc-coverage.md         # UC coverage summary
12-batch-coverage.md      # Batch coverage summary
13-bd-reference.md        # BD reference coverage
```

**07-database-design/**
```
01-er-diagram.md          # ER diagrams
02-master-tables.md       # Master table DDLs
03-transaction-tables.md  # Transaction table DDLs
04-history-tables.md      # History/audit tables
05-indexes.md             # Index definitions
06-constraints.md         # FK, Check constraints
07-views.md               # View definitions
08-stored-procedures.md   # Stored procedures (if any)
```

**08-api-design/**
```
01-plm-apis.md            # PLM module APIs (OpenAPI)
02-aps-apis.md            # APS module APIs
03-common-apis.md         # Common/auth APIs
04-batch-apis.md          # Batch trigger APIs
05-integration-apis.md    # External integration APIs
06-error-responses.md     # Common error responses
07-api-versioning.md      # Versioning strategy
```

**09-ui-specifications/**
```
01-plm-screens.md         # PLM screens specs
02-aps-screens.md         # APS screens specs
03-common-screens.md      # Login, dashboard, etc.
04-components.md          # Reusable UI components
05-state-management.md    # State/store design
06-validation-ui.md       # Client-side validation
07-accessibility.md       # A11y requirements
```

### 4.2.4. Quy trình tạo file lớn

```
1. Đánh giá kích thước nội dung dự kiến
2. Nếu vượt ngưỡng → Tạo thư mục con trước
3. Tạo file index với bảng mục lục
4. Tạo từng file con theo thứ tự
5. Cập nhật links trong file index
6. Verify tất cả links hoạt động
```

### 4.2.5. Lưu ý quan trọng

- **Links tương đối**: Sử dụng `./XX-folder/YY-file.md` trong file index
- **Numbering**: File con dùng prefix số (01-, 02-...) để giữ thứ tự
- **Coverage tracking**: Các file coverage (11-uc-coverage, 12-batch-coverage) đặt cuối thư mục
- **Cross-reference**: Khi tham chiếu từ file khác, dùng full path từ thư mục DD

---

## 🔴 BƯỚC 4.5: Content Requirements Check (BẮT BUỘC - MỚI)

> ⚠️ **SAU KHI TẠO MỖI FILE** - Kiểm tra nội dung bắt buộc

**📄 Tham khảo:** `./.ai-instructions/dd-content-requirements.md`

### 4.5.1. Quy trình kiểm tra

Sau khi tạo mỗi file DD, thực hiện ngay:

1. Mở file `dd-content-requirements.md`
2. Tìm section tương ứng với file vừa tạo
3. Kiểm tra từng mục:
   - **CRITICAL (🔴)**: PHẢI có, không có → DỪNG và bổ sung ngay
   - **REQUIRED (🟠)**: PHẢI có, không có → Ghi warning, tiếp tục

### 4.5.2. Bảng kiểm tra nhanh theo file

| File                   | CRITICAL Check                                          | REQUIRED Check                            | Cấu trúc thư mục con |
| :--------------------- | :------------------------------------------------------ | :---------------------------------------- | :------------------- |
| 00-bd-dd-mapping       | Coverage tables cho UC, Screen, Table, API, Batch       | Links hoạt động, summary stats            | ❌ Không             |
| 01-introduction        | (none)                                                  | Doc info, revision, approvers, scope      | ❌ Không             |
| 02-references          | (none)                                                  | External/Internal refs, terminology       | ❌ Không             |
| **03-system-overview** | **Doc info, Architecture diagram, Tech stack**          | **Actor mapping, Permissions, Decisions** | ❌ Không             |
| 04-considerations      | (none)                                                  | NFRs, assumptions, constraints            | ❌ Không             |
| 05-module-design       | Class diagrams, Package structure                       | Class descriptions, method signatures     | ✅ Có thể            |
| 06-component-design    | Sequence diagrams, Pseudocode                           | Transaction boundaries, error handling    | ✅ Có thể            |
| 07-database-design     | DDL cho TẤT CẢ tables, PKs, FKs                         | Data types, indexes, ER diagram           | ✅ Có thể            |
| 08-api-design          | OpenAPI specs cho TẤT CẢ APIs, Request/Response schemas | Status codes, validation, auth            | ✅ Có thể            |
| 09-ui-specifications   | (none)                                                  | States, interactions, validation          | ✅ Có thể            |
| 10-security-design     | (none)                                                  | Auth impl, RBAC, encryption               | ❌ Không             |
| 11-error-handling      | (none)                                                  | Error codes, messages, exception classes  | ❌ Không             |
| 12-logging-monitoring  | (none)                                                  | Log levels, format, masking               | ❌ Không             |
| 13-deployment-design   | (none)                                                  | Env config, env vars, deployment diagram  | ❌ Không             |
| 14-appendices          | (none)                                                  | (optional - warnings only)                | ❌ Không             |
| 15-checklist-results   | (none)                                                  | Completion status, issues, coverage stats | ❌ Không             |

> 📁 **Lưu ý**: Các file có "✅ Có thể" ở cột cuối cần kiểm tra BƯỚC 4.2 để quyết định có tách thư mục con không.

### 4.5.3. Xử lý khi thiếu nội dung

```
IF thiếu CRITICAL:
    → DỪNG ngay
    → Bổ sung nội dung thiếu
    → Kiểm tra lại
    → Chỉ tiếp tục khi đủ CRITICAL

IF thiếu REQUIRED:
    → Ghi log vào 15-checklist-results.md
    → Cảnh báo user
    → Có thể tiếp tục nhưng PHẢI bổ sung sau

IF thiếu RECOMMENDED:
    → Ghi chú nhưng không bắt buộc
```

---

## 🔄 BƯỚC 5: Validation Script

// turbo

```bash
node .ai-scripts/validate-dd-coverage.js [folder_path]
```

Xử lý kết quả (0: Pass, 1: Fail, 2: Error). Chỉ tiếp tục nếu Pass hoặc user chấp nhận rủi ro.

---

## ✅ BƯỚC 6: Kiểm tra Checklist

**📄 Checklist tổng hợp:** `./.ai-instructions/dd-checklist-summary.md`
**📄 Checklist chi tiết:** `./.ai-instructions/detailed-design-checklist.md`
**📄 Content Requirements:** `./.ai-instructions/dd-content-requirements.md`

Kiểm tra từng mục và lưu kết quả vào `[DD_folder]/15-checklist-results.md`.

---

## 📊 BƯỚC 7: Final Content Verification (BẮT BUỘC - MỚI)

> 🔴 **TRƯỚC KHI HOÀN THÀNH** - Kiểm tra lần cuối toàn bộ DD

### 7.1. Full Content Check

Sử dụng bảng tổng kết từ `dd-content-requirements.md`:

| Tiêu chí       | Target    | Kết quả | Status |
| :------------- | :-------- | :------ | :----- |
| CRITICAL items | 17/17     | ?/?     | ✅/❌  |
| REQUIRED items | ≥70% (53) | ?/76    | ✅/❌  |
| Total files    | 16 files  | ?/16    | ✅/❌  |

### 7.2. Đánh giá tổng thể

```
PASS        = CRITICAL 17/17 + REQUIRED ≥70%
COND. PASS  = CRITICAL 17/17 + REQUIRED 50-69% (cần bổ sung)
FAIL        = CRITICAL < 17 hoặc REQUIRED < 50%
```

### 7.3. Cập nhật Progress

- Cập nhật `dd-progress.md` → Status = ✅ Completed hoặc ⚠️ Incomplete
- Ghi rõ CRITICAL/REQUIRED còn thiếu (nếu có)

---

## 📊 BƯỚC 8: Tổng kết

### 8.1 Thông báo kết quả

- Danh sách files đã tạo (16 files)
- **Content Requirements Status**: PASS/CONDITIONAL PASS/FAIL
- Kết quả checklist
- Link đến `dd-progress.md`

### 8.2 Nếu FAIL hoặc CONDITIONAL PASS

- Liệt kê các CRITICAL/REQUIRED còn thiếu
- Đề xuất action items để bổ sung
- Hỏi user có muốn bổ sung ngay không

---

## 📚 Tài liệu tham khảo

| File                                  | Nội dung                        |
| :------------------------------------ | :------------------------------ |
| `detailed-design-instructions.md`     | Hướng dẫn chính                 |
| `dd-progress-template.md`             | Template progress               |
| `dd-progress-guide.md`                | Hướng dẫn resume                |
| `dd-chapter-input-dependencies.md`    | Input deps cho từng chương      |
| `dd-checklist-summary.md`             | Checklist tổng hợp              |
| `dd-element-coverage-requirements.md` | Yêu cầu coverage                |
| `detailed-design-checklist.md`        | Checklist chi tiết              |
| **`dd-content-requirements.md`**      | **Nội dung bắt buộc từng file** |

> Tất cả file đều nằm trong `.ai-instructions/`

---

## 💡 Lưu ý quan trọng

1. **Đầu vào bắt buộc**: Cần cả SRS và Basic Design
2. **00-Mapping**: File quan trọng nhất, dùng để trace coverage
3. **Content Requirements**: 🔴 CRITICAL không được thiếu, check sau mỗi file
4. **Implemetability**: DD phải đủ chi tiết để code
5. **Validation Rules**: Phải map rõ ràng từ Screen → API → DB
6. **Progress Tracking**: LUÔN cập nhật `dd-progress.md` sau mỗi chương
7. **FAIL nếu thiếu CRITICAL**: Không được bỏ qua các nội dung CRITICAL
8. **Cấu trúc thư mục con**: Áp dụng cho 05, 06, 07, 08, 09 khi nội dung lớn (xem BƯỚC 4.2)

---

## ⚠️ Điều kiện FAIL (Không được bỏ qua)

| Điều kiện                        | Hành động              |
| :------------------------------- | :--------------------- |
| Thiếu bất kỳ CRITICAL item nào   | ❌ FAIL - Bổ sung ngay |
| Thiếu >30% REQUIRED items        | ❌ FAIL - Bổ sung      |
| Coverage mapping < 100%          | ❌ FAIL - Check lại    |
| DDL không đủ cho tất cả tables   | ❌ FAIL - Bổ sung DDL  |
| OpenAPI không đủ cho tất cả APIs | ❌ FAIL - Bổ sung API  |
