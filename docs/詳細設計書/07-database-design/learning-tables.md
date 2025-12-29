# 7.6. Learning Tables

## テーブル一覧

| テーブル名      | 説明               | 推定行数  |
| --------------- | ------------------ | --------- |
| vocabularies    | 単語帳             | 500 万    |
| scenarios       | シナリオ定義       | 500       |
| challenges      | チャレンジ定義     | 100       |
| user_challenges | ユーザーチャレンジ | 100 万/月 |

---

## vocabularies

### DDL

```sql
CREATE TABLE vocabularies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    conversation_id UUID REFERENCES conversations(id) ON DELETE SET NULL,

    word VARCHAR(100) NOT NULL,
    meaning VARCHAR(500) NOT NULL,
    pronunciation VARCHAR(200),
    example_sentence TEXT,

    srs_level VARCHAR(20) NOT NULL DEFAULT 'new'
        CHECK (srs_level IN ('new', 'learning', 'young', 'mature', 'mastered')),
    next_review_date DATE NOT NULL DEFAULT CURRENT_DATE,
    review_count INTEGER NOT NULL DEFAULT 0,
    correct_count INTEGER NOT NULL DEFAULT 0,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE vocabularies IS 'ユーザーが保存した語彙';
COMMENT ON COLUMN vocabularies.srs_level IS 'SRS復習レベル';
COMMENT ON COLUMN vocabularies.next_review_date IS '次の復習予定日';

-- Indexes
CREATE INDEX idx_vocabularies_user_id ON vocabularies(user_id);
CREATE INDEX idx_vocabularies_user_review ON vocabularies(user_id, next_review_date);
CREATE INDEX idx_vocabularies_user_level ON vocabularies(user_id, srs_level);
```

---

## scenarios

### DDL

```sql
CREATE TABLE scenarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    title VARCHAR(200) NOT NULL,
    title_ja VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,

    category VARCHAR(50) NOT NULL
        CHECK (category IN ('daily', 'business', 'travel', 'academic', 'test_prep')),
    difficulty VARCHAR(20) NOT NULL
        CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),

    initial_context JSONB NOT NULL,
    objectives JSONB NOT NULL DEFAULT '[]',
    key_phrases JSONB NOT NULL DEFAULT '[]',

    estimated_duration_minutes INTEGER NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE scenarios IS 'ロールプレイシナリオ定義';

-- Sample Data
INSERT INTO scenarios (id, title, title_ja, description, category, difficulty, initial_context, objectives) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Coffee Shop Order', 'カフェでの注文', 'Practice ordering drinks and food at a coffee shop', 'daily', 'beginner', '{"setting": "coffee shop", "ai_role": "barista"}', '["Order a drink", "Customize your order", "Pay and thank"]');
```

---

## challenges

### DDL

```sql
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    type VARCHAR(30) NOT NULL
        CHECK (type IN ('conversation', 'vocabulary', 'pronunciation', 'streak', 'time')),
    title VARCHAR(200) NOT NULL,
    title_ja VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,

    condition JSONB NOT NULL,
    xp_reward INTEGER NOT NULL DEFAULT 50,

    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE challenges IS 'デイリーチャレンジ定義';

-- Sample Data
INSERT INTO challenges (type, title, title_ja, description, condition, xp_reward) VALUES
('conversation', 'Chatty Day', 'おしゃべりな日', 'Complete 3 conversations today', '{"target": 3}', 50),
('vocabulary', 'Word Master', '単語マスター', 'Review 20 vocabulary words', '{"target": 20}', 30);
```

---

## user_challenges

### DDL

```sql
CREATE TABLE user_challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,

    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    current_progress INTEGER NOT NULL DEFAULT 0,

    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'completed', 'expired')),
    completed_at TIMESTAMP WITH TIME ZONE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_id, challenge_id, assigned_date)
);

COMMENT ON TABLE user_challenges IS 'ユーザーに割り当てられたチャレンジ';

-- Indexes
CREATE INDEX idx_user_challenges_user_date ON user_challenges(user_id, assigned_date);
CREATE INDEX idx_user_challenges_status ON user_challenges(status) WHERE status = 'active';
```

---

← [Conversation Tables](./conversation-tables.md) | _次: [Gamification Tables](./gamification-tables.md)_
