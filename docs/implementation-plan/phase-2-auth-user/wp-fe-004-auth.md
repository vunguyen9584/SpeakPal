# WP-FE-004: Auth Screens

## Overview

- **ID**: WP-FE-004
- **Description**: Login, Register, Forgot Password screens
- **Dependencies**: WP-FE-002, WP-FE-003
- **Estimated Days**: 3
- **Total Tasks**: 7
- **DD References**:
  - `09-ui-specifications.md#auth`
  - `09-ui-specifications/auth-screens.md`
  - `06-component-design.md#uc001-005`

---

## Tasks

### Task 1: Create Auth Feature Structure

- **ID**: WP-FE-004-T001
- **Type**: setup
- **Description**: Tạo auth feature folder structure
- **Files to Create**:
  - `mobile/lib/features/auth/` - Feature folder
  - `mobile/lib/features/auth/presentation/screens/`
  - `mobile/lib/features/auth/presentation/widgets/`
  - `mobile/lib/features/auth/presentation/providers/`
  - `mobile/lib/features/auth/domain/models/`
  - `mobile/lib/features/auth/data/`
- **Estimated Hours**: 0.5

---

### Task 2: Create Auth Models

- **ID**: WP-FE-004-T002
- **Type**: feature
- **Description**: Tạo domain models với Freezed
- **Files to Create**:
  - `mobile/lib/features/auth/domain/models/user.dart`
    ```dart
    @freezed
    class User with _$User {
      const factory User({
        required String id,
        required String email,
        String? username,
        required Level level,
        required int totalXp,
        required int currentLevelXp,
        required League league,
        required double aiSpeed,
        required bool confirmationMode,
        required bool isVerified,
        DateTime? lastLoginAt,
        required DateTime createdAt,
      }) = _User;

      factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    }
    ```
  - `mobile/lib/features/auth/domain/models/auth_tokens.dart`
  - `mobile/lib/features/auth/domain/models/auth_state.dart`
- **Commands**:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Estimated Hours**: 1.5

---

### Task 3: Create Auth Repository

- **ID**: WP-FE-004-T003
- **Type**: feature
- **Description**: Tạo repository để giao tiếp với Auth API
- **Files to Create**:
  - `mobile/lib/features/auth/data/auth_repository.dart`
    ```dart
    class AuthRepository {
      final ApiClient _apiClient;
      final TokenManager _tokenManager;

      Future<User> register(String email, String password, String? username);
      Future<User> login(String email, String password);
      Future<void> logout();
      Future<AuthTokens> refreshTokens();
      Future<void> forgotPassword(String email);
      Future<void> resetPassword(String token, String newPassword);
      Future<User> loginWithGoogle();
      Future<User> loginWithApple();
    }
    ```
- **Estimated Hours**: 2.5

---

### Task 4: Create Auth Providers

- **ID**: WP-FE-004-T004
- **Type**: feature
- **Description**: Tạo Riverpod providers cho auth state management
- **Files to Create**:
  - `mobile/lib/features/auth/presentation/providers/auth_provider.dart`

    ```dart
    final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
      return AuthNotifier(ref.read(authRepositoryProvider));
    });

    class AuthNotifier extends StateNotifier<AuthState> {
      final AuthRepository _repository;

      AuthNotifier(this._repository) : super(const AuthState.initial());

      Future<void> login(String email, String password) async {
        state = const AuthState.loading();
        try {
          final user = await _repository.login(email, password);
          state = AuthState.authenticated(user);
        } catch (e) {
          state = AuthState.error(e.toString());
        }
      }

      Future<void> register(String email, String password) async { ... }
      Future<void> logout() async { ... }
      Future<void> checkAuthStatus() async { ... }
    }
    ```

  - `mobile/lib/features/auth/presentation/providers/auth_state.dart`
- **Estimated Hours**: 2

---

### Task 5: Implement Login Screen

- **ID**: WP-FE-004-T005
- **Type**: feature
- **Description**: Implement login screen với email/password và OAuth buttons
- **Files to Create**:
  - `mobile/lib/features/auth/presentation/screens/login_screen.dart`
  - `mobile/lib/features/auth/presentation/widgets/login_form.dart`
  - `mobile/lib/features/auth/presentation/widgets/social_login_buttons.dart`
- **Screen Elements**:
  - Logo & welcome text
  - Email input field
  - Password input field (with show/hide toggle)
  - "Forgot Password?" link
  - Login button
  - Divider with "OR"
  - Google Sign-in button
  - Apple Sign-in button
  - "Don't have an account? Register" link
- **DD Reference**: `09-ui-specifications/auth-screens.md#login`
- **Estimated Hours**: 4

---

### Task 6: Implement Register Screen

- **ID**: WP-FE-004-T006
- **Type**: feature
- **Description**: Implement registration screen
- **Files to Create**:
  - `mobile/lib/features/auth/presentation/screens/register_screen.dart`
  - `mobile/lib/features/auth/presentation/widgets/register_form.dart`
- **Screen Elements**:
  - Email input
  - Username input (optional)
  - Password input
  - Confirm password input
  - Terms & Privacy checkbox
  - Register button
  - Social login options
  - "Already have an account? Login" link
- **Validation**:
  - Email format validation
  - Password strength indicator
  - Password match validation
- **DD Reference**: `09-ui-specifications/auth-screens.md#register`
- **Estimated Hours**: 3

---

### Task 7: Implement Forgot Password Screen

- **ID**: WP-FE-004-T007
- **Type**: feature
- **Description**: Implement forgot/reset password flow
- **Files to Create**:
  - `mobile/lib/features/auth/presentation/screens/forgot_password_screen.dart`
  - `mobile/lib/features/auth/presentation/screens/reset_password_screen.dart`
  - `mobile/lib/features/auth/presentation/screens/check_email_screen.dart`
- **Flow**:
  1. Enter email → Send reset link
  2. Check email screen (with resend option)
  3. Reset password screen (from deep link)
- **Estimated Hours**: 2.5

---

## Task Summary

| Task ID        | Name                      | Type    | Est. Hours | Status |
| -------------- | ------------------------- | ------- | ---------- | ------ |
| WP-FE-004-T001 | Create Feature Structure  | setup   | 0.5        | ⬜     |
| WP-FE-004-T002 | Create Auth Models        | feature | 1.5        | ⬜     |
| WP-FE-004-T003 | Create Auth Repository    | feature | 2.5        | ⬜     |
| WP-FE-004-T004 | Create Auth Providers     | feature | 2          | ⬜     |
| WP-FE-004-T005 | Implement Login Screen    | feature | 4          | ⬜     |
| WP-FE-004-T006 | Implement Register Screen | feature | 3          | ⬜     |
| WP-FE-004-T007 | Implement Forgot Password | feature | 2.5        | ⬜     |
| **Total**      |                           |         | **16**     |        |

---

_DD References: 09-ui-specifications/auth-screens.md, 06-component-design.md#uc001-005_
