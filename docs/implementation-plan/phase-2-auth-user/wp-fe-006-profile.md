# WP-FE-006: Profile & Settings

## Overview

- **ID**: WP-FE-006
- **Description**: User profile, app settings screens
- **Dependencies**: WP-FE-004
- **Estimated Days**: 2
- **Total Tasks**: 5
- **DD References**:
  - `09-ui-specifications.md#profile`
  - `06-component-design.md#uc030-033`

---

## Tasks

### Task 1: Create Profile Feature Structure

- **ID**: WP-FE-006-T001
- **Type**: setup
- **Description**: Tạo profile feature folder structure
- **Files to Create**:
  - `mobile/lib/features/profile/presentation/screens/`
  - `mobile/lib/features/profile/presentation/widgets/`
  - `mobile/lib/features/profile/presentation/providers/`
  - `mobile/lib/features/profile/data/`
- **Estimated Hours**: 0.5

---

### Task 2: Create Profile Repository

- **ID**: WP-FE-006-T002
- **Type**: feature
- **Description**: Tạo repository cho profile API calls
- **Files to Create**:
  - `mobile/lib/features/profile/data/profile_repository.dart`
    ```dart
    class ProfileRepository {
      final ApiClient _apiClient;

      Future<User> getProfile();
      Future<User> updateProfile(UpdateProfileRequest request);
      Future<void> updateSettings(UpdateSettingsRequest request);
      Future<void> changePassword(ChangePasswordRequest request);
      Future<UserStats> getStats();
    }
    ```
  - `mobile/lib/features/profile/domain/models/user_stats.dart`
- **Estimated Hours**: 1.5

---

### Task 3: Implement Profile Screen

- **ID**: WP-FE-006-T003
- **Type**: feature
- **Description**: Implement user profile screen
- **Files to Create**:
  - `mobile/lib/features/profile/presentation/screens/profile_screen.dart`
  - `mobile/lib/features/profile/presentation/widgets/profile_header.dart`
  - `mobile/lib/features/profile/presentation/widgets/stats_card.dart`
  - `mobile/lib/features/profile/presentation/widgets/level_progress.dart`
  - `mobile/lib/features/profile/presentation/providers/profile_provider.dart`
- **Screen Elements**:
  - Profile header (avatar, name, email, level badge)
  - XP progress bar to next level
  - Stats grid (Conversations, Vocabulary, Streak, Badges)
  - Quick actions (Edit Profile, Manage Personas, Settings)
  - Subscription status card
  - Logout button
- **DD Reference**: `09-ui-specifications/progress-screens.md`
- **Estimated Hours**: 4

---

### Task 4: Implement Settings Screen

- **ID**: WP-FE-006-T004
- **Type**: feature
- **Description**: Implement app settings screen
- **Files to Create**:
  - `mobile/lib/features/profile/presentation/screens/settings_screen.dart`
  - `mobile/lib/features/profile/presentation/widgets/settings_tile.dart`
  - `mobile/lib/features/profile/presentation/widgets/settings_section.dart`
- **Screen Elements**:
  - **Conversation Settings**
    - AI Speed slider (0.5x - 2x)
    - Confirmation Mode toggle
  - **Appearance**
    - Theme selection (Light, Dark, System)
    - Language selection
  - **Notifications**
    - Push notifications toggle
    - Daily reminder time picker
  - **Account**
    - Change Password
    - Delete Account
  - **About**
    - Version info
    - Terms of Service
    - Privacy Policy
    - Contact Support
- **Estimated Hours**: 3

---

### Task 5: Implement Edit Profile Screen

- **ID**: WP-FE-006-T005
- **Type**: feature
- **Description**: Implement profile edit screen
- **Files to Create**:
  - `mobile/lib/features/profile/presentation/screens/edit_profile_screen.dart`
  - `mobile/lib/features/profile/presentation/screens/change_password_screen.dart`
- **Screen Elements**:
  - Avatar picker (camera, gallery, remove)
  - Username input
  - Email display (non-editable)
  - Save button
- **Estimated Hours**: 2.5

---

## Task Summary

| Task ID        | Name                      | Type    | Est. Hours | Status |
| -------------- | ------------------------- | ------- | ---------- | ------ |
| WP-FE-006-T001 | Create Feature Structure  | setup   | 0.5        | ⬜     |
| WP-FE-006-T002 | Create Profile Repository | feature | 1.5        | ⬜     |
| WP-FE-006-T003 | Implement Profile Screen  | feature | 4          | ⬜     |
| WP-FE-006-T004 | Implement Settings Screen | feature | 3          | ⬜     |
| WP-FE-006-T005 | Implement Edit Profile    | feature | 2.5        | ⬜     |
| **Total**      |                           |         | **11.5**   |        |

---

_DD References: 09-ui-specifications.md#profile, 06-component-design.md#uc030-033_
