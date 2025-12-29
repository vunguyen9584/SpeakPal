# 8.4. User APIs

## API-101: GET /users/me

### 概要

| 項目     | 内容      |
| -------- | --------- |
| メソッド | GET       |
| パス     | /users/me |
| 認証     | Auth      |
| 関連 UC  | UC-009    |

### Response

```typescript
interface UserResponse {
  id: string;
  email: string;
  username: string;
  level: "Beginner" | "Basic" | "Intermediate" | "Advanced";
  totalXp: number;
  currentLevelXp: number;
  nextLevelXp: number;
  league: "Bronze" | "Silver" | "Gold" | "Platinum" | "Diamond";
  aiSpeed: number;
  confirmationMode: boolean;
  isVerified: boolean;
  createdAt: string;
}
```

### Error Responses

| Status | Code         | Message       |
| ------ | ------------ | ------------- |
| 401    | ERR_AUTH_002 | Token expired |
| 401    | ERR_AUTH_003 | Token invalid |

---

## API-102: PUT /users/me

### Request

```typescript
interface UpdateUserRequest {
  username?: string; // min: 3, max: 50
  aiSpeed?: number; // range: 0.5 - 2.0
  confirmationMode?: boolean;
}
```

### Response

Same as GET /users/me

### Validation Rules

| Field    | Rule                  | Error Code  |
| -------- | --------------------- | ----------- |
| username | 3-50 chars            | ERR_VAL_004 |
| username | pattern: alphanumeric | ERR_VAL_005 |
| aiSpeed  | 0.5 - 2.0             | ERR_VAL_006 |

---

## API-103: PUT /users/me/password

### Request

```typescript
interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string; // min: 8, max: 128
}
```

### Response

```json
{
  "success": true,
  "data": {
    "message": "Password changed successfully"
  }
}
```

### Error Responses

| Status | Code         | Message                  |
| ------ | ------------ | ------------------------ |
| 400    | ERR_VAL_003  | Password too short       |
| 401    | ERR_AUTH_001 | Invalid current password |

---

## API-104: GET /users/me/stats

### Response

```typescript
interface UserStatsResponse {
  streak: {
    current: number;
    longest: number;
    freezeRemaining: number;
  };
  xp: {
    total: number;
    thisWeek: number;
    level: number;
  };
  conversations: {
    total: number;
    thisWeek: number;
    averageDuration: number;
  };
  pronunciation: {
    averageScore: number;
    trend: "up" | "down" | "stable";
  };
  vocabulary: {
    total: number;
    dueForReview: number;
  };
}
```

---

← [Auth APIs](./auth-apis.md) | _次: [Conversation APIs](./conversation-apis.md)_
