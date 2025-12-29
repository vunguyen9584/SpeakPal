# Phase 4: Learning & Gamification

## Overview

| Item          | Value                            |
| ------------- | -------------------------------- |
| Phase         | 4                                |
| Description   | Learning & Gamification Features |
| Work Packages | 6                                |
| Total Tasks   | 47                               |
| Est. Hours    | 101                              |
| Est. Days     | ~13 days (8h/day)                |
| Dependencies  | Phase 3 (Conversation)           |

> 📁 **Structure**: Phase 4 có 6 WPs, được tổ chức thành thư mục với file riêng cho mỗi WP.

---

## Work Packages

| ID        | Name                      | Tasks | Est. Hours | File                             |
| --------- | ------------------------- | ----- | ---------- | -------------------------------- |
| WP-BE-011 | Learning Module (BE)      | 10    | 22         | [→](./wp-be-011-learning.md)     |
| WP-BE-012 | Gamification Module (BE)  | 9     | 21         | [→](./wp-be-012-gamification.md) |
| WP-BE-013 | Progress Module (BE)      | 7     | 13.5       | [→](./wp-be-013-progress.md)     |
| WP-FE-010 | Learning Screens (FE)     | 8     | 17.5       | [→](./wp-fe-010-learning.md)     |
| WP-FE-011 | Gamification Screens (FE) | 7     | 14         | [→](./wp-fe-011-gamification.md) |
| WP-FE-012 | Progress Screens (FE)     | 6     | 13         | [→](./wp-fe-012-progress.md)     |

---

## Key Features

### Learning Module

- Vocabulary management (save, review, SRS)
- Scenarios browse and selection
- Daily challenges

### Gamification Module

- XP system and levels
- Streak tracking with freeze
- Badges and achievements
- Weekly rankings/leaderboard

### Progress Module

- Statistics aggregation
- Weekly/monthly reports
- Learning history

---

## Work Package Details

### WP-BE-011: Learning Module (BE)

**Tasks:**

1. Create Module Structure
2. Create Learning DTOs (Vocabulary, Scenario, Challenge)
3. Implement Vocabulary Service (CRUD, SRS logic)
4. Implement Scenario Service
5. Implement Challenge Service
6. Implement Controller
7. Add Unit Tests

**APIs:**

- `GET /vocabularies` - List saved vocabulary
- `POST /vocabularies` - Save new vocabulary
- `POST /vocabularies/:id/review` - Record review result
- `GET /vocabularies/due` - Get due for review
- `GET /scenarios` - List scenarios
- `GET /challenges/today` - Get today's challenge

---

### WP-BE-012: Gamification Module (BE)

**Tasks:**

1. Create Module Structure
2. Create Gamification DTOs
3. Implement XP Service (add, level up)
4. Implement Streak Service (check-in, freeze, reset)
5. Implement Badge Service (check, award)
6. Implement Ranking Service
7. Add Unit Tests

**APIs:**

- `GET /streaks` - Get current streak
- `POST /streaks/freeze` - Use streak freeze
- `GET /badges` - List all badges
- `GET /badges/mine` - List earned badges
- `GET /rankings/weekly` - Weekly leaderboard

---

### WP-BE-013: Progress Module (BE)

**Tasks:**

1. Create Module Structure
2. Implement Daily Stats Aggregation
3. Implement Weekly/Monthly Reports
4. Implement History Query
5. Implement Controller
6. Add Unit Tests

---

### WP-FE-010: Learning Screens (FE)

**Tasks:**

1. Create Learning Feature Structure
2. Implement Vocabulary List Screen
3. Implement Vocabulary Detail Screen
4. Implement Review Quiz Screen (SRS)
5. Implement Scenario List Screen
6. Implement Challenge Screen
7. Create Learning Providers

---

### WP-FE-011: Gamification Screens (FE)

**Tasks:**

1. Create Gamification Feature Structure
2. Implement Badges Collection Screen
3. Implement Badge Detail Modal
4. Implement Leaderboard Screen
5. Implement Streak Widget
6. Implement Level Up Animation

---

### WP-FE-012: Progress Screens (FE)

**Tasks:**

1. Create Progress Feature Structure
2. Implement Statistics Dashboard
3. Implement Charts (conversations, vocabulary, XP)
4. Implement Weekly Report Screen
5. Implement History List Screen

---

## Phase Summary

| Category  | Work Packages | Tasks  | Est. Hours |
| --------- | ------------- | ------ | ---------- |
| Backend   | 3             | 20     | 88         |
| Frontend  | 3             | 18     | 72         |
| **Total** | **6**         | **38** | **160**    |

---

## DD References

- `05-module-design/learning-module.md`
- `05-module-design/gamification-module.md`
- `05-module-design/progress-module.md`
- `07-database-design/learning-tables.md`
- `07-database-design/gamification-tables.md`
- `08-api-design/learning-apis.md`
- `08-api-design/gamification-apis.md`
- `09-ui-specifications/progress-screens.md`

---

## Next Phase

→ [Phase 5: Social & Subscription](../phase-5-social.md)

---

_Back to: [\_index.md](../_index.md)_
