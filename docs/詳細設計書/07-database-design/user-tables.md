# 7.4. ユーザー系テーブル DDL

## users テーブル

### 定義

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    level VARCHAR(20) NOT NULL DEFAULT 'Beginner',
    total_xp INTEGER NOT NULL DEFAULT 0,
    current_level_xp INTEGER NOT NULL DEFAULT 0,
    league VARCHAR(20) NOT NULL DEFAULT 'Bronze',
    ai_speed NUMERIC(3,2) NOT NULL DEFAULT 1.00,
    confirmation_mode BOOLEAN NOT NULL DEFAULT false,
    is_verified BOOLEAN NOT NULL DEFAULT false,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_level CHECK (level IN ('Beginner', 'Basic', 'Intermediate', 'Advanced')),
    CONSTRAINT chk_league CHECK (league IN ('Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond')),
    CONSTRAINT chk_ai_speed CHECK (ai_speed BETWEEN 0.5 AND 2.0),
    CONSTRAINT chk_xp_positive CHECK (total_xp >= 0 AND current_level_xp >= 0)
);

-- インデックス
CREATE UNIQUE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_league ON users(league);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- トリガー: updated_at 自動更新
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
```

### カラム詳細

| カラム名          | 型           | NULL | Default    | 説明                 |
| ----------------- | ------------ | ---- | ---------- | -------------------- |
| id                | UUID         | ✗    | gen_random | 主キー               |
| email             | VARCHAR(255) | ✗    | -          | メールアドレス（UK） |
| username          | VARCHAR(50)  | ✗    | -          | 表示名               |
| password_hash     | VARCHAR(255) | ✗    | -          | bcrypt ハッシュ      |
| level             | VARCHAR(20)  | ✗    | Beginner   | 英語レベル           |
| total_xp          | INTEGER      | ✗    | 0          | 累計 XP              |
| current_level_xp  | INTEGER      | ✗    | 0          | 現レベル内 XP        |
| league            | VARCHAR(20)  | ✗    | Bronze     | リーグ               |
| ai_speed          | NUMERIC(3,2) | ✗    | 1.00       | AI 話速(0.5-2.0)     |
| confirmation_mode | BOOLEAN      | ✗    | false      | 発声確認モード       |
| is_verified       | BOOLEAN      | ✗    | false      | メール確認済み       |
| last_login_at     | TIMESTAMPTZ  | ✓    | -          | 最終ログイン         |
| created_at        | TIMESTAMPTZ  | ✗    | NOW        | 作成日時             |
| updated_at        | TIMESTAMPTZ  | ✗    | NOW        | 更新日時             |

---

## personas テーブル

### 定義

```sql
CREATE TABLE personas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    voice VARCHAR(20) NOT NULL,
    personality VARCHAR(20) NOT NULL,
    target_level VARCHAR(20) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_voice CHECK (voice IN ('voice_1', 'voice_2', 'voice_3')),
    CONSTRAINT chk_personality CHECK (personality IN ('cheerful', 'strict', 'sarcastic')),
    CONSTRAINT chk_target_level CHECK (target_level IN ('Beginner', 'Basic', 'Intermediate', 'Advanced')),
    CONSTRAINT uk_user_persona_name UNIQUE (user_id, name)
);

-- インデックス
CREATE INDEX idx_personas_user_id ON personas(user_id);
CREATE INDEX idx_personas_user_default ON personas(user_id, is_default) WHERE is_default = true;
```

### カラム詳細

| カラム名     | 型          | NULL | Default | 説明             |
| ------------ | ----------- | ---- | ------- | ---------------- |
| id           | UUID        | ✗    | gen     | 主キー           |
| user_id      | UUID        | ✗    | -       | 所有ユーザー(FK) |
| name         | VARCHAR(50) | ✗    | -       | ペルソナ名       |
| voice        | VARCHAR(20) | ✗    | -       | 声タイプ         |
| personality  | VARCHAR(20) | ✗    | -       | 性格タイプ       |
| target_level | VARCHAR(20) | ✗    | -       | 対象レベル       |
| is_default   | BOOLEAN     | ✗    | false   | デフォルトフラグ |
| created_at   | TIMESTAMPTZ | ✗    | NOW     | 作成日時         |

---

## subscriptions テーブル

### 定義

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    plan VARCHAR(20) NOT NULL DEFAULT 'free',
    daily_usage_count INTEGER NOT NULL DEFAULT 0,
    daily_usage_limit INTEGER NOT NULL DEFAULT 3,
    last_reset_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_plan CHECK (plan IN ('free', 'premium', 'premium_plus')),
    CONSTRAINT chk_usage_count CHECK (daily_usage_count >= 0)
);

-- インデックス
CREATE UNIQUE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_plan ON subscriptions(plan);
CREATE INDEX idx_subscriptions_expires ON subscriptions(expires_at) WHERE expires_at IS NOT NULL;

-- トリガー
CREATE TRIGGER trg_subscriptions_updated_at
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
```

### プラン別制限

| プラン       | daily_usage_limit | その他制限             |
| ------------ | ----------------- | ---------------------- |
| free         | 3                 | デフォルトペルソナのみ |
| premium      | 無制限 (9999)     | 全機能利用可           |
| premium_plus | 無制限 (9999)     | 発音詳細分析利用可     |

---

## notification_settings テーブル

### 定義

```sql
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    push_enabled BOOLEAN NOT NULL DEFAULT true,
    email_enabled BOOLEAN NOT NULL DEFAULT true,
    streak_reminder BOOLEAN NOT NULL DEFAULT true,
    weekly_report BOOLEAN NOT NULL DEFAULT true,
    monthly_report BOOLEAN NOT NULL DEFAULT true,
    reminder_time TIME NOT NULL DEFAULT '09:00:00',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- インデックス
CREATE UNIQUE INDEX idx_notification_settings_user ON notification_settings(user_id);

-- トリガー
CREATE TRIGGER trg_notification_settings_updated_at
    BEFORE UPDATE ON notification_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
```

---

← [ER 図](./01-er-diagram.md) | _次: [会話系テーブル](./conversation-tables.md)_
