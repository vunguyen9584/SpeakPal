# 会話関連テーブル

## T_CONVERSATIONS - 会話セッション

| No  | カラム名            | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                |
| --- | ------------------- | ------------ | ------------ | --- | --- | --- | ---------- | ------------------- |
| 1   | id                  | ID           | UUID         | ○   |     | ○   |            |                     |
| 2   | user_id             | ユーザー ID  | UUID         |     | ○   | ○   |            | FK: users.id        |
| 3   | persona_id          | ペルソナ ID  | UUID         |     | ○   |     |            | FK: personas.id     |
| 4   | scenario_id         | シナリオ ID  | UUID         |     | ○   |     |            | FK: scenarios.id    |
| 5   | mode                | モード       | VARCHAR(20)  |     |     | ○   |            | instructor/freetalk |
| 6   | topic               | トピック     | VARCHAR(100) |     |     |     |            |                     |
| 7   | duration_seconds    | 会話時間(秒) | INTEGER      |     |     |     | 0          |                     |
| 8   | pronunciation_score | 発音スコア   | INTEGER      |     |     |     |            | 0-100               |
| 9   | xp_earned           | 獲得 XP      | INTEGER      |     |     |     | 0          |                     |
| 10  | started_at          | 開始日時     | TIMESTAMP    |     |     | ○   | NOW()      |                     |
| 11  | ended_at            | 終了日時     | TIMESTAMP    |     |     |     |            |                     |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
| -- | -------------------------- | --------------- | ------ |
| 1 | pk_conversations | id | ○ |
| 2 | idx_conversations_user | user_id | |
| 3 | idx_conversations_date | started_at | |

---

## T_CONVERSATION_TURNS - 会話ターン

| No  | カラム名         | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                 |
| --- | ---------------- | ------------ | ------------ | --- | --- | --- | ---------- | -------------------- |
| 1   | id               | ID           | UUID         | ○   |     | ○   |            |                      |
| 2   | conversation_id  | 会話 ID      | UUID         |     | ○   | ○   |            | FK: conversations.id |
| 3   | speaker          | 発話者       | VARCHAR(10)  |     |     | ○   |            | user/ai              |
| 4   | text_content     | テキスト内容 | TEXT         |     |     |     |            |                      |
| 5   | audio_url        | 音声 URL     | VARCHAR(500) |     |     |     |            |                      |
| 6   | confidence_score | 確信度       | DECIMAL(3,2) |     |     |     |            | 0.00-1.00            |
| 7   | sequence_order   | 順序         | INTEGER      |     |     | ○   |            |                      |
| 8   | created_at       | 作成日時     | TIMESTAMP    |     |     | ○   | NOW()      |                      |

---

## T_CORRECTIONS - 訂正履歴

| No  | カラム名       | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                             |
| --- | -------------- | ------------ | ------------ | --- | --- | --- | ---------- | -------------------------------- |
| 1   | id             | ID           | UUID         | ○   |     | ○   |            |                                  |
| 2   | turn_id        | ターン ID    | UUID         |     | ○   | ○   |            | FK: conversation_turns.id        |
| 3   | type           | 種別         | VARCHAR(20)  |     |     | ○   |            | pronunciation/grammar/vocabulary |
| 4   | original_text  | 元テキスト   | VARCHAR(500) |     |     | ○   |            |                                  |
| 5   | corrected_text | 訂正テキスト | VARCHAR(500) |     |     | ○   |            |                                  |
| 6   | explanation    | 説明         | TEXT         |     |     |     |            |                                  |
| 7   | created_at     | 作成日時     | TIMESTAMP    |     |     | ○   | NOW()      |                                  |

---

## T_SUGGESTIONS - 提案履歴

| No  | カラム名   | 論理名       | データ型  | PK  | FK  | NN  | デフォルト | 説明                      |
| --- | ---------- | ------------ | --------- | --- | --- | --- | ---------- | ------------------------- |
| 1   | id         | ID           | UUID      | ○   |     | ○   |            |                           |
| 2   | turn_id    | ターン ID    | UUID      |     | ○   | ○   |            | FK: conversation_turns.id |
| 3   | template   | テンプレート | TEXT      |     |     |     |            |                           |
| 4   | vocabulary | 語彙リスト   | JSONB     |     |     |     |            | ["word1", "word2", ...]   |
| 5   | was_used   | 使用済み     | BOOLEAN   |     |     | ○   | false      |                           |
| 6   | created_at | 作成日時     | TIMESTAMP |     |     | ○   | NOW()      |                           |

---

_関連ファイル: [\_index.md](./_index.md) | [learning-01.md](./learning-01.md)_
_メインファイル: [../05-data-design.md](../05-data-design.md)_
