# WP-BE-018: Quick Response Service (Backend)

> 📦 Work Package: Quick Response Service Implementation
> 📅 Estimated: 3 days (24 hours)
> 🔗 Dependencies: WP-BE-017 (Translation Service)
> 📚 DD Reference: `06-component-design/translation-02.md#uc036-037`, `08-api-design/translation-apis.md`

---

## 📊 Overview

| Metric     | Value                                             |
| ---------- | ------------------------------------------------- |
| Tasks      | 6                                                 |
| Est. Hours | 24                                                |
| UCs        | UC-036 (Word Association), UC-037 (Instant Drill) |
| APIs       | 7 (start, answer, end for both + next for drill)  |
| BRs        | BR-107 ~ BR-118                                   |

---

## 📋 Task List

| Task ID | Task Name                            | Type        | Hours | Status |
| ------- | ------------------------------------ | ----------- | ----- | ------ |
| P5-T013 | Create Quick Response DTOs           | feature     | 2     | ⬜     |
| P5-T014 | Implement Word Association Challenge | feature     | 6     | ⬜     |
| P5-T015 | Implement Instant Drill              | feature     | 6     | ⬜     |
| P5-T016 | Create Quick Response Controller     | feature     | 4     | ⬜     |
| P5-T017 | Quick Response Unit Tests            | test        | 3     | ⬜     |
| P5-T018 | Wire Quick Response Module           | integration | 3     | ⬜     |

---

## 🎯 Task Details

### P5-T013: Create Quick Response DTOs

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `08-api-design/translation-apis.md#quick-response`

---

#### Description

Tạo DTOs cho Word Association và Instant Drill APIs bao gồm session start, answer submission, và result responses.

#### Files

| Action | Path                                             |
| ------ | ------------------------------------------------ |
| Create | `src/quick-response/dto/word-association.dto.ts` |
| Create | `src/quick-response/dto/instant-drill.dto.ts`    |
| Create | `src/quick-response/dto/index.ts`                |

#### Acceptance Criteria

- [ ] StartWordAssociationDto với difficulty option
- [ ] WordAssociationAnswerDto với sessionId
- [ ] WordAssociationResultDto với score, chain, nextKeyword
- [ ] InstantDrillDtos cho start, next, answer, end
- [ ] All DTOs có validation decorators

---

### P5-T014: Implement Word Association Challenge

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-02.md#uc-036`

---

#### Description

Implement UC-036 ワード連想チャレンジ. 60-second challenge where user speaks related words. Uses Redis for session management, LLM for association validation.

#### Required Methods

| Method               | Signature                                          | Source |
| -------------------- | -------------------------------------------------- | ------ |
| startWordAssociation | (userId, level) => Promise<SessionDto>             | UC-036 |
| evaluateAssociation  | (sessionId, userResponse) => Promise<AnswerResult> | UC-036 |
| endWordAssociation   | (sessionId) => Promise<ChallengeResult>            | UC-036 |

#### Business Rules

| Rule ID | Rule                                             | Implementation    |
| ------- | ------------------------------------------------ | ----------------- |
| BR-107  | 1 問あたり 5 秒、全体で 60 秒                    | Timer in session  |
| BR-108  | チェーンボーナス: 5 問で 1.5 倍、10 問で 2 倍    | multiplier calc   |
| BR-109  | セッション内で同一の回答は不可                   | usedResponses Set |
| BR-111  | XP: 10 問 50XP, 20 問 120XP, ハイスコア更新+30XP | XP calculation    |
| BR-112  | 1 日 3 回まで無料                                | Daily limit check |

#### Session Data (Redis)

```typescript
interface WordAssociationSession {
  id: string;
  userId: string;
  type: "word_assoc";
  keywords: string[]; // 20 keywords from LLM
  currentIndex: number;
  score: number;
  correctCount: number;
  chain: number;
  maxChain: number;
  usedResponses: Set<string>;
  startedAt: Date;
  expiresAt: Date;
}
```

#### Acceptance Criteria

- [ ] Session created with 20 LLM-generated keywords
- [ ] Responses validated against keyword relevance
- [ ] Chain multiplier applied correctly
- [ ] Duplicate responses rejected
- [ ] Session expires after 60 seconds
- [ ] XP awarded based on performance

---

### P5-T015: Implement Instant Drill

**Type:** feature
**Est. Hours:** 6
**DD Ref:** `06-component-design/translation-02.md#uc-037`

---

#### Description

Implement UC-037 瞬間応答ドリル. 10-question drill with AI-generated questions, 10 seconds per question. Evaluates speed, accuracy, and naturalness.

#### Required Methods

| Method                  | Signature                                          | Source |
| ----------------------- | -------------------------------------------------- | ------ |
| startInstantDrill       | (userId, category, level) => Promise<SessionDto>   | UC-037 |
| getNextQuestion         | (sessionId) => Promise<QuestionDto>                | UC-037 |
| evaluateInstantResponse | (sessionId, userResponse, time) => Promise<Result> | UC-037 |
| endInstantDrill         | (sessionId) => Promise<DrillResult>                | UC-037 |

#### Business Rules

| Rule ID | Rule                                     | Implementation     |
| ------- | ---------------------------------------- | ------------------ |
| BR-113  | 1 問あたり 10 秒                         | Session timer      |
| BR-114  | 1 セッション 10 問固定                   | Fixed count        |
| BR-115  | 評価: 速度 30%, 正確性 40%, 自然さ 30%   | Score weights      |
| BR-116  | XP: 完了 40XP, 平均 80 点以上で追加 25XP | XP calculation     |
| BR-117  | Free 2 回/日, Pro 10 回/日, Plus 無制限  | Daily limit        |
| BR-118  | 3 回以上実施で弱点カテゴリを特定         | Weakpoint analysis |

#### Acceptance Criteria

- [ ] 10 questions generated by LLM per session
- [ ] TTS audio generated for each question
- [ ] Speed score decreases with response time
- [ ] Total score uses correct weights (30/40/30)
- [ ] Weakpoint analysis after 3+ sessions
- [ ] XP awarded with bonus for high average

---

### P5-T016: Create Quick Response Controller

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `08-api-design/translation-apis.md#api-t04-t07`

---

#### Description

Tạo QuickResponseController với 7 endpoints cho Word Association và Instant Drill.

#### Endpoints

| Route                                          | Method | Action               |
| ---------------------------------------------- | ------ | -------------------- |
| /api/v1/quick-response/word-association/start  | POST   | Start word challenge |
| /api/v1/quick-response/word-association/answer | POST   | Submit word answer   |
| /api/v1/quick-response/word-association/end    | POST   | End word challenge   |
| /api/v1/quick-response/instant-drill/start     | POST   | Start instant drill  |
| /api/v1/quick-response/instant-drill/next      | GET    | Get next question    |
| /api/v1/quick-response/instant-drill/answer    | POST   | Submit drill answer  |
| /api/v1/quick-response/instant-drill/end       | POST   | End drill session    |

#### Acceptance Criteria

- [ ] All 7 endpoints implemented with proper routes
- [ ] Audio file upload handling
- [ ] Session ID validation
- [ ] Proper error responses
- [ ] Rate limiting applied (120 req/min)

---

### P5-T017: Quick Response Unit Tests

**Type:** test
**Est. Hours:** 3

---

#### Description

Unit tests cho QuickResponseService covering session management, scoring, và edge cases.

#### Acceptance Criteria

- [ ] ≥80% code coverage
- [ ] Chain multiplier tests
- [ ] Session expiry tests
- [ ] Duplicate response rejection tests
- [ ] Daily limit tests

---

### P5-T018: Wire Quick Response Module

**Type:** integration
**Est. Hours:** 3

---

#### Description

Register QuickResponseModule trong app và verify tất cả endpoints hoạt động.

#### Acceptance Criteria

- [ ] Module registered in AppModule
- [ ] Dependencies injected correctly
- [ ] E2E test for word association flow
- [ ] E2E test for instant drill flow

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T013 | ⬜ Pending | -         |
| P5-T014 | ⬜ Pending | -         |
| P5-T015 | ⬜ Pending | -         |
| P5-T016 | ⬜ Pending | -         |
| P5-T017 | ⬜ Pending | -         |
| P5-T018 | ⬜ Pending | -         |

**Progress: 0/6 (0%)**

---

_Created: 2026-01-07_
