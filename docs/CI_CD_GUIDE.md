# 🚀 CI/CD Pipeline Documentation

**Project:** SpeakPal Mobile  
**Last Updated:** 2026-01-11

---

## 📋 Overview

The SpeakPal mobile app uses GitHub Actions for continuous integration and deployment. This document describes the CI/CD pipeline, how to use it, and how to maintain it.

---

## 🔄 Current CI/CD Workflows

### 1. Flutter CI (`flutter-ci.yml`)

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests to `main`
- Changes in `mobile/**` directory

**Jobs:**

#### Job 1: Test & Analyze

```yaml
- Checkout code
- Setup Flutter (3.x stable)
- Get dependencies
- Verify code formatting
- Run static analysis
- Run tests with coverage
- Upload coverage to Codecov
```

**Quality Gates:**

- ✅ Code must be formatted correctly
- ✅ Zero analyze errors
- ✅ All tests must pass
- ✅ Coverage report generated

#### Job 2: Build Android APK

```yaml
- Checkout code
- Setup Java 17
- Setup Flutter
- Build debug APK
- Upload APK artifact (7 days retention)
```

**Outputs:**

- `app-debug.apk` artifact

#### Job 3: Build iOS (macOS)

```yaml
- Only runs on push to main
- Checkout code
- Setup Flutter
- Build iOS (no codesign)
```

**Conditions:**

- Only on `main` branch pushes
- Runs on macOS runner

---

### 2. Backend CI (`backend-ci.yml`)

**Triggers:**

- Push to `main` or `develop`
- Pull requests to `main`
- Changes in `backend/**`

**Jobs:**

- Lint & Test
- Build Docker image
- E2E tests

---

### 3. Flutter Analyze (`flutter-analyze.yml`)

**Purpose:** Quick static analysis check

**Triggers:**

- Push to any branch
- Pull requests

**Jobs:**

- Run `flutter analyze`
- Fail if errors found

---

## 📊 Pipeline Status

### Current Status: ✅ Operational

**Metrics:**

- Average build time: ~5-8 minutes
- Success rate: 95%+
- Coverage: 71%
- Test count: 329 tests

---

## 🔧 Local Development Workflow

### Before Committing

```bash
# 1. Format code
cd mobile
dart format .

# 2. Run analyze
flutter analyze

# 3. Run tests
flutter test

# 4. Check coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Pre-Push Checklist

- [ ] Code formatted
- [ ] No analyze errors
- [ ] All tests passing
- [ ] Coverage maintained or improved
- [ ] No new TODOs for critical paths

---

## 🚀 Deployment Workflows

### Development Deployment

```bash
# Build debug APK
flutter build apk --debug

# Or use CI artifact
# Download from GitHub Actions → Artifacts
```

### Staging Deployment

```bash
# Build release APK for staging
flutter build apk --release \
  --dart-define=API_BASE_URL=https://staging-api.speakpal.com \
  --dart-define=ENVIRONMENT=staging
```

### Production Deployment

```bash
# Build production APK with obfuscation
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/debug-info/android \
  --dart-define=API_BASE_URL=https://api.speakpal.com \
  --dart-define=ENVIRONMENT=production

# Build production iOS
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/debug-info/ios \
  --dart-define=API_BASE_URL=https://api.speakpal.com \
  --dart-define=ENVIRONMENT=production
```

---

## 🔐 Secrets Management

### GitHub Secrets

**Required Secrets:**

```
CODECOV_TOKEN          # For coverage upload
FIREBASE_API_KEY       # Firebase configuration
GOOGLE_SERVICES_JSON   # Android Firebase config
GOOGLE_SERVICES_PLIST  # iOS Firebase config
```

**How to Add Secrets:**

1. Go to Repository Settings
2. Secrets and variables → Actions
3. New repository secret
4. Add name and value
5. Save

**Usage in Workflow:**

```yaml
- name: Upload coverage
  env:
    CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
  run: bash <(curl -s https://codecov.io/bash)
```

---

## 📈 Monitoring & Alerts

### Build Status

**Check Build Status:**

- GitHub Actions tab
- README badge
- Email notifications

**Build Failures:**

- Automatic email to committer
- Slack notification (if configured)
- GitHub status check on PR

### Coverage Tracking

**Codecov Integration:**

- Coverage reports on every PR
- Trend analysis
- Coverage diff
- Fail if coverage drops >1%

**Access:**

- https://codecov.io/gh/YOUR_ORG/SpeakPal

---

## 🛠️ Maintenance

### Updating Flutter Version

```yaml
# .github/workflows/flutter-ci.yml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: "3.x" # Update this
    channel: "stable"
```

**Steps:**

1. Update `flutter-version` in workflow
2. Test locally with new version
3. Update `pubspec.yaml` SDK constraints
4. Commit and push
5. Monitor CI build

### Updating Dependencies

```yaml
# Regular dependency updates
- uses: actions/checkout@v4 # Keep updated
- uses: subosito/flutter-action@v2
- uses: codecov/codecov-action@v4
```

**Schedule:**

- Monthly dependency review
- Security updates: Immediate
- Major version updates: Test thoroughly

### Adding New Jobs

**Example: Add Widget Tests Job**

```yaml
widget-tests:
  name: Widget Tests
  runs-on: ubuntu-latest
  needs: test

  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
    - run: flutter pub get
      working-directory: mobile
    - run: flutter test test/widgets
      working-directory: mobile
```

---

## 🎯 Best Practices

### 1. Fast Feedback

- Run quick checks first (format, analyze)
- Parallel jobs when possible
- Cache dependencies

### 2. Fail Fast

- Stop on first error
- Clear error messages
- Link to relevant docs

### 3. Artifact Management

- Keep artifacts for 7 days
- Name artifacts clearly
- Include version in artifact name

### 4. Security

- Never commit secrets
- Use GitHub Secrets
- Rotate secrets regularly
- Audit secret access

### 5. Testing

- Run all tests in CI
- Maintain >70% coverage
- Test on multiple platforms
- Include integration tests

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Build Fails on CI but Works Locally

**Possible Causes:**

- Different Flutter version
- Missing environment variables
- Platform-specific issues

**Solution:**

```bash
# Match CI Flutter version
flutter version 3.x.x

# Check for environment-specific code
grep -r "Platform.is" lib/

# Verify all dependencies
flutter pub get
flutter clean
flutter pub get
```

#### 2. Tests Pass Locally but Fail in CI

**Possible Causes:**

- Timezone differences
- File path issues
- Async timing issues

**Solution:**

```dart
// Use fake timers
testWidgets('my test', (tester) async {
  await tester.pumpAndSettle();
  // Not just pump()
});

// Use absolute paths
final testFile = File('${Directory.current.path}/test/fixtures/data.json');
```

#### 3. Coverage Upload Fails

**Solution:**

```yaml
- name: Upload coverage
  uses: codecov/codecov-action@v4
  with:
    fail_ci_if_error: false # Don't fail CI if upload fails
    token: ${{ secrets.CODECOV_TOKEN }}
```

---

## 📚 Resources

### Documentation

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Codecov Documentation](https://docs.codecov.com/)

### Tools

- [act](https://github.com/nektos/act) - Run GitHub Actions locally
- [flutter_ci_script](https://pub.dev/packages/flutter_ci_script) - CI helper scripts

---

## 🔄 Workflow Diagram

```
┌─────────────┐
│   Push/PR   │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Format Check   │
└────────┬────────┘
         │ ✅
         ▼
┌─────────────────┐
│ Flutter Analyze │
└────────┬────────┘
         │ ✅
         ▼
┌─────────────────┐
│   Run Tests     │
│  + Coverage     │
└────────┬────────┘
         │ ✅
         ├──────────────┐
         │              │
         ▼              ▼
┌─────────────┐  ┌─────────────┐
│Build Android│  │  Build iOS  │
│     APK     │  │ (main only) │
└─────────────┘  └─────────────┘
```

---

## 📞 Support

**CI/CD Issues:** devops@speakpal.com  
**Build Failures:** Check GitHub Actions logs  
**Coverage Questions:** Check Codecov dashboard

---

**Maintained by:** DevOps Team  
**Last Updated:** 2026-01-11  
**Next Review:** 2026-02-11
