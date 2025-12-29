# WP-FE-011: Gamification Screens (Frontend)

## Overview

| Item           | Value                                                   |
| -------------- | ------------------------------------------------------- |
| ID             | WP-FE-011                                               |
| Name           | Gamification Screens                                    |
| Description    | Badges, leaderboard, streak widget, level up animations |
| Dependencies   | WP-FE-010 (Learning Screens)                            |
| Estimated Days | 3                                                       |
| Total Tasks    | 7                                                       |
| DD References  | `09-ui-specifications.md#gamification`                  |

---

## Tasks

### Task 1: Create Gamification Feature Structure

- **ID**: WP-FE-011-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Gamification
- **Commands**:
  ```bash
  mkdir -p lib/features/gamification/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `gamification_feature.dart`
  - `domain/models/badge.dart`, `streak.dart`, `ranking.dart`
  - `domain/repositories/gamification_repository.dart`
- **Acceptance Criteria**:
  - [ ] Feature folder structure complete
  - [ ] Models với all fields
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Implement Badges Collection Screen

- **ID**: WP-FE-011-T002
- **Type**: feature
- **Description**: Display all badges với earned/locked status
- **Files**: `screens/badges_screen.dart`, `widgets/badge_grid_item.dart`
- **Features**:
  - Grid layout của tất cả badges
  - Earned badges: full color với earned date
  - Locked badges: grayscale với progress bar
  - Category tabs: All, Streak, Level, Conversation, Vocabulary
  - Tap to view detail
- **Acceptance Criteria**:
  - [ ] Grid view với all badges
  - [ ] Earned vs locked visual difference
  - [ ] Category filtering
  - [ ] Progress indication for locked badges
- **Estimated Hours**: 2.5
- **DD Reference**: N/A

---

### Task 3: Implement Badge Detail Modal

- **ID**: WP-FE-011-T003
- **Type**: feature
- **Description**: Modal hiển thị badge detail và progress
- **Files**: `widgets/badge_detail_modal.dart`
- **Content**:
  - Badge icon (large)
  - Badge name và description
  - XP bonus
  - Earned date (if earned)
  - Progress bar và percentage (if locked)
  - Condition description
- **Acceptance Criteria**:
  - [ ] Full badge info display
  - [ ] Progress tracking for locked
  - [ ] Share button for earned badges
- **Estimated Hours**: 1.5
- **DD Reference**: N/A

---

### Task 4: Implement Leaderboard Screen

- **ID**: WP-FE-011-T004
- **Type**: feature
- **Description**: Weekly leaderboard với league tabs
- **Files**: `screens/leaderboard_screen.dart`, `widgets/ranking_list_item.dart`
- **Features**:
  - League tabs: Bronze, Silver, Gold, Platinum, Diamond
  - Top 3 với special styling (gold, silver, bronze)
  - User's own rank highlighted
  - Weekly XP display
  - Promotion/demotion zone indicators
  - Week number và reset timer
- **Acceptance Criteria**:
  - [ ] League tabs working
  - [ ] Top 3 special UI
  - [ ] Current user highlighted
  - [ ] Promotion zone (green), Demotion zone (red)
  - [ ] Pull to refresh
- **Estimated Hours**: 3
- **DD Reference**: N/A

---

### Task 5: Implement Streak Widget

- **ID**: WP-FE-011-T005
- **Type**: feature
- **Description**: Reusable streak widget cho home và profile
- **Files**: `widgets/streak_widget.dart`, `widgets/streak_calendar.dart`
- **Features**:
  - Fire icon với current streak number
  - Freeze count display
  - Mini calendar showing recent 7 days
  - Milestone progress (e.g., "3 days to 30!")
  - Streak at risk warning (no activity today)
- **Implementation**:
  ```dart
  class StreakWidget extends StatelessWidget {
    final int currentStreak;
    final int freezeRemaining;
    final int nextMilestone;
    final bool atRisk;
  }
  ```
- **Acceptance Criteria**:
  - [ ] Fire animation for active streaks
  - [ ] Freeze count với ice icon
  - [ ] 7-day calendar view
  - [ ] Warning state when at risk
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 6: Implement Level Up Animation

- **ID**: WP-FE-011-T006
- **Type**: feature
- **Description**: Full-screen celebration animation khi level up
- **Files**: `widgets/level_up_animation.dart`, `widgets/confetti_animation.dart`
- **Features**:
  - Confetti animation
  - Level number transition (5 → 6)
  - XP progress bar animation
  - Sound effect (optional)
  - "Continue" button
- **Trigger**: Show after conversation ends if leveledUp = true
- **Acceptance Criteria**:
  - [ ] Full screen overlay
  - [ ] Confetti particles
  - [ ] Level number animation
  - [ ] Dismissible after animation
- **Estimated Hours**: 2.5
- **DD Reference**: N/A

---

### Task 7: Create Gamification Providers

- **ID**: WP-FE-011-T007
- **Type**: feature
- **Description**: Riverpod providers cho Gamification
- **Files**: `presentation/providers/gamification_providers.dart`
- **Providers**:
  ```dart
  final streakProvider = FutureProvider.autoDispose<Streak>();
  final allBadgesProvider = FutureProvider.autoDispose<List<Badge>>();
  final myBadgesProvider = FutureProvider.autoDispose<List<EarnedBadge>>();
  final weeklyRankingProvider = FutureProvider.autoDispose.family<RankingResponse, String>();
  final myRankProvider = FutureProvider.autoDispose<UserRankInfo>();
  ```
- **Acceptance Criteria**:
  - [ ] All providers implemented
  - [ ] Cache management
  - [ ] Error states
- **Estimated Hours**: 1.5
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                     | Type    | Hours  | Status |
| -------------- | ------------------------ | ------- | ------ | ------ |
| WP-FE-011-T001 | Create Feature Structure | setup   | 1      | ⬜     |
| WP-FE-011-T002 | Badges Collection Screen | feature | 2.5    | ⬜     |
| WP-FE-011-T003 | Badge Detail Modal       | feature | 1.5    | ⬜     |
| WP-FE-011-T004 | Leaderboard Screen       | feature | 3      | ⬜     |
| WP-FE-011-T005 | Streak Widget            | feature | 2      | ⬜     |
| WP-FE-011-T006 | Level Up Animation       | feature | 2.5    | ⬜     |
| WP-FE-011-T007 | Create Providers         | feature | 1.5    | ⬜     |
| **Total**      |                          |         | **14** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
