# 10. セキュリティ設計

## 10.1. 概要

本章では SpeakPal AI のセキュリティ設計を定義します。

---

## 10.2. 認証設計

### 10.2.1. 認証方式

| 方式                | 用途               | 仕様                   |
| ------------------- | ------------------ | ---------------------- |
| JWT (Access Token)  | API 認証           | HS256, 有効期限 1 時間 |
| JWT (Refresh Token) | トークン更新       | HS256, 有効期限 30 日  |
| OAuth 2.0           | ソーシャルログイン | Google, Apple          |

### 10.2.2. トークン仕様

**Access Token ペイロード:**

```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "role": "user",
  "plan": "premium",
  "iat": 1735470000,
  "exp": 1735473600
}
```

**セキュリティ設定:**
| 項目 | 値 |
| -------------- | --------------------- |
| Algorithm | HS256 |
| Secret Length | 256 bits (最小) |
| Access Token | 1 時間 |
| Refresh Token | 30 日 |

### 10.2.3. パスワードポリシー

| 項目     | 要件                |
| -------- | ------------------- |
| 最小長   | 8 文字              |
| 最大長   | 128 文字            |
| 必須文字 | 英字 + 数字         |
| ハッシュ | bcrypt (cost=12)    |
| 履歴     | 過去 3 回と同一不可 |

---

## 10.3. 認可設計

### 10.3.1. RBAC (Role-Based Access Control)

| ロール  | 権限                   |
| ------- | ---------------------- |
| guest   | 公開エンドポイントのみ |
| user    | 自分のデータ (CRUD)    |
| premium | user + Premium 機能    |
| admin   | 全データ (将来実装)    |

### 10.3.2. リソースアクセス制御

```typescript
// Guard 実装例
@Injectable()
export class OwnershipGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const resourceUserId = request.params.userId || request.body.userId;

    // 自分のリソースのみアクセス可
    return user.id === resourceUserId;
  }
}
```

---

## 10.4. 通信セキュリティ

### 10.4.1. TLS 設定

| 項目           | 設定                    |
| -------------- | ----------------------- |
| 最小バージョン | TLS 1.2                 |
| 推奨バージョン | TLS 1.3                 |
| 証明書         | Let's Encrypt / AWS ACM |
| HSTS           | 1 年, includeSubDomains |

### 10.4.2. CORS 設定

```typescript
const corsOptions = {
  origin: [
    "https://speakpal.app",
    "capacitor://localhost", // iOS
    "http://localhost", // Android
  ],
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
};
```

---

## 10.5. データ保護

### 10.5.1. 暗号化

| 対象         | 方式                     |
| ------------ | ------------------------ |
| パスワード   | bcrypt (cost=12)         |
| DB at rest   | AES-256                  |
| バックアップ | AES-256                  |
| 音声データ   | 一時保存のみ、処理後削除 |

### 10.5.2. 機密データ処理

| データ種別     | 保存     | マスキング | 保持期間    |
| -------------- | -------- | ---------- | ----------- |
| パスワード     | ハッシュ | N/A        | 永久        |
| メールアドレス | 平文     | 部分マスク | 退会後 1 年 |
| 音声データ     | 不可     | N/A        | 処理中のみ  |
| 会話内容       | 暗号化   | なし       | 1 年        |

---

## 10.6. 入力検証

### 10.6.1. バリデーション戦略

| レイヤー    | 責務                              |
| ----------- | --------------------------------- |
| Client      | UX 向上のための即時フィードバック |
| API Gateway | 形式チェック、サイズ制限          |
| Service     | ビジネスルール検証                |
| Database    | 型制約、参照整合性                |

### 10.6.2. 主要バリデーションルール

```typescript
export class ValidationRules {
  static email = {
    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    maxLength: 255,
  };

  static password = {
    minLength: 8,
    maxLength: 128,
    pattern: /^(?=.*[a-zA-Z])(?=.*[0-9])/,
  };

  static username = {
    minLength: 3,
    maxLength: 50,
    pattern: /^[a-zA-Z0-9_-]+$/,
  };
}
```

---

## 10.7. 脆弱性対策 (OWASP Top 10)

| 脆弱性                                | 対策                               |
| ------------------------------------- | ---------------------------------- |
| Injection                             | Prisma ORM (パラメータ化クエリ)    |
| Broken Authentication                 | JWT + Refresh Token ローテーション |
| Sensitive Data Exposure               | TLS 1.3, at-rest 暗号化            |
| XXE                                   | JSON のみ使用                      |
| Broken Access Control                 | RBAC + リソースオーナーシップ検証  |
| Security Misconfiguration             | Infrastructure as Code             |
| XSS                                   | React 自動エスケープ               |
| Insecure Deserialization              | JSON Schema バリデーション         |
| Using Components with Vulnerabilities | Dependabot                         |
| Insufficient Logging                  | 全リクエストログ + 監査ログ        |

---

## 10.8. レート制限

| エンドポイント             | 制限   | 期間   |
| -------------------------- | ------ | ------ |
| POST /auth/login           | 10 回  | 1 分   |
| POST /auth/register        | 5 回   | 1 分   |
| POST /auth/forgot-password | 3 回   | 1 時間 |
| POST /conversations        | 10 回  | 1 分   |
| その他 API                 | 100 回 | 1 分   |

---

← [目次](./_index.md) | _次のセクション: [11-error-handling.md](./11-error-handling.md)_
