# BD File/Folder Structure Guide

> 🔴 **CRITICAL**: Hướng dẫn này định nghĩa cấu trúc file/folder chuẩn cho Basic Design documents.

---

## 1. Tổng quan cấu trúc

### 1.1 Nguyên tắc chính

Các chương **03-07** sử dụng cấu trúc **Main File + Detail Folder**:

| Chương               | Main File                 | Detail Folder           |
| -------------------- | ------------------------- | ----------------------- |
| 03 Functional Design | `03-functional-design.md` | `03-functional-design/` |
| 04 Screen Design     | `04-screen-design.md`     | `04-screen-design/`     |
| 05 Data Design       | `05-data-design.md`       | `05-data-design/`       |
| 06 API Design        | `06-api-design.md`        | `06-api-design/`        |
| 07 Batch Design      | `07-batch-design.md`      | `07-batch-design/`      |

Các chương khác (01, 02, 08, 09, 10) sử dụng **Single File**.

### 1.2 Lợi ích

- **Dễ quản lý**: Main file ngắn gọn, dễ đọc
- **Dễ mở rộng**: Thêm detail files khi cần
- **Dễ review**: Có thể review từng module riêng
- **Dễ navigation**: Links rõ ràng từ main file đến details

---

## 2. Cấu trúc thư mục đầy đủ

```
基本設計書/
├── _index.md
├── 01-system-overview.md
├── 02-system-architecture.md
│
├── 03-functional-design.md          ← Main file
├── 03-functional-design/            ← Detail folder
│   ├── _index.md                    ← Index với common patterns
│   ├── {module}-01.md               ← UC details (ví dụ: mes-01.md)
│   ├── {module}-02.md
│   └── ...
│
├── 04-screen-design.md              ← Main file
├── 04-screen-design/                ← Detail folder
│   ├── _index.md
│   ├── {module}-01.md               ← Screen details (ví dụ: qms-01.md)
│   └── ...
│
├── 05-data-design.md                ← Main file
├── 05-data-design/                  ← Detail folder
│   ├── _index.md                    ← ER diagrams, common columns
│   ├── {module}-01.md               ← Table definitions (ví dụ: wms-01.md)
│   └── ...
│
├── 06-api-design.md                 ← Main file
├── 06-api-design/                   ← Detail folder
│   ├── _index.md                    ← Auth, common specs, error codes
│   ├── {module}-01.md               ← API details
│   └── ...
│
├── 07-batch-design.md               ← Main file
├── 07-batch-design/                 ← Detail folder
│   ├── _index.md                    ← 排他制御, Cron式, common specs
│   ├── {module}-batches.md          ← Batch details
│   └── ...
│
├── 08-non-functional.md
├── 09-error-handling.md
└── 10-appendix.md
```

---

## 3. Main File Requirements

Mỗi main file (03-07) **PHẢI** có các sections sau:

### 3.1 Template cấu trúc Main File

```markdown
# X. [Chapter Name]

## X.1. 概要

Mô tả ngắn về chương, với statistics:

| 項目         | 内容             |
| ------------ | ---------------- |
| モジュール数 | X (module names) |
| 総[Item]数   | Y                |
| [Module1]    | N1               |
| [Module2]    | N2               |

---

## X.2. ドキュメント構成

Links đến detail files:

| ファイル名                                   | 内容             | [Item]数 |
| -------------------------------------------- | ---------------- | -------- |
| [\_index.md](./XX-folder/_index.md)          | 概要・共通仕様   | -        |
| [{module}-01.md](./XX-folder/{module}-01.md) | [Module] [Items] | N        |
| ...                                          | ...              | ...      |

---

## X.3. [Item]一覧

Danh sách items với links:

| [Item] ID | [Item]名 | ... | 詳細ファイル                   |
| --------- | -------- | --- | ------------------------------ |
| ID-001    | Name     | ... | [file.md](./XX-folder/file.md) |

---

## X.4. [Additional Sections as needed]

---

## X.5. Coverage Summary

| Module    | Total | Detailed | Coverage |
| --------- | ----- | -------- | -------- |
| [Module1] | N     | N        | 100%     |
| [Module2] | M     | M        | 100%     |
| **Total** | **X** | **X**    | **100%** |

---

_次のセクション: [next-file.md](./next-file.md)_
```

---

## 4. Detail Folder Requirements

### 4.1 \_index.md (BẮT BUỘC trong mỗi folder)

Mỗi detail folder PHẢI có `_index.md` với:

| Chương               | \_index.md nội dung                                 |
| -------------------- | --------------------------------------------------- |
| 03-functional-design | UC patterns, common flows, actor definitions        |
| 04-screen-design     | Screen layouts, common components, responsive rules |
| 05-data-design       | ER diagrams, common columns, naming conventions     |
| 06-api-design        | Auth specs, common response format, error codes     |
| 07-batch-design      | 排他制御, Cron 式一覧, retry policies               |

### 4.2 Detail Files Naming Convention

| Chương               | File Format           | Ví dụ                              |
| -------------------- | --------------------- | ---------------------------------- |
| 03-functional-design | `{module}-XX.md`      | `mes-01.md`, `qms-02.md`           |
| 04-screen-design     | `{module}-XX.md`      | `wms-01.md`, `wms-02.md`           |
| 05-data-design       | `{module}-XX.md`      | `mes-01.md`, `qms-01.md`           |
| 06-api-design        | `{module}-XX.md`      | `mes-01.md`, `mes-02.md`           |
| 07-batch-design      | `{module}-batches.md` | `mes-batches.md`, `qms-batches.md` |

### 4.3 Module Names

Sử dụng tên module viết thường, ví dụ:

- `mes` - Manufacturing Execution System
- `qms` - Quality Management System
- `wms` - Warehouse Management System
- `plm` - Product Lifecycle Management
- `aps` - Advanced Planning & Scheduling
- `common` - Shared/Common functions

---

## 5. Detail Content Requirements

### 5.1 UC Details (03-functional-design)

Mỗi UC trong detail file phải có:

````markdown
## UC-XXX-YYY: [UC Name]

### 基本情報

| 項目     | 内容              |
| -------- | ----------------- |
| UC ID    | UC-XXX-YYY        |
| UC 名    | [Name]            |
| アクター | [Actor]           |
| 前提条件 | [Pre-conditions]  |
| 事後条件 | [Post-conditions] |
| 関連 FR  | FR-XXX-YYY        |

### 基本フロー

1. Step 1
2. Step 2
   ...

### 代替フロー

- A1: [Alternative flow]

### シーケンス図

```mermaid
sequenceDiagram
...
```
````

### ビジネスルール

| ルール ID | ルール内容 |
| --------- | ---------- |
| BR-001    | [Rule]     |

````

### 5.2 Screen Details (04-screen-design)

Mỗi Screen trong detail file phải có:

```markdown
## SCR-XXX-YYY: [Screen Name]

### 画面基本情報

| 項目 | 内容 |
|----|-----|
| 画面 ID | SCR-XXX-YYY |
| 画面名 | [Name] |
| 画面種別 | [Type] |
| URL | /path/to/screen |
| 関連 UC | UC-XXX-YYY |

### レイアウト

````

+----------------------------------+
| Header |
+----------------------------------+
| Sidebar | Content |
| | |
+----------------------------------+

```

### 項目定義

| No | 項目 ID | 項目名 | 型 | 必須 | 説明 |
|---|--------|-------|---|-----|-----|
| 1 | fld_001 | Field | text | ○ | Description |

### イベント定義

| No | イベント ID | トリガー | アクション |
|---|-----------|---------|---------|
| 1 | evt_001 | Click | [Action] |
```

### 5.3 Table Details (05-data-design)

Mỗi Table trong detail file phải có:

```markdown
## T_XXX_YYYY - [Table Name]

| No  | カラム名 | 論理名 | データ型    | PK  | FK  | NN  | デフォルト | 説明        |
| --- | -------- | ------ | ----------- | --- | --- | --- | ---------- | ----------- |
| 1   | col_id   | ID     | VARCHAR(20) | ○   |     | ○   |            | Primary key |
| 2   | ...      | ...    | ...         |     |     |     |            |             |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
|---|---------|-------|--------|
| 1 | PK_XXX | col_id | ○ |
```

### 5.4 API Details (06-api-design)

Mỗi API trong detail file phải có:

````markdown
## API-XXX-YYY: [API Name]

### 基本情報

| 項目     | 内容                |
| -------- | ------------------- |
| API ID   | API-XXX-YYY         |
| API 名   | [Name]              |
| Endpoint | METHOD /api/v1/path |
| 認証     | Bearer Token (JWT)  |
| 権限     | [Roles]             |

### リクエスト

**Path/Query Parameters:**
| Parameter | Type | Required | Description |
|----------|------|----------|-------------|

**Request Body:**

```json
{}
```
````

### レスポンス

**Success (200 OK):**

```json
{}
```

**Error:**

```json
{}
```

````

### 5.5 Batch Details (07-batch-design)

Mỗi Batch trong detail file phải có:

```markdown
## BAT-XXX-YYY: [Batch Name]

### 基本情報

| 項目 | 内容 |
|----|-----|
| バッチ ID | BAT-XXX-YYY |
| バッチ名 | [Name] |
| 実行タイミング | [Schedule] |
| Cron 式 | [Cron expression] |
| 想定実行時間 | [Duration] |
| タイムアウト | [Timeout] |
| リトライ | [Retry policy] |
| 同時実行 | 可/不可 |

### 処理フロー

````

1. Step 1
   │
   ▼
2. Step 2

```

### 入出力

**入力データ:**
| データ | テーブル/ソース | 説明 |
|-------|---------------|-----|

**出力データ:**
| データ | テーブル/ソース | 説明 |
|-------|---------------|-----|

### エラー処理

| エラー種別 | 対応 |
|----------|-----|
```

---

## 6. Coverage Check với File/Folder Structure

### 6.1 Cách đếm

```
Main file: Đếm items trong danh sách (一覧 section)
Detail files: Đếm sections "## [ID]:" trong các {module}-XX.md files
Coverage = Detail sections / List items × 100%
```

### 6.2 Coverage phải đạt 100%

Mỗi item trong danh sách (main file) PHẢI có section chi tiết tương ứng trong detail files.

---

## 7. Link Conventions

### 7.1 Từ Main File đến Detail

```markdown
[file.md](./XX-folder/file.md)
```

### 7.2 Từ Detail Files qua lại

```markdown
_関連ファイル: [\_index.md](./_index.md) | [other-file.md](./other-file.md)_
```

### 7.3 Về Main File

```markdown
_メインファイル: [../XX-design.md](../XX-design.md)_
```

---

## 8. Checklist tạo File/Folder

### 8.1 Khi tạo mới chương 03-07

- [ ] Tạo main file `XX-design.md`
- [ ] Tạo folder `XX-design/`
- [ ] Tạo `XX-design/_index.md`
- [ ] Tạo detail files `XX-design/{module}-XX.md`
- [ ] Main file có 概要 section với statistics
- [ ] Main file có ドキュメント構成 với links
- [ ] Main file có 一覧 với links đến detail files
- [ ] Main file có Coverage Summary = 100%
- [ ] Tất cả links valid
- [ ] Tất cả items có detail tương ứng

### 8.2 Khi review

- [ ] Main file tồn tại
- [ ] Detail folder tồn tại
- [ ] \_index.md trong folder tồn tại
- [ ] Detail files đúng naming convention
- [ ] Coverage = 100%
- [ ] Links valid
- [ ] Count match (list items = detail sections)
