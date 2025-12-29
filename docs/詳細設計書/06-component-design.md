# 6. コンポーネント設計

> 📋 このドキュメントはコンポーネント設計（ユースケース実装）の概要と各セクションへのリンクを提供します。

---

## 6.1. 概要

### 統計情報

| 項目             | 数量 |
| ---------------- | ---- |
| ユースケース総数 | 33   |
| バッチ処理       | 8    |
| カバレッジ       | 100% |

---

## 6.2. 目次

| セクション | ファイル                                                     | 内容               |
| ---------- | ------------------------------------------------------------ | ------------------ |
| 6.3        | [Conversation UCs](./06-component-design/conversation-01.md) | UC-001~010, UC-033 |
| 6.4        | [Feedback UCs](./06-component-design/feedback-01.md)         | UC-004, UC-006     |
| 6.5        | [User UCs](./06-component-design/user-01.md)                 | UC-011~013         |
| 6.6        | [Subscription UCs](./06-component-design/subscription-01.md) | UC-014~016         |
| 6.7        | [Learning UCs](./06-component-design/learning-01.md)         | UC-017, UC-024~026 |
| 6.8        | [Gamification UCs](./06-component-design/gamification-01.md) | UC-018~020         |
| 6.9        | [Progress UCs](./06-component-design/progress-01.md)         | UC-021~023         |
| 6.10       | [Social UCs](./06-component-design/social-01.md)             | UC-027~029         |
| 6.11       | [Advanced UCs](./06-component-design/advanced-01.md)         | UC-030~032         |
| 6.12       | [Batch Processing](./06-component-design/batch-01.md)        | BAT-001~008        |

---

## 6.3. ユースケース処理サマリー

### 6.3.1. 会話系 (UC-001 ～ UC-010)

| UC ID  | UC 名              | 主要処理                     | 複雑度 |
| ------ | ------------------ | ---------------------------- | ------ |
| UC-001 | モード切替         | セッション設定変更           | 低     |
| UC-002 | トピック選択       | シナリオ/トピック検索・選択  | 低     |
| UC-003 | リアルタイム会話   | STT→LLM→TTS パイプライン     | **高** |
| UC-004 | スマート提案表示   | LLM 提案生成                 | 中     |
| UC-005 | ストリーミング字幕 | WebSocket 差分送信           | 中     |
| UC-006 | 即時訂正           | LLM エラー分析               | 中     |
| UC-007 | AI 速度調整        | ユーザー設定更新             | 低     |
| UC-008 | ペルソナ作成       | ペルソナ CRUD                | 低     |
| UC-009 | 会話割り込み       | 処理キャンセル、状態リセット | 中     |
| UC-010 | 発声確認モード     | ユーザー設定更新             | 低     |
| UC-033 | 会話サマリー       | LLM サマリー生成、XP 計算    | 中     |

### 6.3.2. ユーザー・認証系 (UC-011 ～ UC-016)

| UC ID  | UC 名          | 主要処理                   | 複雑度 |
| ------ | -------------- | -------------------------- | ------ |
| UC-011 | ユーザー登録   | バリデーション、ハッシュ化 | 中     |
| UC-012 | ログイン/認証  | 認証、JWT 生成             | 中     |
| UC-013 | パスワード変更 | 旧パスワード検証、更新     | 低     |
| UC-014 | サブスク管理   | プラン情報取得・表示       | 低     |
| UC-015 | 利用量制限     | 日次利用量チェック         | 中     |
| UC-016 | プラン変更     | IAP 連携、プラン更新       | **高** |

### 6.3.3. 学習系 (UC-017 ～ UC-026)

| UC ID  | UC 名                | 主要処理                   | 複雑度 |
| ------ | -------------------- | -------------------------- | ------ |
| UC-017 | 語彙説明             | LLM 説明生成               | 中     |
| UC-018 | 学習ストリーク       | 日次アクティビティ記録     | 中     |
| UC-019 | アチーブメントバッジ | バッジ条件チェック         | 中     |
| UC-020 | 経験値/レベル        | XP 加算、レベルアップ判定  | 中     |
| UC-021 | 統計ダッシュボード   | 統計集計、グラフデータ生成 | 中     |
| UC-022 | 発音スコア履歴       | 履歴取得、トレンド計算     | 低     |
| UC-023 | 週間/月間レポート    | バッチ生成、メール送信     | **高** |
| UC-024 | シナリオライブラリ   | 検索、フィルター           | 低     |
| UC-025 | デイリーチャレンジ   | チャレンジ生成、完了判定   | 中     |
| UC-026 | 単語帳＆復習         | SRS 計算、復習スケジュール | 中     |

### 6.3.4. ソーシャル・上級系 (UC-027 ～ UC-032)

| UC ID  | UC 名              | 主要処理                    | 複雑度 |
| ------ | ------------------ | --------------------------- | ------ |
| UC-027 | 友達招待           | 招待コード生成・検証        | 中     |
| UC-028 | 週間ランキング     | ランキング計算、表示        | 中     |
| UC-029 | グループ学習       | グループ CRUD、メンバー管理 | 中     |
| UC-030 | 発音詳細分析       | 音声分析、スコア算出        | **高** |
| UC-031 | ロールプレイモード | シナリオ実行、状態管理      | 中     |
| UC-032 | TOEIC/IELTS 対策   | テスト形式シナリオ          | 中     |

---

## 6.4. 共通処理パターン

### 6.4.1. トランザクション境界

```typescript
// Service 層でトランザクション管理
@Injectable()
export class ExampleService {
  constructor(private readonly prisma: PrismaService) {}

  async complexOperation(dto: Dto): Promise<Result> {
    return this.prisma.$transaction(async (tx) => {
      // 1. 親エンティティ作成
      const parent = await tx.parent.create({ data: ... });

      // 2. 子エンティティ作成
      const children = await tx.child.createMany({ data: ... });

      // 3. 関連更新
      await tx.related.update({ where: ..., data: ... });

      return { parent, children };
    });
  }
}
```

### 6.4.2. エラーハンドリング

```typescript
// Controller 層での例外変換
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const response = host.switchToHttp().getResponse();

    if (exception instanceof BusinessException) {
      return response.status(exception.httpStatus).json({
        success: false,
        error: {
          code: exception.code,
          message: exception.message,
          details: exception.details,
        },
      });
    }

    // 予期しないエラー
    return response.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "An unexpected error occurred",
      },
    });
  }
}
```

### 6.4.3. バリデーション

```typescript
// DTO でのバリデーション
export class CreateConversationDto {
  @IsEnum(ConversationMode)
  mode: ConversationMode;

  @IsOptional()
  @IsUUID()
  personaId?: string;

  @IsOptional()
  @IsUUID()
  scenarioId?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  topic?: string;
}
```

---

## 6.5. 複雑度別実装ガイド

### 高複雑度 UC (★★★)

| UC     | 特別な考慮事項                           |
| ------ | ---------------------------------------- |
| UC-003 | 並列処理、ストリーミング、エラーリカバリ |
| UC-016 | IAP 検証、状態整合性、ロールバック       |
| UC-023 | バッチ処理、メール送信、障害復旧         |
| UC-030 | 音声処理、詳細スコアリング、キャッシュ   |

### 中複雑度 UC (★★)

- 標準的な CRUD + ビジネスロジック
- 単一トランザクション内で完結
- 外部サービス呼び出しあり

### 低複雑度 UC (★)

- シンプルな CRUD
- 設定変更のみ
- バリデーションのみ

---

← [目次](./_index.md) | _次のセクション: [07-database-design.md](./07-database-design.md)_
