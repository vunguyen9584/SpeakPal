# 11. エラー処理設計

## 11.1. 概要

本章では SpeakPal AI のエラー処理戦略を定義します。

---

## 11.2. エラー分類

### 11.2.1. エラーカテゴリ

| カテゴリ         | コードプレフィックス | HTTP Status | 説明               |
| ---------------- | -------------------- | ----------- | ------------------ |
| 認証エラー       | ERR*AUTH*            | 401, 403    | 認証・認可の問題   |
| バリデーション   | ERR*VAL*             | 400         | 入力データの問題   |
| ビジネスロジック | ERR*BIZ*             | 400, 409    | ビジネスルール違反 |
| リソース         | ERR*RES*             | 404         | リソース未発見     |
| レート制限       | ERR*RATE*            | 429         | リクエスト過多     |
| 外部サービス     | ERR*EXT*             | 503         | 外部 API 障害      |
| 内部エラー       | ERR*INT*             | 500         | 予期しないエラー   |

---

## 11.3. エラーコード一覧

### 11.3.1. 認証エラー (ERR*AUTH*)

| コード       | メッセージ               | アクション         |
| ------------ | ------------------------ | ------------------ |
| ERR_AUTH_001 | Invalid credentials      | ログイン画面へ     |
| ERR_AUTH_002 | Token expired            | リフレッシュ       |
| ERR_AUTH_003 | Token invalid            | ログイン画面へ     |
| ERR_AUTH_004 | Account locked           | サポート連絡       |
| ERR_AUTH_005 | Email not verified       | 確認メール再送     |
| ERR_AUTH_006 | Insufficient permissions | 権限エラー表示     |
| ERR_AUTH_007 | OAuth provider error     | 別の方法でログイン |

### 11.3.2. バリデーションエラー (ERR*VAL*)

| コード      | メッセージ             | フィールド例    |
| ----------- | ---------------------- | --------------- |
| ERR_VAL_001 | Required field missing | email, password |
| ERR_VAL_002 | Invalid format         | email           |
| ERR_VAL_003 | Value too short        | password        |
| ERR_VAL_004 | Value too long         | username        |
| ERR_VAL_005 | Invalid enum value     | mode            |
| ERR_VAL_006 | Invalid UUID format    | personaId       |

### 11.3.3. ビジネスエラー (ERR*BIZ*)

| コード      | メッセージ                | 説明               |
| ----------- | ------------------------- | ------------------ |
| ERR_BIZ_001 | Email already exists      | メール重複         |
| ERR_BIZ_002 | Usage limit reached       | 日次制限到達       |
| ERR_BIZ_003 | Premium required          | Premium 機能       |
| ERR_BIZ_004 | Max personas reached      | ペルソナ上限       |
| ERR_BIZ_005 | Streak freeze unavailable | フリーズ残数なし   |
| ERR_BIZ_006 | Invitation already used   | 招待コード使用済み |
| ERR_BIZ_007 | Group full                | グループ満員       |

### 11.3.4. 外部サービスエラー (ERR*EXT*)

| コード      | メッセージ              | フォールバック         |
| ----------- | ----------------------- | ---------------------- |
| ERR_EXT_001 | STT service unavailable | 再試行 or 代替サービス |
| ERR_EXT_002 | LLM service unavailable | キャッシュ応答         |
| ERR_EXT_003 | TTS service unavailable | テキストのみ表示       |
| ERR_EXT_004 | Payment service error   | 再試行                 |

---

## 11.4. エラーレスポンス形式

### 11.4.1. 標準エラーレスポンス

```json
{
  "success": false,
  "error": {
    "code": "ERR_AUTH_001",
    "message": "Invalid credentials",
    "details": {
      "field": "password",
      "reason": "Password is incorrect"
    },
    "timestamp": "2025-12-29T12:00:00Z",
    "requestId": "req-uuid-123"
  }
}
```

### 11.4.2. バリデーションエラー (複数フィールド)

```json
{
  "success": false,
  "error": {
    "code": "ERR_VAL_001",
    "message": "Validation failed",
    "details": {
      "fields": [
        { "field": "email", "message": "Invalid email format" },
        { "field": "password", "message": "Password too short" }
      ]
    }
  }
}
```

---

## 11.5. エラーハンドリング実装

### 11.5.1. Exception Filter

```typescript
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  constructor(private readonly logger: LoggerService) {}

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    const errorResponse = this.buildErrorResponse(exception, request);

    // ログ出力
    this.logger.error({
      ...errorResponse,
      stack: exception instanceof Error ? exception.stack : undefined,
    });

    return response.status(errorResponse.status).json(errorResponse.body);
  }

  private buildErrorResponse(exception: unknown, request: Request) {
    if (exception instanceof BusinessException) {
      return {
        status: exception.httpStatus,
        body: {
          success: false,
          error: {
            code: exception.code,
            message: exception.message,
            details: exception.details,
            requestId: request.id,
          },
        },
      };
    }

    // 予期しないエラー
    return {
      status: 500,
      body: {
        success: false,
        error: {
          code: "ERR_INT_001",
          message: "An unexpected error occurred",
          requestId: request.id,
        },
      },
    };
  }
}
```

### 11.5.2. カスタム例外クラス

```typescript
export abstract class BusinessException extends Error {
  abstract readonly code: string;
  abstract readonly httpStatus: number;
  details?: Record<string, unknown>;
}

export class UsageLimitReachedException extends BusinessException {
  code = "ERR_BIZ_002";
  httpStatus = 403;

  constructor(public readonly limit: number) {
    super(`Daily usage limit of ${limit} reached`);
    this.details = { limit };
  }
}
```

---

## 11.6. クライアント側エラーハンドリング

### 11.6.1. Flutter エラーハンドリング

```dart
class ApiErrorHandler {
  static void handle(DioException error, BuildContext context) {
    final errorCode = error.response?.data['error']['code'];

    switch (errorCode) {
      case 'ERR_AUTH_002':
        // トークン期限切れ → リフレッシュ
        AuthService.refreshToken();
        break;
      case 'ERR_AUTH_003':
        // 無効なトークン → ログアウト
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 'ERR_BIZ_002':
        // 利用制限 → アップグレード提案
        showUpgradeDialog(context);
        break;
      default:
        // 一般エラー表示
        showErrorSnackBar(context, error.response?.data['error']['message']);
    }
  }
}
```

---

## 11.7. リトライ戦略

| エラー種別         | リトライ | 最大回数 | 間隔           |
| ------------------ | -------- | -------- | -------------- |
| ネットワークエラー | ○        | 3        | 指数バックオフ |
| タイムアウト       | ○        | 2        | 1 秒 → 2 秒    |
| 外部サービス 5xx   | ○        | 3        | 指数バックオフ |
| 認証エラー         | ✗        | -        | -              |
| バリデーション     | ✗        | -        | -              |

---

← [目次](./_index.md) | _次のセクション: [12-logging-monitoring.md](./12-logging-monitoring.md)_
