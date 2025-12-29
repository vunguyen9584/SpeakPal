# 8.5. Conversation APIs

## API-201: GET /conversations

### 概要

| 項目     | 内容           |
| -------- | -------------- |
| メソッド | GET            |
| パス     | /conversations |
| 認証     | Auth           |

### Query Parameters

| Parameter | Type   | Required | Description    |
| --------- | ------ | -------- | -------------- |
| page      | number | No       | Default: 1     |
| limit     | number | No       | Max: 50        |
| mode      | string | No       | Filter by mode |

### Response

```typescript
interface ConversationListResponse {
  data: ConversationSummary[];
  pagination: Pagination;
}

interface ConversationSummary {
  id: string;
  mode: "instructor" | "freetalk" | "roleplay";
  topic: string | null;
  durationSeconds: number;
  pronunciationScore: number;
  xpEarned: number;
  startedAt: string;
  endedAt: string | null;
}
```

---

## API-202: POST /conversations

### Request

```typescript
interface CreateConversationRequest {
  mode: "instructor" | "freetalk" | "roleplay";
  personaId?: string; // Optional, uses default if not provided
  scenarioId?: string; // Required for roleplay mode
  topic?: string; // Optional for freetalk
}
```

### Response (201 Created)

```typescript
interface ConversationResponse {
  id: string;
  mode: string;
  persona: PersonaSummary;
  scenario: ScenarioSummary | null;
  websocketUrl: string;
  token: string; // Short-lived token for WS auth
  startedAt: string;
}
```

### Error Responses

| Status | Code        | Message             |
| ------ | ----------- | ------------------- |
| 400    | ERR_VAL_005 | Invalid mode        |
| 403    | ERR_BIZ_002 | Usage limit reached |
| 404    | ERR_RES_001 | Persona not found   |
| 404    | ERR_RES_002 | Scenario not found  |

### Processing Steps

1. Check user's daily usage limit
2. Validate personaId (use default if not provided)
3. Validate scenarioId if mode = roleplay
4. Create conversation record
5. Generate WebSocket token
6. Return conversation with WS connection info

---

## API-203: POST /conversations/:id/end

### Response

```typescript
interface ConversationEndResponse {
  id: string;
  summary: string;
  durationSeconds: number;
  pronunciationScore: number;
  xpEarned: number;
  levelUp: boolean;
  newLevel?: number;
  newBadges: Badge[];
  corrections: CorrectionSummary[];
}
```

### Processing Steps

1. Validate conversation ownership
2. Calculate duration
3. Calculate pronunciation score from corrections
4. Calculate XP
5. Generate summary using LLM
6. Update user XP and check level up
7. Check and award badges
8. Update streak
9. Return summary

---

## API-204: GET /conversations/:id/turns

### Response

```typescript
interface TurnListResponse {
  data: Turn[];
}

interface Turn {
  id: string;
  speaker: "user" | "ai";
  content: string;
  sequence: number;
  createdAt: string;
  corrections?: Correction[];
}

interface Correction {
  type: "grammar" | "vocabulary" | "pronunciation";
  originalText: string;
  correctedText: string;
  explanation: string;
  severity: "low" | "medium" | "high";
}
```

---

← [User APIs](./user-apis.md) | _次: [Learning APIs](./learning-apis.md)_
