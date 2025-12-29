# SpeakPal AI 基本設計書

> **AI 英会話練習アプリ - Basic Design Document**

---

## 📋 ドキュメント情報

| 項目             | 内容                      |
| ---------------- | ------------------------- |
| プロジェクト名   | SpeakPal AI               |
| ドキュメント種別 | 基本設計書 (Basic Design) |
| バージョン       | 1.0                       |
| 作成日           | 2025 年 12 月 29 日       |
| ステータス       | Draft                     |

---

## 📑 目次

### 基盤設計

| No  | チャプター                                            | 説明                              |
| --- | ----------------------------------------------------- | --------------------------------- |
| 01  | [システム概要](./01-system-overview.md)               | 目的、範囲、制約、用語集          |
| 02  | [システムアーキテクチャ](./02-system-architecture.md) | アーキテクチャ、DFD、技術スタック |

### コア設計

| No  | チャプター                            | 説明                         |
| --- | ------------------------------------- | ---------------------------- |
| 03  | [機能設計](./03-functional-design.md) | UC 設計、FR→UC マッピング    |
| 04  | [画面設計](./04-screen-design.md)     | 画面一覧、レイアウト、遷移図 |
| 05  | [データ設計](./05-data-design.md)     | ERD、テーブル定義            |
| 06  | [API 設計](./06-api-design.md)        | REST API、WebSocket API      |
| 07  | [バッチ設計](./07-batch-design.md)    | バッチ処理一覧               |

### 品質設計

| No  | チャプター                               | 説明                         |
| --- | ---------------------------------------- | ---------------------------- |
| 08  | [非機能設計](./08-non-functional.md)     | パフォーマンス、セキュリティ |
| 09  | [エラー処理設計](./09-error-handling.md) | エラーコード、リトライ戦略   |
| 10  | [付録](./10-appendix.md)                 | トレーサビリティ、用語集     |

---

## 📊 設計サマリー

### カバレッジ

| 項目             | 値           | ステータス |
| ---------------- | ------------ | ---------- |
| FR→UC マッピング | 33/33 (100%) | ✅ PASS    |
| 画面設計         | 20/20 (100%) | ✅ PASS    |
| テーブル設計     | 17/17 (100%) | ✅ PASS    |
| API 設計         | 45 APIs      | ✅ PASS    |
| バッチ設計       | 8 バッチ     | ✅ PASS    |

### 主要設計決定

| 項目           | 決定内容                       |
| -------------- | ------------------------------ |
| アーキテクチャ | マイクロサービス               |
| 通信プロトコル | REST + WebSocket               |
| データベース   | PostgreSQL + Redis             |
| 認証           | JWT + OAuth 2.0                |
| 外部 AI        | Deepgram + GPT-4o + ElevenLabs |

---

## 📁 フォルダ構成

```
基本設計書/
├── _index.md                      # このファイル
├── bd-progress.md                 # 進捗トラッカー
├── 01-system-overview.md          # システム概要
├── 02-system-architecture.md      # システムアーキテクチャ
├── 03-functional-design.md        # 機能設計
├── 03-functional-design/          # 機能設計詳細
│   ├── _index.md
│   ├── conversation-01.md
│   ├── feedback-01.md
│   ├── customization-01.md
│   ├── user-01.md
│   ├── subscription-01.md
│   ├── gamification-01.md
│   ├── progress-01.md
│   ├── learning-01.md
│   ├── social-01.md
│   └── advanced-01.md
├── 04-screen-design.md            # 画面設計
├── 04-screen-design/              # 画面設計詳細
│   ├── _index.md
│   ├── auth-01.md
│   ├── home-01.md
│   ├── conversation-01.md
│   ├── settings-01.md
│   ├── progress-01.md
│   ├── learning-01.md
│   └── social-01.md
├── 05-data-design.md              # データ設計
├── 05-data-design/                # データ設計詳細
│   ├── _index.md
│   ├── user-01.md
│   ├── conversation-01.md
│   ├── learning-01.md
│   ├── gamification-01.md
│   └── social-01.md
├── 06-api-design.md               # API設計
├── 07-batch-design.md             # バッチ設計
├── 08-non-functional.md           # 非機能設計
├── 09-error-handling.md           # エラー処理設計
└── 10-appendix.md                 # 付録
```

---

## 🔗 関連ドキュメント

| ドキュメント            | 場所                                             |
| ----------------------- | ------------------------------------------------ |
| システム要件定義書(SRS) | [../システム要件定義書/](../システム要件定義書/) |
| 詳細設計書(DD)          | TBD                                              |

---

_最終更新: 2025-12-29_
