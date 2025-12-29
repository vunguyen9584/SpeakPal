# WP-BE-011: Learning Module (Backend)

## Overview

| Item           | Value                                                                   |
| -------------- | ----------------------------------------------------------------------- |
| ID             | WP-BE-011                                                               |
| Name           | Learning Module                                                         |
| Description    | Vocabulary management, SRS, Scenarios, Daily Challenges                 |
| Dependencies   | WP-BE-005 (User Module)                                                 |
| Estimated Days | 4                                                                       |
| Total Tasks    | 10                                                                      |
| DD References  | `05-module-design/learning-module.md`, `08-api-design/learning-apis.md` |

---

## Tasks

### Task 1: Create Module Structure

- **ID**: WP-BE-011-T001
- **Type**: setup
- **Description**: Khởi tạo Learning module với controllers và services
- **Commands**:
  ```bash
  cd backend
  nest g module modules/learning
  nest g controller modules/learning/vocabulary
  nest g controller modules/learning/scenario
  nest g controller modules/learning/challenge
  nest g service modules/learning/vocabulary
  nest g service modules/learning/scenario
  nest g service modules/learning/challenge
  nest g service modules/learning/srs
  ```
- **Files to Create**:
  - `backend/src/modules/learning/learning.module.ts`
  - `backend/src/modules/learning/vocabulary/vocabulary.controller.ts`
  - `backend/src/modules/learning/vocabulary/vocabulary.service.ts`
  - `backend/src/modules/learning/scenario/scenario.controller.ts`
  - `backend/src/modules/learning/scenario/scenario.service.ts`
  - `backend/src/modules/learning/challenge/challenge.controller.ts`
  - `backend/src/modules/learning/challenge/challenge.service.ts`
  - `backend/src/modules/learning/srs/srs.service.ts`
- **Acceptance Criteria**:
  - [ ] Module được tạo và register trong AppModule
  - [ ] 3 Controllers được setup (Vocabulary, Scenario, Challenge)
  - [ ] 4 Services được setup (including SRS)
  - [ ] Folder structure clean và organized
- **Estimated Hours**: 1.5
- **DD Reference**: `05-module-design/learning-module.md#クラス図`

---

### Task 2: Create Learning DTOs

- **ID**: WP-BE-011-T002
- **Type**: feature
- **Description**: Tạo DTOs cho Vocabulary, Scenario, Challenge APIs
- **Files to Create**:
  - `backend/src/modules/learning/vocabulary/dto/create-vocabulary.dto.ts`
  - `backend/src/modules/learning/vocabulary/dto/vocabulary-response.dto.ts`
  - `backend/src/modules/learning/vocabulary/dto/vocabulary-query.dto.ts`
  - `backend/src/modules/learning/vocabulary/dto/review-request.dto.ts`
  - `backend/src/modules/learning/scenario/dto/scenario-query.dto.ts`
  - `backend/src/modules/learning/scenario/dto/scenario-response.dto.ts`
  - `backend/src/modules/learning/challenge/dto/challenge-response.dto.ts`
- **Implementation Details**:

  ```typescript
  // create-vocabulary.dto.ts
  export class CreateVocabularyDto {
    @IsString()
    @Length(1, 100)
    word: string;

    @IsString()
    @Length(1, 500)
    meaning: string;

    @IsOptional()
    @IsString()
    pronunciation?: string;

    @IsOptional()
    @IsString()
    exampleSentence?: string;

    @IsOptional()
    @IsUUID()
    conversationId?: string;
  }

  // vocabulary-response.dto.ts
  export class VocabularyResponseDto {
    id: string;
    word: string;
    meaning: string;
    pronunciation: string;
    exampleSentence: string;
    srsLevel: SRSLevel;
    nextReviewDate: Date;
    reviewCount: number;
    correctCount: number;
  }
  ```

- **Acceptance Criteria**:
  - [ ] CreateVocabularyDto với validation
  - [ ] VocabularyResponseDto với all fields
  - [ ] VocabularyQueryDto với pagination và srsLevel filter
  - [ ] ReviewRequestDto với result enum (correct/incorrect)
  - [ ] ScenarioQueryDto với category và difficulty filters
  - [ ] ChallengeResponseDto với progress tracking
- **Estimated Hours**: 2
- **DD Reference**: `08-api-design/learning-apis.md`

---

### Task 3: Implement SRS Service

- **ID**: WP-BE-011-T003
- **Type**: feature
- **Description**: Implement Spaced Repetition System với interval calculation và level transition
- **Files to Create**:
  - `backend/src/modules/learning/srs/srs.service.ts`
  - `backend/src/modules/learning/srs/srs.constants.ts`
- **Implementation Details**:

  ```typescript
  // SRS Level Intervals
  const SRS_INTERVALS = {
    new: 0, // Review immediately
    learning: 1, // 1 day
    young: 3, // 3 days
    mature: 7, // 7 days
    mastered: 30, // 30 days
  };

  @Injectable()
  export class SRSService {
    getInterval(level: SRSLevel): number {
      return SRS_INTERVALS[level];
    }

    calculateNextReview(item: SRSItem, result: ReviewResult): Date {
      const newLevel = this.updateLevel(item.srsLevel, result);
      const interval = this.getInterval(newLevel);
      return addDays(new Date(), interval);
    }

    updateLevel(current: SRSLevel, result: ReviewResult): SRSLevel {
      if (result === "correct") {
        switch (current) {
          case "new":
            return "learning";
          case "learning":
            return "young";
          case "young":
            return "mature";
          case "mature":
            return "mastered";
          case "mastered":
            return "mastered";
        }
      } else {
        // Incorrect: demote by 1 level
        switch (current) {
          case "mastered":
            return "mature";
          case "mature":
            return "young";
          case "young":
            return "learning";
          default:
            return "learning";
        }
      }
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] SRS intervals defined: new(0), learning(1), young(3), mature(7), mastered(30)
  - [ ] Level up on correct answer
  - [ ] Level down on incorrect answer (max 1 level)
  - [ ] calculateNextReview() returns correct date
  - [ ] Handle edge cases (already mastered, already new)
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/learning-module.md#SRS設計`

---

### Task 4: Implement Vocabulary Repository

- **ID**: WP-BE-011-T004
- **Type**: feature
- **Description**: Implement repository pattern cho Vocabulary entity
- **Files to Create**:
  - `backend/src/modules/learning/vocabulary/vocabulary.repository.ts`
- **Implementation Details**:

  ```typescript
  @Injectable()
  export class VocabularyRepository {
    constructor(private prisma: PrismaService) {}

    async create(userId: string, dto: CreateVocabularyDto): Promise<Vocabulary>;
    async findByUser(
      userId: string,
      query: VocabQueryDto
    ): Promise<PaginatedResult>;
    async findById(id: string): Promise<Vocabulary | null>;
    async findDueForReview(userId: string): Promise<Vocabulary[]>;
    async updateAfterReview(
      id: string,
      newLevel: SRSLevel,
      nextDate: Date
    ): Promise<Vocabulary>;
    async checkDuplicate(userId: string, word: string): Promise<boolean>;
    async countByUser(userId: string): Promise<number>;
  }
  ```

- **Acceptance Criteria**:
  - [ ] CRUD operations for vocabulary
  - [ ] Filter by SRS level
  - [ ] Get due for review (nextReviewDate <= today)
  - [ ] Duplicate check (same word for same user)
  - [ ] Pagination support
  - [ ] Count vocabulary per user
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/learning-module.md#VocabularyService`

---

### Task 5: Implement Vocabulary Service

- **ID**: WP-BE-011-T005
- **Type**: feature
- **Description**: Implement business logic cho Vocabulary management
- **Files to Modify**:
  - `backend/src/modules/learning/vocabulary/vocabulary.service.ts`
- **Implementation Details**:

  ```typescript
  @Injectable()
  export class VocabularyService {
    constructor(
      private repo: VocabularyRepository,
      private srs: SRSService,
      private pronunciationService: PronunciationService // External
    ) {}

    async addWord(
      userId: string,
      dto: CreateVocabularyDto
    ): Promise<Vocabulary> {
      // 1. Check duplicate
      if (await this.repo.checkDuplicate(userId, dto.word)) {
        throw new ConflictException("Word already exists");
      }

      // 2. Auto-fetch pronunciation if empty
      if (!dto.pronunciation) {
        dto.pronunciation = await this.pronunciationService.getPronunciation(
          dto.word
        );
      }

      // 3. Create with SRS defaults
      return this.repo.create(userId, {
        ...dto,
        srsLevel: "new",
        nextReviewDate: new Date(),
      });
    }

    async recordReview(
      id: string,
      result: ReviewResult
    ): Promise<ReviewResponse> {
      const vocab = await this.repo.findById(id);
      const newLevel = this.srs.updateLevel(vocab.srsLevel, result);
      const nextDate = this.srs.calculateNextReview(vocab, result);

      const updated = await this.repo.updateAfterReview(id, newLevel, nextDate);

      // Calculate XP
      const xpEarned = result === "correct" ? 5 : 1;

      return {
        previousLevel: vocab.srsLevel,
        newLevel,
        nextReviewDate: nextDate,
        xpEarned,
      };
    }

    async getDueForReview(userId: string): Promise<Vocabulary[]> {
      return this.repo.findDueForReview(userId);
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] addWord() với duplicate check
  - [ ] Auto-fetch pronunciation nếu không cung cấp
  - [ ] recordReview() update SRS level và next review date
  - [ ] Return XP earned cho review (correct: 5, incorrect: 1)
  - [ ] getDueForReview() returns words needing review
  - [ ] listByUser() với pagination và filters
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/learning-module.md#VocabularyService詳細`

---

### Task 6: Implement Scenario Service

- **ID**: WP-BE-011-T006
- **Type**: feature
- **Description**: Implement Scenario browsing và selection
- **Files to Modify**:
  - `backend/src/modules/learning/scenario/scenario.service.ts`
- **Files to Create**:
  - `backend/src/modules/learning/scenario/scenario.repository.ts`
- **Implementation Details**:

  ```typescript
  @Injectable()
  export class ScenarioService {
    async list(query: ScenarioQueryDto): Promise<Scenario[]> {
      // Filter by category, difficulty
    }

    async getById(id: string): Promise<Scenario> {
      // Get single scenario with details
    }

    async getByCategory(category: string): Promise<Scenario[]> {
      // List all in category
    }

    async startScenario(
      userId: string,
      scenarioId: string
    ): Promise<ConversationContext> {
      // Create conversation with scenario context
      // Return context for ConversationModule
    }
  }
  ```

- **Categories**: daily, business, travel, academic, test_prep
- **Difficulty**: beginner, intermediate, advanced
- **Acceptance Criteria**:
  - [ ] List scenarios với category filter
  - [ ] List scenarios với difficulty filter
  - [ ] Get scenario by ID với full details
  - [ ] startScenario() creates conversation context
  - [ ] Return estimated duration
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/learning-module.md#ScenarioService`

---

### Task 7: Implement Challenge Service

- **ID**: WP-BE-011-T007
- **Type**: feature
- **Description**: Implement Daily Challenge generation và completion
- **Files to Modify**:
  - `backend/src/modules/learning/challenge/challenge.service.ts`
- **Files to Create**:
  - `backend/src/modules/learning/challenge/challenge.repository.ts`
- **Challenge Types**:
  | Type | Description | XP Reward |
  | ------------- | ---------------------------- | --------- |
  | conversation | Complete N conversations | 50 |
  | vocabulary | Review N vocabulary items | 30 |
  | pronunciation | Achieve score >= N | 40 |
  | streak | Maintain N day streak | 100 |
  | time | Practice for N minutes | 60 |
- **Implementation Details**:

  ```typescript
  @Injectable()
  export class ChallengeService {
    async getTodayChallenge(userId: string): Promise<UserChallenge[]> {
      // Get or generate today's challenges
      const existing = await this.repo.findTodayChallenges(userId);
      if (existing.length > 0) return existing;

      return this.generateDailyChallenge(userId);
    }

    async generateDailyChallenge(userId: string): Promise<UserChallenge[]> {
      // 1. Analyze user's 30-day activity pattern
      const pattern = await this.analyzePattern(userId);

      // 2. Select challenge type based on pattern
      // 50% weakness-focused, 30% balanced, 20% strength-focused
      const challengeType = this.selectChallengeType(pattern);

      // 3. Adjust difficulty based on user level
      const difficulty = this.adjustDifficulty(pattern.userLevel);

      return this.repo.createUserChallenge(userId, challengeType, difficulty);
    }

    async completeChallenge(
      userId: string,
      challengeId: string
    ): Promise<ChallengeResult> {
      // Mark as completed, award XP
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] getTodayChallenge() returns or generates challenges
  - [ ] generateDailyChallenge() với smart selection algorithm
  - [ ] Challenge difficulty adjusted to user level
  - [ ] completeChallenge() awards XP
  - [ ] Track progress (currentProgress / targetProgress)
  - [ ] 5 challenge types supported
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/learning-module.md#ChallengeService詳細`

---

### Task 8: Implement Vocabulary Controller

- **ID**: WP-BE-011-T008
- **Type**: feature
- **Description**: Implement REST API endpoints cho Vocabulary
- **Files to Modify**:
  - `backend/src/modules/learning/vocabulary/vocabulary.controller.ts`
- **APIs to Implement**:
  | Method | Endpoint | Description |
  | ------ | --------------------------- | ------------------------ |
  | GET | /vocabularies | List user vocabulary |
  | POST | /vocabularies | Add new vocabulary |
  | GET | /vocabularies/due | Get due for review |
  | POST | /vocabularies/:id/review | Record review result |
- **Implementation Details**:
  ```typescript
  @Controller("vocabularies")
  @UseGuards(JwtAuthGuard)
  export class VocabularyController {
    @Get()
    async list(@User() user, @Query() query: VocabQueryDto) {}

    @Post()
    async create(@User() user, @Body() dto: CreateVocabularyDto) {}

    @Get("due")
    async getDue(@User() user) {}

    @Post(":id/review")
    async recordReview(
      @User() user,
      @Param("id") id: string,
      @Body() dto: ReviewRequestDto
    ) {}
  }
  ```
- **Acceptance Criteria**:
  - [ ] GET /vocabularies với pagination và srsLevel filter
  - [ ] POST /vocabularies với validation
  - [ ] GET /vocabularies/due returns words needing review
  - [ ] POST /vocabularies/:id/review updates SRS và returns XP
  - [ ] All endpoints protected với JwtAuthGuard
  - [ ] Proper error responses (400, 404, 409)
- **Estimated Hours**: 2
- **DD Reference**: `08-api-design/learning-apis.md`

---

### Task 9: Implement Scenario & Challenge Controllers

- **ID**: WP-BE-011-T009
- **Type**: feature
- **Description**: Implement REST API endpoints cho Scenario và Challenge
- **Files to Modify**:
  - `backend/src/modules/learning/scenario/scenario.controller.ts`
  - `backend/src/modules/learning/challenge/challenge.controller.ts`
- **APIs to Implement**:
  | Method | Endpoint | Description |
  | ------ | ------------------ | --------------------- |
  | GET | /scenarios | List scenarios |
  | GET | /scenarios/:id | Get scenario detail |
  | GET | /challenges/today | Get today's challenges|
- **Acceptance Criteria**:
  - [ ] GET /scenarios với category và difficulty filters
  - [ ] GET /scenarios/:id returns full scenario detail
  - [ ] GET /challenges/today returns or generates challenges
  - [ ] All endpoints protected với JWT
- **Estimated Hours**: 1.5
- **DD Reference**: `08-api-design/learning-apis.md`

---

### Task 10: Add Unit Tests

- **ID**: WP-BE-011-T010
- **Type**: test
- **Description**: Viết unit tests cho Learning module
- **Files to Create**:
  - `backend/src/modules/learning/tests/srs.service.spec.ts`
  - `backend/src/modules/learning/tests/vocabulary.service.spec.ts`
  - `backend/src/modules/learning/tests/challenge.service.spec.ts`
- **Test Cases**:
  | Test Suite | Test Cases |
  | ----------------- | --------------------------------------------------- |
  | SRSService | level transitions, interval calculation, edge cases |
  | VocabularyService | add word, duplicate check, record review, XP calc |
  | ChallengeService | generate daily, complete, progress tracking |
- **Acceptance Criteria**:
  - [ ] Coverage >= 80% cho services
  - [ ] Test SRS level transitions (all 5 levels)
  - [ ] Test XP calculation
  - [ ] Test duplicate word handling
  - [ ] Test challenge generation
  - [ ] Mock external dependencies
- **Estimated Hours**: 3
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                                     | Type    | Hours  | Status |
| -------------- | ---------------------------------------- | ------- | ------ | ------ |
| WP-BE-011-T001 | Create Module Structure                  | setup   | 1.5    | ⬜     |
| WP-BE-011-T002 | Create Learning DTOs                     | feature | 2      | ⬜     |
| WP-BE-011-T003 | Implement SRS Service                    | feature | 2      | ⬜     |
| WP-BE-011-T004 | Implement Vocabulary Repo                | feature | 2      | ⬜     |
| WP-BE-011-T005 | Implement Vocabulary Service             | feature | 3      | ⬜     |
| WP-BE-011-T006 | Implement Scenario Service               | feature | 2      | ⬜     |
| WP-BE-011-T007 | Implement Challenge Service              | feature | 3      | ⬜     |
| WP-BE-011-T008 | Implement Vocabulary Controller          | feature | 2      | ⬜     |
| WP-BE-011-T009 | Implement Scenario/Challenge Controllers | feature | 1.5    | ⬜     |
| WP-BE-011-T010 | Add Unit Tests                           | test    | 3      | ⬜     |
| **Total**      |                                          |         | **22** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
