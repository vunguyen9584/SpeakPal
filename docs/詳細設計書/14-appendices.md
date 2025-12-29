# 14. 付録

## 14.1. SRS → BD → DD トレーサビリティマトリクス

### 14.1.1. 機能要件 → UC → DD マッピング

| FR ID  | FR 名                | UC ID  | DD セクション          |
| ------ | -------------------- | ------ | ---------------------- |
| FR-001 | リアルタイム会話     | UC-003 | 05-module/conversation |
| FR-002 | リアルタイム訂正     | UC-006 | 05-module/feedback     |
| FR-003 | 語彙提案             | UC-004 | 05-module/feedback     |
| FR-004 | 発音評価             | UC-030 | 05-module/feedback     |
| FR-005 | 会話モード切替       | UC-001 | 06-component           |
| FR-006 | ペルソナカスタマイズ | UC-008 | 05-module/user         |
| FR-007 | 学習進捗追跡         | UC-021 | 05-module/progress     |
| FR-008 | AI 速度調整          | UC-007 | 05-module/user         |
| FR-009 | シナリオ学習         | UC-024 | 05-module/learning     |
| FR-010 | 発音詳細分析         | UC-030 | 05-module/feedback     |
| FR-011 | ストリーク管理       | UC-018 | 05-module/gamification |
| FR-012 | デイリーチャレンジ   | UC-025 | 05-module/learning     |
| FR-013 | 単語帳               | UC-026 | 05-module/learning     |
| FR-014 | アチーブメント       | UC-019 | 05-module/gamification |
| FR-015 | ランキング           | UC-028 | 05-module/gamification |
| FR-016 | レポート生成         | UC-023 | 06-component/batch     |

### 14.1.2. 非機能要件 → DD マッピング

| NFR ID  | NFR 名           | DD セクション            |
| ------- | ---------------- | ------------------------ |
| NFR-001 | AI 応答遅延      | 04-design-considerations |
| NFR-002 | 割り込み検知     | 05-module/conversation   |
| NFR-003 | 字幕遅延         | 08-api/websocket         |
| NFR-004 | 同時接続数       | 13-deployment            |
| NFR-005 | スケーラビリティ | 13-deployment            |
| NFR-006 | 可用性           | 13-deployment            |
| NFR-007 | 認証             | 10-security              |
| NFR-008 | データ暗号化     | 10-security              |
| NFR-009 | 監査ログ         | 12-logging               |

---

## 14.2. 決定ログ

### 14.2.1. アーキテクチャ決定

| ID     | 日付       | 決定事項                   | 理由                         |
| ------ | ---------- | -------------------------- | ---------------------------- |
| AD-001 | 2025-12-29 | Flutter 採用               | iOS/Android 共通コードベース |
| AD-002 | 2025-12-29 | NestJS 採用                | TypeScript、モジュラー設計   |
| AD-003 | 2025-12-29 | PostgreSQL 採用            | トランザクション、拡張性     |
| AD-004 | 2025-12-29 | WebSocket for リアルタイム | 低遅延双方向通信             |
| AD-005 | 2025-12-29 | JWT 認証                   | ステートレス、スケーラブル   |
| AD-006 | 2025-12-29 | Deepgram for STT           | 高精度、低遅延               |
| AD-007 | 2025-12-29 | GPT-4o for LLM             | 高品質会話生成               |
| AD-008 | 2025-12-29 | ElevenLabs for TTS         | 自然な音声、多様な声         |

### 14.2.2. 設計決定

| ID     | 日付       | 決定事項                      | 理由                     |
| ------ | ---------- | ----------------------------- | ------------------------ |
| DD-001 | 2025-12-29 | Riverpod for Flutter 状態管理 | 型安全、テスタビリティ   |
| DD-002 | 2025-12-29 | Prisma for ORM                | 型安全、マイグレーション |
| DD-003 | 2025-12-29 | 月次パーティショニング        | 大量データ管理           |
| DD-004 | 2025-12-29 | SRS for 復習                  | 効率的な記憶定着         |

---

## 14.3. オープン課題

| ID     | カテゴリ | 内容                       | 優先度 | 担当者 | 期限    |
| ------ | -------- | -------------------------- | ------ | ------ | ------- |
| OI-001 | 技術     | オフラインモードの詳細設計 | Low    | TBD    | Phase 2 |
| OI-002 | ビジネス | 多言語対応の範囲確定       | Low    | PM     | Phase 2 |
| OI-003 | 技術     | 管理者画面の設計           | Low    | TBD    | Phase 2 |

---

## 14.4. 用語集

| 用語 | 定義                                               |
| ---- | -------------------------------------------------- |
| CCU  | Concurrent Users - 同時接続ユーザー数              |
| DAU  | Daily Active Users - 日次アクティブユーザー        |
| STT  | Speech-to-Text - 音声をテキストに変換              |
| TTS  | Text-to-Speech - テキストを音声に変換              |
| LLM  | Large Language Model - 大規模言語モデル            |
| VAD  | Voice Activity Detection - 音声区間検出            |
| SRS  | Spaced Repetition System - 間隔反復学習            |
| XP   | Experience Points - 経験値                         |
| JWT  | JSON Web Token - 認証トークン形式                  |
| RBAC | Role-Based Access Control - 役割ベースアクセス制御 |

---

## 14.5. 参考資料

| ドキュメント          | URL / パス                       |
| --------------------- | -------------------------------- |
| システム要件定義書    | ../システム要件定義書/\_index.md |
| 基本設計書            | ../基本設計書/\_index.md         |
| Flutter Documentation | https://flutter.dev/docs         |
| NestJS Documentation  | https://docs.nestjs.com/         |
| OpenAI API Reference  | https://platform.openai.com/docs |
| Deepgram API          | https://developers.deepgram.com/ |
| ElevenLabs API        | https://docs.elevenlabs.io/      |

---

## 14.6. 改訂履歴

| バージョン | 日付       | 変更者 | 変更内容 |
| ---------- | ---------- | ------ | -------- |
| 1.0        | 2025-12-29 | AI     | 初版作成 |

---

← [目次](./_index.md) | _次のセクション: [15-checklist-results.md](./15-checklist-results.md)_
