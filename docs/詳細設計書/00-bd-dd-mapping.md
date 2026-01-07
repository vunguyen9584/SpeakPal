# 0. BD-DD マッピング

> 📌 このファイルは基本設計(BD)の全要素が詳細設計(DD)のどこで設計されるかをマッピングします。
> 100%カバレッジが必須です。

---

## 0.1. 概要

### 統計情報

| 項目          | 数量 | カバレッジ |
| ------------- | ---- | ---------- |
| ユースケース  | 38   | 100%       |
| 画面          | 24   | 100%       |
| テーブル      | 23   | 100%       |
| REST API      | 57   | 100%       |
| WebSocket API | 10   | 100%       |
| バッチ        | 8    | 100%       |
| **合計**      | 160  | **100%**   |

---

## 0.2. ユースケース → DD マッピング

### 0.2.1. 会話モジュール (UC-001 ～ UC-010)

| UC ID  | UC 名              | DD セクション               | ファイル            |
| ------ | ------------------ | --------------------------- | ------------------- |
| UC-001 | モード切替         | 06-component-design         | conversation-01.md  |
| UC-002 | トピック選択       | 06-component-design         | conversation-01.md  |
| UC-003 | リアルタイム会話   | 06-component-design, 08-api | conversation-01.md  |
| UC-004 | スマート提案表示   | 06-component-design         | feedback-01.md      |
| UC-005 | ストリーミング字幕 | 06-component-design         | conversation-01.md  |
| UC-006 | 即時訂正           | 06-component-design         | feedback-01.md      |
| UC-007 | AI 速度調整        | 06-component-design, 09-ui  | customization-01.md |
| UC-008 | ペルソナ作成       | 06-component-design         | customization-01.md |
| UC-009 | 会話割り込み       | 06-component-design         | conversation-01.md  |
| UC-010 | 発声確認モード     | 06-component-design         | conversation-01.md  |

### 0.2.2. ユーザー・認証モジュール (UC-011 ～ UC-016)

| UC ID  | UC 名                  | DD セクション               | ファイル           |
| ------ | ---------------------- | --------------------------- | ------------------ |
| UC-011 | ユーザー登録           | 06-component-design, 10-sec | user-01.md         |
| UC-012 | ログイン/認証          | 06-component-design, 10-sec | user-01.md         |
| UC-013 | パスワード変更         | 06-component-design         | user-01.md         |
| UC-014 | サブスクリプション管理 | 06-component-design         | subscription-01.md |
| UC-015 | 利用量制限             | 06-component-design         | subscription-01.md |
| UC-016 | プラン変更             | 06-component-design         | subscription-01.md |

### 0.2.3. 学習モジュール (UC-017 ～ UC-026)

| UC ID  | UC 名                | DD セクション               | ファイル           |
| ------ | -------------------- | --------------------------- | ------------------ |
| UC-017 | 語彙説明             | 06-component-design         | learning-01.md     |
| UC-018 | 学習ストリーク       | 06-component-design         | gamification-01.md |
| UC-019 | アチーブメントバッジ | 06-component-design         | gamification-01.md |
| UC-020 | 経験値/レベル        | 06-component-design         | gamification-01.md |
| UC-021 | 統計ダッシュボード   | 06-component-design, 09-ui  | progress-01.md     |
| UC-022 | 発音スコア履歴       | 06-component-design         | progress-01.md     |
| UC-023 | 週間/月間レポート    | 06-component-design (Batch) | progress-01.md     |
| UC-024 | シナリオライブラリ   | 06-component-design         | learning-01.md     |
| UC-025 | デイリーチャレンジ   | 06-component-design         | learning-01.md     |
| UC-026 | 単語帳＆復習         | 06-component-design         | learning-01.md     |

### 0.2.4. ソーシャル・上級モジュール (UC-027 ～ UC-033)

| UC ID  | UC 名              | DD セクション       | ファイル           |
| ------ | ------------------ | ------------------- | ------------------ |
| UC-027 | 友達招待           | 06-component-design | social-01.md       |
| UC-028 | 週間ランキング     | 06-component-design | social-01.md       |
| UC-029 | グループ学習       | 06-component-design | social-01.md       |
| UC-030 | 発音詳細分析       | 06-component-design | advanced-01.md     |
| UC-031 | ロールプレイモード | 06-component-design | advanced-01.md     |
| UC-032 | TOEIC/IELTS 対策   | 06-component-design | advanced-01.md     |
| UC-033 | 会話サマリー       | 06-component-design | conversation-01.md |

### 0.2.5. 翻訳練習モジュール (UC-034 ～ UC-038)

| UC ID  | UC 名                | DD セクション               | ファイル          |
| ------ | -------------------- | --------------------------- | ----------------- |
| UC-034 | ダイレクト翻訳練習   | 06-component-design, 08-api | translation-01.md |
| UC-035 | 高度意図翻訳練習     | 06-component-design, 08-api | translation-01.md |
| UC-036 | ワード連想チャレンジ | 06-component-design, 08-api | translation-02.md |
| UC-037 | 瞬間応答ドリル       | 06-component-design, 08-api | translation-02.md |
| UC-038 | シャドーイング練習   | 06-component-design, 08-api | translation-02.md |

### 0.2.6. UC カバレッジサマリー

| カテゴリ   | UC 数  | カバー済み | カバレッジ |
| ---------- | ------ | ---------- | ---------- |
| 会話       | 10     | 10         | 100%       |
| ユーザー   | 6      | 6          | 100%       |
| 学習       | 10     | 10         | 100%       |
| ソーシャル | 7      | 7          | 100%       |
| 翻訳練習   | 5      | 5          | 100%       |
| **合計**   | **38** | **38**     | **100%**   |

---

## 0.3. 画面 → DD マッピング

| SCR ID  | 画面名             | DD セクション        | ファイル                |
| ------- | ------------------ | -------------------- | ----------------------- |
| SCR-001 | スプラッシュ       | 09-ui-specifications | auth-screens.md         |
| SCR-002 | オンボーディング   | 09-ui-specifications | auth-screens.md         |
| SCR-003 | ログイン           | 09-ui-specifications | auth-screens.md         |
| SCR-004 | 新規登録           | 09-ui-specifications | auth-screens.md         |
| SCR-005 | ホーム             | 09-ui-specifications | home-01.md              |
| SCR-006 | 会話選択           | 09-ui-specifications | conversation-screens.md |
| SCR-007 | 会話画面           | 09-ui-specifications | conversation-screens.md |
| SCR-008 | 会話結果           | 09-ui-specifications | conversation-screens.md |
| SCR-009 | プロフィール       | 09-ui-specifications | settings-01.md          |
| SCR-010 | 設定               | 09-ui-specifications | settings-01.md          |
| SCR-011 | サブスクリプション | 09-ui-specifications | settings-01.md          |
| SCR-012 | 通知設定           | 09-ui-specifications | settings-01.md          |
| SCR-013 | 統計ダッシュボード | 09-ui-specifications | progress-screens.md     |
| SCR-014 | バッジコレクション | 09-ui-specifications | progress-screens.md     |
| SCR-015 | 週間/月間レポート  | 09-ui-specifications | progress-screens.md     |
| SCR-016 | 単語帳             | 09-ui-specifications | learning-01.md          |
| SCR-017 | 復習クイズ         | 09-ui-specifications | learning-01.md          |
| SCR-018 | デイリーチャレンジ | 09-ui-specifications | learning-01.md          |
| SCR-019 | 友達招待           | 09-ui-specifications | social-01.md            |
| SCR-020 | ランキング         | 09-ui-specifications | social-01.md            |
| SCR-021 | ダイレクト翻訳     | 09-ui-specifications | translation-screens.md  |
| SCR-022 | 高度意図翻訳       | 09-ui-specifications | translation-screens.md  |
| SCR-023 | クイックレスポンス | 09-ui-specifications | translation-screens.md  |
| SCR-024 | シャドーイング     | 09-ui-specifications | translation-screens.md  |

### 画面カバレッジサマリー

| カテゴリ   | 画面数 | カバー済み | カバレッジ |
| ---------- | ------ | ---------- | ---------- |
| 認証       | 4      | 4          | 100%       |
| ホーム     | 1      | 1          | 100%       |
| 会話       | 3      | 3          | 100%       |
| 設定       | 4      | 4          | 100%       |
| 進捗       | 3      | 3          | 100%       |
| 学習       | 3      | 3          | 100%       |
| ソーシャル | 2      | 2          | 100%       |
| 翻訳練習   | 4      | 4          | 100%       |
| **合計**   | **24** | **24**     | **100%**   |

---

## 0.4. テーブル → DD マッピング

| テーブル名             | DD セクション      | ファイル               |
| ---------------------- | ------------------ | ---------------------- |
| users                  | 07-database-design | user-tables.md         |
| user_levels            | 07-database-design | user-tables.md         |
| personas               | 07-database-design | user-tables.md         |
| subscriptions          | 07-database-design | user-tables.md         |
| conversations          | 07-database-design | conversation-tables.md |
| conversation_turns     | 07-database-design | conversation-tables.md |
| corrections            | 07-database-design | conversation-tables.md |
| vocabularies           | 07-database-design | learning-tables.md     |
| scenarios              | 07-database-design | learning-tables.md     |
| user_challenges        | 07-database-design | learning-tables.md     |
| streaks                | 07-database-design | gamification-tables.md |
| badges                 | 07-database-design | gamification-tables.md |
| user_badges            | 07-database-design | gamification-tables.md |
| user_rankings          | 07-database-design | gamification-tables.md |
| invitations            | 07-database-design | social-tables.md       |
| groups                 | 07-database-design | social-tables.md       |
| group_members          | 07-database-design | social-tables.md       |
| notification_settings  | 07-database-design | user-tables.md         |
| translation_questions  | 07-database-design | translation-tables.md  |
| translation_results    | 07-database-design | translation-tables.md  |
| intent_questions       | 07-database-design | translation-tables.md  |
| shadowing_contents     | 07-database-design | translation-tables.md  |
| quick_response_results | 07-database-design | translation-tables.md  |

### テーブルカバレッジサマリー

| カテゴリ             | テーブル数 | カバー済み | カバレッジ |
| -------------------- | ---------- | ---------- | ---------- |
| ユーザー系           | 5          | 5          | 100%       |
| 会話系               | 3          | 3          | 100%       |
| 学習系               | 3          | 3          | 100%       |
| ゲーミフィケーション | 4          | 4          | 100%       |
| ソーシャル系         | 3          | 3          | 100%       |
| 翻訳練習系           | 5          | 5          | 100%       |
| **合計**             | **23**     | **23**     | **100%**   |

---

## 0.5. API → DD マッピング

### 0.5.1. REST API (57 APIs)

| カテゴリ             | API 数 | DD セクション | ファイル             |
| -------------------- | ------ | ------------- | -------------------- |
| 認証 API             | 7      | 08-api-design | auth-apis.md         |
| ユーザー API         | 5      | 08-api-design | user-apis.md         |
| ペルソナ API         | 6      | 08-api-design | user-apis.md         |
| 会話 API             | 5      | 08-api-design | conversation-apis.md |
| 学習 API             | 7      | 08-api-design | learning-apis.md     |
| ゲーミフィケーション | 5      | 08-api-design | gamification-apis.md |
| サブスクリプション   | 3      | 08-api-design | subscription-apis.md |
| ソーシャル API       | 4      | 08-api-design | social-apis.md       |
| 翻訳練習 API         | 15     | 08-api-design | translation-apis.md  |

### 0.5.2. WebSocket API (10 Events)

| イベント名        | DD セクション | ファイル          |
| ----------------- | ------------- | ----------------- |
| connection        | 08-api-design | websocket-apis.md |
| audio_stream      | 08-api-design | websocket-apis.md |
| text_result       | 08-api-design | websocket-apis.md |
| ai_response_start | 08-api-design | websocket-apis.md |
| ai_response_audio | 08-api-design | websocket-apis.md |
| ai_response_end   | 08-api-design | websocket-apis.md |
| correction        | 08-api-design | websocket-apis.md |
| suggestion        | 08-api-design | websocket-apis.md |
| interrupt         | 08-api-design | websocket-apis.md |
| disconnect        | 08-api-design | websocket-apis.md |

### 0.5.3. API カバレッジサマリー

| タイプ        | API 数 | カバー済み | カバレッジ |
| ------------- | ------ | ---------- | ---------- |
| REST API      | 57     | 57         | 100%       |
| WebSocket API | 10     | 10         | 100%       |
| **合計**      | **67** | **67**     | **100%**   |

---

## 0.6. バッチ → DD マッピング

| Batch ID | バッチ名               | DD セクション       | ファイル    |
| -------- | ---------------------- | ------------------- | ----------- |
| BAT-001  | 日次利用量リセット     | 06-component-design | batch-01.md |
| BAT-002  | ストリーク判定         | 06-component-design | batch-01.md |
| BAT-003  | デイリーチャレンジ生成 | 06-component-design | batch-01.md |
| BAT-004  | 復習語彙リマインダー   | 06-component-design | batch-01.md |
| BAT-005  | 統計データ集計         | 06-component-design | batch-01.md |
| BAT-006  | 週間ランキング更新     | 06-component-design | batch-01.md |
| BAT-007  | 週間レポート送信       | 06-component-design | batch-01.md |
| BAT-008  | 月間レポート送信       | 06-component-design | batch-01.md |

### バッチカバレッジサマリー

| 頻度     | バッチ数 | カバー済み | カバレッジ |
| -------- | -------- | ---------- | ---------- |
| 日次     | 5        | 5          | 100%       |
| 週次     | 2        | 2          | 100%       |
| 月次     | 1        | 1          | 100%       |
| **合計** | **8**    | **8**      | **100%**   |

---

## 0.7. 総合カバレッジサマリー

| 要素タイプ    | BD 総数 | DD カバー | カバレッジ | ステータス |
| ------------- | ------- | --------- | ---------- | ---------- |
| ユースケース  | 38      | 38        | 100%       | ✅ PASS    |
| 画面          | 24      | 24        | 100%       | ✅ PASS    |
| テーブル      | 23      | 23        | 100%       | ✅ PASS    |
| REST API      | 57      | 57        | 100%       | ✅ PASS    |
| WebSocket API | 10      | 10        | 100%       | ✅ PASS    |
| バッチ        | 8       | 8         | 100%       | ✅ PASS    |
| **合計**      | **160** | **160**   | **100%**   | ✅ PASS    |

---

## 0.8. DD ファイル構成予定

```
詳細設計書/
├── _index.md                      # 目次
├── dd-progress.md                 # 進捗トラッカー
├── 00-bd-dd-mapping.md            # このファイル
├── 01-introduction.md             # 導入
├── 02-references-terminology.md   # 参考資料・用語
├── 03-system-overview.md          # システム概要
├── 04-design-considerations.md    # 設計考慮事項
├── 05-module-design.md            # モジュール設計
├── 05-module-design/
│   ├── auth-module.md
│   ├── user-module.md
│   ├── conversation-module.md
│   └── ...
├── 06-component-design.md         # コンポーネント設計
├── 06-component-design/
│   ├── conversation-01.md
│   ├── feedback-01.md
│   ├── customization-01.md
│   ├── user-01.md
│   ├── subscription-01.md
│   ├── learning-01.md
│   ├── gamification-01.md
│   ├── progress-01.md
│   ├── social-01.md
│   ├── advanced-01.md
│   └── batch-01.md
├── 07-database-design.md          # データベース設計
├── 07-database-design/
│   ├── 01-er-diagram.md
│   ├── user-tables.md
│   ├── conversation-tables.md
│   ├── learning-tables.md
│   ├── gamification-tables.md
│   └── social-tables.md
├── 08-api-design.md               # API設計
├── 08-api-design/
│   ├── auth-apis.md
│   ├── user-apis.md
│   ├── conversation-apis.md
│   ├── learning-apis.md
│   ├── gamification-apis.md
│   ├── subscription-apis.md
│   ├── social-apis.md
│   └── websocket-apis.md
├── 09-ui-specifications.md        # UI仕様
├── 09-ui-specifications/
│   ├── auth-01.md
│   ├── home-01.md
│   ├── conversation-01.md
│   ├── settings-01.md
│   ├── progress-01.md
│   ├── learning-01.md
│   └── social-01.md
├── 10-security-design.md          # セキュリティ設計
├── 11-error-handling.md           # エラー処理設計
├── 12-logging-monitoring.md       # ログ・監視設計
├── 13-deployment-design.md        # デプロイ設計
├── 14-appendices.md               # 付録
└── 15-checklist-results.md        # チェックリスト結果
```

---

← [目次](./_index.md) | _次のセクション: [01-introduction.md](./01-introduction.md)_
