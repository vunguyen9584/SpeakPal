# WP-BE-012: Gamification Module (Backend)

## Overview

| Item           | Value                                                                           |
| -------------- | ------------------------------------------------------------------------------- |
| ID             | WP-BE-012                                                                       |
| Name           | Gamification Module                                                             |
| Description    | XP, Levels, Streaks, Badges, Leaderboard/Rankings                               |
| Dependencies   | WP-BE-011 (Learning Module)                                                     |
| Estimated Days | 4                                                                               |
| Total Tasks    | 9                                                                               |
| DD References  | `05-module-design/gamification-module.md`, `08-api-design/gamification-apis.md` |

---

## Tasks

### Task 1: Create Module Structure

- **ID**: WP-BE-012-T001
- **Type**: setup
- **Description**: Khởi tạo Gamification module với controllers và services
- **Commands**:
  ```bash
  nest g module modules/gamification
  nest g service modules/gamification/xp
  nest g service modules/gamification/streak
  nest g service modules/gamification/badge
  nest g service modules/gamification/ranking
  ```
- **Files to Create**:
  - `gamification.module.ts`, `xp.service.ts`, `streak.service.ts`, `badge.service.ts`, `ranking.service.ts`
  - Controllers: `streak.controller.ts`, `badge.controller.ts`, `ranking.controller.ts`
- **Acceptance Criteria**:
  - [ ] Module registered trong AppModule
  - [ ] 4 Services (XP, Streak, Badge, Ranking) injected correctly
- **Estimated Hours**: 1.5
- **DD Reference**: `05-module-design/gamification-module.md`

---

### Task 2: Create DTOs

- **ID**: WP-BE-012-T002
- **Type**: feature
- **Description**: Tạo DTOs cho Gamification APIs
- **Files**: `streak-response.dto.ts`, `badge-response.dto.ts`, `ranking-response.dto.ts`
- **Acceptance Criteria**:
  - [ ] StreakResponseDto với currentStreak, longestStreak, freezeRemaining
  - [ ] BadgeDto với code, name, category, xpBonus, condition
  - [ ] RankingResponseDto với league, weekNumber, entries
- **Estimated Hours**: 1.5
- **DD Reference**: `08-api-design/gamification-apis.md`

---

### Task 3: Implement XP Service

- **ID**: WP-BE-012-T003
- **Type**: feature
- **Description**: Implement XP calculation và level up logic
- **Level Formula**: Level N requires N\*200 XP (Level 5 = 1500 total XP)
- **Implementation**:
  - `addXP(userId, amount, source)` - Add XP và check level up
  - `calculateLevel(totalXp)` - Return current level
  - Track weeklyXp separately for rankings
- **Acceptance Criteria**:
  - [ ] addXP() updates total và weekly XP
  - [ ] Level up detection và badge award
  - [ ] XP history logging
- **Estimated Hours**: 2.5
- **DD Reference**: `05-module-design/gamification-module.md`

---

### Task 4: Implement Streak Service

- **ID**: WP-BE-012-T004
- **Type**: feature
- **Description**: Implement streak tracking với freeze support
- **Logic**:
  - Yesterday active → streak += 1
  - Gap + freeze available → use freeze, maintain streak
  - Gap + no freeze → reset streak to 1
- **Methods**: `recordActivity()`, `useFreeze()`, `checkStreakStatus()`
- **Acceptance Criteria**:
  - [ ] Streak continues/resets correctly
  - [ ] Freeze deduction works
  - [ ] Award streak badges (7, 30, 100 days)
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/gamification-module.md#StreakService詳細`

---

### Task 5: Define Badge System

- **ID**: WP-BE-012-T005
- **Type**: feature
- **Description**: Define all badges và seed data
- **Badges** (14 total):
  - Streak: STREAK_7, STREAK_30, STREAK_100
  - Level: LEVEL_5, LEVEL_10, LEVEL_20
  - Conversation: CONV_FIRST, CONV_10, CONV_100
  - Vocabulary: VOCAB_50, VOCAB_100, VOCAB_500
  - Other: PRON_PERFECT, CHALLENGE_STREAK_7
- **Acceptance Criteria**:
  - [ ] All 14 badges defined với conditions
  - [ ] Seed script created
  - [ ] Japanese names for all badges
- **Estimated Hours**: 1.5
- **DD Reference**: `05-module-design/gamification-module.md#バッジ定義`

---

### Task 6: Implement Badge Service

- **ID**: WP-BE-012-T006
- **Type**: feature
- **Description**: Implement badge checking và awarding
- **Methods**:
  - `listAll()` - All badges
  - `listUserBadges(userId)` - Earned badges
  - `checkAndAward(userId, eventType)` - Check conditions và award
  - `getProgress(userId, badgeId)` - Progress tracking
- **Acceptance Criteria**:
  - [ ] Condition checking for all badge types
  - [ ] Award XP bonus when badge earned
  - [ ] Send notification on earn
  - [ ] Prevent duplicate awards
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/gamification-module.md#BadgeService詳細`

---

### Task 7: Implement Ranking Service

- **ID**: WP-BE-012-T007
- **Type**: feature
- **Description**: Implement weekly rankings và league system
- **Leagues**: Bronze → Silver → Gold → Platinum → Diamond
- **Promotion**: Top 10 promoted, Bottom 10 demoted (weekly)
- **Methods**: `getWeeklyRanking()`, `getUserRank()`, `processWeeklyPromotions()`
- **Acceptance Criteria**:
  - [ ] Weekly ranking by weeklyXp
  - [ ] 5 leagues với promotion/demotion
  - [ ] Weekly batch job for processing
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/gamification-module.md#RankingService詳細`

---

### Task 8: Implement Controllers

- **ID**: WP-BE-012-T008
- **Type**: feature
- **Description**: Implement REST API endpoints
- **APIs**:
  - `GET /streaks` - Get current streak
  - `POST /streaks/freeze` - Use freeze
  - `GET /badges` - All badges
  - `GET /badges/mine` - Earned badges
  - `GET /rankings/weekly` - Leaderboard
- **Acceptance Criteria**:
  - [ ] All 5 endpoints implemented
  - [ ] JWT authentication
  - [ ] Proper error responses
- **Estimated Hours**: 2
- **DD Reference**: `08-api-design/gamification-apis.md`

---

### Task 9: Add Unit Tests

- **ID**: WP-BE-012-T009
- **Type**: test
- **Description**: Unit tests cho Gamification module
- **Test Suites**: XPService, StreakService, BadgeService, RankingService
- **Acceptance Criteria**:
  - [ ] Coverage >= 80%
  - [ ] Test level up, streak freeze, badge conditions
- **Estimated Hours**: 3
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                      | Type    | Hours  | Status |
| -------------- | ------------------------- | ------- | ------ | ------ |
| WP-BE-012-T001 | Create Module Structure   | setup   | 1.5    | ⬜     |
| WP-BE-012-T002 | Create DTOs               | feature | 1.5    | ⬜     |
| WP-BE-012-T003 | Implement XP Service      | feature | 2.5    | ⬜     |
| WP-BE-012-T004 | Implement Streak Service  | feature | 3      | ⬜     |
| WP-BE-012-T005 | Define Badge System       | feature | 1.5    | ⬜     |
| WP-BE-012-T006 | Implement Badge Service   | feature | 3      | ⬜     |
| WP-BE-012-T007 | Implement Ranking Service | feature | 3      | ⬜     |
| WP-BE-012-T008 | Implement Controllers     | feature | 2      | ⬜     |
| WP-BE-012-T009 | Add Unit Tests            | test    | 3      | ⬜     |
| **Total**      |                           |         | **21** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
