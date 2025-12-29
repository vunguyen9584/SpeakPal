# 12. ログ・監視設計

## 12.1. 概要

本章では SpeakPal AI のログ出力と監視設計を定義します。

---

## 12.2. ログ設計

### 12.2.1. ログレベル

| レベル | 用途                | 本番環境 |
| ------ | ------------------- | -------- |
| ERROR  | エラー、例外        | ○        |
| WARN   | 警告、潜在的問題    | ○        |
| INFO   | 重要な処理開始/完了 | ○        |
| DEBUG  | デバッグ情報        | ✗        |
| TRACE  | 詳細トレース        | ✗        |

### 12.2.2. ログ形式

```json
{
  "timestamp": "2025-12-29T12:00:00.000Z",
  "level": "INFO",
  "service": "conversation-service",
  "traceId": "trace-uuid",
  "spanId": "span-uuid",
  "userId": "user-uuid",
  "message": "Conversation started",
  "context": {
    "conversationId": "conv-uuid",
    "mode": "instructor"
  }
}
```

### 12.2.3. 必須ログポイント

| イベント           | レベル | コンテキスト              |
| ------------------ | ------ | ------------------------- |
| API リクエスト受信 | INFO   | method, path, userId      |
| API レスポンス送信 | INFO   | status, duration          |
| 認証成功/失敗      | INFO   | userId, provider          |
| 会話開始           | INFO   | conversationId, mode      |
| 会話終了           | INFO   | duration, score, xp       |
| 外部 API 呼び出し  | INFO   | service, duration, status |
| エラー発生         | ERROR  | code, message, stack      |
| レート制限発動     | WARN   | userId, endpoint          |

---

## 12.3. 構造化ログ実装

### 12.3.1. Logger Service

```typescript
@Injectable()
export class LoggerService {
  private readonly logger: pino.Logger;

  constructor(private readonly configService: ConfigService) {
    this.logger = pino({
      level: configService.get("LOG_LEVEL", "info"),
      formatters: {
        level: (label) => ({ level: label }),
      },
      timestamp: pino.stdTimeFunctions.isoTime,
    });
  }

  info(message: string, context?: Record<string, unknown>) {
    this.logger.info({ ...context }, message);
  }

  error(message: string, error?: Error, context?: Record<string, unknown>) {
    this.logger.error(
      {
        ...context,
        error: error
          ? {
              message: error.message,
              stack: error.stack,
            }
          : undefined,
      },
      message
    );
  }
}
```

### 12.3.2. Request Logger Middleware

```typescript
@Injectable()
export class RequestLoggerMiddleware implements NestMiddleware {
  constructor(private readonly logger: LoggerService) {}

  use(req: Request, res: Response, next: NextFunction) {
    const startTime = Date.now();
    const requestId = uuid();
    req.id = requestId;

    this.logger.info("Request received", {
      requestId,
      method: req.method,
      path: req.path,
      userId: req.user?.id,
    });

    res.on("finish", () => {
      this.logger.info("Response sent", {
        requestId,
        status: res.statusCode,
        duration: Date.now() - startTime,
      });
    });

    next();
  }
}
```

---

## 12.4. メトリクス設計

### 12.4.1. ビジネスメトリクス

| メトリクス名                   | タイプ    | 説明           |
| ------------------------------ | --------- | -------------- |
| conversations_total            | Counter   | 会話総数       |
| conversations_duration_seconds | Histogram | 会話時間分布   |
| users_active_daily             | Gauge     | DAU            |
| xp_awarded_total               | Counter   | 付与 XP 総数   |
| badges_earned_total            | Counter   | 獲得バッジ総数 |

### 12.4.2. テクニカルメトリクス

| メトリクス名                    | タイプ    | 説明              |
| ------------------------------- | --------- | ----------------- |
| http_requests_total             | Counter   | HTTP リクエスト数 |
| http_request_duration_seconds   | Histogram | レスポンス時間    |
| websocket_connections           | Gauge     | WS 接続数         |
| external_api_duration_seconds   | Histogram | 外部 API 応答時間 |
| database_query_duration_seconds | Histogram | DB クエリ時間     |

### 12.4.3. Prometheus 形式

```typescript
// Prometheus メトリクス例
const conversationsTotal = new Counter({
  name: "speakpal_conversations_total",
  help: "Total number of conversations",
  labelNames: ["mode", "status"],
});

const httpRequestDuration = new Histogram({
  name: "speakpal_http_request_duration_seconds",
  help: "HTTP request duration in seconds",
  labelNames: ["method", "path", "status"],
  buckets: [0.01, 0.05, 0.1, 0.5, 1, 2, 5],
});
```

---

## 12.5. 監視・アラート設計

### 12.5.1. 監視ダッシュボード

| ダッシュボード    | 内容                       |
| ----------------- | -------------------------- |
| Overview          | 主要 KPI、ヘルスチェック   |
| API Performance   | レスポンス時間、エラー率   |
| Conversations     | 会話数、完了率、平均時間   |
| External Services | STT/LLM/TTS の遅延、可用性 |
| Infrastructure    | CPU、メモリ、ネットワーク  |

### 12.5.2. アラート定義

| アラート名            | 条件                   | 深刻度   | 通知先    |
| --------------------- | ---------------------- | -------- | --------- |
| HighErrorRate         | エラー率 > 5% (5 分間) | Critical | PagerDuty |
| SlowAPIResponse       | P95 > 2 秒 (5 分間)    | Warning  | Slack     |
| ExternalServiceDown   | 外部 API 可用性 < 99%  | Critical | PagerDuty |
| HighCPUUsage          | CPU > 80% (10 分間)    | Warning  | Slack     |
| DBConnectionExhausted | 接続数 > 80%           | Critical | PagerDuty |
| LowDiskSpace          | ディスク使用率 > 80%   | Warning  | Slack     |

### 12.5.3. SLO/SLI

| サービスレベル目標 | SLI                 | SLO      |
| ------------------ | ------------------- | -------- |
| 可用性             | 成功リクエスト率    | 99.9%    |
| 応答時間           | P95 レスポンス時間  | < 500ms  |
| AI 応答開始        | 音声入力 → 応答開始 | < 1000ms |
| エラー率           | 5xx エラー率        | < 0.1%   |

---

## 12.6. 分散トレーシング

### 12.6.1. トレースコンテキスト

```typescript
// トレースヘッダー伝播
const traceContext = {
  traceId: "trace-uuid",
  spanId: "span-uuid",
  parentSpanId: "parent-span-uuid",
};

// 外部API呼び出し時の伝播
const headers = {
  "X-Trace-Id": traceContext.traceId,
  "X-Span-Id": newSpanId(),
  "X-Parent-Span-Id": traceContext.spanId,
};
```

### 12.6.2. サービス間トレース

```
Client → API Gateway → Conversation Service → STT → LLM → TTS → Client
   │         │              │                 │      │      │
   └─────────┴──────────────┴─────────────────┴──────┴──────┘
                        同一 traceId で追跡可能
```

---

← [目次](./_index.md) | _次のセクション: [13-deployment-design.md](./13-deployment-design.md)_
