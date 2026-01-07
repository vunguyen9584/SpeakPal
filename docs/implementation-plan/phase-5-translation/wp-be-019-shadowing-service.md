# WP-BE-019: Shadowing Service (Backend)

> 📦 Work Package: Shadowing Service Implementation
> 📅 Estimated: 3 days (24 hours)
> 🔗 Dependencies: WP-BE-017 (Translation Service), WP-INT-003 (ElevenLabs TTS)
> 📚 DD Reference: `06-component-design/translation-02.md#uc-038`, `08-api-design/translation-apis.md`

---

## 📊 Overview

| Metric     | Value                                             |
| ---------- | ------------------------------------------------- |
| Tasks      | 6                                                 |
| Est. Hours | 24                                                |
| UCs        | UC-038 (Shadowing Practice)                       |
| APIs       | 4 (contents list, content detail, start, analyze) |
| BRs        | BR-119 ~ BR-124                                   |

---

## 📋 Task List

| Task ID | Task Name                    | Type        | Hours | Status |
| ------- | ---------------------------- | ----------- | ----- | ------ |
| P5-T019 | Create Shadowing DTOs        | feature     | 2     | ⬜     |
| P5-T020 | Implement Content Management | feature     | 4     | ⬜     |
| P5-T021 | Implement Shadowing Analysis | feature     | 8     | ⬜     |
| P5-T022 | Create Shadowing Controller  | feature     | 4     | ⬜     |
| P5-T023 | Shadowing Unit Tests         | test        | 3     | ⬜     |
| P5-T024 | Wire Shadowing Module        | integration | 3     | ⬜     |

---

## 🎯 Task Details

### P5-T019: Create Shadowing DTOs

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `08-api-design/translation-apis.md#shadowing`

---

#### Description

Tạo DTOs cho Shadowing APIs bao gồm content listing, session start, và analysis results.

#### Files

| Action | Path                                         |
| ------ | -------------------------------------------- |
| Create | `src/shadowing/dto/shadowing-content.dto.ts` |
| Create | `src/shadowing/dto/shadowing-session.dto.ts` |
| Create | `src/shadowing/dto/shadowing-result.dto.ts`  |
| Create | `src/shadowing/dto/index.ts`                 |

#### DTOs Required

```typescript
// Content listing
export class GetShadowingContentsQueryDto {
  @IsOptional()
  @IsEnum(["conversation", "news", "speech", "podcast"])
  contentType?: string;

  @IsOptional()
  level?: UserLevel;

  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number = 1;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 20;
}

// Analysis result
export class ShadowingAnalysisResponseDto {
  totalScore: number;
  followingScore: number;
  pronunciationScore: number;
  rhythmScore: number;
  completenessScore: number;
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
}
```

#### Acceptance Criteria

- [ ] Query DTOs cho content listing với pagination
- [ ] Session start DTO với speed selection
- [ ] Analysis result DTO với all score types
- [ ] WeakSegment type định nghĩa rõ

---

### P5-T020: Implement Content Management

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `06-component-design/translation-02.md#shadowing-content`

---

#### Description

Implement methods để manage shadowing contents: list with filtering, get detail with transcript/timestamps, premium content access control.

#### Required Methods

| Method             | Signature                                           | Source |
| ------------------ | --------------------------------------------------- | ------ |
| getContents        | (query: QueryDto, user) => Promise<PaginatedResult> | UC-038 |
| getContentById     | (id, userId) => Promise<ContentDetail>              | UC-038 |
| checkPremiumAccess | (userId, content) => boolean                        | BR-124 |

#### Business Rules

| Rule ID | Rule                                         | Implementation |
| ------- | -------------------------------------------- | -------------- |
| BR-120  | コンテンツ長: 30 秒〜3 分                    | Validation     |
| BR-124  | Free: 基本コンテンツのみ、有料: 全コンテンツ | Access control |

#### Acceptance Criteria

- [ ] List contents with type/level filtering
- [ ] Pagination support
- [ ] Premium content marked as locked for free users
- [ ] Content detail includes transcript and timestamps
- [ ] Audio URL only returned for accessible content

---

### P5-T021: Implement Shadowing Analysis

**Type:** feature
**Est. Hours:** 8
**DD Ref:** `06-component-design/translation-02.md#analyze`

---

#### Description

Implement core shadowing analysis: compare user audio với model audio, calculate following score (timing), pronunciation score, rhythm score, và completeness.

#### Required Methods

| Method                 | Signature                                         | Source |
| ---------------------- | ------------------------------------------------- | ------ |
| startSession           | (userId, contentId, speed) => Promise<Session>    | UC-038 |
| analyzeShadowing       | (sessionId, userAudio) => Promise<AnalysisResult> | UC-038 |
| analyzeFollowingTiming | (modelTs, userTs) => number                       | UC-038 |
| identifyWeakSegments   | (modelTs, userTs) => WeakSegment[]                | UC-038 |

#### Speed Adjustment (BR-119)

```typescript
const SPEED_OPTIONS = {
  slow: 0.75,
  normal: 1.0,
  fast: 1.25,
};

async function adjustAudioSpeed(
  audioUrl: string,
  speed: number
): Promise<string> {
  // Use TTS service to re-synthesize at different speed
  // Or use audio processing library (ffmpeg)
}
```

#### Following Score Algorithm

```typescript
function analyzeFollowingTiming(
  modelTs: SentenceTimestamp[],
  userTs: SentenceTimestamp[]
): number {
  let totalScore = 0;
  let matched = 0;

  for (const m of modelTs) {
    // Find matching user segment using Levenshtein similarity
    const u = userTs.find((x) => levenshteinSimilarity(x.text, m.text) > 0.8);

    if (u) {
      matched++;
      const delay = u.startTime - m.startTime;

      // Score based on how closely user follows model timing
      if (delay >= 0 && delay <= 1.0) totalScore += 100; // 0-1s delay = perfect
      else if (delay > 0 && delay <= 2.0) totalScore += 70; // 1-2s delay = good
      else totalScore += 40; // >2s delay = needs work
    }
  }

  return matched > 0 ? Math.round(totalScore / matched) : 0;
}
```

#### Total Score Calculation (BR-121)

```typescript
const totalScore = Math.round(
  followingScore * 0.2 + // 追従 20%
    pronunciationScore * 0.4 + // 発音 40%
    rhythmScore * 0.2 + // リズム 20%
    completenessScore * 0.2 // 完成度 20%
);
```

#### Business Rules

| Rule ID | Rule                                             | Implementation |
| ------- | ------------------------------------------------ | -------------- |
| BR-119  | 速度調整: 0.75x / 1.0x / 1.25x の 3 段階         | Speed options  |
| BR-121  | 評価: 追従 20%, 発音 40%, リズム 20%, 完成度 20% | Score weights  |
| BR-122  | XP: 完了 35XP, 90 点以上で追加 20XP              | XP calculation |
| BR-123  | Free 5 回/日, Pro 20 回/日, Plus 無制限          | Daily limit    |

#### Acceptance Criteria

- [ ] Session created with speed selection
- [ ] User audio transcribed with timestamps
- [ ] Following score based on timing analysis
- [ ] Pronunciation score from AI analysis
- [ ] Weak segments identified with specific issues
- [ ] Total score uses correct weights (20/40/20/20)
- [ ] XP awarded: 35 base + 20 for 90+

---

### P5-T022: Create Shadowing Controller

**Type:** feature
**Est. Hours:** 4
**DD Ref:** `08-api-design/translation-apis.md#shadowing`

---

#### Description

Tạo ShadowingController với 4 endpoints.

#### Endpoints

| Route                                  | Method | Action             |
| -------------------------------------- | ------ | ------------------ |
| /api/v1/shadowing/contents             | GET    | List contents      |
| /api/v1/shadowing/contents/:id         | GET    | Get content detail |
| /api/v1/shadowing/sessions/start       | POST   | Start session      |
| /api/v1/shadowing/sessions/:id/analyze | POST   | Analyze shadowing  |

#### Acceptance Criteria

- [ ] All 4 endpoints implemented
- [ ] Large audio file upload support (up to 3 min audio)
- [ ] Premium content access validation
- [ ] Rate limiting (30 req/min)

---

### P5-T023: Shadowing Unit Tests

**Type:** test
**Est. Hours:** 3

---

#### Description

Unit tests cho ShadowingService covering analysis algorithms và edge cases.

#### Test Cases

- Following timing score calculation
- Weak segment identification
- Premium access control
- Speed adjustment logic
- XP calculation

#### Acceptance Criteria

- [ ] ≥80% code coverage
- [ ] Timing analysis edge cases tested
- [ ] Premium access tests
- [ ] All business rules verified

---

### P5-T024: Wire Shadowing Module

**Type:** integration
**Est. Hours:** 3

---

#### Description

Register ShadowingModule và verify integration.

#### Acceptance Criteria

- [ ] Module registered
- [ ] E2E test for complete shadowing flow
- [ ] Audio processing pipeline tested
- [ ] Large file upload tested

---

## 📊 Phase Progress

| Task ID | Status     | Completed |
| ------- | ---------- | --------- |
| P5-T019 | ⬜ Pending | -         |
| P5-T020 | ⬜ Pending | -         |
| P5-T021 | ⬜ Pending | -         |
| P5-T022 | ⬜ Pending | -         |
| P5-T023 | ⬜ Pending | -         |
| P5-T024 | ⬜ Pending | -         |

**Progress: 0/6 (0%)**

---

_Created: 2026-01-07_
