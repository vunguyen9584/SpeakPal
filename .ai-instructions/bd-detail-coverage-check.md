# BD Detail Coverage Check - Hướng dẫn chi tiết

> 🚨 **CRITICAL FILE** - File này chứa hướng dẫn quan trọng nhất trong toàn bộ quy trình BD.
> Bỏ sót kiểm tra này = **Document không hoàn chỉnh dù PASS các tiêu chí khác!**

---

## 1. UC Detail Coverage Check

### 1.1 Quy trình kiểm tra

```
BƯỚC 1: Đếm UC trong danh sách
  - Mở file 03-functional-design.md
  - Tìm tất cả bảng "ユースケース一覧" hoặc "Use Case List"
  - Đếm số dòng data (không tính header)
  - Ghi lại: UC_Count_In_List = [số]

BƯỚC 2: Đếm UC có chi tiết
  - Tìm tất cả section "### X.X.X. UC-XXX-YYY:"
  - Mỗi section phải có:
    ✓ Bảng 基本情報 (Basic Info)
    ✓ シーケンス図 (Sequence Diagram)
  - Ghi lại: UC_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  Coverage = UC_Count_Detailed / UC_Count_In_List * 100%
```

### 1.2 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động             |
| ---------- | ------------------ | --------------------- |
| **100%**   | ✅ PASS            | Tiếp tục              |
| **80-99%** | ❌ FAIL (Minor)    | Bổ sung UC thiếu      |
| **50-79%** | ❌ FAIL (Major)    | Document nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Chưa hoàn thành       |

### 1.3 Template UC chi tiết (nếu cần bổ sung)

````markdown
### X.X.X. UC-XXX-YYY: [Tên UC]

#### 基本情報

| 項目              | 内容              |
| ----------------- | ----------------- |
| **UC ID**         | UC-XXX-YYY        |
| **UC 名**         | [Tên]             |
| **アクター**      | [Actor]           |
| **マッピング FR** | FR-XX-XX-XXX      |
| **優先度**        | Must/Should/Could |
| **前提条件**      | [Điều kiện trước] |
| **事後条件**      | [Điều kiện sau]   |

#### シーケンス図

\```mermaid
sequenceDiagram
participant U as User
participant UI as Web UI
participant API as API Service
participant DB as Database

    U->>UI: Action
    UI->>API: Request
    API->>DB: Query
    DB-->>API: Result
    API-->>UI: Response
    UI-->>U: Display

\```
````

---

## 2. Screen Detail Coverage Check

### 2.1 Quy trình kiểm tra

```
BƯỚC 1: Đếm Screen trong danh sách
  - Mở file 04-screen-design.md
  - Tìm tất cả bảng "画面一覧" hoặc "Screen List"
  - Đếm số dòng data (không tính header)
  - Ghi lại: Screen_Count_In_List = [số]

BƯỚC 2: Đếm Screen có chi tiết
  - Tìm tất cả section "### X.X.X. SCR-XXX-YYY:"
  - Mỗi section phải có:
    ✓ 画面基本情報 (Screen Info)
    ✓ レイアウト (Layout/Wireframe)
    ✓ 画面項目定義 (Item Definition)
    ✓ イベント定義 (Event Definition)
  - Ghi lại: Screen_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  Coverage = Screen_Count_Detailed / Screen_Count_In_List * 100%
```

### 2.2 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động             |
| ---------- | ------------------ | --------------------- |
| **100%**   | ✅ PASS            | Tiếp tục              |
| **80-99%** | ❌ FAIL (Minor)    | Bổ sung Screen thiếu  |
| **50-79%** | ❌ FAIL (Major)    | Document nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Chưa hoàn thành       |

### 2.3 Template Screen chi tiết (nếu cần bổ sung)

````markdown
### X.X.X. SCR-XXX-YYY: [Tên Screen]

#### 画面基本情報

| 項目           | 内容                        |
| -------------- | --------------------------- |
| **画面 ID**    | SCR-XXX-YYY                 |
| **画面名**     | [Tên]                       |
| **画面タイプ** | List/Input/Detail/Dashboard |
| **URL**        | /module/path                |
| **アクセス権** | [Roles]                     |
| **Related UC** | UC-XXX-YYY                  |

#### レイアウト

\```
┌────────────────────────────────────────────────┐
│ [ヘッダー] パンくずリスト │
├────────────────────────────────────────────────┤
│ [メインコンテンツエリア] │
│ │
└────────────────────────────────────────────────┘
\```

#### 画面項目定義

| No  | 項目 ID | 項目名 | タイプ | 必須 | 最大長 | 検証条件 |
| --- | ------- | ------ | ------ | ---- | ------ | -------- |
| 1   | xxx_001 | [Name] | [Type] | ○/-  | 100    | [条件]   |

#### イベント定義

| No  | イベント ID | トリガー       | アクション |
| --- | ----------- | -------------- | ---------- |
| 1   | EVT-001     | ボタンクリック | [説明]     |
````

---

## 3. Table Detail Coverage Check (BẮT BUỘC cho Data Design)

> 🔴 **QUAN TRỌNG**: Mỗi table trong danh sách PHẢI có định nghĩa chi tiết đầy đủ

### 3.1 Quy trình kiểm tra

```
BƯỚC 1: Đếm Table trong danh sách
  - Mở file 05-data-design.md
  - Tìm tất cả bảng "テーブル一覧" (Table List)
    - マスタテーブル (Master Tables)
    - トランザクションテーブル (Transaction Tables)
  - Đếm số dòng data (không tính header)
  - Ghi lại: Table_Count_In_List = [số]

BƯỚC 2: Đếm Table có chi tiết
  - Tìm tất cả section "### X.X.X. [TABLE_ID] - [TABLE_NAME]"
  - Mỗi section phải có:
    ✓ Column Definition Table (No, カラム名, 論理名, データ型, PK, FK, NN, デフォルト, 説明)
    ✓ INDEX definitions
  - Ghi lại: Table_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  Coverage = Table_Count_Detailed / Table_Count_In_List * 100%
```

### 3.2 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động             |
| ---------- | ------------------ | --------------------- |
| **100%**   | ✅ PASS            | Tiếp tục              |
| **80-99%** | ❌ FAIL (Minor)    | Bổ sung Table thiếu   |
| **50-79%** | ❌ FAIL (Major)    | Document nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Chưa hoàn thành       |

### 3.3 Template Table chi tiết (nếu cần bổ sung)

```markdown
### X.X.X. [TABLE_ID] - [TABLE_NAME]

| No  | カラム名 | 論理名 | データ型    | PK  | FK  | NN  | デフォルト | 説明 |
| --- | -------- | ------ | ----------- | --- | --- | --- | ---------- | ---- |
| 1   | col_id   | [名前] | VARCHAR(36) | ○   |     | ○   |            | UUID |

**INDEX:**

- IX_xxx: column_name
- UK_xxx: column_name (UNIQUE)
```

---

## 4. API Detail Coverage Check (BẮT BUỘC cho API Design)

> 🔴 **QUAN TRỌNG**: Mỗi API trong danh sách PHẢI có định nghĩa chi tiết đầy đủ

### 4.1 Quy trình kiểm tra

```
BƯỚC 1: Đếm API trong danh sách
  - Mở file 06-api-design.md
  - Tìm tất cả bảng "API 一覧" (API List)
    - PLM モジュール API
    - APS モジュール API
    - 共通 API
  - Đếm số dòng data (không tính header)
  - Ghi lại: API_Count_In_List = [số]

BƯỚC 2: Đếm API có chi tiết
  - Tìm tất cả section "### X.X.X. API-XXX-YYY:"
  - Mỗi section phải có:
    ✓ 基本情報 (Basic Info) table
    ✓ Request params/body (nếu có)
    ✓ Response example (JSON)
  - Ghi lại: API_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  Coverage = API_Count_Detailed / API_Count_In_List * 100%
```

### 4.2 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động             |
| ---------- | ------------------ | --------------------- |
| **100%**   | ✅ PASS            | Tiếp tục              |
| **80-99%** | ❌ FAIL (Minor)    | Bổ sung API thiếu     |
| **50-79%** | ❌ FAIL (Major)    | Document nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Chưa hoàn thành       |

### 4.3 Template API chi tiết (nếu cần bổ sung)

```markdown
### X.X.X. API-XXX-YYY: [Tên API]

#### 基本情報

| 項目               | 値                  |
| ------------------ | ------------------- |
| **API ID**         | API-XXX-YYY         |
| **メソッド**       | GET/POST/PUT/DELETE |
| **エンドポイント** | /api/v1/...         |
| **認証**           | Bearer Token (JWT)  |
| **認可**           | PERMISSION_NAME     |

#### リクエストパラメータ/ボディ

[Table hoặc JSON example]

#### レスポンス (200 OK)

\`\`\`json
{
"success": true,
"data": { ... }
}
\`\`\`
```

---

## 5. Batch Detail Coverage Check (BẮT BUỘC cho Batch Design)

> 🔴 **QUAN TRỌNG**: Mỗi batch trong danh sách PHẢI có định nghĩa chi tiết đầy đủ

### 5.1 Quy trình kiểm tra

```
BƯỚC 1: Đếm Batch trong danh sách
  - Mở file 07-batch-design.md
  - Tìm bảng "バッチ一覧" (Batch List)
  - Đếm số dòng data (không tính header)
  - Ghi lại: Batch_Count_In_List = [số]

BƯỚC 2: Đếm Batch có chi tiết
  - Tìm tất cả section "### X.X.X. BAT-XXX:"
  - Mỗi section phải có:
    ✓ 基本情報 (Basic Info) table
    ✓ 処理フロー (Processing Flow) - Mermaid flowchart
    ✓ 入出力 (Input/Output) table
    ✓ エラー処理 (Error Handling) table
  - Ghi lại: Batch_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  Coverage = Batch_Count_Detailed / Batch_Count_In_List * 100%
```

### 5.2 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động             |
| ---------- | ------------------ | --------------------- |
| **100%**   | ✅ PASS            | Tiếp tục              |
| **80-99%** | ❌ FAIL (Minor)    | Bổ sung Batch thiếu   |
| **50-79%** | ❌ FAIL (Major)    | Document nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Chưa hoàn thành       |

---

## 6. Bảng đối chiếu tổng hợp (BẮT BUỘC điền)

### 6.1 UC Coverage

| Module    | UC trong DS | UC chi tiết | Thiếu      | Coverage    | OK? |
| --------- | ----------- | ----------- | ---------- | ----------- | --- |
| PLM       | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| APS       | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| Common    | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL** | **\_\_\_**  | **\_\_\_**  | **\_\_\_** | **\_\_\_%** | ☐   |

### 6.2 Screen Coverage

| Module    | SCR trong DS | SCR chi tiết | Thiếu      | Coverage    | OK? |
| --------- | ------------ | ------------ | ---------- | ----------- | --- |
| PLM       | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| APS       | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| Common    | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL** | **\_\_\_**   | **\_\_\_**   | **\_\_\_** | **\_\_\_%** | ☐   |

### 6.3 Table Coverage

| Category    | TBL trong DS | TBL chi tiết | Thiếu      | Coverage    | OK? |
| ----------- | ------------ | ------------ | ---------- | ----------- | --- |
| Master      | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| Transaction | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL**   | **\_\_\_**   | **\_\_\_**   | **\_\_\_** | **\_\_\_%** | ☐   |

### 6.4 API Coverage

| Category    | API trong DS | API chi tiết | Thiếu      | Coverage    | OK? |
| ----------- | ------------ | ------------ | ---------- | ----------- | --- |
| PLM APIs    | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| APS APIs    | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| Common APIs | \_\_\_       | \_\_\_       | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL**   | **\_\_\_**   | **\_\_\_**   | **\_\_\_** | **\_\_\_%** | ☐   |

### 6.5 Batch Coverage

| Category  | Batch trong DS | Batch chi tiết | Thiếu      | Coverage    | OK? |
| --------- | -------------- | -------------- | ---------- | ----------- | --- |
| **TOTAL** | **\_\_\_**     | **\_\_\_**     | **\_\_\_** | **\_\_\_%** | ☐   |

---

## 7. Danh sách items thiếu (nếu có)

### UCs thiếu chi tiết:

- [ ] UC-XXX-001: [Tên]
- [ ] UC-XXX-002: [Tên]

### Screens thiếu chi tiết:

- [ ] SCR-XXX-001: [Tên]
- [ ] SCR-XXX-002: [Tên]

### Tables thiếu chi tiết:

- [ ] T_XXX: [Tên]
- [ ] M_XXX: [Tên]

### APIs thiếu chi tiết:

- [ ] API-PLM-XXX: [Mô tả]
- [ ] API-APS-XXX: [Mô tả]
- [ ] API-CMN-XXX: [Mô tả]

### Batches thiếu chi tiết:

- [ ] BAT-XXX: [Tên]

---

> ⚠️ **CẢNH BÁO**: Coverage < 100% cho UC, Screen, Table, API, hoặc Batch = **KHÔNG ĐƯỢC PASS** dù các tiêu chí khác OK!
