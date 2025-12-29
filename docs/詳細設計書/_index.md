# 詳細設計書 (Detailed Design Document)

## SpeakPal AI - AI 英会話練習アプリ

---

## 📋 ドキュメント情報

| 項目             | 内容                                  |
| ---------------- | ------------------------------------- |
| プロジェクト名   | SpeakPal AI                           |
| ドキュメント種別 | 詳細設計書 (Detailed Design Document) |
| バージョン       | 1.0                                   |
| 作成日           | 2025 年 12 月 29 日                   |
| ステータス       | ✅ Completed                          |

---

## 📚 目次

### 基礎セクション

| No  | ファイル                                           | 内容                       |
| --- | -------------------------------------------------- | -------------------------- |
| 00  | [BD-DD マッピング](./00-bd-dd-mapping.md)          | 設計要素の追跡             |
| 01  | [導入](./01-introduction.md)                       | 目的、スコープ、規約       |
| 02  | [参考資料・用語集](./02-references-terminology.md) | 外部資料、略語             |
| 03  | [システム概要](./03-system-overview.md)            | アーキテクチャ、モジュール |
| 04  | [設計考慮事項](./04-design-considerations.md)      | 前提、制約、リスク         |

### コア設計セクション

| No  | ファイル                                                            | 内容                   |
| --- | ------------------------------------------------------------------- | ---------------------- |
| 05  | [モジュール設計](./05-module-design.md)                             | 各モジュールの詳細設計 |
|     | ├─ [Auth Module](./05-module-design/auth-module.md)                 | 認証サービス           |
|     | ├─ [User Module](./05-module-design/user-module.md)                 | ユーザー管理           |
|     | ├─ [Conversation Module](./05-module-design/conversation-module.md) | 会話処理               |
|     | ├─ [Feedback Module](./05-module-design/feedback-module.md)         | フィードバック         |
|     | ├─ [Learning Module](./05-module-design/learning-module.md)         | 学習管理               |
|     | └─ [Gamification Module](./05-module-design/gamification-module.md) | ゲーミフィケーション   |
| 06  | [コンポーネント設計](./06-component-design.md)                      | UC ごとの実装設計      |

### データ・インターフェースセクション

| No  | ファイル                                                              | 内容                       |
| --- | --------------------------------------------------------------------- | -------------------------- |
| 07  | [データベース設計](./07-database-design.md)                           | ER 図、DDL                 |
|     | ├─ [User Tables](./07-database-design/user-tables.md)                 | ユーザー系テーブル         |
|     | └─ [Conversation Tables](./07-database-design/conversation-tables.md) | 会話系テーブル             |
| 08  | [API 設計](./08-api-design.md)                                        | REST API, WebSocket        |
| 09  | [UI 仕様](./09-ui-specifications.md)                                  | 画面仕様、デザインシステム |

### 品質・運用セクション

| No  | ファイル                                        | 内容                       |
| --- | ----------------------------------------------- | -------------------------- |
| 10  | [セキュリティ設計](./10-security-design.md)     | 認証、認可、暗号化         |
| 11  | [エラー処理設計](./11-error-handling.md)        | エラーコード、例外処理     |
| 12  | [ログ・監視設計](./12-logging-monitoring.md)    | ログ、メトリクス、アラート |
| 13  | [デプロイメント設計](./13-deployment-design.md) | K8s、CI/CD、インフラ       |

### 付録

| No  | ファイル                                        | 内容                     |
| --- | ----------------------------------------------- | ------------------------ |
| 14  | [付録](./14-appendices.md)                      | トレーサビリティ、用語集 |
| 15  | [チェックリスト結果](./15-checklist-results.md) | 品質チェック結果         |

---

## 📊 設計サマリー

### カバレッジ

| 項目            | BD 総数 | DD カバー | カバレッジ |
| --------------- | ------- | --------- | ---------- |
| ユースケース    | 33      | 33        | 100%       |
| 画面            | 20      | 20        | 100%       |
| テーブル        | 18      | 18        | 100%       |
| REST API        | 42      | 42        | 100%       |
| WebSocket Event | 10      | 10        | 100%       |
| バッチ          | 8       | 8         | 100%       |
| **合計**        | **131** | **131**   | **100%**   |

### 技術スタック

| レイヤー  | 技術                |
| --------- | ------------------- |
| Mobile    | Flutter / Dart      |
| Web       | React               |
| Backend   | NestJS / TypeScript |
| Database  | PostgreSQL          |
| Cache     | Redis               |
| AI (STT)  | Deepgram            |
| AI (LLM)  | GPT-4o              |
| AI (TTS)  | ElevenLabs          |
| Container | Docker / Kubernetes |

---

## 📁 ディレクトリ構成

```
詳細設計書/
├── _index.md                     # このファイル
├── dd-progress.md                # 進捗トラッカー
├── 00-bd-dd-mapping.md           # BD-DD マッピング
├── 01-introduction.md            # 導入
├── 02-references-terminology.md  # 参考資料・用語集
├── 03-system-overview.md         # システム概要
├── 04-design-considerations.md   # 設計考慮事項
├── 05-module-design.md           # モジュール設計 (Index)
├── 05-module-design/
│   ├── auth-module.md
│   ├── user-module.md
│   ├── conversation-module.md
│   ├── feedback-module.md
│   ├── learning-module.md
│   └── gamification-module.md
├── 06-component-design.md        # コンポーネント設計
├── 07-database-design.md         # データベース設計 (Index)
├── 07-database-design/
│   ├── user-tables.md
│   └── conversation-tables.md
├── 08-api-design.md              # API 設計
├── 09-ui-specifications.md       # UI 仕様
├── 10-security-design.md         # セキュリティ設計
├── 11-error-handling.md          # エラー処理設計
├── 12-logging-monitoring.md      # ログ・監視設計
├── 13-deployment-design.md       # デプロイメント設計
├── 14-appendices.md              # 付録
└── 15-checklist-results.md       # チェックリスト結果
```

---

## 🔗 関連ドキュメント

| ドキュメント       | パス                             |
| ------------------ | -------------------------------- |
| システム要件定義書 | ../システム要件定義書/\_index.md |
| 基本設計書         | ../基本設計書/\_index.md         |

---

**✅ 詳細設計書 完成**

_作成日: 2025 年 12 月 29 日_
