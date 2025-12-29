# データ設計 - 共通仕様

## 1. 概要

このフォルダには、SpeakPal AI のデータベース設計詳細が含まれています。

---

## 2. ER 図（詳細）

```mermaid
erDiagram
    users {
        uuid id PK
        string email UK
        string username
        string password_hash
        string level
        int total_xp
        int current_level
        boolean is_active
        timestamp created_at
        timestamp updated_at
        timestamp last_login
    }

    personas {
        uuid id PK
        uuid user_id FK
        string name
        string voice
        string personality
        string target_level
        boolean is_default
        timestamp created_at
    }

    conversations {
        uuid id PK
        uuid user_id FK
        uuid persona_id FK
        uuid scenario_id FK
        string mode
        string topic
        int duration_seconds
        int pronunciation_score
        int xp_earned
        timestamp started_at
        timestamp ended_at
    }

    conversation_turns {
        uuid id PK
        uuid conversation_id FK
        string speaker
        text text_content
        string audio_url
        float confidence_score
        int sequence_order
        timestamp created_at
    }

    corrections {
        uuid id PK
        uuid turn_id FK
        string type
        string original_text
        string corrected_text
        text explanation
    }

    vocabularies {
        uuid id PK
        uuid user_id FK
        uuid turn_id FK
        string word
        string meaning
        string pronunciation
        text example_sentence
        string srs_level
        date next_review_date
        timestamp created_at
    }

    streaks {
        uuid id PK
        uuid user_id FK
        int current_streak
        int longest_streak
        date last_activity_date
        int freeze_remaining
    }

    badges {
        uuid id PK
        string name
        string description
        string icon_url
        string category
        int xp_reward
        jsonb condition_rule
    }

    user_badges {
        uuid id PK
        uuid user_id FK
        uuid badge_id FK
        timestamp earned_at
    }

    subscriptions {
        uuid id PK
        uuid user_id FK
        string plan
        int daily_conversation_limit
        int daily_usage_count
        date last_reset_date
        timestamp started_at
        timestamp expires_at
        boolean is_active
    }

    users ||--o{ personas : "creates"
    users ||--o{ conversations : "has"
    users ||--o{ vocabularies : "saves"
    users ||--|| streaks : "has"
    users ||--o{ user_badges : "earns"
    users ||--|| subscriptions : "has"
    conversations ||--|{ conversation_turns : "contains"
    conversation_turns ||--o{ corrections : "has"
    badges ||--o{ user_badges : "awarded"
```

---

## 3. 共通カラム

すべてのテーブルに以下の共通カラムを含めます：

| カラム名   | データ型  | 説明             |
| ---------- | --------- | ---------------- |
| id         | UUID      | プライマリキー   |
| created_at | TIMESTAMP | 作成日時         |
| updated_at | TIMESTAMP | 更新日時（一部） |

---

## 4. 命名規則

| 対象           | 規則                    | 例                   |
| -------------- | ----------------------- | -------------------- |
| テーブル名     | スネークケース複数形    | users, conversations |
| カラム名       | スネークケース          | user_id, created_at  |
| プライマリキー | id                      | id                   |
| 外部キー       | {テーブル}\_id          | user_id, persona_id  |
| インデックス   | idx*{テーブル}*{カラム} | idx_users_email      |

---

## 5. データ型マッピング

| 論理型 | PostgreSQL        | 説明                 |
| ------ | ----------------- | -------------------- |
| ID     | UUID              | 一意識別子           |
| 文字列 | VARCHAR(n)        | 可変長文字列         |
| 長文   | TEXT              | 長いテキスト         |
| 整数   | INTEGER           | 32 ビット整数        |
| 小数   | NUMERIC(p,s)      | 精密小数             |
| 真偽値 | BOOLEAN           | true/false           |
| 日時   | TIMESTAMP WITH TZ | タイムゾーン付き日時 |
| 日付   | DATE              | 日付のみ             |
| JSON   | JSONB             | バイナリ JSON        |
| 列挙型 | VARCHAR(50)       | 文字列で管理         |

---

_メインファイル: [../05-data-design.md](../05-data-design.md)_
