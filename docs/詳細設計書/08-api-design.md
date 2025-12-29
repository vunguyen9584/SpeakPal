# 8. API 設計

> 📋 このドキュメントは API 設計の概要と各セクションへのリンクを提供します。

---

## 8.1. 概要

### 統計情報

| 項目            | 数量 |
| --------------- | ---- |
| REST API 総数   | 42   |
| WebSocket Event | 10   |
| 合計            | 52   |

### API バージョン

| バージョン | ベースパス | ステータス |
| ---------- | ---------- | ---------- |
| v1         | /api/v1    | Current    |

---

## 8.2. 目次

| セクション | ファイル                                                  | 内容                  |
| ---------- | --------------------------------------------------------- | --------------------- |
| 8.3        | [Auth APIs](./08-api-design/auth-apis.md)                 | 認証関連 (7 APIs)     |
| 8.4        | [User APIs](./08-api-design/user-apis.md)                 | ユーザー (11 APIs)    |
| 8.5        | [Conversation APIs](./08-api-design/conversation-apis.md) | 会話 (5 APIs)         |
| 8.6        | [Learning APIs](./08-api-design/learning-apis.md)         | 学習 (7 APIs)         |
| 8.7        | [Gamification APIs](./08-api-design/gamification-apis.md) | ゲーミフィケーション  |
| 8.8        | [Subscription APIs](./08-api-design/subscription-apis.md) | サブスク (3 APIs)     |
| 8.9        | [Social APIs](./08-api-design/social-apis.md)             | ソーシャル (9 APIs)   |
| 8.10       | [WebSocket APIs](./08-api-design/websocket-apis.md)       | WebSocket (10 Events) |

---

## 8.3. 共通仕様

### 8.3.1. リクエスト形式

**Content-Type:**

```
application/json
```

**認証ヘッダー:**

```
Authorization: Bearer <access_token>
```

### 8.3.2. レスポンス形式

**成功レスポンス:**

```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "timestamp": "2025-12-29T12:00:00Z",
    "requestId": "uuid"
  }
}
```

**ページネーションレスポンス:**

```json
{
  "success": true,
  "data": [ ... ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

**エラーレスポンス:**

```json
{
  "success": false,
  "error": {
    "code": "ERR_AUTH_001",
    "message": "Invalid credentials",
    "details": { ... }
  }
}
```

### 8.3.3. HTTP ステータスコード

| コード | 意味                  | 使用場面             |
| ------ | --------------------- | -------------------- |
| 200    | OK                    | GET/PUT/PATCH 成功   |
| 201    | Created               | POST 作成成功        |
| 204    | No Content            | DELETE 成功          |
| 400    | Bad Request           | バリデーションエラー |
| 401    | Unauthorized          | 未認証               |
| 403    | Forbidden             | 権限不足             |
| 404    | Not Found             | リソース未発見       |
| 409    | Conflict              | 重複エラー           |
| 429    | Too Many Requests     | レート制限           |
| 500    | Internal Server Error | サーバーエラー       |

---

## 8.4. 認証要件

| レベル  | ヘッダー     | 説明               |
| ------- | ------------ | ------------------ |
| Public  | なし         | 認証不要           |
| Auth    | Bearer Token | ログインユーザー   |
| Premium | Bearer Token | Premium プラン限定 |

---

## 8.5. レート制限

| エンドポイントグループ | 制限             | Window |
| ---------------------- | ---------------- | ------ |
| /auth/\*               | 20/分            | 60 秒  |
| /conversations         | 10/分            | 60 秒  |
| /api/v1/\* (一般)      | 100/分           | 60 秒  |
| WebSocket              | 50 メッセージ/分 | 60 秒  |

**レート制限ヘッダー:**

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1735470000
```

---

## 8.6. API 一覧

### 8.6.1. 認証 API (7)

| Method | Endpoint              | 認証 | 説明                   |
| ------ | --------------------- | ---- | ---------------------- |
| POST   | /auth/register        | -    | ユーザー登録           |
| POST   | /auth/login           | -    | ログイン               |
| POST   | /auth/logout          | Auth | ログアウト             |
| POST   | /auth/refresh         | -    | トークン更新           |
| POST   | /auth/forgot-password | -    | パスワードリセット要求 |
| POST   | /auth/reset-password  | -    | パスワードリセット     |
| POST   | /auth/oauth/:provider | -    | OAuth ログイン         |

### 8.6.2. ユーザー API (5)

| Method | Endpoint           | 認証 | 説明             |
| ------ | ------------------ | ---- | ---------------- |
| GET    | /users/me          | Auth | 自分の情報取得   |
| PUT    | /users/me          | Auth | プロフィール更新 |
| PUT    | /users/me/password | Auth | パスワード変更   |
| GET    | /users/me/stats    | Auth | 統計情報取得     |
| PUT    | /users/me/settings | Auth | 設定更新         |

### 8.6.3. ペルソナ API (6)

| Method | Endpoint              | 認証 | 説明           |
| ------ | --------------------- | ---- | -------------- |
| GET    | /personas             | Auth | 一覧取得       |
| POST   | /personas             | Auth | 作成           |
| GET    | /personas/:id         | Auth | 詳細取得       |
| PUT    | /personas/:id         | Auth | 更新           |
| DELETE | /personas/:id         | Auth | 削除           |
| PUT    | /personas/:id/default | Auth | デフォルト設定 |

### 8.6.4. 会話 API (5)

| Method | Endpoint                 | 認証 | 説明       |
| ------ | ------------------------ | ---- | ---------- |
| GET    | /conversations           | Auth | 一覧取得   |
| POST   | /conversations           | Auth | 会話開始   |
| GET    | /conversations/:id       | Auth | 詳細取得   |
| POST   | /conversations/:id/end   | Auth | 会話終了   |
| GET    | /conversations/:id/turns | Auth | ターン一覧 |

### 8.6.5. 学習 API (7)

| Method | Endpoint                 | 認証 | 説明             |
| ------ | ------------------------ | ---- | ---------------- |
| GET    | /vocabularies            | Auth | 語彙一覧         |
| POST   | /vocabularies            | Auth | 語彙追加         |
| POST   | /vocabularies/:id/review | Auth | 復習記録         |
| GET    | /vocabularies/due        | Auth | 復習対象取得     |
| GET    | /scenarios               | Auth | シナリオ一覧     |
| GET    | /scenarios/:id           | Auth | シナリオ詳細     |
| GET    | /challenges/today        | Auth | 今日のチャレンジ |

### 8.6.6. ゲーミフィケーション API (5)

| Method | Endpoint         | 認証 | 説明           |
| ------ | ---------------- | ---- | -------------- |
| GET    | /streaks         | Auth | ストリーク取得 |
| POST   | /streaks/freeze  | Auth | フリーズ使用   |
| GET    | /badges          | Auth | 全バッジ一覧   |
| GET    | /badges/mine     | Auth | 獲得バッジ一覧 |
| GET    | /rankings/weekly | Auth | 週間ランキング |

### 8.6.7. サブスクリプション API (3)

| Method | Endpoint                | 認証 | 説明         |
| ------ | ----------------------- | ---- | ------------ |
| GET    | /subscriptions/me       | Auth | 現在のプラン |
| POST   | /subscriptions/purchase | Auth | プラン購入   |
| POST   | /subscriptions/restore  | Auth | 購入復元     |

### 8.6.8. ソーシャル API (9)

| Method | Endpoint            | 認証 | 説明           |
| ------ | ------------------- | ---- | -------------- |
| POST   | /invitations        | Auth | 招待コード生成 |
| POST   | /invitations/accept | Auth | 招待承諾       |
| GET    | /invitations/mine   | Auth | 自分の招待一覧 |
| GET    | /groups             | Auth | グループ一覧   |
| POST   | /groups             | Auth | グループ作成   |
| GET    | /groups/:id         | Auth | グループ詳細   |
| POST   | /groups/:id/join    | Auth | グループ参加   |
| POST   | /groups/:id/leave   | Auth | グループ退出   |
| GET    | /groups/:id/members | Auth | メンバー一覧   |

---

## 8.7. WebSocket イベント一覧

### 8.7.1. Client → Server

| イベント     | ペイロード                      | 説明     |
| ------------ | ------------------------------- | -------- |
| connection   | `{ token, conversationId }`     | 接続     |
| audio_stream | `{ chunk, sequence, is_final }` | 音声送信 |
| interrupt    | `{ reason }`                    | 割り込み |
| disconnect   | -                               | 切断     |

### 8.7.2. Server → Client

| イベント          | ペイロード                       | 説明         |
| ----------------- | -------------------------------- | ------------ |
| connected         | `{ sessionId }`                  | 接続完了     |
| text_result       | `{ text, is_final, confidence }` | STT 結果     |
| ai_response_start | `{ responseId }`                 | AI 応答開始  |
| ai_response_audio | `{ chunk, sequence }`            | 音声チャンク |
| ai_response_end   | -                                | AI 応答終了  |
| correction        | `{ corrections[] }`              | 訂正情報     |
| suggestion        | `{ template, vocabulary[] }`     | 提案情報     |
| error             | `{ code, message }`              | エラー       |

---

← [目次](./_index.md) | _次のセクション: [09-ui-specifications.md](./09-ui-specifications.md)_
