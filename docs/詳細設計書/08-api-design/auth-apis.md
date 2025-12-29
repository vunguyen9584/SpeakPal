# 8.3. Auth APIs

## API-001: POST /auth/register

### 概要

| 項目     | 内容           |
| -------- | -------------- |
| メソッド | POST           |
| パス     | /auth/register |
| 認証     | Public         |
| 関連 UC  | UC-011         |

### Request

```typescript
interface RegisterRequest {
  email: string; // 必須, format: email, max: 255
  password: string; // 必須, min: 8, max: 128
  username: string; // 必須, min: 3, max: 50, pattern: ^[a-zA-Z0-9_-]+$
}
```

**Example:**

```json
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "username": "john_doe"
}
```

### Response

```typescript
interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  expiresIn: number; // seconds
  user: {
    id: string;
    email: string;
    username: string;
    level: string;
    totalXp: number;
  };
}
```

**Example (201 Created):**

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR...",
    "expiresIn": 3600,
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "username": "john_doe",
      "level": "Beginner",
      "totalXp": 0
    }
  }
}
```

### Error Responses

| Status | Code     | Message                 |
| ------ | -------- | ----------------------- |
| 400    | VAL_001  | Invalid email format    |
| 400    | VAL_002  | Password too weak       |
| 400    | VAL_003  | Invalid username format |
| 409    | AUTH_001 | Email already exists    |

### Processing Steps

1. Validate input (email, password, username format)
2. Check if email already exists
3. Hash password using bcrypt
4. Create user + subscription + streak + default persona in transaction
5. Generate JWT tokens
6. Queue verification email
7. Return auth response

---

## API-002: POST /auth/login

### 概要

| 項目     | 内容        |
| -------- | ----------- |
| メソッド | POST        |
| パス     | /auth/login |
| 認証     | Public      |
| 関連 UC  | UC-012      |

### Request

```typescript
interface LoginRequest {
  email: string; // 必須
  password: string; // 必須
}
```

### Response

Same as RegisterResponse (AuthResponse)

### Error Responses

| Status | Code     | Message             |
| ------ | -------- | ------------------- |
| 401    | AUTH_002 | Invalid credentials |
| 403    | AUTH_003 | Account locked      |

---

## API-003: POST /auth/refresh

### Request

```typescript
interface RefreshRequest {
  refreshToken: string;
}
```

### Response

```typescript
interface RefreshResponse {
  accessToken: string;
  expiresIn: number;
}
```

---

← [目次](../08-api-design.md) | _次: [User APIs](./user-apis.md)_
