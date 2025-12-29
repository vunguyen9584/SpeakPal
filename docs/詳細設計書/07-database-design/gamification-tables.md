# 7.7. Gamification Tables

## テーブル一覧

| テーブル名    | 説明           | 推定行数 |
| ------------- | -------------- | -------- |
| streaks       | 連続学習       | 10 万    |
| badges        | バッジ定義     | 50       |
| user_badges   | ユーザーバッジ | 100 万   |
| user_rankings | 週間ランキング | 50 万/月 |

---

## streaks

### DDL

```sql
CREATE TABLE streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,

    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    freeze_remaining INTEGER NOT NULL DEFAULT 0,

    last_activity_date DATE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE streaks IS '連続学習ストリーク';
COMMENT ON COLUMN streaks.freeze_remaining IS '使用可能なフリーズ数';

-- Index
CREATE INDEX idx_streaks_active ON streaks(last_activity_date) WHERE current_streak > 0;
```

---

## badges

### DDL

```sql
CREATE TABLE badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,

    name VARCHAR(100) NOT NULL,
    name_ja VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,

    category VARCHAR(30) NOT NULL
        CHECK (category IN ('streak', 'level', 'conversation', 'vocabulary', 'pronunciation', 'special')),
    icon_url VARCHAR(255) NOT NULL,

    condition JSONB NOT NULL,
    xp_bonus INTEGER NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE badges IS 'バッジ定義マスタ';

-- Sample Data
INSERT INTO badges (code, name, name_ja, description, category, icon_url, condition, xp_bonus) VALUES
('STREAK_7', '7-Day Streak', '7日連続', 'Maintain a 7-day learning streak', 'streak', '/badges/streak_7.svg', '{"type": "streak", "target": 7}', 100),
('STREAK_30', 'Monthly Master', '月間マスター', 'Maintain a 30-day learning streak', 'streak', '/badges/streak_30.svg', '{"type": "streak", "target": 30}', 500),
('CONV_FIRST', 'First Steps', 'はじめの一歩', 'Complete your first conversation', 'conversation', '/badges/first_conv.svg', '{"type": "conversation_count", "target": 1}', 50),
('CONV_100', 'Conversationalist', '会話の達人', 'Complete 100 conversations', 'conversation', '/badges/conv_100.svg', '{"type": "conversation_count", "target": 100}', 300);
```

---

## user_badges

### DDL

```sql
CREATE TABLE user_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,

    earned_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_id, badge_id)
);

COMMENT ON TABLE user_badges IS 'ユーザーが獲得したバッジ';

-- Indexes
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_user_badges_earned_at ON user_badges(earned_at DESC);
```

---

## user_rankings

### DDL

```sql
CREATE TABLE user_rankings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    week_number INTEGER NOT NULL,
    year INTEGER NOT NULL,
    league VARCHAR(20) NOT NULL
        CHECK (league IN ('Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond')),

    weekly_xp INTEGER NOT NULL DEFAULT 0,
    rank INTEGER NOT NULL,

    change VARCHAR(10) NOT NULL DEFAULT 'same'
        CHECK (change IN ('promoted', 'demoted', 'same')),

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_id, week_number, year)
) PARTITION BY RANGE (year);

COMMENT ON TABLE user_rankings IS '週間ランキング履歴';

-- 2025 Partition
CREATE TABLE user_rankings_2025
    PARTITION OF user_rankings
    FOR VALUES FROM (2025) TO (2026);

-- Indexes
CREATE INDEX idx_user_rankings_week_league ON user_rankings(week_number, year, league, weekly_xp DESC);
```

---

← [Learning Tables](./learning-tables.md) | _次: [Social Tables](./social-tables.md)_
