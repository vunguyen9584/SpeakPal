# 7. データベース設計

> 📋 このドキュメントはデータベース設計の概要と各セクションへのリンクを提供します。

---

## 7.1. 概要

### 統計情報

| 項目                     | 数量 |
| ------------------------ | ---- |
| テーブル総数             | 18   |
| マスタテーブル           | 5    |
| トランザクションテーブル | 13   |

### データベース構成

| 項目         | 設定            |
| ------------ | --------------- |
| RDBMS        | PostgreSQL 15.x |
| 文字コード   | UTF-8           |
| 照合順序     | en_US.UTF-8     |
| タイムゾーン | UTC             |

---

## 7.2. 目次

| セクション | ファイル                                                            | 内容                    |
| ---------- | ------------------------------------------------------------------- | ----------------------- |
| 7.3        | [ER 図](./07-database-design/01-er-diagram.md)                      | エンティティ関係図      |
| 7.4        | [ユーザー系](./07-database-design/user-tables.md)                   | users, personas 等      |
| 7.5        | [会話系](./07-database-design/conversation-tables.md)               | conversations, turns 等 |
| 7.6        | [学習系](./07-database-design/learning-tables.md)                   | vocabularies 等         |
| 7.7        | [ゲーミフィケーション](./07-database-design/gamification-tables.md) | streaks, badges 等      |
| 7.8        | [ソーシャル系](./07-database-design/social-tables.md)               | invitations, groups 等  |

---

## 7.3. ER 図

```mermaid
erDiagram
    USERS ||--o{ PERSONAS : has
    USERS ||--|| SUBSCRIPTIONS : has
    USERS ||--|| STREAKS : has
    USERS ||--o{ USER_BADGES : earns
    USERS ||--o{ CONVERSATIONS : participates
    USERS ||--o{ VOCABULARIES : saves
    USERS ||--o{ USER_CHALLENGES : attempts
    USERS ||--o{ INVITATIONS : sends
    USERS ||--o{ GROUP_MEMBERS : joins

    CONVERSATIONS ||--o{ CONVERSATION_TURNS : contains
    CONVERSATION_TURNS ||--o{ CORRECTIONS : has

    BADGES ||--o{ USER_BADGES : awarded_to

    SCENARIOS ||--o{ CONVERSATIONS : used_in
    CHALLENGES ||--o{ USER_CHALLENGES : assigned_to

    GROUPS ||--o{ GROUP_MEMBERS : has

    USERS {
        uuid id PK
        string email UK
        string username
        string password_hash
        enum level
        int total_xp
        int current_level_xp
        enum league
        float ai_speed
        bool confirmation_mode
        bool is_verified
        timestamp last_login_at
        timestamp created_at
        timestamp updated_at
    }

    PERSONAS {
        uuid id PK
        uuid user_id FK
        string name
        enum voice
        enum personality
        enum target_level
        bool is_default
        timestamp created_at
    }

    SUBSCRIPTIONS {
        uuid id PK
        uuid user_id FK
        enum plan
        int daily_usage_count
        int daily_usage_limit
        date last_reset_date
        timestamp expires_at
        timestamp created_at
    }

    CONVERSATIONS {
        uuid id PK
        uuid user_id FK
        uuid persona_id FK
        uuid scenario_id FK
        enum mode
        string topic
        int duration_seconds
        int pronunciation_score
        int xp_earned
        text summary
        timestamp started_at
        timestamp ended_at
    }

    CONVERSATION_TURNS {
        uuid id PK
        uuid conversation_id FK
        enum speaker
        text content
        text audio_url
        int sequence
        timestamp created_at
    }

    CORRECTIONS {
        uuid id PK
        uuid turn_id FK
        enum type
        string original_text
        string corrected_text
        string explanation
        enum severity
    }

    VOCABULARIES {
        uuid id PK
        uuid user_id FK
        uuid conversation_id FK
        string word
        string meaning
        string pronunciation
        text example_sentence
        enum srs_level
        date next_review_date
        timestamp created_at
    }

    STREAKS {
        uuid id PK
        uuid user_id FK
        int current_streak
        int longest_streak
        int freeze_remaining
        date last_activity_date
    }

    BADGES {
        uuid id PK
        string code UK
        string name
        text description
        string icon_url
        int xp_bonus
        jsonb condition
    }

    USER_BADGES {
        uuid id PK
        uuid user_id FK
        uuid badge_id FK
        timestamp earned_at
    }

    SCENARIOS {
        uuid id PK
        string title
        text description
        enum category
        enum difficulty
        jsonb initial_context
        bool is_active
    }

    CHALLENGES {
        uuid id PK
        enum type
        string title
        text description
        jsonb condition
        int xp_reward
        bool is_active
    }

    USER_CHALLENGES {
        uuid id PK
        uuid user_id FK
        uuid challenge_id FK
        date assigned_date
        enum status
        timestamp completed_at
    }

    INVITATIONS {
        uuid id PK
        uuid sender_id FK
        uuid receiver_id FK
        string code UK
        enum status
        int bonus_xp
        timestamp created_at
        timestamp used_at
    }

    GROUPS {
        uuid id PK
        string name
        uuid owner_id FK
        int max_members
        bool is_active
        timestamp created_at
    }

    GROUP_MEMBERS {
        uuid id PK
        uuid group_id FK
        uuid user_id FK
        enum role
        timestamp joined_at
    }

    USER_RANKINGS {
        uuid id PK
        uuid user_id FK
        int week_number
        int year
        enum league
        int weekly_xp
        int rank
        enum change
    }

    NOTIFICATION_SETTINGS {
        uuid id PK
        uuid user_id FK
        bool push_enabled
        bool email_enabled
        bool streak_reminder
        bool weekly_report
        bool monthly_report
        time reminder_time
    }
```

---

## 7.4. 共通カラム規約

### 型規約

| 論理型     | PostgreSQL 型            | 説明             |
| ---------- | ------------------------ | ---------------- |
| ID         | UUID                     | PRIMARY KEY      |
| 外部キー   | UUID                     | REFERENCES       |
| 文字列(短) | VARCHAR(n)               | 長さ制限あり     |
| 文字列(長) | TEXT                     | 長さ制限なし     |
| 列挙型     | VARCHAR(50)              | アプリ層で制約   |
| 数値       | INTEGER                  | 32 ビット整数    |
| 小数       | NUMERIC(10,2)            | 金額等           |
| 真偽値     | BOOLEAN                  | true/false       |
| 日付       | DATE                     | 日付のみ         |
| 日時       | TIMESTAMP WITH TIME ZONE | タイムゾーン付き |
| JSON       | JSONB                    | バイナリ JSON    |

### 共通カラム

| カラム名   | 型                       | 必須 | 説明             |
| ---------- | ------------------------ | ---- | ---------------- |
| id         | UUID                     | ○    | 主キー           |
| created_at | TIMESTAMP WITH TIME ZONE | ○    | 作成日時（自動） |
| updated_at | TIMESTAMP WITH TIME ZONE | -    | 更新日時（自動） |

---

## 7.5. インデックス戦略

### インデックス種別

| 種別        | 用途               | 対象例                |
| ----------- | ------------------ | --------------------- |
| PRIMARY KEY | 主キー             | id                    |
| UNIQUE      | 一意制約           | email, code           |
| B-tree      | 範囲検索、等価検索 | user_id, created_at   |
| GIN         | JSONB 検索         | condition             |
| 複合        | 複数カラム検索     | (user_id, created_at) |

### 主要インデックス一覧

| テーブル        | インデックス名                 | カラム                    |
| --------------- | ------------------------------ | ------------------------- |
| users           | idx_users_email                | email                     |
| conversations   | idx_conversations_user_started | user_id, started_at DESC  |
| vocabularies    | idx_vocabularies_user_review   | user_id, next_review_date |
| user_challenges | idx_user_challenges_user_date  | user_id, assigned_date    |
| user_rankings   | idx_user_rankings_week_league  | week_number, year, league |

---

## 7.6. パーティショニング

### 対象テーブル

| テーブル           | パーティション方式 | キー       | 保持期間 |
| ------------------ | ------------------ | ---------- | -------- |
| conversations      | RANGE (月次)       | started_at | 12 ヶ月  |
| conversation_turns | RANGE (月次)       | created_at | 6 ヶ月   |
| user_rankings      | RANGE (年次)       | year       | 3 年     |

### パーティション DDL 例

```sql
-- 月次パーティション
CREATE TABLE conversations (
    id UUID NOT NULL,
    user_id UUID NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL,
    ...
) PARTITION BY RANGE (started_at);

-- 2025年1月パーティション
CREATE TABLE conversations_2025_01
    PARTITION OF conversations
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

---

## 7.7. マイグレーション戦略

### ツール

| ツール | 用途                           |
| ------ | ------------------------------ |
| Prisma | スキーマ管理、マイグレーション |

### 命名規則

```
YYYYMMDDHHMMSS_description.sql
例: 20251229120000_create_users_table.sql
```

### ロールバック

```bash
# マイグレーション実行
npx prisma migrate deploy

# ロールバック（手動）
npx prisma migrate resolve --rolled-back MIGRATION_NAME
```

---

← [目次](./_index.md) | _次のセクション: [08-api-design.md](./08-api-design.md)_
