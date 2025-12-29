# 学習関連テーブル

## T_VOCABULARIES - 語彙/単語帳

| No  | カラム名         | 論理名      | データ型     | PK  | FK  | NN  | デフォルト | 説明                         |
| --- | ---------------- | ----------- | ------------ | --- | --- | --- | ---------- | ---------------------------- |
| 1   | id               | ID          | UUID         | ○   |     | ○   |            |                              |
| 2   | user_id          | ユーザー ID | UUID         |     | ○   | ○   |            | FK: users.id                 |
| 3   | turn_id          | ターン ID   | UUID         |     | ○   |     |            | FK: conversation_turns.id    |
| 4   | word             | 単語        | VARCHAR(100) |     |     | ○   |            |                              |
| 5   | meaning          | 意味        | VARCHAR(255) |     |     | ○   |            |                              |
| 6   | pronunciation    | 発音記号    | VARCHAR(100) |     |     |     |            |                              |
| 7   | example_sentence | 例文        | TEXT         |     |     |     |            |                              |
| 8   | srs_level        | SRS レベル  | VARCHAR(20)  |     |     | ○   | 'new'      | new/learning/review/mastered |
| 9   | next_review_date | 次回復習日  | DATE         |     |     |     |            |                              |
| 10  | review_count     | 復習回数    | INTEGER      |     |     | ○   | 0          |                              |
| 11  | correct_count    | 正解回数    | INTEGER      |     |     | ○   | 0          |                              |
| 12  | created_at       | 作成日時    | TIMESTAMP    |     |     | ○   | NOW()      |                              |
| 13  | updated_at       | 更新日時    | TIMESTAMP    |     |     | ○   | NOW()      |                              |

---

## T_SCENARIOS - シナリオ

| No  | カラム名         | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                      |
| --- | ---------------- | ------------ | ------------ | --- | --- | --- | ---------- | ------------------------- |
| 1   | id               | ID           | UUID         | ○   |     | ○   |            |                           |
| 2   | name             | シナリオ名   | VARCHAR(100) |     |     | ○   |            |                           |
| 3   | description      | 説明         | TEXT         |     |     |     |            |                           |
| 4   | category         | カテゴリ     | VARCHAR(50)  |     |     | ○   |            | travel/business/daily/etc |
| 5   | difficulty_level | 難易度       | VARCHAR(20)  |     |     | ○   |            | Beginner/Basic/etc        |
| 6   | prompt_template  | プロンプト   | TEXT         |     |     | ○   |            | AI への指示テンプレート   |
| 7   | is_premium       | プレミアム   | BOOLEAN      |     |     | ○   | false      |                           |
| 8   | is_roleplay      | ロールプレイ | BOOLEAN      |     |     | ○   | false      |                           |
| 9   | rating           | 評価         | DECIMAL(2,1) |     |     |     |            | 1.0-5.0                   |
| 10  | play_count       | 利用回数     | INTEGER      |     |     | ○   | 0          |                           |
| 11  | created_at       | 作成日時     | TIMESTAMP    |     |     | ○   | NOW()      |                           |

---

## T_CHALLENGES - チャレンジ定義

| No  | カラム名    | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                        |
| --- | ----------- | ------------ | ------------ | --- | --- | --- | ---------- | --------------------------- |
| 1   | id          | ID           | UUID         | ○   |     | ○   |            |                             |
| 2   | name        | チャレンジ名 | VARCHAR(100) |     |     | ○   |            |                             |
| 3   | description | 説明         | TEXT         |     |     |     |            |                             |
| 4   | type        | 種別         | VARCHAR(50)  |     |     | ○   |            | conversation/vocabulary/etc |
| 5   | condition   | 達成条件     | JSONB        |     |     | ○   |            |                             |
| 6   | xp_reward   | XP 報酬      | INTEGER      |     |     | ○   |            |                             |
| 7   | is_active   | 有効フラグ   | BOOLEAN      |     |     | ○   | true       |                             |

---

## T_USER_CHALLENGES - ユーザーチャレンジ

| No  | カラム名      | 論理名        | データ型    | PK  | FK  | NN  | デフォルト | 説明                      |
| --- | ------------- | ------------- | ----------- | --- | --- | --- | ---------- | ------------------------- |
| 1   | id            | ID            | UUID        | ○   |     | ○   |            |                           |
| 2   | user_id       | ユーザー ID   | UUID        |     | ○   | ○   |            | FK: users.id              |
| 3   | challenge_id  | チャレンジ ID | UUID        |     | ○   | ○   |            | FK: challenges.id         |
| 4   | assigned_date | 割当日        | DATE        |     |     | ○   |            |                           |
| 5   | status        | ステータス    | VARCHAR(20) |     |     | ○   | 'pending'  | pending/completed/expired |
| 6   | completed_at  | 完了日時      | TIMESTAMP   |     |     |     |            |                           |

---

_関連ファイル: [\_index.md](./_index.md) | [gamification-01.md](./gamification-01.md)_
_メインファイル: [../05-data-design.md](../05-data-design.md)_
