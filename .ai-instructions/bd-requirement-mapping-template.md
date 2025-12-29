# BD Requirement Mapping Template

> Template này dùng để tích hợp FR→UC mapping vào file `03-functional-design.md`

## 1. Section Requirement Coverage (Thêm vào đầu file)

```markdown
## 1. 要件カバレッジサマリー (Requirement Coverage Summary)

> このセクションは、SRS の機能要件が BD のユースケースで適切にカバーされていることを示します。

### 1.1 カバレッジ統計

| メトリック               | 値             |
| ------------------------ | -------------- |
| SRS 内 FR 総数           | [X]            |
| UC でカバーされた FR 数  | [Y]            |
| カバーされていない FR 数 | [Z]            |
| **カバレッジ率**         | **[Y/X*100]%** |

### 1.2 優先度別カバレッジ

| 優先度 | 総数 | カバー済み | 未カバー | カバレッジ率 | ステータス |
| ------ | ---- | ---------- | -------- | ------------ | ---------- |
| Must   | [n]  | [n]        | 0        | 100%         | ✅ PASS    |
| Should | [n]  | [n]        | [n]      | [x]%         | ✅/⚠️      |
| Could  | [n]  | [n]        | [n]      | [x]%         | ℹ️ INFO    |

### 1.3 FR→UC マッピングテーブル

| FR ID  | FR 機能名           | サブシステム | 優先度 | マッピング UC  | ステータス  |
| ------ | ------------------- | ------------ | ------ | -------------- | ----------- |
| FR-001 | ログイン/ログアウト | ユーザー管理 | Must   | UC-001, UC-002 | ✅ カバー済 |
| FR-002 | アカウント管理      | ユーザー管理 | Must   | UC-003         | ✅ カバー済 |
| ...    | ...                 | ...          | ...    | ...            | ...         |

### 1.4 未カバー FR 一覧 (該当なしの場合は省略可)

| FR ID  | FR 機能名 | 優先度 | 未カバー理由 | 対応方針       |
| ------ | --------- | ------ | ------------ | -------------- |
| FR-XXX | [名前]    | Should | [理由]       | UC 追加 / 延期 |
```

## 2. Use Case List Template

```markdown
## 2. ユースケース一覧

| UC ID  | UC 名                  | アクター   | マッピング FR  | 優先度 |
| ------ | ---------------------- | ---------- | -------------- | ------ |
| UC-001 | システムにログインする | 全ユーザー | FR-001         | Must   |
| UC-002 | パスワードを再設定する | 全ユーザー | FR-001         | Must   |
| UC-003 | ユーザーを管理する     | Admin      | FR-002, FR-003 | Must   |
| ...    | ...                    | ...        | ...            | ...    |
```

## 3. Tiêu chuẩn Coverage

> 🔴 **Basic Design yêu cầu 100% coverage cho TẤT CẢ FR**, không phân biệt priority.

| Priority   | Yêu cầu Coverage | Hành động nếu không đạt            |
| ---------- | ---------------- | ---------------------------------- |
| **Must**   | **100%**         | KHÔNG được tiếp tục. Phải thêm UC. |
| **Should** | **100%**         | KHÔNG được tiếp tục. Phải thêm UC. |
| **Could**  | **100%**         | KHÔNG được tiếp tục. Phải thêm UC. |

**Lý do:** Basic Design là tài liệu thiết kế toàn diện, phải cover 100% yêu cầu trong SRS. Priority chỉ ảnh hưởng đến thứ tự implementation, không phải scope của BD.

## 4. Báo cáo Coverage cho User

```markdown
## 📊 Requirement Coverage Report

### Kết quả kiểm tra:

| Priority | Total | Covered | Coverage | Status  |
| -------- | ----- | ------- | -------- | ------- |
| Must     | [X]   | [X]     | 100%     | ✅ PASS |
| Should   | [X]   | [Y]     | [Z]%     | ✅/⚠️   |
| Could    | [X]   | [Y]     | [Z]%     | ℹ️ INFO |

### [Nếu có FR chưa cover]

⚠️ **Các FR sau chưa có Use Case:**

| #   | FR ID  | FR Name | Priority | Đề xuất          |
| --- | ------ | ------- | -------- | ---------------- |
| 1   | FR-XXX | [Tên]   | Should   | Thêm UC-XXX      |
| 2   | FR-YYY | [Tên]   | Could    | Defer to Phase 2 |

### Bạn muốn:

1. ✅ Thêm UC cho tất cả FR chưa cover (khuyến nghị cho Should)
2. 📝 Defer các FR Could sang Phase 2 (ghi vào Open Issues)
3. 🔍 Review từng FR và quyết định riêng
4. ❌ Bỏ qua và tiếp tục (KHÔNG khuyến nghị)
```
