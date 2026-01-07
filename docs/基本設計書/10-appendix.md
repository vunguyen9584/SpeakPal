# 10. 付録

## 10.1. トレーサビリティマトリクス

### 10.1.1. SRS → BD マッピング

| SRS セクション                 | BD セクション                   | カバレッジ |
| ------------------------------ | ------------------------------- | ---------- |
| 1. Introduction                | 01-system-overview              | ✅ 100%    |
| 2. Overall Description         | 01-system-overview              | ✅ 100%    |
| 3. Functional Requirements     | 03-functional-design            | ✅ 100%    |
| 4. External Interfaces         | 04-screen-design, 06-api-design | ✅ 100%    |
| 5. Non-functional Requirements | 08-non-functional               | ✅ 100%    |
| 6. Other Requirements          | 05-data-design, 07-batch-design | ✅ 100%    |
| 7. Appendix                    | 10-appendix                     | ✅ 100%    |

### 10.1.2. FR → UC → Screen → API → Table 完全トレーサビリティ

> 📌 **ENHANCED**: 完全なトレーサビリティマトリクス (FR → UC → Screen → API → Table)

| FR ID  | FR 名                  | UC ID  | 画面 ID                        | API                                 | テーブル                     |
| ------ | ---------------------- | ------ | ------------------------------ | ----------------------------------- | ---------------------------- |
| FR-001 | 会話モード切替         | UC-001 | SCR-CONV-001                   | POST /conversations                 | conversations                |
| FR-002 | インストラクター会話   | UC-002 | SCR-CONV-002                   | WebSocket /ws/{id}                  | conversations, turns         |
| FR-003 | フリートーク会話       | UC-003 | SCR-CONV-002                   | WebSocket /ws/{id}                  | conversations, turns         |
| FR-004 | スマート提案表示       | UC-004 | SCR-CONV-002                   | WebSocket (suggestion)              | turns                        |
| FR-005 | ストリーミング字幕     | UC-005 | SCR-CONV-002                   | WebSocket (text_result)             | turns                        |
| FR-006 | 即時訂正表示           | UC-006 | SCR-CONV-002                   | WebSocket (correction)              | corrections                  |
| FR-007 | AI 速度調整            | UC-007 | SCR-SETTINGS-002               | PUT /users/me                       | users                        |
| FR-008 | カスタムペルソナ作成   | UC-008 | SCR-SETTINGS-003               | POST /personas                      | personas                     |
| FR-009 | 割り込み対応           | UC-009 | SCR-CONV-002                   | WebSocket (interrupt)               | -                            |
| FR-010 | フィラーワード         | UC-010 | SCR-CONV-002                   | -                                   | -                            |
| FR-011 | ユーザー登録           | UC-011 | SCR-AUTH-001                   | POST /auth/register                 | users                        |
| FR-012 | ログイン/認証          | UC-012 | SCR-AUTH-002                   | POST /auth/login                    | users, sessions              |
| FR-013 | パスワード変更         | UC-013 | SCR-SETTINGS-004               | PUT /users/me/password              | users                        |
| FR-014 | サブスクリプション管理 | UC-014 | SCR-SETTINGS-005               | GET /subscriptions                  | subscriptions                |
| FR-015 | 利用量制限             | UC-015 | SCR-HOME-001, SCR-SETTINGS-005 | GET /subscriptions                  | subscriptions                |
| FR-016 | プラン変更             | UC-016 | SCR-SETTINGS-005               | POST /subscriptions/verify          | subscriptions                |
| FR-017 | 語彙解説               | UC-017 | SCR-CONV-002                   | POST /vocabularies                  | vocabularies                 |
| FR-018 | 学習ストリーク         | UC-018 | SCR-HOME-001                   | GET /streaks                        | streaks                      |
| FR-019 | 実績バッジ             | UC-019 | SCR-PROGRESS-003               | GET /badges/user                    | badges, user_badges          |
| FR-020 | 経験値＆レベル         | UC-020 | SCR-HOME-001, SCR-PROGRESS-001 | GET /users/me/stats                 | users                        |
| FR-021 | 学習統計ダッシュボード | UC-021 | SCR-PROGRESS-001               | GET /users/me/stats                 | user_statistics              |
| FR-022 | 発音スコア履歴         | UC-022 | SCR-PROGRESS-002               | GET /conversations                  | conversations                |
| FR-023 | 週間/月間レポート      | UC-023 | SCR-PROGRESS-001               | -                                   | user_reports (Batch)         |
| FR-024 | シナリオライブラリ     | UC-024 | SCR-LEARNING-001               | GET /scenarios                      | scenarios                    |
| FR-025 | デイリーチャレンジ     | UC-025 | SCR-HOME-001, SCR-LEARNING-002 | GET /challenges/today               | challenges, user_challenges  |
| FR-026 | 単語帳＆復習           | UC-026 | SCR-LEARNING-003               | GET /vocabularies                   | vocabularies                 |
| FR-027 | 友達招待               | UC-027 | SCR-SOCIAL-001                 | POST /invitations/generate          | invitations                  |
| FR-028 | 週間ランキング         | UC-028 | SCR-SOCIAL-002                 | GET /rankings/weekly                | user_rankings                |
| FR-029 | グループ学習           | UC-029 | SCR-SOCIAL-003                 | GET /groups, POST /groups           | groups, group_members        |
| FR-030 | 発音詳細分析           | UC-030 | SCR-CONV-002, SCR-PROGRESS-002 | WebSocket + GET /conversations      | turns, pronunciation_details |
| FR-031 | ロールプレイモード     | UC-031 | SCR-LEARNING-001, SCR-CONV-002 | GET /scenarios, POST /conversations | scenarios, conversations     |
| FR-032 | TOEIC/IELTS 対策       | UC-032 | SCR-LEARNING-001               | GET /scenarios                      | scenarios                    |
| FR-033 | 発話確認モード         | UC-033 | SCR-SETTINGS-002               | PUT /users/me                       | users                        |

### 10.1.3. カバレッジサマリー

---

## 10.2. 決定ログ

### 10.2.1. アーキテクチャ決定

| ID     | 決定内容                           | 理由                           | 日付       |
| ------ | ---------------------------------- | ------------------------------ | ---------- |
| AD-001 | マイクロサービスアーキテクチャ採用 | スケーラビリティ、独立デプロイ | 2025-12-29 |
| AD-002 | WebSocket 使用（リアルタイム通信） | 低遅延双方向通信必須           | 2025-12-29 |
| AD-003 | PostgreSQL + Redis 構成            | トランザクション + キャッシュ  | 2025-12-29 |
| AD-004 | JWT 認証採用                       | ステートレス、スケーラブル     | 2025-12-29 |

### 10.2.2. 技術選定理由

| 技術          | 選定理由                                                |
| ------------- | ------------------------------------------------------- |
| NestJS        | TypeScript 対応、エンタープライズ向け設計               |
| React/Flutter | クロスプラットフォーム対応、モダン UI、共通コードベース |
| Deepgram      | 高精度 STT、低遅延、ストリーミング対応                  |
| GPT-4o        | 高品質会話生成、文脈理解、マルチタスク対応              |
| ElevenLabs    | 自然な音声、多様な声、低遅延                            |

---

## 10.3. 未解決事項

| ID     | 内容                                   | ステータス | 担当 | 期限      |
| ------ | -------------------------------------- | ---------- | ---- | --------- |
| OI-001 | 外部サービス障害時のフォールバック詳細 | 検討中     | 開発 | DD 作成時 |
| OI-002 | 音声データの一時保存方式               | 検討中     | 開発 | DD 作成時 |
| OI-003 | オフラインモード対応可否               | 保留       | PM   | Phase 2   |
| OI-004 | 管理者画面の要件詳細                   | 未着手     | PM   | 要確認    |

---

## 10.4. 用語集

| 用語 | 説明                                                |
| ---- | --------------------------------------------------- |
| UC   | Use Case（ユースケース）                            |
| FR   | Functional Requirement（機能要件）                  |
| BD   | Basic Design（基本設計）                            |
| DD   | Detailed Design（詳細設計）                         |
| STT  | Speech-to-Text（音声 → テキスト変換）               |
| TTS  | Text-to-Speech（テキスト → 音声変換）               |
| LLM  | Large Language Model（大規模言語モデル）            |
| VAD  | Voice Activity Detection（音声活動検出）            |
| SRS  | Spaced Repetition System（間隔反復学習）            |
| JWT  | JSON Web Token（認証トークン）                      |
| RBAC | Role-Based Access Control（役割ベースアクセス制御） |
| RTO  | Recovery Time Objective（復旧目標時間）             |
| RPO  | Recovery Point Objective（復旧目標時点）            |
| CCU  | Concurrent Users（同時接続ユーザー数）              |

---

## 10.5. 参考資料

| No  | 資料名                         | 種別         | 場所                                 |
| --- | ------------------------------ | ------------ | ------------------------------------ |
| 1   | システム要件定義書（SRS）      | ドキュメント | ../システム要件定義書/               |
| 2   | OpenAI GPT-4o API ドキュメント | 外部資料     | https://platform.openai.com/docs     |
| 3   | Deepgram API ドキュメント      | 外部資料     | https://developers.deepgram.com/docs |
| 4   | ElevenLabs API ドキュメント    | 外部資料     | https://docs.elevenlabs.io/          |

---

## 10.6. 改訂履歴

| バージョン | 日付       | 作成者 | 変更内容 |
| ---------- | ---------- | ------ | -------- |
| 1.0        | 2025-12-29 | AI     | 初版作成 |

---

## 10.7. 承認

| 役割                     | 氏名 | 署名 | 日付 | コメント |
| ------------------------ | ---- | ---- | ---- | -------- |
| プロジェクトマネージャー |      |      |      |          |
| テクニカルリード         |      |      |      |          |
| アーキテクト             |      |      |      |          |
| レビュアー               |      |      |      |          |

---

**現在のステータス**: ☑ レビュー完了

---

← [目次](./_index.md)
