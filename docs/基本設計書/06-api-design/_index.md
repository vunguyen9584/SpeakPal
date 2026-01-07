# API 設計 - 共通仕様

> 📌 このファイルでは、API 設計の共通仕様とパターンを定義します。

---

## 📋 概要

| 項目           | 内容                      |
| -------------- | ------------------------- |
| Base URL       | `https://api.speakpal.ai` |
| API Version    | v1                        |
| Protocol       | HTTPS                     |
| Data Format    | JSON                      |
| Authentication | Bearer Token (JWT)        |
| Character Set  | UTF-8                     |

---

## 🔐 認証仕様

### 認証方式

| 方式          | 用途                 | 有効期限 |
| ------------- | -------------------- | -------- |
| Access Token  | API リクエスト認証   | 1 時間   |
| Refresh Token | アクセストークン更新 | 30 日    |
| OAuth 2.0     | ソーシャルログイン   | -        |

### Authorization Header

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### JWT Payload 構造

```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "role": "user",
  "plan": "premium",
  "iat": 1735467600,
  "exp": 1735471200
}
```

---

## 📝 共通レスポンス形式

### 成功レスポンス

```json
{
  "success": true,
  "data": {
    // ... response data
  },
  "message": "操作が完了しました",
  "timestamp": "2025-12-29T10:00:00Z"
}
```

### エラーレスポンス

```json
{
  "success": false,
  "error": {
    "code": "AUTH_001",
    "message": "認証に失敗しました",
    "details": {
      "field": "email",
      "reason": "メールアドレスが無効です"
    }
  },
  "timestamp": "2025-12-29T10:00:00Z"
}
```

### ページネーションレスポンス

```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total_items": 150,
      "total_pages": 8,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

---

## 📊 HTTP ステータスコード

| コード | 意味                  | 使用場面             |
| ------ | --------------------- | -------------------- |
| 200    | OK                    | 一般的な成功         |
| 201    | Created               | リソース作成成功     |
| 204    | No Content            | 削除成功             |
| 400    | Bad Request           | リクエスト形式エラー |
| 401    | Unauthorized          | 認証エラー           |
| 403    | Forbidden             | 権限不足             |
| 404    | Not Found             | リソース未発見       |
| 409    | Conflict              | 重複エラー           |
| 422    | Unprocessable Entity  | バリデーションエラー |
| 429    | Too Many Requests     | レート制限超過       |
| 500    | Internal Server Error | サーバー内部エラー   |
| 503    | Service Unavailable   | メンテナンス中       |

---

## 🚦 レート制限

### 制限設定

| API カテゴリ       | 制限          | 時間枠 |
| ------------------ | ------------- | ------ |
| 認証 API           | 10 requests   | 1 分   |
| 一般 API (Free)    | 30 requests   | 1 分   |
| 一般 API (Basic)   | 60 requests   | 1 分   |
| 一般 API (Premium) | 120 requests  | 1 分   |
| WebSocket          | 5 connections | 同時   |

### レート制限ヘッダー

```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1735467660
```

### 制限超過時

```json
{
  "success": false,
  "error": {
    "code": "RATE_001",
    "message": "レート制限を超過しました",
    "details": {
      "retry_after": 45
    }
  }
}
```

---

## 📐 バリデーション規則

### 共通バリデーション

| フィールドタイプ | 規則                                 |
| ---------------- | ------------------------------------ |
| email            | RFC 5322 準拠、最大 255 文字         |
| password         | 8-128 文字、英字と数字を含む         |
| username         | 3-50 文字、英数字と `_-` のみ        |
| uuid             | UUID v4 形式                         |
| date             | ISO 8601 形式 (YYYY-MM-DD)           |
| datetime         | ISO 8601 形式 (YYYY-MM-DDTHH:mm:ssZ) |
| text (short)     | 最大 100 文字                        |
| text (long)      | 最大 10,000 文字                     |

### バリデーションエラー形式

```json
{
  "success": false,
  "error": {
    "code": "VAL_001",
    "message": "バリデーションエラー",
    "details": {
      "errors": [
        {
          "field": "email",
          "code": "invalid_format",
          "message": "メールアドレスの形式が正しくありません"
        },
        {
          "field": "password",
          "code": "too_short",
          "message": "パスワードは8文字以上必要です"
        }
      ]
    }
  }
}
```

---

## 🔄 バージョニング戦略

### URL ベースバージョニング

```
https://api.speakpal.ai/v1/users
https://api.speakpal.ai/v2/users  (将来)
```

### バージョン移行ポリシー

| 項目                     | 内容                                  |
| ------------------------ | ------------------------------------- |
| サポート期間             | 新バージョンリリースから 12 ヶ月      |
| 非推奨通知               | リリース 6 ヶ月前                     |
| 強制移行                 | サポート期間終了後                    |
| 非推奨レスポンスヘッダー | `Deprecation: true`, `Sunset: <date>` |

---

## 📡 WebSocket 共通仕様

### 接続 URL

```
wss://api.speakpal.ai/ws/{conversation_id}
```

### メッセージ形式

```json
{
  "event": "event_name",
  "data": { ... },
  "timestamp": "2025-12-29T10:00:00Z",
  "sequence": 1
}
```

### ハートビート

| 項目       | 値                           |
| ---------- | ---------------------------- |
| Ping 間隔  | 30 秒                        |
| Timeout    | 60 秒                        |
| 再接続待機 | 1-5 秒 (exponential backoff) |

### エラーイベント

```json
{
  "event": "error",
  "data": {
    "code": "WS_001",
    "message": "接続エラー",
    "recoverable": true
  }
}
```

---

## 🔒 セキュリティ仕様

### HTTPS 要件

- TLS 1.2 以上必須
- 証明書: Let's Encrypt または商用証明書
- HSTS ヘッダー有効

### CORS 設定

```http
Access-Control-Allow-Origin: https://app.speakpal.ai
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 86400
```

### セキュリティヘッダー

```http
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'self'
```

---

## 📊 API カテゴリ一覧

| カテゴリ                 | Prefix                  | 詳細ファイル                                                         |
| ------------------------ | ----------------------- | -------------------------------------------------------------------- |
| 認証 API                 | `/api/v1/auth`          | [06-api-design.md](../06-api-design.md#621-認証-api)                 |
| ユーザー API             | `/api/v1/users`         | [06-api-design.md](../06-api-design.md#622-ユーザー-api)             |
| ペルソナ API             | `/api/v1/personas`      | [06-api-design.md](../06-api-design.md#623-ペルソナ-api)             |
| 会話 API                 | `/api/v1/conversations` | [06-api-design.md](../06-api-design.md#624-会話-api)                 |
| 学習 API                 | `/api/v1/vocabularies`  | [06-api-design.md](../06-api-design.md#625-学習-api)                 |
| ゲーミフィケーション API | `/api/v1/streaks`       | [06-api-design.md](../06-api-design.md#626-ゲーミフィケーション-api) |
| サブスクリプション API   | `/api/v1/subscriptions` | [06-api-design.md](../06-api-design.md#627-サブスクリプション-api)   |
| ソーシャル API           | `/api/v1/invitations`   | [06-api-design.md](../06-api-design.md#628-ソーシャル-api)           |

---

← [目次](../_index.md) | [API 詳細](../06-api-design.md)
