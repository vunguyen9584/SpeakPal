---
description: Tạo Basic Design Document (BD) từ SRS
---

# Workflow: Create Basic Design Document

## 📝 Mô tả

Tạo tài liệu Basic Design (BD) từ System Requirement Specification (SRS).

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng:

```
Để tạo tài liệu Basic Design, tôi cần:
1. **Folder chứa SRS** (ví dụ: ./docs/TênDựÁn)
```

Xác định đường dẫn:

- **SRS Input**: `[folder]/システム要件定義書/`
- **BD Output**: `[folder]/基本設計書/`

---

## ✅ BƯỚC 2: Kiểm tra SRS tồn tại

- ❌ **BẮT BUỘC**: Folder SRS PHẢI tồn tại → nếu không, dừng

---

## 📖 BƯỚC 3: Load tài liệu tham khảo

Load từ `.ai-instructions/`:

| File                                 | Nội dung                       |
| ------------------------------------ | ------------------------------ |
| `basic-design-instructions.md`       | Hướng dẫn chính tạo BD         |
| `bd-file-folder-structure.md`        | **Cấu trúc File/Folder chuẩn** |
| `bd-progress-template.md`            | Template progress tracking     |
| `bd-chapter-input-dependencies.md`   | Dependencies mỗi chương        |
| `bd-requirement-mapping-template.md` | Template FR→UC mapping         |

---

## 📂 BƯỚC 4: Tạo cấu trúc thư mục

> 📄 **Chi tiết**: `.ai-instructions/bd-file-folder-structure.md`

// turbo

```bash
mkdir -p "[folder]/基本設計書"
mkdir -p "[folder]/基本設計書/03-functional-design"
mkdir -p "[folder]/基本設計書/04-screen-design"
mkdir -p "[folder]/基本設計書/05-data-design"
mkdir -p "[folder]/基本設計書/06-api-design"
mkdir -p "[folder]/基本設計書/07-batch-design"
```

Tạo `bd-progress.md` từ template để tracking tiến độ.

---

## 🏗️ BƯỚC 5: Tạo nội dung theo cấu trúc chuẩn

> 📄 **QUAN TRỌNG**: Xem `.ai-instructions/bd-file-folder-structure.md` cho chi tiết đầy đủ

### 5.1 Thứ tự tạo files

| #   | File/Folder                        | Dependencies | Cấu trúc      | DFD Required    |
| --- | ---------------------------------- | ------------ | ------------- | --------------- |
| 1   | `_index.md`                        | -            | Single file   | -               |
| 2   | `01-system-overview.md`            | SRS 01, 02   | Single file   | -               |
| 3   | `02-system-architecture.md`        | SRS 03, NFR  | Single file   | **Level 0 & 1** |
| 4   | `03-functional-design.md` + folder | SRS FR-UC    | Main + Folder | **Level 2**     |
| 5   | `04-screen-design.md` + folder     | 03           | Main + Folder | -               |
| 6   | `05-data-design.md` + folder       | 03, 04       | Main + Folder | -               |
| 7   | `06-api-design.md` + folder        | 03, 04, 05   | Main + Folder | -               |
| 8   | `07-batch-design.md` + folder      | 03, 05, 06   | Main + Folder | -               |
| 9   | `08-non-functional.md`             | SRS NFR      | Single file   | -               |
| 10  | `09-error-handling.md`             | 03, 06       | Single file   | -               |
| 11  | `10-appendix.md`                   | All          | Single file   | -               |

### 5.2 Workflow tạo chương 03-07 (Main + Folder)

```
1. Phân tích SRS → Xác định số lượng items theo module
      │
      ▼
2. Tạo folder: XX-design/
      │
      ▼
3. Tạo _index.md trong folder → Common specs
      │
      ▼
4. Tạo detail files theo module → {module}-01.md, {module}-02.md...
      │
      ▼
5. Tạo main file → Overview, list, links đến detail files
      │
      ▼
6. Cập nhật Coverage Summary → Phải 100%
7. Thêm DFD Level 2 vào các module chính
```

> **Chi tiết format**: Xem `bd-file-folder-structure.md` section 3-5

### 5.3 Yêu cầu DFD (Data Flow Diagram)

**DFD Level 0 & 1** - Trong `02-system-architecture.md`:

```markdown
## 2.10. データフローダイアグラム (DFD)

### 2.10.1. DFD レベル 0 (コンテキスト図)

- Hệ thống như 1 process duy nhất
- Tất cả external entities (Users, External Systems)
- Data flows giữa entities và system

### 2.10.2. コンテキスト図のデータフロー一覧

- Bảng liệt kê data flows với From/To/Content

### 2.10.3. DFD レベル 1 (システム概要)

- Core processes (theo modules)
- Data stores (databases)
- Data flows giữa processes

### 2.10.4-6. Process/Data Store definitions
```

**DFD Level 2** - Trong các `{module}-01.md` (folder 03-functional-design/):

````markdown
## DFD レベル 2: [Module Name]

### データフローダイアグラム

```mermaid
graph TB
    <!-- Sub-processes của module -->
    <!-- Data stores chi tiết -->
    <!-- Data flows nội bộ -->
```
````

### サブプロセス定義

- Bảng định nghĩa sub-processes

### データストア詳細

- Bảng chi tiết data stores

```

**Modules cần có DFD Level 2:**

| Tiêu chí xác định           | Priority | Mô tả                                        |
| --------------------------- | -------- | -------------------------------------------- |
| Core Business Module        | Must     | Module chứa logic nghiệp vụ chính           |
| Transaction/Financial       | Must     | Module xử lý giao dịch, tài chính          |
| Data Processing Module      | Must     | Module nhập/xuất dữ liệu quan trọng         |
| Security/Compliance Module  | Must     | Module bảo mật, tuân thủ                     |
| User Management Module      | Should   | Module quản lý người dùng, phân quyền       |
| Reporting Module            | Should   | Module báo cáo, thống kê                     |
| Các module khác              | Optional | Tùy độ phức tạp và tầm quan trọng          |

> **Quy tắc**: Đặt DFD Level 2 trong file `{module}-01.md` của từng module trong folder `03-functional-design/`

---

## 🚨 BƯỚC 6: Detail Coverage Check (CRITICAL)

> 📄 **Hướng dẫn chi tiết**: `.ai-instructions/bd-detail-coverage-check.md`

### 6.1 Cách đếm với File/Folder Structure

```

Main file: Đếm items trong danh sách (一覧)
Detail files: Đếm sections chi tiết trong các {module}-XX.md
Coverage = Detail sections / List items × 100%

✅ PASS: Coverage = 100%
❌ FAIL: Coverage < 100% → DỪNG LẠI, bổ sung TRƯỚC KHI tiếp tục!

```

### 6.2 Checklist Coverage

| Item   | Main File               | Detail Folder         | Target |
| ------ | ----------------------- | --------------------- | ------ |
| UC     | 03-functional-design.md | 03-functional-design/ | 100%   |
| Screen | 04-screen-design.md     | 04-screen-design/     | 100%   |
| Table  | 05-data-design.md       | 05-data-design/       | 100%   |
| API    | 06-api-design.md        | 06-api-design/        | 100%   |
| Batch  | 07-batch-design.md      | 07-batch-design/      | 100%   |

> ⚠️ **CẢNH BÁO**: Coverage < 100% = Document chưa hoàn thành!

---

## ✅ BƯỚC 7: Kiểm tra với Checklist

Load checklists từ `.ai-instructions/`:

| Chương            | Checklist File                      |
| ----------------- | ----------------------------------- |
| Functional Design | `bd-functional-design-checklist.md` |
| Screen Design     | `bd-screen-design-checklist.md`     |
| Data Design       | `bd-data-design-checklist.md`       |
| API Design        | `bd-api-design-checklist.md`        |
| Batch Design      | `bd-batch-design-checklist.md`      |

---

## 📊 BƯỚC 8: Tổng kết

1. Cập nhật `bd-progress.md` → Status = ✅ Completed
2. Verify file/folder structure với checklist
3. Thông báo kết quả cho user

---

## 📚 Tài liệu tham khảo

Tất cả trong `.ai-instructions/`:

| File                           | Mô tả                    |
| ------------------------------ | ------------------------ |
| `basic-design-instructions.md` | Hướng dẫn chính          |
| `bd-file-folder-structure.md`  | **Cấu trúc File/Folder** |
| `bd-detail-coverage-check.md`  | Kiểm tra coverage        |
| `bd-checklist-summary.md`      | Checklist tổng hợp       |
| `bd-progress-template.md`      | Template progress        |
| `bd-*-checklist.md`            | Checklists từng chương   |

---

## 💡 Lưu ý quan trọng

1. **SRS là bắt buộc** - Phải có trước khi tạo BD
2. **Main + Folder Structure** - Chương 03-07 PHẢI dùng cấu trúc này
3. **Coverage 100%** - Tất cả items phải có detail tương ứng
4. **\_index.md in folders** - Mỗi folder PHẢI có \_index.md
5. **Detail File Naming** - Theo convention: {module}-XX.md
6. **Links Valid** - Main file links phải trỏ đúng detail files
7. **DFD Required** - PHẢI có DFD Level 0/1 trong Architecture, Level 2 trong core modules

---

## 📊 DFD Checklist

### DFD Level 0 & 1 (BẮt buộc)

| Level   | Vị trí                 | Nội dung                                             | Required |
| ------- | ---------------------- | ---------------------------------------------------- | -------- |
| Level 0 | 02-system-architecture | Context Diagram (Hệ thống + External Entities)       | ✅ Must  |
| Level 0 | 02-system-architecture | Data Flow List (Bảng From/To/Content)                | ✅ Must  |
| Level 1 | 02-system-architecture | System DFD (Core Processes + Data Stores)            | ✅ Must  |
| Level 1 | 02-system-architecture | Process/Data Store Definitions                       | ✅ Must  |

### DFD Level 2 (Theo module)

| Tiêu chí Module             | Vị trí                         | Required  |
| --------------------------- | ------------------------------ | --------- |
| Core Business Module        | `{module}-01.md`               | ✅ Must   |
| Transaction/Financial       | `{module}-01.md`               | ✅ Must   |
| Data Processing Module      | `{module}-01.md`               | ✅ Must   |
| Security/Compliance Module  | `{module}-01.md`               | ✅ Must   |
| User Management Module      | `{module}-01.md`               | ⚠️ Should |
| Reporting Module            | `{module}-01.md`               | ⚠️ Should |
| Các module khác              | `{module}-01.md`               | Optional  |

> **Note**: Xác định module nào cần DFD Level 2 dựa trên độ phức tạp và tầm quan trọng của từng module trong hệ thống cụ thể.
```
