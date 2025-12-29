# ゲーミフィケーション関連テーブル

## T_STREAKS - ストリーク

| No  | カラム名           | 論理名         | データ型  | PK  | FK  | NN  | デフォルト | 説明             |
| --- | ------------------ | -------------- | --------- | --- | --- | --- | ---------- | ---------------- |
| 1   | id                 | ID             | UUID      | ○   |     | ○   |            |                  |
| 2   | user_id            | ユーザー ID    | UUID      |     | ○   | ○   |            | FK: users.id, UK |
| 3   | current_streak     | 現在ストリーク | INTEGER   |     |     | ○   | 0          |                  |
| 4   | longest_streak     | 最長ストリーク | INTEGER   |     |     | ○   | 0          |                  |
| 5   | last_activity_date | 最終活動日     | DATE      |     |     |     |            |                  |
| 6   | freeze_remaining   | フリーズ残数   | INTEGER   |     |     | ○   | 1          |                  |
| 7   | freeze_used_date   | フリーズ使用日 | DATE      |     |     |     |            |                  |
| 8   | updated_at         | 更新日時       | TIMESTAMP |     |     | ○   | NOW()      |                  |

---

## T_BADGES - バッジ定義

| No  | カラム名       | 論理名       | データ型     | PK  | FK  | NN  | デフォルト | 説明                                         |
| --- | -------------- | ------------ | ------------ | --- | --- | --- | ---------- | -------------------------------------------- |
| 1   | id             | ID           | UUID         | ○   |     | ○   |            |                                              |
| 2   | name           | バッジ名     | VARCHAR(100) |     |     | ○   |            |                                              |
| 3   | description    | 説明         | TEXT         |     |     |     |            |                                              |
| 4   | icon_url       | アイコン URL | VARCHAR(500) |     |     |     |            |                                              |
| 5   | category       | カテゴリ     | VARCHAR(50)  |     |     | ○   |            | streak/conversation/vocabulary/level/special |
| 6   | xp_reward      | XP 報酬      | INTEGER      |     |     | ○   | 0          |                                              |
| 7   | condition_rule | 条件ルール   | JSONB        |     |     | ○   |            |                                              |
| 8   | sort_order     | 表示順       | INTEGER      |     |     | ○   | 0          |                                              |

---

## T_USER_BADGES - ユーザーバッジ

| No  | カラム名  | 論理名      | データ型  | PK  | FK  | NN  | デフォルト | 説明          |
| --- | --------- | ----------- | --------- | --- | --- | --- | ---------- | ------------- |
| 1   | id        | ID          | UUID      | ○   |     | ○   |            |               |
| 2   | user_id   | ユーザー ID | UUID      |     | ○   | ○   |            | FK: users.id  |
| 3   | badge_id  | バッジ ID   | UUID      |     | ○   | ○   |            | FK: badges.id |
| 4   | earned_at | 獲得日時    | TIMESTAMP |     |     | ○   | NOW()      |               |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
| -- | ------------------------- | ------------------ | ------ |
| 1 | uk_user_badges | user_id, badge_id | ○ |

---

## T_SUBSCRIPTIONS - サブスクリプション

| No  | カラム名                 | 論理名         | データ型     | PK  | FK  | NN  | デフォルト | 説明                     |
| --- | ------------------------ | -------------- | ------------ | --- | --- | --- | ---------- | ------------------------ |
| 1   | id                       | ID             | UUID         | ○   |     | ○   |            |                          |
| 2   | user_id                  | ユーザー ID    | UUID         |     | ○   | ○   |            | FK: users.id, UK         |
| 3   | plan                     | プラン         | VARCHAR(20)  |     |     | ○   | 'free'     | free/plus/pro            |
| 4   | daily_conversation_limit | 日次会話上限   | INTEGER      |     |     | ○   |            |                          |
| 5   | daily_usage_count        | 日次使用回数   | INTEGER      |     |     | ○   | 0          |                          |
| 6   | last_reset_date          | 最終リセット日 | DATE         |     |     |     |            |                          |
| 7   | store_product_id         | ストア商品 ID  | VARCHAR(100) |     |     |     |            | App Store/Google Play ID |
| 8   | store_transaction_id     | ストア取引 ID  | VARCHAR(100) |     |     |     |            |                          |
| 9   | started_at               | 開始日時       | TIMESTAMP    |     |     |     |            |                          |
| 10  | expires_at               | 有効期限       | TIMESTAMP    |     |     |     |            |                          |
| 11  | is_active                | 有効フラグ     | BOOLEAN      |     |     | ○   | true       |                          |
| 12  | created_at               | 作成日時       | TIMESTAMP    |     |     | ○   | NOW()      |                          |
| 13  | updated_at               | 更新日時       | TIMESTAMP    |     |     | ○   | NOW()      |                          |

---

_関連ファイル: [\_index.md](./_index.md) | [social-01.md](./social-01.md)_
_メインファイル: [../05-data-design.md](../05-data-design.md)_
