# ユーザー関連テーブル

## T_USERS - ユーザー

| No  | カラム名         | 論理名             | データ型     | PK  | FK  | NN  | デフォルト | 説明                                 |
| --- | ---------------- | ------------------ | ------------ | --- | --- | --- | ---------- | ------------------------------------ |
| 1   | id               | ID                 | UUID         | ○   |     | ○   |            | PRIMARY KEY                          |
| 2   | email            | メールアドレス     | VARCHAR(255) |     |     | ○   |            | UNIQUE                               |
| 3   | username         | ユーザー名         | VARCHAR(50)  |     |     | ○   |            |                                      |
| 4   | password_hash    | パスワードハッシュ | VARCHAR(255) |     |     |     |            | OAuth 時は NULL                      |
| 5   | level            | 学習レベル         | VARCHAR(20)  |     |     | ○   | 'Beginner' | Beginner/Basic/Intermediate/Advanced |
| 6   | total_xp         | 累計 XP            | INTEGER      |     |     | ○   | 0          |                                      |
| 7   | current_level    | 現在レベル         | INTEGER      |     |     | ○   | 1          |                                      |
| 8   | auth_provider    | 認証プロバイダ     | VARCHAR(20)  |     |     |     | 'email'    | email/google/apple                   |
| 9   | auth_provider_id | プロバイダ ID      | VARCHAR(255) |     |     |     |            | OAuth 時の ID                        |
| 10  | is_active        | 有効フラグ         | BOOLEAN      |     |     | ○   | true       |                                      |
| 11  | is_verified      | 認証済みフラグ     | BOOLEAN      |     |     | ○   | false      |                                      |
| 12  | created_at       | 作成日時           | TIMESTAMP    |     |     | ○   | NOW()      |                                      |
| 13  | updated_at       | 更新日時           | TIMESTAMP    |     |     | ○   | NOW()      |                                      |
| 14  | last_login       | 最終ログイン       | TIMESTAMP    |     |     |     |            |                                      |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
| -- | --------------------- | --------------- | ------ |
| 1 | pk_users | id | ○ |
| 2 | uk_users_email | email | ○ |
| 3 | idx_users_auth | auth_provider, auth_provider_id | |

---

## T_USER_LEVELS - ユーザーレベル履歴

| No  | カラム名   | 論理名      | データ型    | PK  | FK  | NN  | デフォルト | 説明         |
| --- | ---------- | ----------- | ----------- | --- | --- | --- | ---------- | ------------ |
| 1   | id         | ID          | UUID        | ○   |     | ○   |            |              |
| 2   | user_id    | ユーザー ID | UUID        |     | ○   | ○   |            | FK: users.id |
| 3   | old_level  | 旧レベル    | VARCHAR(20) |     |     | ○   |            |              |
| 4   | new_level  | 新レベル    | VARCHAR(20) |     |     | ○   |            |              |
| 5   | changed_at | 変更日時    | TIMESTAMP   |     |     | ○   | NOW()      |              |

---

## T_PERSONAS - ペルソナ

| No  | カラム名     | 論理名      | データ型    | PK  | FK  | NN  | デフォルト | 説明                      |
| --- | ------------ | ----------- | ----------- | --- | --- | --- | ---------- | ------------------------- |
| 1   | id           | ID          | UUID        | ○   |     | ○   |            |                           |
| 2   | user_id      | ユーザー ID | UUID        |     | ○   | ○   |            | FK: users.id              |
| 3   | name         | ペルソナ名  | VARCHAR(50) |     |     | ○   |            | ユーザー内で UNIQUE       |
| 4   | voice        | 声          | VARCHAR(20) |     |     | ○   |            | voice_1/voice_2/voice_3   |
| 5   | personality  | 性格        | VARCHAR(20) |     |     | ○   |            | cheerful/strict/sarcastic |
| 6   | target_level | 対象レベル  | VARCHAR(20) |     |     | ○   |            |                           |
| 7   | is_default   | デフォルト  | BOOLEAN     |     |     | ○   | false      |                           |
| 8   | created_at   | 作成日時    | TIMESTAMP   |     |     | ○   | NOW()      |                           |

**INDEX:**
| No | INDEX 名 | カラム | UNIQUE |
| -- | -------------------------- | --------------- | ------ |
| 1 | pk_personas | id | ○ |
| 2 | uk_personas_user_name | user_id, name | ○ |
| 3 | idx_personas_user | user_id | |

---

_関連ファイル: [\_index.md](./_index.md) | [conversation-01.md](./conversation-01.md)_
_メインファイル: [../05-data-design.md](../05-data-design.md)_
