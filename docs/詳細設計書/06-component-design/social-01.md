# 6.10. Social Use Cases (UC-027 ～ UC-029)

## UC-027: 友達招待

### 処理概要

招待コードを生成し、友達を招待する。

### シーケンス図

```mermaid
sequenceDiagram
    participant U1 as 招待者
    participant C1 as Client (招待者)
    participant API as API Server
    participant IS as InvitationService
    participant DB as PostgreSQL
    participant U2 as 被招待者
    participant C2 as Client (被招待者)

    U1->>C1: 招待コード生成
    C1->>API: POST /invitations
    API->>IS: createCode(userId)
    IS->>IS: generateRandomCode(8)
    IS->>DB: INSERT invitations
    IS-->>API: InvitationDto
    API-->>C1: { code: "ABC12345" }
    C1-->>U1: コード表示・共有

    Note over U1,U2: コードを共有

    U2->>C2: コード入力
    C2->>API: POST /invitations/accept
    API->>IS: accept(code, userId)
    IS->>DB: SELECT WHERE code = ?
    IS->>IS: validateCode()

    alt 有効
        IS->>DB: UPDATE invitations SET status = 'accepted'
        IS->>DB: UPDATE users SET total_xp += 50 (両者)
        IS-->>API: { success: true, bonusXP: 50 }
    else 無効
        IS-->>API: 400 Bad Request
    end
```

### ビジネスルール

| Rule ID | ルール内容                    |
| ------- | ----------------------------- |
| BR-027  | 1 人 5 個まで有効な招待コード |
| BR-028  | コード有効期限は 30 日        |
| BR-029  | 招待成功で両者 50XP ボーナス  |
| BR-030  | 自己招待は不可                |

---

## UC-028: 週間ランキング

### ランキング表示データ

| フィールド | 説明           |
| ---------- | -------------- |
| rank       | 順位           |
| username   | ユーザー名     |
| weeklyXP   | 今週の XP      |
| change     | 前週からの変動 |

---

← [Progress UCs](./progress-01.md) | _次: [Advanced UCs](./advanced-01.md)_
