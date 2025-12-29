# WP-BE-013: Progress Module (Backend)

## Overview

| Item           | Value                                                                     |
| -------------- | ------------------------------------------------------------------------- |
| ID             | WP-BE-013                                                                 |
| Name           | Progress Module                                                           |
| Description    | Statistics aggregation, reports, learning history                         |
| Dependencies   | WP-BE-011, WP-BE-012                                                      |
| Estimated Days | 3                                                                         |
| Total Tasks    | 7                                                                         |
| DD References  | `05-module-design/progress-module.md`, `06-component-design.md#uc021-023` |

---

## Tasks

### Task 1: Create Module Structure

- **ID**: WP-BE-013-T001
- **Type**: setup
- **Description**: Khởi tạo Progress module
- **Commands**:
  ```bash
  nest g module modules/progress
  nest g controller modules/progress
  nest g service modules/progress/stats
  nest g service modules/progress/report
  nest g service modules/progress/history
  ```
- **Files to Create**:
  - `progress.module.ts`, `progress.controller.ts`
  - `stats.service.ts`, `report.service.ts`, `history.service.ts`
- **Acceptance Criteria**:
  - [ ] Module registered
  - [ ] 3 Services setup (Stats, Report, History)
- **Estimated Hours**: 1
- **DD Reference**: `05-module-design/progress-module.md`

---

### Task 2: Create Progress DTOs

- **ID**: WP-BE-013-T002
- **Type**: feature
- **Description**: Tạo DTOs cho Progress APIs
- **Files**: `stats-response.dto.ts`, `report-response.dto.ts`, `history-query.dto.ts`
- **Stats Response**:
  ```typescript
  interface StatsResponse {
    daily: {
      conversations: number;
      minutes: number;
      xp: number;
      vocabulary: number;
    };
    weekly: {
      conversations: number;
      minutes: number;
      xp: number;
      vocabulary: number;
    };
    monthly: {
      conversations: number;
      minutes: number;
      xp: number;
      vocabulary: number;
    };
    allTime: {
      totalConversations: number;
      totalMinutes: number;
      totalXp: number;
    };
    averagePronunciation: number;
    currentStreak: number;
  }
  ```
- **Acceptance Criteria**:
  - [ ] StatsResponseDto với daily/weekly/monthly breakdown
  - [ ] ReportResponseDto với sections
  - [ ] HistoryQueryDto với date range, pagination
- **Estimated Hours**: 1.5
- **DD Reference**: N/A

---

### Task 3: Implement Daily Stats Aggregation

- **ID**: WP-BE-013-T003
- **Type**: feature
- **Description**: Aggregate daily statistics từ conversations và vocabulary
- **Files**: `stats.service.ts`
- **Implementation**:
  ```typescript
  async getDailyStats(userId: string, date: Date): Promise<DailyStats> {
    const conversations = await this.conversationRepo.countByUserAndDate(userId, date);
    const minutes = await this.conversationRepo.sumMinutesByUserAndDate(userId, date);
    const xp = await this.xpHistoryRepo.sumByUserAndDate(userId, date);
    const vocabulary = await this.vocabularyRepo.countReviewsByUserAndDate(userId, date);
    const avgPronunciation = await this.conversationRepo.avgPronunciationByUserAndDate(userId, date);

    return { conversations, minutes, xp, vocabulary, avgPronunciation };
  }
  ```
- **Acceptance Criteria**:
  - [ ] Count conversations per day
  - [ ] Sum practice minutes per day
  - [ ] Sum XP earned per day
  - [ ] Count vocabulary reviews per day
  - [ ] Calculate average pronunciation score
- **Estimated Hours**: 2.5
- **DD Reference**: `06-component-design.md#uc021`

---

### Task 4: Implement Weekly/Monthly Reports

- **ID**: WP-BE-013-T004
- **Type**: feature
- **Description**: Generate weekly và monthly summary reports
- **Files**: `report.service.ts`
- **Report Sections**:
  - Summary stats (total conversations, minutes, XP)
  - Pronunciation trend (weekly averages)
  - Top corrections (most common errors)
  - Vocabulary progress (new words, mastered words)
  - Achievement highlights (badges earned, level ups)
- **Implementation**:
  ```typescript
  async generateWeeklyReport(userId: string, weekNumber: number): Promise<WeeklyReport> {
    const startDate = getWeekStart(weekNumber);
    const endDate = getWeekEnd(weekNumber);

    return {
      summary: await this.aggregateStats(userId, startDate, endDate),
      pronunciationTrend: await this.getPronunciationTrend(userId, startDate, endDate),
      topCorrections: await this.getTopCorrections(userId, startDate, endDate),
      vocabularyProgress: await this.getVocabProgress(userId, startDate, endDate),
      achievements: await this.getAchievements(userId, startDate, endDate),
    };
  }
  ```
- **Acceptance Criteria**:
  - [ ] Weekly report với all sections
  - [ ] Monthly report với all sections
  - [ ] Pronunciation trend chart data
  - [ ] Top 5 correction types
  - [ ] New và mastered vocabulary counts
- **Estimated Hours**: 3
- **DD Reference**: `06-component-design.md#uc023`

---

### Task 5: Implement History Query

- **ID**: WP-BE-013-T005
- **Type**: feature
- **Description**: Query learning history với filters và pagination
- **Files**: `history.service.ts`
- **Query Options**:
  - Date range (startDate, endDate)
  - Activity type (conversation, vocabulary, challenge)
  - Pagination (page, limit)
- **Response**:
  ```typescript
  interface HistoryItem {
    id: string;
    type: "conversation" | "vocabulary_review" | "challenge";
    timestamp: Date;
    duration?: number;
    xpEarned: number;
    details: object;
  }
  ```
- **Acceptance Criteria**:
  - [ ] Filter by date range
  - [ ] Filter by activity type
  - [ ] Pagination support
  - [ ] Return XP earned per activity
  - [ ] Include activity details
- **Estimated Hours**: 2
- **DD Reference**: `06-component-design.md#uc021`

---

### Task 6: Implement Controller

- **ID**: WP-BE-013-T006
- **Type**: feature
- **Description**: Implement REST API endpoints
- **APIs**:
  | Method | Endpoint | Description |
  | ------ | ------------------------- | ------------------------ |
  | GET | /progress/stats | Get aggregated stats |
  | GET | /progress/reports/weekly | Get weekly report |
  | GET | /progress/reports/monthly | Get monthly report |
  | GET | /progress/history | Get learning history |
- **Acceptance Criteria**:
  - [ ] All 4 endpoints implemented
  - [ ] JWT authentication
  - [ ] Query params validated
- **Estimated Hours**: 1.5
- **DD Reference**: N/A

---

### Task 7: Add Unit Tests

- **ID**: WP-BE-013-T007
- **Type**: test
- **Description**: Unit tests cho Progress module
- **Test Suites**: StatsService, ReportService, HistoryService
- **Acceptance Criteria**:
  - [ ] Coverage >= 80%
  - [ ] Test aggregation calculations
  - [ ] Test date range queries
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                     | Type    | Hours    | Status |
| -------------- | ------------------------ | ------- | -------- | ------ |
| WP-BE-013-T001 | Create Module Structure  | setup   | 1        | ⬜     |
| WP-BE-013-T002 | Create Progress DTOs     | feature | 1.5      | ⬜     |
| WP-BE-013-T003 | Implement Daily Stats    | feature | 2.5      | ⬜     |
| WP-BE-013-T004 | Implement Weekly/Monthly | feature | 3        | ⬜     |
| WP-BE-013-T005 | Implement History Query  | feature | 2        | ⬜     |
| WP-BE-013-T006 | Implement Controller     | feature | 1.5      | ⬜     |
| WP-BE-013-T007 | Add Unit Tests           | test    | 2        | ⬜     |
| **Total**      |                          |         | **13.5** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
