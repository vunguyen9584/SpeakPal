# 8. API 設計 - 共通仕様

> 📌 **ENHANCED**: Rate limiting, performance benchmarks, versioning strategy

---

## 8.1. 概要

### 8.1.1. API 構成

| 項目        | 仕様                               |
| ----------- | ---------------------------------- |
| Protocol    | HTTPS (TLS 1.3)                    |
| Format      | JSON (UTF-8)                       |
| Auth Method | Bearer Token (JWT)                 |
| Base URL    | `https://api.speakpal.ai/v1`       |
| Total APIs  | 52 (42 REST + 10 WebSocket events) |

### 8.1.2. ファイル構成

| セクション | ファイル                                                  | 内容                 |
| ---------- | --------------------------------------------------------- | -------------------- |
| 8.2        | [Auth APIs](./08-api-design/auth-apis.md)                 | 認証関連 API         |
| 8.3        | [User APIs](./08-api-design/user-apis.md)                 | ユーザー管理 API     |
| 8.4        | [Conversation APIs](./08-api-design/conversation-apis.md) | 会話 API             |
| 8.5        | [Learning APIs](./08-api-design/learning-apis.md)         | 学習 API             |
| 8.6        | [Gamification APIs](./08-api-design/gamification-apis.md) | ゲーミフィケーション |
| 8.7        | [Social APIs](./08-api-design/social-apis.md)             | ソーシャル API       |
| 8.8        | [Subscription APIs](./08-api-design/subscription-apis.md) | サブスクリプション   |
| 8.9        | [WebSocket APIs](./08-api-design/websocket-apis.md)       | リアルタイム通信     |

---

## 8.2. Rate Limiting Specifications

> 📌 **ENHANCED** (ENH-07): エンドポイント別レート制限

### 8.2.1. レート制限ポリシー

| Tier      | Limit             | Window  | Applies To            |
| --------- | ----------------- | ------- | --------------------- |
| Free User | 100 req/min       | sliding | All APIs              |
| Plus User | 500 req/min       | sliding | All APIs              |
| Pro User  | 2000 req/min      | sliding | All APIs              |
| Auth APIs | 10 req/min        | fixed   | /auth/\* (全ユーザー) |
| AI APIs   | 20 req/min (Free) | sliding | /conversations/\*     |

### 8.2.2. エンドポイント別制限

| Endpoint                  | Limit  | Reason               |
| ------------------------- | ------ | -------------------- |
| POST /auth/login          | 5/min  | ブルートフォース防止 |
| POST /auth/register       | 3/min  | スパム防止           |
| POST /auth/password-reset | 3/hour | 悪用防止             |
| POST /conversations       | 10/min | AI リソース保護      |
| WebSocket connect         | 5/min  | 接続スパム防止       |
| GET /rankings/weekly      | 60/min | キャッシュ利用促進   |

### 8.2.3. レート制限ヘッダー

```http
X-RateLimit-Limit: 500
X-RateLimit-Remaining: 423
X-RateLimit-Reset: 1704067200
Retry-After: 30 (429 時のみ)
```

### 8.2.4. 制限超過時のレスポンス

```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "retryAfter": 30
  }
}
```

---

## 8.3. Performance Benchmarks

> 📌 **ENHANCED** (ENH-06): API 応答時間目標

### 8.3.1. 応答時間ターゲット (p95)

| API Category        | Target (p95) | Max (p99) | SLO   |
| ------------------- | ------------ | --------- | ----- |
| Auth (login/logout) | 100ms        | 200ms     | 99.9% |
| User CRUD           | 50ms         | 100ms     | 99.9% |
| Conversation Start  | 200ms        | 500ms     | 99.5% |
| AI Response (TTFB)  | 800ms        | 1500ms    | 99%   |
| Gamification Read   | 30ms         | 50ms      | 99.9% |
| Rankings            | 100ms        | 200ms     | 99.5% |
| Batch Statistics    | 500ms        | 1000ms    | 99%   |

### 8.3.2. WebSocket パフォーマンス

| Metric                   | Target   | Measurement          |
| ------------------------ | -------- | -------------------- |
| Connection Time          | < 300ms  | handshake complete   |
| Message Latency (audio)  | < 100ms  | client to server     |
| Transcript Latency (STT) | < 500ms  | audio to text        |
| AI Response Start        | < 1500ms | input to first token |
| TTS Audio Chunk Latency  | < 200ms  | text to audio chunk  |

### 8.3.3. 負荷テスト基準

```
LOAD TEST SCENARIOS:
1. Normal Load:    100 concurrent users, 10 min
2. Peak Load:      500 concurrent users, 5 min
3. Stress Test:    1000 concurrent users, ramp up
4. Endurance Test: 200 users, 1 hour

SUCCESS CRITERIA:
- Error Rate < 0.1%
- p95 Latency within target
- No memory leaks
- Graceful degradation under stress
```

---

## 8.4. API Versioning Strategy

> 📌 **ENHANCED** (ENH-08): API バージョニング戦略

### 8.4.1. バージョニング方式

```
URL PATH VERSIONING:
  https://api.speakpal.ai/v1/users
  https://api.speakpal.ai/v2/users

HEADER VERSIONING (optional):
  Accept: application/vnd.speakpal.v1+json
```

### 8.4.2. バージョンライフサイクル

| Phase     | Duration  | Status     | Support Level        |
| --------- | --------- | ---------- | -------------------- |
| Current   | -         | Active     | 全機能 + バグ修正    |
| Supported | 12 months | Deprecated | セキュリティ修正のみ |
| EOL       | -         | Removed    | サポート終了         |

### 8.4.3. 非互換変更ルール

```
NON-BREAKING CHANGES (v1 内で許容):
✅ 新しいエンドポイント追加
✅ 新しいオプショナルパラメータ追加
✅ レスポンスに新しいフィールド追加
✅ エラーコードの追加

BREAKING CHANGES (v2 必須):
❌ 既存エンドポイントの削除
❌ 必須パラメータの追加/削除
❌ レスポンス構造の変更
❌ 認証方式の変更
❌ エラーコードの削除/変更
```

### 8.4.4. Deprecation 通知

```http
Deprecation: true
Sunset: Sat, 01 Jan 2026 00:00:00 GMT
Link: <https://api.speakpal.ai/v2/users>; rel="successor-version"
```

```json
{
  "data": { ... },
  "meta": {
    "deprecation": {
      "message": "This endpoint is deprecated. Please use /v2/users",
      "sunsetDate": "2026-01-01T00:00:00Z",
      "migration": "https://docs.speakpal.ai/migration/v1-to-v2"
    }
  }
}
```

---

## 8.5. Common Response Format

### 8.5.1. 成功レスポンス

```json
{
  "success": true,
  "data": {
    // response data
  },
  "meta": {
    "requestId": "req_abc123",
    "timestamp": "2026-01-07T10:00:00Z",
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "hasNext": true
    }
  }
}
```

### 8.5.2. エラーレスポンス

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "email": "Invalid email format",
      "password": "Must be at least 8 characters"
    }
  },
  "meta": {
    "requestId": "req_xyz789",
    "timestamp": "2026-01-07T10:00:00Z"
  }
}
```

---

## 8.6. Security Headers

| Header                    | Value                               |
| ------------------------- | ----------------------------------- |
| Strict-Transport-Security | max-age=31536000; includeSubDomains |
| X-Content-Type-Options    | nosniff                             |
| X-Frame-Options           | DENY                                |
| X-XSS-Protection          | 1; mode=block                       |
| Content-Security-Policy   | default-src 'self'                  |
| Referrer-Policy           | strict-origin-when-cross-origin     |

---

## 8.7. BD 参照マトリクス

| DD Section       | BD Section             | Coverage |
| ---------------- | ---------------------- | -------- |
| 8.2 Auth APIs    | BD 06-api-design (6.4) | ✅ 100%  |
| 8.3 User APIs    | BD 06-api-design (6.4) | ✅ 100%  |
| 8.4 Conversation | BD 06-api-design (6.4) | ✅ 100%  |
| 8.5 Learning     | BD 06-api-design (6.4) | ✅ 100%  |
| 8.6 Gamification | BD 06-api-design (6.4) | ✅ 100%  |
| 8.7 Social       | BD 06-api-design (6.4) | ✅ 100%  |
| 8.8 Subscription | BD 06-api-design (6.4) | ✅ 100%  |
| 8.9 WebSocket    | BD 06-api-design (6.5) | ✅ 100%  |

> 📋 BD Reference: [基本設計書/06-api-design.md](../基本設計書/06-api-design.md)

---

_メインファイル: [../08-api-design.md](../08-api-design.md)_
