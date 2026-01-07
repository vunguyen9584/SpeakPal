# WP-BE-017: Translation Service (Backend)

> 📦 Work Package: Translation Service Implementation
> 📅 Estimated: 4 days (32 hours)
> 🔗 Dependencies: WP-BE-005 (User Module), WP-INT-001 (Deepgram STT)
> 📚 DD Reference: `06-component-design/translation-01.md`, `08-api-design/translation-apis.md`

---

## 📊 Overview

| Metric     | Value                                        |
| ---------- | -------------------------------------------- |
| Tasks      | 8                                            |
| Est. Hours | 32                                           |
| UCs        | UC-034 (Direct Translation), UC-035 (Intent) |
| APIs       | 4 (GET/POST translation, GET/POST intent)    |
| BRs        | BR-095 ~ BR-106                              |

---

## 📋 Task List

| Task ID | Task Name                            | Type        | Hours | Status |
| ------- | ------------------------------------ | ----------- | ----- | ------ |
| P5-T005 | Create Translation DTOs              | feature     | 2     | ⬜     |
| P5-T006 | Create Translation Repository        | feature     | 3     | ⬜     |
| P5-T007 | Implement getTranslationQuestion     | feature     | 4     | ⬜     |
| P5-T008 | Implement evaluateTranslation        | feature     | 6     | ⬜     |
| P5-T009 | Implement Intent Translation         | feature     | 5     | ⬜     |
| P5-T010 | Create Translation Controller        | feature     | 4     | ⬜     |
| P5-T011 | Translation Service Unit Tests       | test        | 4     | ⬜     |
| P5-T012 | Wire Translation Module Dependencies | integration | 4     | ⬜     |

---

## 🎯 Task Details

### P5-T005: Create Translation DTOs

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `08-api-design/translation-apis.md#request-response`

---

#### Description

Tạo Data Transfer Objects cho Translation APIs bao gồm request DTOs, response DTOs, và validation decorators. DTOs cần cover cả Direct Translation và Intent Translation flows.

#### Required Methods (from DD)

| DTO                         | Purpose                           | DD Ref  |
| --------------------------- | --------------------------------- | ------- |
| GetTranslationQuestionQuery | Query params cho GET /questions   | API-T01 |
| TranslationQuestionResponse | Response cho translation question | API-T01 |
| TranslationAnswerRequest    | Request body cho POST /answers    | API-T02 |
| TranslationResultResponse   | Response cho evaluation result    | API-T02 |
| GetIntentQuestionQuery      | Query params cho GET /intent      | API-T03 |
| IntentQuestionResponse      | Response cho intent question      | API-T03 |
| IntentAnswerRequest         | Request body cho intent answer    | API-T04 |
| IntentResultResponse        | Response cho intent evaluation    | API-T04 |

#### Files

| Action | Path                                                  |
| ------ | ----------------------------------------------------- |
| Create | `src/translation/dto/get-translation-question.dto.ts` |
| Create | `src/translation/dto/translation-answer.dto.ts`       |
| Create | `src/translation/dto/translation-response.dto.ts`     |
| Create | `src/translation/dto/intent-question.dto.ts`          |
| Create | `src/translation/dto/intent-answer.dto.ts`            |
| Create | `src/translation/dto/index.ts`                        |

#### DTO Specifications

```typescript
// get-translation-question.dto.ts
export class GetTranslationQuestionQueryDto {
  @IsEnum(["daily", "business", "travel", "news", "entertainment"])
  topic: string;

  @IsOptional()
  @IsEnum(["Beginner", "Intermediate", "Upper", "Advanced"])
  level?: string;
}

// translation-answer.dto.ts
export class TranslationAnswerDto {
  @IsUUID()
  questionId: string;

  @IsNumber()
  @Min(0)
  @Max(60)
  responseTimeSec: number;
}

// translation-response.dto.ts
export class TranslationResultResponseDto {
  id: string;
  userAnswer: string;
  totalScore: number;
  grammarScore: number;
  vocabScore: number;
  speedScore: number;
  modelAnswer: string;
  feedback: {
    goodPoints: string[];
    improvements: string[];
    grammarNotes?: string;
  };
  xpEarned: number;
  streakBonus: boolean;
}
```

#### Acceptance Criteria

- [ ] 8 DTOs created với class-validator decorators
- [ ] All DTOs có proper TypeScript types
- [ ] Validation messages in Japanese (error messages)
- [ ] Response DTOs có static `fromEntity()` methods
- [ ] Index file exports all DTOs

---

### P5-T006: Create Translation Repository

**Type:** feature
**Est. Hours:** 3
**DD Ref:** `06-component-design/translation-01.md#pseudocode`

---

#### Description

Tạo TranslationRepository và TranslationResultRepository để handle database operations. Bao gồm methods cho random question selection, result storage, và daily count tracking.

#### Required Methods (from DD)

| Method             | Signature                                       | DD Ref     |
| ------------------ | ----------------------------------------------- | ---------- |
| findRandomQuestion | (topic, level, excludeIds) => Promise<Question> | UC-034 seq |
| findById           | (id: string) => Promise<Question>               | UC-034     |
| createResult       | (data: CreateResultDto) => Promise<Result>      | UC-034     |
| getDailyCount      | (userId, practiceType, date) => Promise<number> | BR-099     |
| findIntentQuestion | (category, level) => Promise<IntentQuestion>    | UC-035     |

#### Dependencies (to inject)

| Dependency    | Type    | Source WP |
| ------------- | ------- | --------- |
| PrismaService | Service | WP-BE-001 |
| LoggerService | Service | WP-BE-003 |

#### Files

| Action | Path                                                              |
| ------ | ----------------------------------------------------------------- |
| Create | `src/translation/repositories/translation-question.repository.ts` |
| Create | `src/translation/repositories/translation-result.repository.ts`   |
| Create | `src/translation/repositories/intent-question.repository.ts`      |
| Create | `src/translation/repositories/index.ts`                           |

#### Implementation

```typescript
@Injectable()
export class TranslationQuestionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findRandomQuestion(
    topic: string,
    level: UserLevel,
    excludeIds: string[]
  ): Promise<TranslationQuestion | null> {
    // Use raw query for RANDOM() selection with exclusions
    const questions = await this.prisma.$queryRaw<TranslationQuestion[]>`
      SELECT * FROM translation_questions
      WHERE topic = ${topic}
        AND level = ${level}
        AND is_active = true
        AND id NOT IN (${Prisma.join(excludeIds.length ? excludeIds : [""])})
      ORDER BY RANDOM()
      LIMIT 1
    `;
    return questions[0] || null;
  }

  async findById(id: string): Promise<TranslationQuestion | null> {
    return this.prisma.translationQuestion.findUnique({
      where: { id },
    });
  }
}

@Injectable()
export class TranslationResultRepository {
  async getDailyCount(
    userId: string,
    practiceType: PracticeType,
    date: Date
  ): Promise<number> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    return this.prisma.translationResult.count({
      where: {
        userId,
        practiceType,
        createdAt: {
          gte: startOfDay,
          lte: endOfDay,
        },
      },
    });
  }
}
```

#### Acceptance Criteria

- [ ] TranslationQuestionRepository với findRandomQuestion method
- [ ] TranslationResultRepository với getDailyCount method
- [ ] IntentQuestionRepository với findByCategory method
- [ ] All repositories use PrismaService injection
- [ ] Raw query cho random selection (performance)
- [ ] Proper error handling và logging

---

### P5-T007: Implement getTranslationQuestion

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `06-component-design/translation-01.md#uc-034`

---

#### Description

Implement logic để lấy translation question cho user. Bao gồm: check daily limit, get recently shown từ Redis, fetch random question excluding recent, update Redis cache.

#### Required Methods (from DD)

| Method                 | Signature                                       | DD Ref |
| ---------------------- | ----------------------------------------------- | ------ |
| getTranslationQuestion | (userId, topic, level?) => Promise<QuestionDto> | UC-034 |
| getDailyProgress       | (userId) => Promise<{completed, limit}>         | BR-099 |

#### Dependencies (to inject)

| Dependency              | Type       | Source WP  |
| ----------------------- | ---------- | ---------- |
| TranslationQuestionRepo | Repository | P5-T006    |
| RedisService            | Service    | WP-INF-002 |
| UserService             | Service    | WP-BE-005  |
| SubscriptionService     | Service    | WP-BE-015  |

#### Files

| Action | Path                                              |
| ------ | ------------------------------------------------- |
| Create | `src/translation/services/translation.service.ts` |

#### Implementation Logic

```typescript
async getTranslationQuestion(
  userId: string,
  topic: string,
  level?: UserLevel
): Promise<TranslationQuestionResponseDto> {
  // 1. Check daily limit (BR-099)
  const dailyCount = await this.resultRepo.getDailyCount(userId, 'DIRECT', new Date());
  const userPlan = await this.subscriptionService.getUserPlan(userId);
  const limit = DAILY_LIMITS[userPlan].directTranslation;

  if (dailyCount >= limit) {
    throw new UsageLimitException('TRANS_LIMIT_001', '本日の練習回数上限に達しました');
  }

  // 2. Get recently shown question IDs from Redis (BR-095)
  const cacheKey = `recently_shown:${userId}:${topic}`;
  const recentIds = await this.redis.smembers(cacheKey);

  // 3. Get user's level if not specified
  const userLevel = level || (await this.userService.getUserLevel(userId));

  // 4. Fetch random question excluding recent
  let question = await this.questionRepo.findRandomQuestion(topic, userLevel, recentIds);

  // 5. If all exhausted, reset cache and get any
  if (!question) {
    await this.redis.del(cacheKey);
    question = await this.questionRepo.findRandomQuestion(topic, userLevel, []);
  }

  if (!question) {
    throw new NotFoundException('TRANS_004', '利用可能な問題がありません');
  }

  // 6. Add to recently shown (expire 7 days = 604800 seconds)
  await this.redis.sadd(cacheKey, question.id);
  await this.redis.expire(cacheKey, 604800);

  // 7. Return response
  return TranslationQuestionResponseDto.fromEntity(question, {
    dailyProgress: { completed: dailyCount, limit }
  });
}
```

#### Business Rules

| Rule ID | Rule                                                    | Implementation            |
| ------- | ------------------------------------------------------- | ------------------------- |
| BR-095  | 同一トピック内で過去 7 日間に出題された文は再出題しない | Redis SADD with 7-day TTL |
| BR-099  | Free 10 問/日, Pro 50 問/日, Plus 無制限                | Check in getDailyProgress |

#### Acceptance Criteria

- [ ] Method returns random question not recently shown
- [ ] Daily limit enforced based on user's subscription plan
- [ ] Redis cache updated with 7-day expiry
- [ ] NotFoundException when no questions available
- [ ] UsageLimitException when daily limit reached
- [ ] Response includes daily progress info

---

### P5-T008: Implement evaluateTranslation

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-01.md#evaluate`

---

#### Description

Implement evaluation logic cho user's translation answer. Call LLM để analyze grammar/vocab, calculate speed score, compute total score với weights, award XP với streak bonus.

#### Required Methods (from DD)

| Method               | Signature                                                | DD Ref |
| -------------------- | -------------------------------------------------------- | ------ |
| evaluateTranslation  | (userId, questionId, userAnswer, responseTime) => Result | UC-034 |
| calculateSpeedScore  | (responseTimeSec: number) => number                      | BR-097 |
| getTranslationStreak | (userId) => Promise<number>                              | BR-098 |

#### Dependencies (to inject)

| Dependency            | Type       | Source WP  |
| --------------------- | ---------- | ---------- |
| LLMService            | Service    | WP-INT-002 |
| TranslationResultRepo | Repository | P5-T006    |
| UserService           | Service    | WP-BE-005  |
| STTService            | Service    | WP-INT-001 |

#### Files

| Action | Path                                              |
| ------ | ------------------------------------------------- |
| Modify | `src/translation/services/translation.service.ts` |

#### LLM Prompt Template

```typescript
const EVALUATION_PROMPT = `
You are an English language teacher evaluating a student's translation.

Source text (Japanese): {sourceText}
Expected answer: {targetText}
Alternative correct answers: {altAnswers}
Student's answer: {userAnswer}
Student's level: {level}

Evaluate the student's answer and provide:
1. grammarScore (0-100): How grammatically correct is the answer?
2. vocabScore (0-100): How appropriate is the vocabulary choice?
3. feedback:
   - goodPoints: List 1-3 things the student did well
   - improvements: List 1-3 areas for improvement
   - grammarNotes: Any specific grammar explanation if needed

Return JSON format:
{
  "grammarScore": number,
  "vocabScore": number,
  "feedback": { "goodPoints": [], "improvements": [], "grammarNotes": "" }
}
`;
```

#### Implementation Logic

```typescript
async evaluateTranslation(
  userId: string,
  questionId: string,
  userAnswer: string,
  responseTimeSec: number
): Promise<TranslationResultResponseDto> {
  // 1. Check daily limit
  const dailyCount = await this.getDailyCount(userId, 'DIRECT');
  const limit = await this.getDailyLimit(userId);
  if (dailyCount >= limit) {
    throw new UsageLimitException('TRANS_LIMIT_001');
  }

  // 2. Get question
  const question = await this.questionRepo.findById(questionId);
  if (!question) throw new NotFoundException('TRANS_004');

  // 3. AI evaluation
  const aiEval = await this.llmService.evaluateTranslation({
    sourceText: question.sourceText,
    targetText: question.targetText,
    altAnswers: question.altAnswers,
    userAnswer,
    level: question.level
  });

  // 4. Calculate speed score (BR-097)
  const speedScore = this.calculateSpeedScore(responseTimeSec);

  // 5. Calculate total score (40% grammar, 30% vocab, 30% speed)
  const totalScore = Math.round(
    aiEval.grammarScore * 0.4 +
    aiEval.vocabScore * 0.3 +
    speedScore * 0.3
  );

  // 6. Calculate XP (BR-098)
  let xpEarned = 20; // Base XP
  if (totalScore >= 80) xpEarned += 10;
  const streak = await this.getTranslationStreak(userId);
  if (totalScore >= 70 && streak >= 4) xpEarned += 30; // Streak bonus

  // 7. Save result
  const result = await this.resultRepo.create({
    userId,
    practiceType: 'DIRECT',
    questionId,
    userAnswer,
    totalScore,
    grammarScore: aiEval.grammarScore,
    vocabScore: aiEval.vocabScore,
    speedScore,
    responseTimeSec,
    feedback: aiEval.feedback,
    xpEarned
  });

  // 8. Award XP
  await this.userService.addXP(userId, xpEarned);

  return {
    ...result,
    modelAnswer: question.targetText,
    streakBonus: streak >= 4 && totalScore >= 70
  };
}

private calculateSpeedScore(responseTimeSec: number): number {
  if (responseTimeSec <= 5) return 100;
  if (responseTimeSec <= 10) return 80;
  if (responseTimeSec <= 15) return 60;
  if (responseTimeSec <= 20) return 40;
  return 20;
}
```

#### Business Rules

| Rule ID | Rule                                                                            | Implementation        |
| ------- | ------------------------------------------------------------------------------- | --------------------- |
| BR-097  | Speed score: 5 秒以内 100 点, 10 秒以内 80 点, 15 秒以内 60 点, 20 秒以内 40 点 | calculateSpeedScore() |
| BR-098  | XP: 完了 20XP, 80 点以上+10XP, 連続 5 問正解+30XP                               | Streak bonus logic    |

#### Acceptance Criteria

- [ ] LLM called with proper prompt for evaluation
- [ ] Speed score calculated correctly per BR-097
- [ ] Total score uses weights: 40% grammar, 30% vocab, 30% speed
- [ ] XP awarded with streak bonus when applicable
- [ ] Result saved to database with all scores
- [ ] Response includes model answer and feedback

---

### P5-T009: Implement Intent Translation

**Type:** feature
**Est. Hours:** 5
**DD Ref:** `06-component-design/translation-01.md#uc-035`

---

#### Description

Implement UC-035 高度意図翻訳練習. User receives a situation description và phải express the intent in English. Requires Intermediate+ level.

#### Required Methods (from DD)

| Method                   | Signature                                         | DD Ref |
| ------------------------ | ------------------------------------------------- | ------ |
| getIntentQuestion        | (userId, category) => Promise<IntentQuestion>     | UC-035 |
| evaluateIntentExpression | (userId, questionId, userExpr) => Promise<Result> | UC-035 |

#### Dependencies (to inject)

| Dependency         | Type       | Source WP  |
| ------------------ | ---------- | ---------- |
| IntentQuestionRepo | Repository | P5-T006    |
| LLMService         | Service    | WP-INT-002 |
| UserService        | Service    | WP-BE-005  |

#### Files

| Action | Path                                              |
| ------ | ------------------------------------------------- |
| Modify | `src/translation/services/translation.service.ts` |

#### Business Rules

| Rule ID | Rule                                    | Implementation |
| ------- | --------------------------------------- | -------------- |
| BR-101  | Intermediate 以上のレベルのみ利用可     | Level check    |
| BR-102  | 同一意図に対して複数の正解表現を許容    | altPhrases     |
| BR-104  | XP: 完了 30XP, 85 点以上で追加 20XP     | XP calc        |
| BR-106  | Free 5 問/日, Pro 30 問/日, Plus 無制限 | Daily limit    |

#### Acceptance Criteria

- [ ] Level restriction enforced (Intermediate+)
- [ ] Intent question returned with situation description
- [ ] AI evaluates: intent match (40%), naturalness (30%), vocab (30%)
- [ ] Multiple correct expressions accepted
- [ ] Alternative phrases shown in response
- [ ] XP awarded: 30 base + 20 bonus for 85+

---

### P5-T010: Create Translation Controller

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `08-api-design/translation-apis.md`

---

#### Description

Tạo TranslationController với 4 endpoints: GET /questions, POST /answers, GET /intent-questions, POST /intent-answers. Handle file upload cho audio.

#### Required Methods (from DD)

| Method                  | Route                                | HTTP | DD Ref  |
| ----------------------- | ------------------------------------ | ---- | ------- |
| getTranslationQuestion  | /api/v1/translation/questions        | GET  | API-T01 |
| submitTranslationAnswer | /api/v1/translation/answers          | POST | API-T02 |
| getIntentQuestion       | /api/v1/translation/intent-questions | GET  | API-T03 |
| submitIntentAnswer      | /api/v1/translation/intent-answers   | POST | API-T04 |

#### Files

| Action | Path                                        |
| ------ | ------------------------------------------- |
| Create | `src/translation/translation.controller.ts` |
| Create | `src/translation/translation.module.ts`     |

#### Implementation

```typescript
@Controller("api/v1/translation")
@UseGuards(JwtAuthGuard)
@ApiTags("Translation")
export class TranslationController {
  constructor(private readonly translationService: TranslationService) {}

  @Get("questions")
  @ApiOperation({ summary: "翻訳問題取得" })
  async getQuestion(
    @Query() query: GetTranslationQuestionQueryDto,
    @GetUser() user: User
  ): Promise<TranslationQuestionResponseDto> {
    return this.translationService.getTranslationQuestion(
      user.id,
      query.topic,
      query.level
    );
  }

  @Post("answers")
  @ApiOperation({ summary: "翻訳回答評価" })
  @UseInterceptors(FileInterceptor("audio"))
  async submitAnswer(
    @Body() dto: TranslationAnswerDto,
    @UploadedFile() audio: Express.Multer.File,
    @GetUser() user: User
  ): Promise<TranslationResultResponseDto> {
    // 1. Transcribe audio
    const transcript = await this.sttService.transcribe(audio.buffer);

    // 2. Evaluate
    return this.translationService.evaluateTranslation(
      user.id,
      dto.questionId,
      transcript,
      dto.responseTimeSec
    );
  }

  @Get("intent-questions")
  @ApiOperation({ summary: "意図問題取得" })
  async getIntentQuestion(
    @Query() query: GetIntentQuestionQueryDto,
    @GetUser() user: User
  ): Promise<IntentQuestionResponseDto> {
    return this.translationService.getIntentQuestion(user.id, query.category);
  }

  @Post("intent-answers")
  @UseInterceptors(FileInterceptor("audio"))
  async submitIntentAnswer(
    @Body() dto: IntentAnswerDto,
    @UploadedFile() audio: Express.Multer.File,
    @GetUser() user: User
  ): Promise<IntentResultResponseDto> {
    const transcript = await this.sttService.transcribe(audio.buffer);
    return this.translationService.evaluateIntentExpression(
      user.id,
      dto.questionId,
      transcript
    );
  }
}
```

#### Acceptance Criteria

- [ ] 4 endpoints registered với proper routes
- [ ] JWT authentication guard applied
- [ ] File upload handling for audio
- [ ] Swagger documentation với @ApiOperation
- [ ] Proper error responses (400, 403, 404, 429)
- [ ] Response format matches DD specification

---

### P5-T011: Translation Service Unit Tests

**Type:** test
**Est. Hours:** 4
**DD Ref:** `06-component-design/translation-01.md`

---

#### Description

Tạo unit tests cho TranslationService covering: question fetching, evaluation, daily limits, XP calculation, streak bonus.

#### Files

| Action | Path                                                          |
| ------ | ------------------------------------------------------------- |
| Create | `src/translation/translation.service.spec.ts`                 |
| Create | `src/translation/repositories/translation.repository.spec.ts` |

#### Test Cases

```typescript
describe("TranslationService", () => {
  describe("getTranslationQuestion", () => {
    it("should return random question excluding recently shown");
    it("should throw UsageLimitException when daily limit reached");
    it("should reset cache when all questions exhausted");
    it("should return question with daily progress info");
  });

  describe("evaluateTranslation", () => {
    it("should calculate total score with correct weights");
    it("should award base XP of 20");
    it("should award bonus XP for score >= 80");
    it("should award streak bonus for 5+ consecutive correct");
    it("should save result to database");
  });

  describe("calculateSpeedScore", () => {
    it("should return 100 for response <= 5 seconds");
    it("should return 80 for response <= 10 seconds");
    it("should return 60 for response <= 15 seconds");
    it("should return 40 for response <= 20 seconds");
    it("should return 20 for response > 20 seconds");
  });
});
```

#### Acceptance Criteria

- [ ] ≥80% code coverage for TranslationService
- [ ] All business rules (BR-095 ~ BR-099) tested
- [ ] Mock dependencies properly (Redis, LLM, Prisma)
- [ ] Edge cases covered (empty questions, limit reached)
- [ ] Tests pass with `npm test`

---

### P5-T012: Wire Translation Module Dependencies

**Type:** integration
**Est. Hours:** 4
**DD Ref:** Module wiring

---

#### Description

Wire TranslationModule với tất cả dependencies, register trong AppModule, và verify integration hoạt động end-to-end.

#### Files

| Action | Path                                    |
| ------ | --------------------------------------- |
| Modify | `src/translation/translation.module.ts` |
| Modify | `src/app.module.ts`                     |

#### Module Definition

```typescript
@Module({
  imports: [
    PrismaModule,
    RedisModule,
    UserModule,
    SubscriptionModule,
    LLMModule,
    STTModule,
  ],
  controllers: [TranslationController],
  providers: [
    TranslationService,
    TranslationQuestionRepository,
    TranslationResultRepository,
    IntentQuestionRepository,
  ],
  exports: [TranslationService],
})
export class TranslationModule {}
```

#### Acceptance Criteria

- [ ] TranslationModule imports all required modules
- [ ] All providers registered and injectable
- [ ] AppModule imports TranslationModule
- [ ] API endpoints accessible via HTTP
- [ ] Integration test passes (POST /answers with audio)
- [ ] No circular dependency warnings

---

## 📊 Phase Progress

| Task ID | Task Name                            | Status     | Completed |
| ------- | ------------------------------------ | ---------- | --------- |
| P5-T005 | Create Translation DTOs              | ⬜ Pending | -         |
| P5-T006 | Create Translation Repository        | ⬜ Pending | -         |
| P5-T007 | Implement getTranslationQuestion     | ⬜ Pending | -         |
| P5-T008 | Implement evaluateTranslation        | ⬜ Pending | -         |
| P5-T009 | Implement Intent Translation         | ⬜ Pending | -         |
| P5-T010 | Create Translation Controller        | ⬜ Pending | -         |
| P5-T011 | Translation Service Unit Tests       | ⬜ Pending | -         |
| P5-T012 | Wire Translation Module Dependencies | ⬜ Pending | -         |

**Progress: 0/8 (0%)**

---

_Created: 2026-01-07_
