# WP-FE-010: Learning Screens (Frontend)

## Overview

| Item           | Value                                                                      |
| -------------- | -------------------------------------------------------------------------- |
| ID             | WP-FE-010                                                                  |
| Name           | Learning Screens                                                           |
| Description    | Vocabulary list, review quiz, scenarios, challenges                        |
| Dependencies   | WP-FE-007 (Home)                                                           |
| Estimated Days | 4                                                                          |
| Total Tasks    | 8                                                                          |
| DD References  | `09-ui-specifications.md#learning`, `06-component-design.md#uc017,024-026` |

---

## Tasks

### Task 1: Create Learning Feature Structure

- **ID**: WP-FE-010-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Learning
- **Commands**:
  ```bash
  mkdir -p lib/features/learning/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `learning_feature.dart` - Barrel file
  - `domain/models/vocabulary.dart`, `scenario.dart`, `challenge.dart`
  - `domain/repositories/learning_repository.dart`
  - `data/repositories/learning_repository_impl.dart`
- **Acceptance Criteria**:
  - [ ] Feature folder structure complete
  - [ ] Models defined với all fields
  - [ ] Repository interface defined
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Implement Vocabulary List Screen

- **ID**: WP-FE-010-T002
- **Type**: feature
- **Description**: Screen hiển thị saved vocabulary với filters
- **Files**: `screens/vocabulary_list_screen.dart`, `widgets/vocabulary_list_item.dart`
- **Features**:
  - List vocabulary với word, meaning, SRS level badge
  - Filter by SRS level (new, learning, young, mature, mastered)
  - Search by word
  - Sort by date added / next review
  - Pull to refresh
- **Acceptance Criteria**:
  - [ ] List với pagination (infinite scroll)
  - [ ] Filter chips for SRS levels
  - [ ] Search functionality
  - [ ] Show next review date
  - [ ] SRS level color coded
- **Estimated Hours**: 3
- **DD Reference**: `09-ui-specifications.md#vocabulary`

---

### Task 3: Implement Vocabulary Detail Screen

- **ID**: WP-FE-010-T003
- **Type**: feature
- **Description**: Chi tiết vocabulary với pronunciation và example
- **Files**: `screens/vocabulary_detail_screen.dart`
- **Content**:
  - Word với pronunciation (tap to hear)
  - Meaning (Japanese)
  - Example sentence
  - SRS info (level, next review, review count)
  - Source conversation link (nếu có)
  - Delete button
- **Acceptance Criteria**:
  - [ ] Display all vocabulary fields
  - [ ] Play pronunciation on tap
  - [ ] Link to source conversation
  - [ ] Delete với confirmation
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 4: Implement Review Quiz Screen (SRS)

- **ID**: WP-FE-010-T004
- **Type**: feature
- **Description**: Quiz screen cho vocabulary review
- **Files**: `screens/review_quiz_screen.dart`, `widgets/flashcard_widget.dart`
- **Flow**:
  1. Show word (front of flashcard)
  2. User taps to reveal meaning
  3. User marks correct/incorrect
  4. Next card
  5. Show summary at end
- **Features**:
  - Flashcard flip animation
  - Pronunciation play button
  - Progress indicator (5/20 cards)
  - Skip button
  - End session early option
- **Acceptance Criteria**:
  - [ ] Flashcard flip animation
  - [ ] Correct/Incorrect buttons
  - [ ] Progress bar
  - [ ] XP earned display
  - [ ] Summary với correct/total count
- **Estimated Hours**: 3.5
- **DD Reference**: `06-component-design.md#uc026`

---

### Task 5: Implement Scenario List Screen

- **ID**: WP-FE-010-T005
- **Type**: feature
- **Description**: Browse scenario library
- **Files**: `screens/scenario_list_screen.dart`, `widgets/scenario_card.dart`
- **Features**:
  - Category tabs: Daily, Business, Travel, Academic, Test Prep
  - Difficulty badges: Beginner, Intermediate, Advanced
  - Estimated duration
  - Tap to start conversation với scenario
- **Acceptance Criteria**:
  - [ ] Category tabs working
  - [ ] Difficulty filter
  - [ ] Scenario card với title, description, duration
  - [ ] Start button navigates to conversation
- **Estimated Hours**: 2.5
- **DD Reference**: `06-component-design.md#uc024`

---

### Task 6: Implement Challenge Screen

- **ID**: WP-FE-010-T006
- **Type**: feature
- **Description**: Daily challenge display và tracking
- **Files**: `screens/challenge_screen.dart`, `widgets/challenge_card.dart`
- **Features**:
  - Today's challenges list (1-3 challenges)
  - Progress bar per challenge
  - XP reward display
  - Completed state với checkmark
  - Timer until next refresh (midnight)
- **Challenge Types Display**:
  - Conversation: "Complete 2 conversations" (1/2)
  - Vocabulary: "Review 10 words" (5/10)
  - Pronunciation: "Achieve 80% score" (75%)
- **Acceptance Criteria**:
  - [ ] Display today's challenges
  - [ ] Real-time progress update
  - [ ] Completion animation
  - [ ] XP earned popup
- **Estimated Hours**: 2.5
- **DD Reference**: `06-component-design.md#uc025`

---

### Task 7: Create Learning Providers

- **ID**: WP-FE-010-T007
- **Type**: feature
- **Description**: Riverpod providers cho Learning feature
- **Files**: `presentation/providers/learning_providers.dart`
- **Providers**:
  ```dart
  final vocabularyListProvider = FutureProvider.autoDispose.family<List<Vocabulary>, VocabQuery>();
  final vocabularyDetailProvider = FutureProvider.autoDispose.family<Vocabulary, String>();
  final dueVocabularyProvider = FutureProvider.autoDispose<List<Vocabulary>>();
  final scenarioListProvider = FutureProvider.autoDispose.family<List<Scenario>, ScenarioQuery>();
  final todayChallengesProvider = FutureProvider.autoDispose<List<UserChallenge>>();
  ```
- **Acceptance Criteria**:
  - [ ] All providers implemented
  - [ ] Cache invalidation on actions
  - [ ] Error handling
  - [ ] Loading states
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 8: Implement Navigation

- **ID**: WP-FE-010-T008
- **Type**: feature
- **Description**: Navigation routes cho Learning screens
- **Routes**:
  - `/vocabulary` → VocabularyListScreen
  - `/vocabulary/:id` → VocabularyDetailScreen
  - `/vocabulary/review` → ReviewQuizScreen
  - `/scenarios` → ScenarioListScreen
  - `/challenges` → ChallengeScreen
- **Acceptance Criteria**:
  - [ ] All routes registered
  - [ ] Deep linking support
  - [ ] Back navigation works correctly
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                      | Type    | Hours    | Status |
| -------------- | ------------------------- | ------- | -------- | ------ |
| WP-FE-010-T001 | Create Feature Structure  | setup   | 1        | ⬜     |
| WP-FE-010-T002 | Vocabulary List Screen    | feature | 3        | ⬜     |
| WP-FE-010-T003 | Vocabulary Detail Screen  | feature | 2        | ⬜     |
| WP-FE-010-T004 | Review Quiz Screen        | feature | 3.5      | ⬜     |
| WP-FE-010-T005 | Scenario List Screen      | feature | 2.5      | ⬜     |
| WP-FE-010-T006 | Challenge Screen          | feature | 2.5      | ⬜     |
| WP-FE-010-T007 | Create Learning Providers | feature | 2        | ⬜     |
| WP-FE-010-T008 | Implement Navigation      | feature | 1        | ⬜     |
| **Total**      |                           |         | **17.5** |        |

---

_Back to: [\_phase-4.md](./_phase-4.md)_
