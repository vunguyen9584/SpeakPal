# 🔧 Technical Debt Resolution Plan

**Based on:** CODE_AUDIT_REPORT_2026-01-10.md  
**Start Date:** 2026-01-10  
**Target Completion:** 2026-02-07 (4 weeks)  
**Owner:** Mobile Development Team

---

## 📋 Executive Summary

**Total Issues:** 148 findings  
**Critical/High Priority:** 30 issues  
**Strategy:** Phased approach with production-ready fixes, comprehensive testing, and progress tracking

---

## 🎯 Principles & Constraints

### ✅ Quality Gates

1. **Production-Ready Standard:**

   - ❌ No quick fixes or workarounds
   - ✅ Complete implementation with proper error handling
   - ✅ Unit + Widget tests cho mọi thay đổi
   - ✅ Code review bởi 2+ developers

2. **Technical Debt Prevention:**

   - ❌ No new TODOs introduced
   - ✅ Proper documentation cho complex logic
   - ✅ Follow established patterns and architecture
   - ✅ Refactor existing code if needed

3. **Progress Tracking:**
   - Daily standup reports with checklist updates
   - GitHub Issues/Projects integration
   - Automated test coverage reports
   - Weekly stakeholder reviews

---

## 📊 Phase Overview

| Phase | Focus                       | Duration | Issues | Status |
| ----- | --------------------------- | -------- | ------ | ------ |
| 0     | Setup & Tooling             | 2 days   | N/A    | ⏳     |
| 1     | Critical Stability Fixes    | 5 days   | 30     | ⏳     |
| 2     | Core Feature Completion     | 7 days   | 25     | ⏳     |
| 3     | Security & Production Prep  | 5 days   | 20     | ⏳     |
| 4     | Polish & Optimization       | 6 days   | 73     | ⏳     |
| 5     | Final QA & Launch Readiness | 3 days   | N/A    | ⏳     |

**Total:** 28 working days (4 weeks)

---

# 🚀 Phase 0: Setup & Tooling (Days 1-2)

**Objective:** Establish infrastructure cho quality tracking và automated fixes

## Work Packages

### WP-SETUP-001: Code Quality Automation

**Owner:** DevOps Lead  
**Duration:** 1 day

#### Tasks

- [ ] **T001: Setup Flutter Analyze CI Pipeline**

  ```yaml
  # .github/workflows/flutter-analyze.yml
  name: Flutter Analyze
  on: [push, pull_request]
  jobs:
    analyze:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        - uses: subosito/flutter-action@v2
        - run: flutter pub get
        - run: flutter analyze --no-pub
        - run: |
            ISSUES=$(flutter analyze --no-pub 2>&1 | grep -E "error •|warning •" | wc -l)
            echo "TOTAL_ISSUES=$ISSUES" >> $GITHUB_ENV
        - name: Fail if errors exist
          run: |
            if [ "$TOTAL_ISSUES" -gt 0 ]; then
              echo "❌ Found $TOTAL_ISSUES issues"
              exit 1
            fi
  ```

  **DoD:** CI fails nếu có errors, passes với warnings only

- [ ] **T002: Setup Test Coverage Reporting**

  ```bash
  # Add to CI
  flutter test --coverage
  lcov --remove coverage/lcov.info 'lib/*/*.g.dart' -o coverage/lcov.info
  genhtml coverage/lcov.info -o coverage/html
  # Upload to codecov.io
  ```

  **DoD:** Coverage report visible trong PRs, baseline 60%+ established

- [ ] **T003: Create Issue Tracking Template**

  ```markdown
  # Issue #[ID] - [Title from Audit Report]

  **Audit ID:** #[1-65]
  **Category:** [Tech Debt/Missing Feature/Best Practice/Security]
  **Severity:** [Critical/High/Medium/Low]
  **Phase:** [1/2/3/4]

  ## Problem

  [Description from audit report]

  ## Solution Approach

  - [ ] Implementation steps
  - [ ] Testing requirements
  - [ ] Review checklist

  ## DoD

  - [ ] Code complete
  - [ ] Tests passing (unit + widget)
  - [ ] Code reviewed by 2+ devs
  - [ ] Documentation updated
  - [ ] No new warnings introduced
  ```

  **DoD:** Template created, 30 issues created trong GitHub Projects

- [ ] **T004: Setup Development Environment Standards**
  ```bash
  # Create scripts/dev-setup.sh
  #!/bin/bash
  flutter doctor -v
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  flutter analyze
  flutter test
  ```
  **DoD:** All devs có consistent setup, documented trong README

### WP-SETUP-002: Establish Baseline Metrics

**Owner:** Tech Lead  
**Duration:** 0.5 day

#### Tasks

- [ ] **T001: Run Initial Metrics Collection**

  ```bash
  # Collect baseline
  flutter analyze > baseline_analyze.txt
  flutter test --coverage
  grep -r "TODO" lib/ > baseline_todos.txt
  grep -r "print(" lib/ > baseline_prints.txt
  ```

  **DoD:** Baseline documented trong `docs/metrics-baseline.md`

- [ ] **T002: Create Weekly Progress Dashboard**

  ```markdown
  # Weekly Metrics Dashboard

  | Week | Analyze Issues | Test Coverage | TODOs | Print Statements | P0/P1 Issues |
  | ---- | -------------- | ------------- | ----- | ---------------- | ------------ |
  | W0   | 499            | 60%           | 70    | 19 files         | 30/30        |
  | W1   | Target: <100   | Target: 65%   | <50   | 0 files          | 15/30        |
  ```

  **DoD:** Dashboard template created, automated script to update

---

# 🔥 Phase 1: Critical Stability Fixes (Days 3-7)

**Objective:** Eliminate blockers, fix critical errors, establish stable baseline

## WP-P1-001: Flutter Analyze Error Resolution

**Owner:** Senior Flutter Developer  
**Duration:** 2 days  
**Priority:** 🔴 Critical  
**Audit IDs:** #1, #12, #13, #14

### Implementation Strategy

#### Stage 1: Automated Fixes (0.5 day)

- [ ] **T001: Run dart fix**

  ```bash
  cd mobile
  dart fix --apply --dry-run > fix_preview.txt
  # Review preview
  dart fix --apply
  ```

  **Expected:** ~100-150 issues auto-fixed  
  **DoD:** All auto-fixable issues resolved, no regressions

- [ ] **T002: Add Missing Dependencies**
  ```yaml
  # pubspec.yaml additions
  dependencies:
    fl_chart: ^0.68.0 # For progress charts
  ```
  ```bash
  flutter pub get
  flutter pub upgrade --major-versions fl_chart
  ```
  **DoD:** All dependency errors resolved, builds successfully

#### Stage 2: Undefined Identifier Fixes (0.5 day)

- [ ] **T003: Create Missing Theme Constants**

  ```dart
  // lib/config/theme/text_styles.dart
  class AppTextStyles {
    static const TextStyle h1 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );

    static const TextStyle bodyLarge = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    );

    // ... complete set from design system
  }

  // lib/config/theme/colors.dart
  class AppColors {
    // Already exists, verify completeness
    static const Color textPrimary = Color(0xFF1A1A1A);
    static const Color textSecondary = Color(0xFF6B6B6B);
    // ...
  }
  ```

  **DoD:**

  - [ ] All TextStyles defined according to design system
  - [ ] All Colors defined with dark mode variants
  - [ ] Imported correctly trong progress screens
  - [ ] No undefined_identifier errors remain

- [ ] **T004: Fix Progress Chart Implementations**

  ```dart
  // lib/features/progress/presentation/widgets/xp_trend_chart.dart
  // Fix: Undefined method 'AxisTitles'

  import 'package:fl_chart/fl_chart.dart';

  class XpTrendChart extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          // ... rest of chart config
        ),
      );
    }
  }
  ```

  **DoD:**

  - [ ] Charts render correctly
  - [ ] Widget tests updated and passing
  - [ ] fl_chart API usage follows latest version patterns

#### Stage 3: Deprecated API Migration (0.5 day)

- [ ] **T005: Update LinearGradient Usage**

  ```dart
  // Find all instances of .withValues()
  // Old (deprecated):
  LinearGradient(
    colors: [Colors.blue, Colors.red],
  ).withValues(...)

  // New (Flutter 3.x):
  LinearGradient(
    colors: [Colors.blue, Colors.red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  ```

  **DoD:**

  - [ ] All deprecated LinearGradient calls updated
  - [ ] Visual regression testing passed
  - [ ] No precision loss warnings

- [ ] **T006: Fix use_build_context_synchronously Warnings**

  ```dart
  // Pattern to fix:
  // Bad:
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.push(context, ...); // ❌ BuildContext after async gap
  }

  // Good:
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return; // ✅ Check mounted state
    Navigator.push(context, ...);
  }
  ```

  **DoD:**

  - [ ] All async BuildContext usages protected với mounted checks
  - [ ] Widget lifecycle properly handled
  - [ ] No use_build_context_synchronously warnings remain

#### Stage 4: Cleanup & Validation (0.5 day)

- [ ] **T007: Remove Unused Imports**

  ```bash
  # Manual review of unused_import warnings
  # Remove systematically per file
  ```

  **DoD:**

  - [ ] Zero unused_import warnings
  - [ ] Code still compiles and tests pass

- [ ] **T008: Final Validation**

  ```bash
  flutter clean
  flutter pub get
  flutter analyze --no-pub
  flutter test
  ```

  **Expected Result:**

  - ✅ **0 errors**
  - ⚠️ **<50 warnings** (acceptable warnings only)
  - ✅ **All tests passing**

  **DoD:**

  - [ ] CI pipeline green
  - [ ] Metrics updated trong dashboard
  - [ ] Documentation của remaining warnings (nếu có)

### Testing Requirements

- [ ] **Automated Tests:**

  - Run full test suite: `flutter test`
  - Expected: 147/147 tests passing (maintain 100%)

- [ ] **Manual Testing:**

  - [ ] Progress screens render correctly
  - [ ] Charts display data accurately
  - [ ] Gradients look visually correct
  - [ ] No navigation crashes after async operations

- [ ] **Regression Testing:**
  - [ ] Compare screenshots before/after (golden tests)
  - [ ] Verify all features still work as expected

### Definition of Done

- [ ] ✅ Flutter analyze shows 0 errors
- [ ] ✅ Warnings reduced from 499 to <50
- [ ] ✅ All tests passing (147/147)
- [ ] ✅ Code reviewed by 2+ developers
- [ ] ✅ Documentation updated (theme constants, chart usage)
- [ ] ✅ CI pipeline configured and green
- [ ] ✅ Metrics dashboard updated

---

## WP-P1-002: Logging Infrastructure

**Owner:** Backend/Mobile Integration Engineer  
**Duration:** 1 day  
**Priority:** 🔴 Critical  
**Audit IDs:** #3, #10, #21

### Implementation Strategy

#### Step 1: Create Logging Service (0.3 day)

- [ ] **T001: Design Logging Architecture**

  ```dart
  // lib/core/utils/logger_service.dart
  import 'dart:developer' as developer;
  import 'package:flutter/foundation.dart';

  enum LogLevel {
    debug,
    info,
    warning,
    error,
    fatal,
  }

  class LoggerService {
    static const String _defaultTag = 'SpeakPal';

    // Singleton
    static final LoggerService _instance = LoggerService._internal();
    factory LoggerService() => _instance;
    LoggerService._internal();

    // Optional: Sentry/Crashlytics integration
    Function(String message, Object error, StackTrace stackTrace)? _errorReporter;

    void setErrorReporter(Function(String, Object, StackTrace) reporter) {
      _errorReporter = reporter;
    }

    void debug(String message, {String? tag, Object? data}) {
      if (kDebugMode) {
        _log(LogLevel.debug, message, tag: tag, data: data);
      }
    }

    void info(String message, {String? tag, Object? data}) {
      _log(LogLevel.info, message, tag: tag, data: data);
    }

    void warning(String message, {String? tag, Object? error, Object? data}) {
      _log(LogLevel.warning, message, tag: tag, error: error, data: data);
    }

    void error(
      String message, {
      String? tag,
      Object? error,
      StackTrace? stackTrace,
      Object? data,
    }) {
      _log(
        LogLevel.error,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
        data: data,
      );

      // Report to crash analytics
      if (error != null && stackTrace != null && _errorReporter != null) {
        _errorReporter!(message, error, stackTrace);
      }
    }

    void fatal(
      String message, {
      String? tag,
      required Object error,
      required StackTrace stackTrace,
      Object? data,
    }) {
      _log(
        LogLevel.fatal,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
        data: data,
      );

      // Always report fatal errors
      _errorReporter?.call(message, error, stackTrace);
    }

    void _log(
      LogLevel level,
      String message, {
      String? tag,
      Object? error,
      StackTrace? stackTrace,
      Object? data,
    }) {
      final effectiveTag = tag ?? _defaultTag;
      final emoji = _getEmoji(level);
      final logLevel = _getLogLevel(level);

      final buffer = StringBuffer();
      buffer.write('[$emoji ${level.name.toUpperCase()}] $message');

      if (data != null) {
        buffer.write('\n📦 Data: $data');
      }

      developer.log(
        buffer.toString(),
        name: effectiveTag,
        level: logLevel,
        error: error,
        stackTrace: stackTrace,
      );
    }

    String _getEmoji(LogLevel level) {
      switch (level) {
        case LogLevel.debug:
          return '🐛';
        case LogLevel.info:
          return 'ℹ️';
        case LogLevel.warning:
          return '⚠️';
        case LogLevel.error:
          return '🔥';
        case LogLevel.fatal:
          return '💥';
      }
    }

    int _getLogLevel(LogLevel level) {
      switch (level) {
        case LogLevel.debug:
          return 500;
        case LogLevel.info:
          return 800;
        case LogLevel.warning:
          return 900;
        case LogLevel.error:
          return 1000;
        case LogLevel.fatal:
          return 1200;
      }
    }
  }

  // Convenience global instances
  final logger = LoggerService();
  ```

  **DoD:**

  - [ ] LoggerService implemented với all levels
  - [ ] Unit tests cho LoggerService
  - [ ] Documentation added

#### Step 2: Crash Reporting Integration (0.2 day)

- [ ] **T002: Setup Firebase Crashlytics**

  ```yaml
  # pubspec.yaml
  dependencies:
    firebase_crashlytics: ^4.3.0
  ```

  ```dart
  // lib/core/utils/crash_reporter.dart
  import 'package:firebase_crashlytics/firebase_crashlytics.dart';
  import 'package:flutter/foundation.dart';

  class CrashReporter {
    static Future<void> initialize() async {
      if (kDebugMode) {
        // Disable in debug mode
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
        return;
      }

      // Enable in release
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Pass uncaught errors to Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Pass async errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    static Future<void> recordError(
      Object error,
      StackTrace stackTrace, {
      String? reason,
      bool fatal = false,
    }) async {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    }

    static Future<void> log(String message) async {
      await FirebaseCrashlytics.instance.log(message);
    }
  }

  // Wire to LoggerService
  void setupLogging() {
    logger.setErrorReporter((message, error, stackTrace) {
      CrashReporter.recordError(error, stackTrace, reason: message);
    });
  }
  ```

  ```dart
  // lib/main.dart updates
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    await CrashReporter.initialize();
    setupLogging();

    runApp(const ProviderScope(child: MyApp()));
  }
  ```

  **DoD:**

  - [ ] Crashlytics configured
  - [ ] Tested với intentional crash trong debug
  - [ ] Verified reports appear trong Firebase console

#### Step 3: Replace Print Statements (0.3 day)

- [ ] **T003: Systematic Print Replacement**

  ```bash
  # Create migration script
  # scripts/replace-prints.sh

  #!/bin/bash
  FILES_WITH_PRINT=$(grep -rl "print(" lib/ --include="*.dart")

  for file in $FILES_WITH_PRINT; do
    echo "Processing: $file"
    # Review each file manually, categorize logs:
    # - Debug info → logger.debug()
    # - Important events → logger.info()
    # - Warnings → logger.warning()
    # - Errors → logger.error()
  done
  ```

  **Migration Pattern:**

  ```dart
  // Before:
  print('WebSocket connected');
  print('Received text result: $data');
  print('Error playing audio chunk: $e');

  // After:
  logger.info('WebSocket connected', tag: 'ConversationSocket');
  logger.debug('Received text result', tag: 'ConversationSocket', data: data);
  logger.error(
    'Error playing audio chunk',
    tag: 'AudioPlayer',
    error: e,
    stackTrace: stackTrace,
  );
  ```

  **Files to Update (19 total):**

  - [ ] `conversation/data/services/conversation_socket_service.dart`
  - [ ] `conversation/data/services/audio_player_service.dart`
  - [ ] `conversation/presentation/widgets/vocabulary_section.dart`
  - [ ] `core/network/socket_client.dart`
  - [ ] ... (complete list from grep results)

  **DoD:**

  - [ ] Zero `print(` statements trong lib/
  - [ ] All logging uses LoggerService
  - [ ] Appropriate log levels assigned
  - [ ] Tags meaningful và consistent

#### Step 4: Testing & Documentation (0.2 day)

- [ ] **T004: Create Logging Guidelines**

  ```markdown
  # docs/coding-standards/LOGGING_GUIDE.md

  ## When to Use Each Log Level

  ### Debug 🐛

  - Development-only information
  - Detailed variable states
  - Flow tracing
  - **Never logged in production**

  ### Info ℹ️

  - Important business events
  - State transitions
  - User actions
  - API responses (success)

  ### Warning ⚠️

  - Recoverable errors
  - Deprecated API usage
  - Missing optional data
  - Fallback behaviors

  ### Error 🔥

  - Caught exceptions
  - Failed operations
  - Invalid states
  - **Reported to Crashlytics**

  ### Fatal 💥

  - Unrecoverable errors
  - Critical system failures
  - Data corruption
  - **Always reported to Crashlytics**

  ## Examples

  ...
  ```

  **DoD:**

  - [ ] Logging guide created
  - [ ] Examples provided
  - [ ] Team training completed

### Testing Requirements

- [ ] **Unit Tests:**

  ```dart
  // test/core/utils/logger_service_test.dart
  group('LoggerService', () {
    test('should format debug messages correctly', () { ... });
    test('should call error reporter for errors', () { ... });
    test('should not log debug in release mode', () { ... });
  });
  ```

- [ ] **Integration Test:**
  - [ ] Trigger intentional error trong staging
  - [ ] Verify appears trong Firebase Crashlytics
  - [ ] Verify log levels filter correctly

### Definition of Done

- [ ] ✅ LoggerService implemented and tested
- [ ] ✅ Crashlytics integrated and verified
- [ ] ✅ All 19 files với print() updated
- [ ] ✅ Zero print statements remain trong production code
- [ ] ✅ Logging guidelines documented
- [ ] ✅ Team trained on logging standards
- [ ] ✅ Code reviewed and approved

---

## WP-P1-003: Error Handling Infrastructure

**Owner:** Senior Mobile Developer  
**Duration:** 2 days  
**Priority:** 🟡 High  
**Audit IDs:** #10, #21, #38

### Implementation Strategy

#### Step 1: Define Error Taxonomy (0.5 day)

- [ ] **T001: Create Error Type Hierarchy**

  ```dart
  // lib/core/errors/app_error.dart

  /// Base sealed class for all application errors
  sealed class AppError implements Exception {
    final String message;
    final String? userMessage;
    final Object? originalError;
    final StackTrace? stackTrace;

    const AppError(
      this.message, {
      this.userMessage,
      this.originalError,
      this.stackTrace,
    });

    /// User-facing error message (localized)
    String getUserMessage() => userMessage ?? message;

    @override
    String toString() => 'AppError: $message';
  }

  /// Network-related errors
  final class NetworkError extends AppError {
    final int? statusCode;
    final String? endpoint;

    const NetworkError(
      super.message, {
      super.userMessage,
      super.originalError,
      super.stackTrace,
      this.statusCode,
      this.endpoint,
    });

    factory NetworkError.noConnection() => const NetworkError(
      'No internet connection',
      userMessage: 'Please check your internet connection and try again',
    );

    factory NetworkError.timeout() => const NetworkError(
      'Request timeout',
      userMessage: 'The request took too long. Please try again',
    );

    factory NetworkError.serverError(int statusCode) => NetworkError(
      'Server error: $statusCode',
      userMessage: 'Something went wrong. Please try again later',
      statusCode: statusCode,
    );
  }

  /// Authentication/Authorization errors
  final class AuthError extends AppError {
    const AuthError(
      super.message, {
      super.userMessage,
      super.originalError,
      super.stackTrace,
    });

    factory AuthError.invalidCredentials() => const AuthError(
      'Invalid credentials',
      userMessage: 'Email or password is incorrect',
    );

    factory AuthError.sessionExpired() => const AuthError(
      'Session expired',
      userMessage: 'Your session has expired. Please login again',
    );

    factory AuthError.unauthorized() => const AuthError(
      'Unauthorized access',
      userMessage: 'You do not have permission to access this resource',
    );
  }

  /// Validation errors
  final class ValidationError extends AppError {
    final Map<String, String>? fieldErrors;

    const ValidationError(
      super.message, {
      super.userMessage,
      this.fieldErrors,
      super.originalError,
      super.stackTrace,
    });
  }

  /// Storage/Persistence errors
  final class StorageError extends AppError {
    const StorageError(
      super.message, {
      super.userMessage,
      super.originalError,
      super.stackTrace,
    });
  }

  /// Audio/Media errors
  final class MediaError extends AppError {
    const MediaError(
      super.message, {
      super.userMessage,
      super.originalError,
      super.stackTrace,
    });

    factory MediaError.permissionDenied() => const MediaError(
      'Microphone permission denied',
      userMessage: 'Please allow microphone access in settings',
    );
  }

  /// Unknown/Unexpected errors
  final class UnknownError extends AppError {
    const UnknownError(
      super.message, {
      super.userMessage,
      super.originalError,
      super.stackTrace,
    });
  }
  ```

  **DoD:**

  - [ ] All error types defined
  - [ ] Factory methods for common errors
  - [ ] User-friendly messages provided

#### Step 2: Create Error Handler Service (0.5 day)

- [ ] **T002: Implement Centralized Error Handler**

  ```dart
  // lib/core/errors/error_handler.dart

  import 'package:flutter/material.dart';
  import 'app_error.dart';
  import '../utils/logger_service.dart';
  import '../utils/crash_reporter.dart';

  class ErrorHandler {
    static final ErrorHandler _instance = ErrorHandler._internal();
    factory ErrorHandler() => _instance;
    ErrorHandler._internal();

    /// Handle error - log, report, show UI
    Future<void> handleError(
      AppError error, {
      BuildContext? context,
      bool showDialog = true,
      VoidCallback? onRetry,
    }) async {
      // Log error
      logger.error(
        error.message,
        error: error.originalError ?? error,
        stackTrace: error.stackTrace,
      );

      // Report to Crashlytics if serious
      if (error is! ValidationError && error.originalError != null) {
        await CrashReporter.recordError(
          error.originalError!,
          error.stackTrace ?? StackTrace.current,
          reason: error.message,
        );
      }

      // Show UI if context available
      if (context != null && showDialog && context.mounted) {
        await _showErrorDialog(context, error, onRetry: onRetry);
      }
    }

    Future<void> _showErrorDialog(
      BuildContext context,
      AppError error, {
      VoidCallback? onRetry,
    }) async {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_getErrorTitle(error)),
          content: Text(error.getUserMessage()),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRetry();
                },
                child: const Text('Retry'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    String _getErrorTitle(AppError error) {
      return switch (error) {
        NetworkError() => 'Connection Error',
        AuthError() => 'Authentication Error',
        ValidationError() => 'Validation Error',
        MediaError() => 'Media Error',
        _ => 'Error',
      };
    }

    /// Convert DioException to AppError
    AppError fromDioException(DioException e) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          NetworkError.timeout(),
        DioExceptionType.connectionError => NetworkError.noConnection(),
        DioExceptionType.badResponse => NetworkError.serverError(
            e.response?.statusCode ?? 500),
        _ => UnknownError(
            'Network error: ${e.message}',
            originalError: e,
            stackTrace: e.stackTrace,
          ),
      };
    }
  }

  final errorHandler = ErrorHandler();
  ```

  **DoD:**

  - [ ] Centralized error handling
  - [ ] User-friendly dialogs
  - [ ] Logging + crash reporting integrated
  - [ ] DioException conversion

#### Step 3: Update Network Layer (0.5 day)

- [ ] **T003: Enhance API Client Error Handling**

  ```dart
  // lib/core/network/api_client.dart updates

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e, stackTrace) {
      final appError = errorHandler.fromDioException(e);
      logger.error(
        'API GET failed: $path',
        error: appError,
        stackTrace: stackTrace,
      );
      throw appError;
    } catch (e, stackTrace) {
      final appError = UnknownError(
        'Unexpected error during API call',
        originalError: e,
        stackTrace: stackTrace,
      );
      logger.error('Unexpected API error', error: appError, stackTrace: stackTrace);
      throw appError;
    }
  }

  // Similar updates for post, put, patch, delete
  ```

  **DoD:**

  - [ ] All API methods catch and convert errors
  - [ ] Proper logging on all error paths
  - [ ] AppError types thrown instead of raw exceptions

#### Step 4: Update Repositories (0.3 day)

- [ ] **T004: Repository Error Handling Pattern**

  ```dart
  // Example: lib/features/auth/data/auth_repository.dart

  @override
  Future<Either<AppError, User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final user = User.fromJson(response.data!);
      return Right(user);

    } on NetworkError catch (e) {
      if (e.statusCode == 401) {
        return Left(AuthError.invalidCredentials());
      }
      return Left(e);

    } on AppError catch (e) {
      return Left(e);

    } catch (e, stackTrace) {
      final error = UnknownError(
        'Login failed',
        originalError: e,
        stackTrace: stackTrace,
      );
      logger.error('Login error', error: error, stackTrace: stackTrace);
      return Left(error);
    }
  }
  ```

  **DoD:**

  - [ ] All repositories return Either<AppError, T>
  - [ ] Specific error types for specific failures
  - [ ] Comprehensive error handling

#### Step 5: Update Providers (0.2 day)

- [ ] **T005: Provider Error Handling Pattern**

  ```dart
  // Example: lib/features/auth/presentation/providers/auth_provider.dart

  final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
    return AuthNotifier(ref.read(authRepositoryProvider));
  });

  class AuthNotifier extends StateNotifier<AuthState> {
    final AuthRepository _repository;

    AuthNotifier(this._repository) : super(const AuthState.initial());

    Future<void> login(String email, String password, BuildContext context) async {
      state = const AuthState.loading();

      final result = await _repository.login(email, password);

      result.fold(
        (error) {
          state = AuthState.error(error);
          // Show error to user
          errorHandler.handleError(error, context: context);
        },
        (user) {
          state = AuthState.authenticated(user);
        },
      );
    }
  }
  ```

  **DoD:**

  - [ ] Providers use errorHandler for user feedback
  - [ ] State includes error information
  - [ ] Context passed for dialog display

### Testing Requirements

- [ ] **Unit Tests:**

  ```dart
  group('ErrorHandler', () {
    test('converts DioException to NetworkError', () { ... });
    test('converts timeout to NetworkError.timeout', () { ... });
    test('converts 401 to AuthError.invalidCredentials', () { ... });
  });

  group('Repository Error Handling', () {
    test('returns Left(AuthError) on 401', () { ... });
    test('returns Left(NetworkError) on timeout', () { ... });
  });
  ```

- [ ] **Widget Tests:**
  ```dart
  testWidgets('shows error dialog on login failure', (tester) async {
    // Mock error response
    // Trigger login
    // Verify dialog shown with correct message
  });
  ```

### Definition of Done

- [ ] ✅ Error type hierarchy defined
- [ ] ✅ ErrorHandler service implemented
- [ ] ✅ API client updated với proper error handling
- [ ] ✅ Repositories return Either<AppError, T>
- [ ] ✅ Providers integrate errorHandler
- [ ] ✅ Unit tests for error handling (80%+ coverage)
- [ ] ✅ Widget tests verify error dialogs
- [ ] ✅ Code reviewed and approved

---

## Phase 1 Completion Checklist

### Pre-Deployment Validation

- [ ] **Code Quality:**

  - [ ] Flutter analyze: 0 errors, <50 warnings
  - [ ] All tests passing: 147+ tests
  - [ ] Code coverage: >65%
  - [ ] No new TODOs introduced

- [ ] **Functionality:**

  - [ ] All critical screens load without errors
  - [ ] Charts and progress visualizations work
  - [ ] Error dialogs display correctly
  - [ ] Logging verified trong console

- [ ] **Integration:**
  - [ ] CI pipeline green
  - [ ] Crashlytics receiving test reports
  - [ ] Logs structured and filterable

### Metrics Checkpoint

| Metric           | Before  | After | Target |
| ---------------- | ------- | ----- | ------ |
| Analyze Issues   | 499     | <100  | <50    |
| Print Statements | 19      | 0     | 0      |
| Test Coverage    | 60%     | 65%+  | 65%+   |
| Error Types      | Generic | Typed | Typed  |

### Exit Criteria

- [ ] ✅ All WP-P1-xxx work packages complete
- [ ] ✅ No P0/P1 blockers remaining
- [ ] ✅ Code reviews approved by 2+ developers
- [ ] ✅ Stakeholder demo completed
- [ ] ✅ Documentation updated
- [ ] ✅ Ready to proceed to Phase 2

---

# ⚠️ Risk Management

## Identified Risks

| Risk ID | Risk Description                          | Probability | Impact | Mitigation                                                    |
| ------- | ----------------------------------------- | ----------- | ------ | ------------------------------------------------------------- |
| R1      | Dart fix breaks existing functionality    | Medium      | High   | Extensive testing after each fix; maintain detailed changelog |
| R2      | Team unfamiliar với Either pattern        | Low         | Medium | Training session before implementation; code review           |
| R3      | Crashlytics quota exceeded during testing | Low         | Low    | Use test mode initially; monitor quota                        |
| R4      | Migration introduces new bugs             | Medium      | High   | Incremental rollout; A/B testing; rollback plan               |

## Rollback Plan

If critical issues discovered:

1. Revert to previous Git commit
2. Identify root cause
3. Fix in isolated branch
4. Re-test before merge
5. Document lessons learned

---

**End of Phase 1 Plan**

_Next: Phase 2 - Core Feature Completion (separate document)_
