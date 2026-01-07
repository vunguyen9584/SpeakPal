# 8.9. Translation APIs

> このファイルは翻訳練習機能（FR-034〜FR-038）に関する API 設計を定義します。

---

## API サマリー

| No  | API                                            | Method | 説明               |
| --- | ---------------------------------------------- | ------ | ------------------ |
| 1   | /api/v1/translation/questions                  | GET    | 翻訳問題取得       |
| 2   | /api/v1/translation/answers                    | POST   | 翻訳回答評価       |
| 3   | /api/v1/translation/intent-questions           | GET    | 意図問題取得       |
| 4   | /api/v1/translation/intent-answers             | POST   | 意図回答評価       |
| 5   | /api/v1/quick-response/word-association/start  | POST   | ワード連想開始     |
| 6   | /api/v1/quick-response/word-association/answer | POST   | ワード連想回答     |
| 7   | /api/v1/quick-response/word-association/end    | POST   | ワード連想終了     |
| 8   | /api/v1/quick-response/instant-drill/start     | POST   | 瞬間応答開始       |
| 9   | /api/v1/quick-response/instant-drill/next      | GET    | 次の質問取得       |
| 10  | /api/v1/quick-response/instant-drill/answer    | POST   | 瞬間応答回答       |
| 11  | /api/v1/quick-response/instant-drill/end       | POST   | 瞬間応答終了       |
| 12  | /api/v1/shadowing/contents                     | GET    | コンテンツ一覧     |
| 13  | /api/v1/shadowing/contents/:id                 | GET    | コンテンツ詳細     |
| 14  | /api/v1/shadowing/sessions/start               | POST   | シャドーイング開始 |
| 15  | /api/v1/shadowing/sessions/:id/analyze         | POST   | シャドーイング分析 |

---

## API-T01: 翻訳問題取得

### 基本情報

| 項目    | 内容                          |
| ------- | ----------------------------- |
| Method  | GET                           |
| Path    | /api/v1/translation/questions |
| 認証    | Bearer Token                  |
| 関連 UC | UC-034                        |

### Request

```typescript
// Query Parameters
interface GetTranslationQuestionQuery {
  topic: 'daily' | 'business' | 'travel' | 'news' | 'entertainment';
  level?: 'Beginner' | 'Intermediate' | 'Upper' | 'Advanced'; // default: user's level
}

// Headers
{
  "Authorization": "Bearer {accessToken}"
}
```

### Response

```typescript
// 200 OK
interface TranslationQuestionResponse {
  success: true;
  data: {
    id: string;
    topic: string;
    level: string;
    sourceLanguage: string;
    sourceText: string;        // 母国語の問題文
    difficulty: number;        // 1-5
    wordCount: number;
    grammarPoints: string[];
    timeLimit: number;         // 30 seconds
    dailyProgress: {
      completed: number;
      limit: number;
    };
  };
}

// 429 Too Many Requests
{
  "success": false,
  "error": {
    "code": "TRANS_LIMIT_001",
    "message": "本日の練習回数上限に達しました",
    "details": { "limit": 10, "used": 10, "resetAt": "2026-01-08T00:00:00Z" }
  }
}
```

---

## API-T02: 翻訳回答評価

### 基本情報

| 項目    | 内容                        |
| ------- | --------------------------- |
| Method  | POST                        |
| Path    | /api/v1/translation/answers |
| 認証    | Bearer Token                |
| 関連 UC | UC-034                      |

### Request

```typescript
// Headers
{
  "Authorization": "Bearer {accessToken}",
  "Content-Type": "multipart/form-data"
}

// Body
interface TranslationAnswerRequest {
  questionId: string;          // UUID
  audio: File;                 // 音声ファイル (webm/mp3/wav)
  responseTimeSec: number;     // 応答時間（秒）
}
```

### Response

```typescript
// 200 OK
interface TranslationResultResponse {
  success: true;
  data: {
    id: string;
    userAnswer: string; // 音声認識結果
    totalScore: number; // 0-100
    grammarScore: number;
    vocabScore: number;
    speedScore: number;
    modelAnswer: string; // 模範解答
    feedback: {
      goodPoints: string[];
      improvements: string[];
      grammarNotes?: string;
    };
    xpEarned: number;
    streakBonus: boolean;
  };
}
```

### 処理ステップ

```
1. 音声ファイルをSTTで変換
2. 問題データを取得
3. AI評価リクエスト（文法・語彙）
4. 速度スコア計算
5. 総合スコア計算
6. 結果をDB保存
7. XP付与
8. レスポンス返却
```

---

## API-T03: 意図問題取得

### 基本情報

| 項目    | 内容                                 |
| ------- | ------------------------------------ |
| Method  | GET                                  |
| Path    | /api/v1/translation/intent-questions |
| 認証    | Bearer Token                         |
| 関連 UC | UC-035                               |

### Request

```typescript
// Query Parameters
interface GetIntentQuestionQuery {
  category: "greeting" | "daily" | "business" | "emotion" | "request";
}

// 制限: Intermediate以上のレベルが必要
```

### Response

```typescript
// 200 OK
interface IntentQuestionResponse {
  success: true;
  data: {
    id: string;
    category: string;
    level: string;
    intentDescription: string;  // シチュエーション説明
    difficulty: number;
    dailyProgress: {
      completed: number;
      limit: number;
    };
  };
}

// 403 Forbidden (レベル不足)
{
  "success": false,
  "error": {
    "code": "TRANS_LEVEL_001",
    "message": "この機能にはIntermediate以上のレベルが必要です",
    "details": { "required": "Intermediate", "current": "Beginner" }
  }
}
```

---

## API-T04: ワード連想チャレンジ開始

### 基本情報

| 項目    | 内容                                          |
| ------- | --------------------------------------------- |
| Method  | POST                                          |
| Path    | /api/v1/quick-response/word-association/start |
| 認証    | Bearer Token                                  |
| 関連 UC | UC-036                                        |

### Request

```typescript
// Headers
{
  "Authorization": "Bearer {accessToken}",
  "Content-Type": "application/json"
}

// Body (optional)
interface StartWordAssociationRequest {
  difficulty?: 'easy' | 'medium' | 'hard';  // default: based on user level
}
```

### Response

```typescript
// 200 OK
interface WordAssociationStartResponse {
  success: true;
  data: {
    sessionId: string;
    firstKeyword: string;
    totalTime: number;          // 60 seconds
    perQuestionTime: number;    // 5 seconds
    dailyFreeRemaining: number;
  };
}

// 429 Too Many Requests (無料枠使い切り)
{
  "success": false,
  "error": {
    "code": "QR_LIMIT_001",
    "message": "本日の無料チャレンジ回数を使い切りました",
    "details": { "freeLimit": 3, "used": 3, "upgradeUrl": "/subscription" }
  }
}
```

---

## API-T05: ワード連想回答

### 基本情報

| 項目   | 内容                                           |
| ------ | ---------------------------------------------- |
| Method | POST                                           |
| Path   | /api/v1/quick-response/word-association/answer |
| 認証   | Bearer Token                                   |

### Request

```typescript
interface WordAssociationAnswerRequest {
  sessionId: string;
  audio: File; // 音声ファイル
}
```

### Response

```typescript
// 200 OK
interface WordAssociationAnswerResponse {
  success: true;
  data: {
    correct: boolean;
    userResponse: string; // 音声認識結果
    score: number; // 累積スコア
    chain: number; // 現在の連続正解数
    multiplier: number; // 1.0 / 1.5 / 2.0
    nextKeyword: string | null; // 次のキーワード（nullで終了）
    timeRemaining: number; // 残り秒数
  };
}
```

---

## API-T06: 瞬間応答ドリル開始

### 基本情報

| 項目    | 内容                                       |
| ------- | ------------------------------------------ |
| Method  | POST                                       |
| Path    | /api/v1/quick-response/instant-drill/start |
| 認証    | Bearer Token                               |
| 関連 UC | UC-037                                     |

### Request

```typescript
interface StartInstantDrillRequest {
  category: "daily_questions" | "opinions" | "situations";
}
```

### Response

```typescript
// 200 OK
interface InstantDrillStartResponse {
  success: true;
  data: {
    sessionId: string;
    totalQuestions: number; // 10
    perQuestionTime: number; // 10 seconds
    category: string;
  };
}
```

---

## API-T07: シャドーイングコンテンツ一覧

### 基本情報

| 項目    | 内容                       |
| ------- | -------------------------- |
| Method  | GET                        |
| Path    | /api/v1/shadowing/contents |
| 認証    | Bearer Token               |
| 関連 UC | UC-038                     |

### Request

```typescript
// Query Parameters
interface GetShadowingContentsQuery {
  contentType?: "conversation" | "news" | "speech" | "podcast";
  level?: string;
  page?: number;
  limit?: number;
}
```

### Response

```typescript
// 200 OK
interface ShadowingContentsResponse {
  success: true;
  data: {
    items: Array<{
      id: string;
      contentType: string;
      title: string;
      description: string;
      level: string;
      durationSec: number;
      isPremium: boolean;
      isLocked: boolean; // 無料ユーザーかつpremiumコンテンツ
      thumbnailUrl?: string;
    }>;
    pagination: {
      total: number;
      page: number;
      limit: number;
      hasMore: boolean;
    };
  };
}
```

---

## API-T08: シャドーイング分析

### 基本情報

| 項目   | 内容                                   |
| ------ | -------------------------------------- |
| Method | POST                                   |
| Path   | /api/v1/shadowing/sessions/:id/analyze |
| 認証   | Bearer Token                           |

### Request

```typescript
// Headers
{
  "Authorization": "Bearer {accessToken}",
  "Content-Type": "multipart/form-data"
}

// Body
interface AnalyzeShadowingRequest {
  userAudio: File;              // ユーザー録音音声
}
```

### Response

```typescript
// 200 OK
interface ShadowingAnalysisResponse {
  success: true;
  data: {
    totalScore: number; // 0-100
    followingScore: number; // 追従スコア
    pronunciationScore: number; // 発音スコア
    rhythmScore: number; // リズムスコア
    completenessScore: number; // 完成度
    feedback: {
      goodPoints: string[];
      improvements: string[];
    };
    weakSegments: Array<{
      startTime: number;
      endTime: number;
      text: string;
      issue: "pronunciation" | "timing" | "skipped";
    }>;
    xpEarned: number;
  };
}
```

---

## エラーコード一覧

| コード          | HTTP | 説明                                |
| --------------- | ---- | ----------------------------------- |
| TRANS_001       | 403  | マイク権限なし                      |
| TRANS_002       | 503  | AI サービス障害                     |
| TRANS_003       | 400  | 音声認識失敗                        |
| TRANS_004       | 404  | 問題が見つからない                  |
| TRANS_LIMIT_001 | 429  | ダイレクト翻訳日次制限              |
| TRANS_LIMIT_002 | 429  | 意図翻訳日次制限                    |
| TRANS_LEVEL_001 | 403  | レベル制限（Intermediate 以上必要） |
| TRANS_VAL_001   | 400  | 発話が短すぎる                      |
| QR_LIMIT_001    | 429  | チャレンジ日次制限                  |
| QR_LIMIT_002    | 429  | ドリル日次制限                      |
| QR_003          | 404  | セッションが見つからない            |
| SHADOW_001      | 404  | シャドーイングセッションなし        |
| SHADOW_002      | 403  | プレミアムコンテンツ制限            |

---

## レート制限

| エンドポイント     | 制限        |
| ------------------ | ----------- |
| /translation/\*    | 60 req/min  |
| /quick-response/\* | 120 req/min |
| /shadowing/\*      | 30 req/min  |

---

## カバレッジサマリー

| API カテゴリ       | API 数 | ステータス |
| ------------------ | ------ | ---------- |
| Translation API    | 4      | ✅ 完了    |
| Quick Response API | 7      | ✅ 完了    |
| Shadowing API      | 4      | ✅ 完了    |
| **合計**           | **15** | ✅ 完了    |

---

← [WebSocket APIs](./websocket-apis.md) | [目次](../08-api-design.md)
