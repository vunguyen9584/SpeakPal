# ソーシャル関連テーブル

## T_INVITATIONS - 招待

| No  | カラム名     | 論理名      | データ型    | PK  | FK  | NN  | デフォルト | 説明              |
| --- | ------------ | ----------- | ----------- | --- | --- | --- | ---------- | ----------------- |
| 1   | id           | ID          | UUID        | ○   |     | ○   |            |                   |
| 2   | inviter_id   | 招待者 ID   | UUID        |     | ○   | ○   |            | FK: users.id      |
| 3   | invite_code  | 招待コード  | VARCHAR(20) |     |     | ○   |            | UNIQUE            |
| 4   | invitee_id   | 被招待者 ID | UUID        |     | ○   |     |            | FK: users.id      |
| 5   | status       | ステータス  | VARCHAR(20) |     |     | ○   | 'pending'  | pending/completed |
| 6   | xp_rewarded  | XP 付与済み | BOOLEAN     |     |     | ○   | false      |                   |
| 7   | created_at   | 作成日時    | TIMESTAMP   |     |     | ○   | NOW()      |                   |
| 8   | completed_at | 完了日時    | TIMESTAMP   |     |     |     |            |                   |

---

## T_GROUPS - グループ

| No  | カラム名    | 論理名      | データ型     | PK  | FK  | NN  | デフォルト | 説明         |
| --- | ----------- | ----------- | ------------ | --- | --- | --- | ---------- | ------------ |
| 1   | id          | ID          | UUID         | ○   |     | ○   |            |              |
| 2   | name        | グループ名  | VARCHAR(100) |     |     | ○   |            |              |
| 3   | owner_id    | オーナー ID | UUID         |     | ○   | ○   |            | FK: users.id |
| 4   | invite_code | 招待コード  | VARCHAR(20)  |     |     | ○   |            | UNIQUE       |
| 5   | max_members | 最大人数    | INTEGER      |     |     | ○   | 20         |              |
| 6   | is_active   | 有効フラグ  | BOOLEAN      |     |     | ○   | true       |              |
| 7   | created_at  | 作成日時    | TIMESTAMP    |     |     | ○   | NOW()      |              |

---

## T_GROUP_MEMBERS - グループメンバー

| No  | カラム名  | 論理名      | データ型    | PK  | FK  | NN  | デフォルト | 説明               |
| --- | --------- | ----------- | ----------- | --- | --- | --- | ---------- | ------------------ |
| 1   | id        | ID          | UUID        | ○   |     | ○   |            |                    |
| 2   | group_id  | グループ ID | UUID        |     | ○   | ○   |            | FK: groups.id      |
| 3   | user_id   | ユーザー ID | UUID        |     | ○   | ○   |            | FK: users.id       |
| 4   | role      | 役割        | VARCHAR(20) |     |     | ○   | 'member'   | owner/admin/member |
| 5   | joined_at | 参加日時    | TIMESTAMP   |     |     | ○   | NOW()      |                    |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
| -- | ------------------------- | ------------------ | ------ |
| 1 | uk_group_members | group_id, user_id | ○ |

---

_関連ファイル: [\_index.md](./_index.md) | [user-01.md](./user-01.md)_
_メインファイル: [../05-data-design.md](../05-data-design.md)_
