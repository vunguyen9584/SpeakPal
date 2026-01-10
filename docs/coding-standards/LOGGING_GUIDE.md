# 📝 Logging Guidelines

## Purpose

To ensure consistent logging practices across the application, facilitating debugging, error tracking, and production monitoring without cluttering the console or leaking sensitive information.

## LoggerService

We use a centralized `LoggerService` (located in `lib/core/utils/logger_service.dart`) which handles:

- Console logging (Debug/Profile modes only)
- Crash reporting via Firebase Crashlytics (Release mode)
- Log formatting and tagging

### Global Instance

A global instance `logger` is available for use throughout the app:

```dart
import 'package:mobile/core/utils/logger_service.dart';

logger.info('Message');
```

## Log Levels

| Level       | Method             | Emoji | Usage                                                                            | Crashlytics    |
| ----------- | ------------------ | ----- | -------------------------------------------------------------------------------- | -------------- |
| **Debug**   | `logger.debug()`   | 🐛    | Development details, variable states, flow tracing. **Ignored in Release mode.** | ❌             |
| **Info**    | `logger.info()`    | ℹ️    | Major app events, screen navigation, user actions, successful API calls.         | ❌             |
| **Warning** | `logger.warning()` | ⚠️    | Unexpected but handled issues, deprecated API usage, recoverable errors.         | ❌ (Logs only) |
| **Error**   | `logger.error()`   | 🔥    | Exceptions caught, API failures, functionality breakage.                         | ✅ (Non-fatal) |
| **Fatal**   | `logger.fatal()`   | 💥    | App crashes, invalid states requiring restart.                                   | ✅ (Fatal)     |

## Dos and Don'ts

### ✅ Do

- Use **tags** to identify the source (e.g., class name or feature).
- Pass `error` and `stackTrace` parameters when logging exceptions.
- Use `logger.debug` for high-volume logs (e.g., scroll updates, stream events).
- Sanitize sensitive data before logging (e.g., "Password: \*\*\*").

### ❌ Don't

- Use `print()` or `debugPrint()` directly.
- Log PII (Personally Identifiable Information) like passwords, tokens, or emails.
- Leave `logger.debug` calls in tight loops in production code.

## Examples

### API Error

```dart
try {
  await api.fetchUser();
} catch (e, stack) {
  logger.error(
    'Failed to fetch user profile',
    tag: 'UserRepository',
    error: e,
    stackTrace: stack,
  );
}
```

### Screen Navigation

```dart
logger.info('Navigating to Home Screen', tag: 'AppRouter');
```

### Debugging State

```dart
logger.debug(
  'User score update',
  tag: 'GamificationProvider',
  data: {'old': 100, 'new': 120}
);
```
