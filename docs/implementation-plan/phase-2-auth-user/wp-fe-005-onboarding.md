# WP-FE-005: Onboarding Screens

## Overview

- **ID**: WP-FE-005
- **Description**: Level test, persona setup
- **Dependencies**: WP-FE-004
- **Estimated Days**: 2
- **Total Tasks**: 5
- **DD References**:
  - `09-ui-specifications.md#onboarding`
  - `06-component-design.md#uc006-008`

---

## Tasks

### Task 1: Create Onboarding Feature Structure

- **ID**: WP-FE-005-T001
- **Type**: setup
- **Description**: Tạo onboarding feature folder structure
- **Files to Create**:
  - `mobile/lib/features/onboarding/presentation/screens/`
  - `mobile/lib/features/onboarding/presentation/widgets/`
  - `mobile/lib/features/onboarding/presentation/providers/`
  - `mobile/lib/features/onboarding/domain/`
- **Estimated Hours**: 0.5

---

### Task 2: Implement Welcome Screen

- **ID**: WP-FE-005-T002
- **Type**: feature
- **Description**: Implement welcome/tutorial carousel
- **Files to Create**:
  - `mobile/lib/features/onboarding/presentation/screens/welcome_screen.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/onboarding_page.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/page_indicator.dart`
- **Screen Elements**:
  - PageView with 3-4 onboarding pages
  - Illustration + title + description for each page
  - Page indicator dots
  - Skip button
  - Next/Get Started button
- **Pages**:
  1. "Practice conversation with AI" - AI chat illustration
  2. "Get instant feedback" - Feedback/correction illustration
  3. "Track your progress" - Charts/gamification illustration
  4. "Start your journey" - Get started CTA
- **Estimated Hours**: 3

---

### Task 3: Implement Level Selection

- **ID**: WP-FE-005-T003
- **Type**: feature
- **Description**: Implement level selection screen
- **Files to Create**:
  - `mobile/lib/features/onboarding/presentation/screens/level_selection_screen.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/level_card.dart`
- **Screen Elements**:
  - Title: "What's your English level?"
  - Level cards (BEGINNER, ELEMENTARY, INTERMEDIATE, UPPER_INTERMEDIATE, ADVANCED)
  - Each card with description và example
  - Continue button
- **Estimated Hours**: 2.5

---

### Task 4: Implement Persona Setup

- **ID**: WP-FE-005-T004
- **Type**: feature
- **Description**: Implement persona creation/selection screen
- **Files to Create**:
  - `mobile/lib/features/onboarding/presentation/screens/persona_setup_screen.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/persona_card.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/voice_selector.dart`
  - `mobile/lib/features/onboarding/presentation/widgets/personality_selector.dart`
- **Screen Elements**:
  - Title: "Create your AI conversation partner"
  - Persona name input
  - Voice selection (Male US, Female US, Male UK, Female UK)
  - Personality selection (Friendly, Professional, Casual, Strict)
  - Preview/test voice button
  - Create button
- **Estimated Hours**: 3.5

---

### Task 5: Implement Onboarding Flow

- **ID**: WP-FE-005-T005
- **Type**: feature
- **Description**: Connect screens và manage flow state
- **Files to Create**:
  - `mobile/lib/features/onboarding/presentation/providers/onboarding_provider.dart`
  - `mobile/lib/features/onboarding/presentation/screens/onboarding_complete_screen.dart`
- **Flow Logic**:
  ```dart
  class OnboardingNotifier extends StateNotifier<OnboardingState> {
    // Track current step
    // Save selections (level, persona)
    // Navigate between screens
    // Complete onboarding → navigate to home
  }
  ```
- **Navigation Flow**:
  1. Welcome → Level Selection
  2. Level Selection → Persona Setup
  3. Persona Setup → Onboarding Complete → Home
- **Estimated Hours**: 2

---

## Task Summary

| Task ID        | Name                      | Type    | Est. Hours | Status |
| -------------- | ------------------------- | ------- | ---------- | ------ |
| WP-FE-005-T001 | Create Feature Structure  | setup   | 0.5        | ⬜     |
| WP-FE-005-T002 | Implement Welcome Screen  | feature | 3          | ⬜     |
| WP-FE-005-T003 | Implement Level Selection | feature | 2.5        | ⬜     |
| WP-FE-005-T004 | Implement Persona Setup   | feature | 3.5        | ⬜     |
| WP-FE-005-T005 | Implement Onboarding Flow | feature | 2          | ⬜     |
| **Total**      |                           |         | **11.5**   |        |

---

_DD References: 09-ui-specifications.md#onboarding, 06-component-design.md#uc006-008_
