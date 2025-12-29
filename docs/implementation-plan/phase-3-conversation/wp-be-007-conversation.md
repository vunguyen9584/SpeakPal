# WP-BE-007: Conversation Module (Backend)

## Overview

| Item           | Value                                                                                                                        |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| ID             | WP-BE-007                                                                                                                    |
| Name           | Conversation Module                                                                                                          |
| Description    | Session management, turn handling, XP calculation                                                                            |
| Dependencies   | WP-BE-005 (User Module)                                                                                                      |
| Estimated Days | 4                                                                                                                            |
| Total Tasks    | 8                                                                                                                            |
| DD References  | `05-module-design/conversation-module.md`, `08-api-design/conversation-apis.md`, `07-database-design/conversation-tables.md` |

---

## Tasks

### Task 1: Create Module Structure

- **ID**: WP-BE-007-T001
- **Type**: setup
- **Description**: Khởi tạo module structure cho Conversation với controller, service, gateway
- **Commands**:
  ```bash
  cd backend
  nest g module modules/conversation
  nest g controller modules/conversation
  nest g service modules/conversation
  nest g gateway modules/conversation
  ```
- **Files to Create**:
  - `backend/src/modules/conversation/conversation.module.ts` - Module definition
  - `backend/src/modules/conversation/conversation.controller.ts` - REST controller
  - `backend/src/modules/conversation/conversation.service.ts` - Business logic
  - `backend/src/modules/conversation/conversation.gateway.ts` - WebSocket gateway
  - `backend/src/modules/conversation/conversation.repository.ts` - Data access
  - `backend/src/modules/conversation/entities/conversation.entity.ts` - Entity
  - `backend/src/modules/conversation/entities/turn.entity.ts` - Turn entity
- **Acceptance Criteria**:
  - [ ] Module được tạo và register trong AppModule
  - [ ] Controller, Service, Gateway được inject đúng
  - [ ] Repository pattern được setup với Prisma
- **Estimated Hours**: 1.5
- **DD Reference**: `05-module-design/conversation-module.md#クラス図`

---

### Task 2: Create Conversation DTOs

- **ID**: WP-BE-007-T002
- **Type**: feature
- **Description**: Tạo các DTOs cho Conversation APIs với validation decorators
- **Files to Create**:
  - `backend/src/modules/conversation/dto/create-conversation.dto.ts`
  - `backend/src/modules/conversation/dto/conversation-response.dto.ts`
  - `backend/src/modules/conversation/dto/conversation-summary.dto.ts`
  - `backend/src/modules/conversation/dto/turn.dto.ts`
  - `backend/src/modules/conversation/dto/list-conversations-query.dto.ts`
- **Implementation Details**:

  ```typescript
  // create-conversation.dto.ts
  export class CreateConversationDto {
    @IsEnum(["instructor", "freetalk", "roleplay"])
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

- **Acceptance Criteria**:
  - [ ] CreateConversationDto với validation cho mode, personaId, scenarioId, topic
  - [ ] ConversationResponseDto với conversationId, websocketUrl, mode, persona, startedAt
  - [ ] ConversationSummaryDto với summary, duration, score, xpEarned, corrections
  - [ ] TurnDto với speaker, content, sequence, corrections
  - [ ] ListConversationsQueryDto với pagination (page, limit, mode filter)
- **Estimated Hours**: 1.5
- **DD Reference**: `08-api-design/conversation-apis.md`

---

### Task 3: Implement Conversation Repository

- **ID**: WP-BE-007-T003
- **Type**: feature
- **Description**: Implement repository pattern cho Conversation và Turn entities
- **Files to Create**:
  - `backend/src/modules/conversation/repositories/conversation.repository.ts`
  - `backend/src/modules/conversation/repositories/turn.repository.ts`
- **Implementation Details**:

  ```typescript
  @Injectable()
  export class ConversationRepository {
    constructor(private prisma: PrismaService) {}

    async create(
      userId: string,
      dto: CreateConversationDto
    ): Promise<Conversation>;
    async findById(id: string): Promise<Conversation | null>;
    async findByUser(
      userId: string,
      query: ListQuery
    ): Promise<PaginatedResult<Conversation>>;
    async updateEndData(
      id: string,
      summary: string,
      score: number
    ): Promise<Conversation>;
    async countTodayConversations(userId: string): Promise<number>;
  }
  ```

- **Acceptance Criteria**:
  - [ ] ConversationRepository với CRUD operations
  - [ ] TurnRepository với addTurn, getTurns, getLastTurn
  - [ ] Pagination support cho list conversations
  - [ ] Filter by mode support
  - [ ] Count today conversations cho usage limit check
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/conversation-module.md#ConversationService`

---

### Task 4: Implement Session Management

- **ID**: WP-BE-007-T004
- **Type**: feature
- **Description**: Implement conversation session lifecycle (create, start, active, end)
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.service.ts`
- **Implementation Details**:
  - Check usage limit trước khi tạo session (Free: 3/day)
  - Generate WebSocket token (short-lived JWT, 1 hour expiry)
  - Cache active session trong Redis
  - Handle session timeout (auto-end after 30 min inactivity)
- **Acceptance Criteria**:
  - [ ] `createSession()` - tạo conversation, check limit, generate WS token
  - [ ] `getActiveSession()` - lấy session từ Redis cache
  - [ ] `endSession()` - end conversation, clear cache
  - [ ] Usage limit check: Free 3/day, Premium unlimited
  - [ ] Session được cache trong Redis với TTL 30 phút
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/conversation-module.md#create()`

---

### Task 5: Implement Turn Handling

- **ID**: WP-BE-007-T005
- **Type**: feature
- **Description**: Implement logic xử lý mỗi turn trong conversation (user turn + AI turn)
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.service.ts`
- **Files to Create**:
  - `backend/src/modules/conversation/turn.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class TurnService {
    async addUserTurn(conversationId: string, text: string): Promise<Turn>;
    async addAITurn(conversationId: string, text: string): Promise<Turn>;
    async attachCorrections(
      turnId: string,
      corrections: Correction[]
    ): Promise<void>;
    async getTurns(conversationId: string): Promise<Turn[]>;
    async getLastTurn(conversationId: string): Promise<Turn | null>;
  }
  ```
- **Acceptance Criteria**:
  - [ ] User turn: lưu text từ STT, timestamp, sequence number
  - [ ] AI turn: lưu response text, timestamp, sequence number
  - [ ] Corrections được attach vào user turn
  - [ ] Sequence number tự động increment
  - [ ] Support pagination khi lấy turns
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/conversation-module.md#addTurn()`

---

### Task 6: Implement Conversation Controller

- **ID**: WP-BE-007-T006
- **Type**: feature
- **Description**: Implement REST API endpoints cho Conversation
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.controller.ts`
- **APIs to Implement**:
  | Method | Endpoint | Description |
  | ------ | -------------------------- | ---------------------- |
  | GET | /conversations | List user conversations |
  | POST | /conversations | Start new conversation |
  | GET | /conversations/:id | Get conversation detail |
  | POST | /conversations/:id/end | End conversation |
  | GET | /conversations/:id/turns | Get conversation turns |
- **Implementation Details**:
  ```typescript
  @Controller("conversations")
  @UseGuards(JwtAuthGuard)
  export class ConversationController {
    @Get()
    async list(@User() user, @Query() query: ListConversationsQueryDto) {}

    @Post()
    async create(@User() user, @Body() dto: CreateConversationDto) {}

    @Get(":id")
    async get(@User() user, @Param("id") id: string) {}

    @Post(":id/end")
    async end(@User() user, @Param("id") id: string) {}

    @Get(":id/turns")
    async getTurns(@User() user, @Param("id") id: string) {}
  }
  ```
- **Acceptance Criteria**:
  - [ ] GET /conversations - pagination, filter by mode
  - [ ] POST /conversations - validate, check limit, return with WS URL
  - [ ] GET /conversations/:id - ownership check, return detail
  - [ ] POST /conversations/:id/end - calculate summary, return with XP
  - [ ] GET /conversations/:id/turns - return all turns with corrections
  - [ ] All endpoints protected với JwtAuthGuard
  - [ ] Proper error responses (403, 404, 400)
- **Estimated Hours**: 3
- **DD Reference**: `08-api-design/conversation-apis.md`

---

### Task 7: Implement XP Calculation

- **ID**: WP-BE-007-T007
- **Type**: feature
- **Description**: Implement XP calculation logic và integration với Gamification module
- **Files to Modify**:
  - `backend/src/modules/conversation/conversation.service.ts`
- **Files to Create**:
  - `backend/src/modules/conversation/xp-calculator.service.ts`
- **Implementation Details**:

  ```typescript
  // XP Calculation Formula
  baseXP = duration_minutes * 10;
  bonusXP = pronunciationScore > 70 ? (pronunciationScore - 70) * 0.5 : 0;
  totalXP = baseXP + bonusXP;

  // Streak bonus
  if (currentStreak >= 7) totalXP *= 1.2; // 20% bonus
  if (currentStreak >= 30) totalXP *= 1.5; // 50% bonus
  ```

- **Acceptance Criteria**:
  - [ ] Calculate base XP from duration (10 XP per minute)
  - [ ] Calculate bonus XP from pronunciation score
  - [ ] Apply streak multiplier
  - [ ] Call gamification module để update user XP
  - [ ] Return levelUp flag nếu user level up
  - [ ] Return newBadges nếu có badge mới
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/conversation-module.md#XP計算ロジック`

---

### Task 8: Add Unit Tests

- **ID**: WP-BE-007-T008
- **Type**: test
- **Description**: Viết unit tests cho Conversation module
- **Files to Create**:
  - `backend/src/modules/conversation/tests/conversation.service.spec.ts`
  - `backend/src/modules/conversation/tests/conversation.controller.spec.ts`
  - `backend/src/modules/conversation/tests/turn.service.spec.ts`
  - `backend/src/modules/conversation/tests/xp-calculator.spec.ts`
- **Test Cases**:
  | Test Suite | Test Cases |
  | ---------------------- | ---------------------------------------------------- |
  | ConversationService | create session, check usage limit, end session |
  | ConversationController | list, create, get, end - success & error cases |
  | TurnService | add user turn, add AI turn, attach corrections |
  | XPCalculator | base XP, bonus XP, streak multiplier |
- **Acceptance Criteria**:
  - [ ] Coverage >= 80% cho service layer
  - [ ] Test usage limit: Free user bị block sau 3 conversations
  - [ ] Test XP calculation với các edge cases
  - [ ] Test error handling (404, 403)
  - [ ] Mock external dependencies (Redis, Prisma)
- **Estimated Hours**: 3
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                     | Type    | Hours  | Status |
| -------------- | ------------------------ | ------- | ------ | ------ |
| WP-BE-007-T001 | Create Module Structure  | setup   | 1.5    | ⬜     |
| WP-BE-007-T002 | Create Conversation DTOs | feature | 1.5    | ⬜     |
| WP-BE-007-T003 | Implement Repository     | feature | 2      | ⬜     |
| WP-BE-007-T004 | Implement Session Mgmt   | feature | 3      | ⬜     |
| WP-BE-007-T005 | Implement Turn Handling  | feature | 2      | ⬜     |
| WP-BE-007-T006 | Implement Controller     | feature | 3      | ⬜     |
| WP-BE-007-T007 | Implement XP Calculation | feature | 2      | ⬜     |
| WP-BE-007-T008 | Add Unit Tests           | test    | 3      | ⬜     |
| **Total**      |                          |         | **18** |        |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
