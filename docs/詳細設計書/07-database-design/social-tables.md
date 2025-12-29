# 7.8. Social Tables

## テーブル一覧

| テーブル名    | 説明             | 推定行数 |
| ------------- | ---------------- | -------- |
| invitations   | 招待コード       | 10 万    |
| groups        | グループ         | 5 千     |
| group_members | グループメンバー | 2 万     |

---

## invitations

### DDL

```sql
CREATE TABLE invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(id) ON DELETE SET NULL,

    code VARCHAR(8) NOT NULL UNIQUE,

    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'expired')),
    bonus_xp INTEGER NOT NULL DEFAULT 50,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 days'),
    used_at TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE invitations IS '友達招待';
COMMENT ON COLUMN invitations.code IS '8文字の招待コード';

-- Indexes
CREATE INDEX idx_invitations_sender ON invitations(sender_id);
CREATE INDEX idx_invitations_code ON invitations(code) WHERE status = 'pending';
CREATE INDEX idx_invitations_cleanup ON invitations(expires_at) WHERE status = 'pending';
```

---

## groups

### DDL

```sql
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,
    description TEXT,

    max_members INTEGER NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE groups IS '学習グループ';

-- Indexes
CREATE INDEX idx_groups_owner ON groups(owner_id);
CREATE INDEX idx_groups_active ON groups(is_active) WHERE is_active = true;
```

---

## group_members

### DDL

```sql
CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    role VARCHAR(20) NOT NULL DEFAULT 'member'
        CHECK (role IN ('owner', 'admin', 'member')),

    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (group_id, user_id)
);

COMMENT ON TABLE group_members IS 'グループメンバー';

-- Indexes
CREATE INDEX idx_group_members_group ON group_members(group_id);
CREATE INDEX idx_group_members_user ON group_members(user_id);
```

---

## トリガー関数 (Shared)

```sql
-- updated_at 自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 各テーブルにトリガー適用
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_personas_updated_at
    BEFORE UPDATE ON personas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at
    BEFORE UPDATE ON conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabularies_updated_at
    BEFORE UPDATE ON vocabularies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_streaks_updated_at
    BEFORE UPDATE ON streaks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_groups_updated_at
    BEFORE UPDATE ON groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

---

← [Gamification Tables](./gamification-tables.md) | _戻る: [データベース設計](../07-database-design.md)_
