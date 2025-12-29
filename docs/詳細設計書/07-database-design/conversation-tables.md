# 7.5. 会話系テーブル DDL

## conversations テーブル

### 定義

```sql
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    persona_id UUID REFERENCES personas(id) ON DELETE SET NULL,
    scenario_id UUID REFERENCES scenarios(id) ON DELETE SET NULL,
    mode VARCHAR(20) NOT NULL,
    topic VARCHAR(100),
    duration_seconds INTEGER,
    pronunciation_score INTEGER,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    summary TEXT,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP WITH TIME ZONE,

    CONSTRAINT chk_mode CHECK (mode IN ('instructor', 'freetalk', 'roleplay')),
    CONSTRAINT chk_pronunciation_score CHECK (pronunciation_score IS NULL OR (pronunciation_score >= 0 AND pronunciation_score <= 100)),
    CONSTRAINT chk_xp_positive CHECK (xp_earned >= 0)
) PARTITION BY RANGE (started_at);

-- パーティション例（月次）
CREATE TABLE conversations_2025_01 PARTITION OF conversations
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

-- インデックス
CREATE INDEX idx_conversations_user_started ON conversations(user_id, started_at DESC);
CREATE INDEX idx_conversations_user_mode ON conversations(user_id, mode);
CREATE INDEX idx_conversations_scenario ON conversations(scenario_id) WHERE scenario_id IS NOT NULL;
```

### カラム詳細

| カラム名            | 型           | NULL | Default | 説明              |
| ------------------- | ------------ | ---- | ------- | ----------------- |
| id                  | UUID         | ✗    | gen     | 主キー            |
| user_id             | UUID         | ✗    | -       | ユーザー(FK)      |
| persona_id          | UUID         | ✓    | -       | ペルソナ(FK)      |
| scenario_id         | UUID         | ✓    | -       | シナリオ(FK)      |
| mode                | VARCHAR(20)  | ✗    | -       | 会話モード        |
| topic               | VARCHAR(100) | ✓    | -       | トピック          |
| duration_seconds    | INTEGER      | ✓    | -       | 会話時間（秒）    |
| pronunciation_score | INTEGER      | ✓    | -       | 発音スコア(0-100) |
| xp_earned           | INTEGER      | ✗    | 0       | 獲得 XP           |
| summary             | TEXT         | ✓    | -       | AI 生成サマリー   |
| started_at          | TIMESTAMPTZ  | ✗    | NOW     | 開始日時          |
| ended_at            | TIMESTAMPTZ  | ✓    | -       | 終了日時          |

---

## conversation_turns テーブル

### 定義

```sql
CREATE TABLE conversation_turns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    speaker VARCHAR(10) NOT NULL,
    content TEXT NOT NULL,
    audio_url TEXT,
    sequence INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_speaker CHECK (speaker IN ('user', 'ai')),
    CONSTRAINT chk_sequence CHECK (sequence > 0),
    CONSTRAINT uk_conversation_sequence UNIQUE (conversation_id, sequence)
) PARTITION BY RANGE (created_at);

-- パーティション例
CREATE TABLE conversation_turns_2025_01 PARTITION OF conversation_turns
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

-- インデックス
CREATE INDEX idx_conversation_turns_conv_seq ON conversation_turns(conversation_id, sequence);
```

### カラム詳細

| カラム名        | 型          | NULL | Default | 説明                   |
| --------------- | ----------- | ---- | ------- | ---------------------- |
| id              | UUID        | ✗    | gen     | 主キー                 |
| conversation_id | UUID        | ✗    | -       | 会話(FK)               |
| speaker         | VARCHAR(10) | ✗    | -       | 話者(user/ai)          |
| content         | TEXT        | ✗    | -       | 発話内容               |
| audio_url       | TEXT        | ✓    | -       | 音声 URL（一時保存用） |
| sequence        | INTEGER     | ✗    | -       | 発話順序               |
| created_at      | TIMESTAMPTZ | ✗    | NOW     | 作成日時               |

---

## corrections テーブル

### 定義

```sql
CREATE TABLE corrections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    turn_id UUID NOT NULL REFERENCES conversation_turns(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL,
    original_text VARCHAR(500) NOT NULL,
    corrected_text VARCHAR(500) NOT NULL,
    explanation TEXT,
    severity VARCHAR(10) NOT NULL DEFAULT 'medium',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_type CHECK (type IN ('grammar', 'vocabulary', 'pronunciation', 'naturalness')),
    CONSTRAINT chk_severity CHECK (severity IN ('low', 'medium', 'high'))
);

-- インデックス
CREATE INDEX idx_corrections_turn_id ON corrections(turn_id);
CREATE INDEX idx_corrections_type ON corrections(type);
```

### カラム詳細

| カラム名       | 型           | NULL | Default | 説明           |
| -------------- | ------------ | ---- | ------- | -------------- |
| id             | UUID         | ✗    | gen     | 主キー         |
| turn_id        | UUID         | ✗    | -       | ターン(FK)     |
| type           | VARCHAR(20)  | ✗    | -       | 訂正タイプ     |
| original_text  | VARCHAR(500) | ✗    | -       | 元のテキスト   |
| corrected_text | VARCHAR(500) | ✗    | -       | 訂正後テキスト |
| explanation    | TEXT         | ✓    | -       | 説明（日本語） |
| severity       | VARCHAR(10)  | ✗    | medium  | 深刻度         |
| created_at     | TIMESTAMPTZ  | ✗    | NOW     | 作成日時       |

---

← [ユーザー系](./user-tables.md) | _次: [学習系](./learning-tables.md)_
