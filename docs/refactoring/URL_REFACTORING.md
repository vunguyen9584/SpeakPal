# URL Refactoring Summary

## Overview

Refactored hardcoded HTTP URLs throughout the codebase to use centralized configuration management. This improves maintainability and flexibility across different environments.

## Changes Made

### Backend (NestJS)

#### 1. Created Centralized Config

**File**: `backend/src/config/external-services.config.ts`

- Centralized all external service URLs
- Supports environment variables with fallback defaults
- Includes:
  - OpenAI API URL
  - Apple App Store URLs (production & sandbox)
  - Google Play Store auth scope
  - Application base URL & CORS origins

#### 2. Updated Services

**Files Modified**:

- `src/integrations/appstore/appstore.client.ts`

  - Replaced hardcoded Apple URLs with config
  - Uses `externalServices.appStore.productionUrl` and `sandboxUrl`

- `src/integrations/playstore/playstore.client.ts`

  - Replaced hardcoded Google auth scope with config
  - Uses `externalServices.playStore.authScope`

- `src/modules/feedback/feedback.service.ts`

  - Replaced hardcoded OpenAI URL with config
  - Uses `externalServices.openai.baseUrl`

- `src/modules/feedback/vocabulary-extractor.service.ts`

  - Replaced hardcoded OpenAI URL with config
  - Uses `externalServices.openai.baseUrl`

- `src/modules/social/invitation/invitation.service.ts`

  - Replaced hardcoded app URL with config
  - Uses `externalServices.app.baseUrl`
  - Added ConfigService injection

- `src/modules/conversation/conversation.gateway.ts`
  - Replaced hardcoded CORS origins with config
  - Uses `externalServices.app.corsOrigins`

#### 3. Registered Config

**File**: `src/config/config.module.ts`

- Added `externalServicesConfig` to the config load array

### Mobile (Flutter/Dart)

#### 1. Created Centralized API Config

**File**: `mobile/lib/core/config/api_config.dart`

- New `ApiConfig` class with all API endpoints
- Automatic environment-based URL selection
- Includes WebSocket URL generation
- Provider-based for easy dependency injection

#### 2. Updated Core Providers

**File**: `mobile/lib/core/providers/providers.dart`

- Removed hardcoded `baseUrl` in Dio configuration
- Now uses `apiConfigProvider` for dynamic URL
- Automatically adapts to dev/staging/prod environments

#### 3. Updated Repositories

**File**: `mobile/lib/features/translation/data/translation_repository.dart`

- Removed inline Dio creation with hardcoded URL
- Now uses shared `dioProvider` from core providers
- Cleaner and more maintainable

#### 4. Cleaned Up API Endpoints

**File**: `mobile/lib/core/network/api_endpoints.dart`

- Removed hardcoded `baseUrl` constant
- Now only contains endpoint paths
- Base URL managed by `ApiConfig`

#### 5. Updated Mock Data

**File**: `mobile/lib/features/translation/screens/shadowing_library_screen.dart`

- Replaced example.com URLs with empty strings and TODO comments
- Mock data will be replaced by real API responses

## Environment Variables

### Backend (.env)

```env
# External Services
OPENAI_API_URL=https://api.openai.com/v1/chat/completions
OPENAI_API_KEY=your_key_here

# App Store
APPSTORE_PRODUCTION_URL=https://buy.itunes.apple.com/verifyReceipt
APPSTORE_SANDBOX_URL=https://sandbox.itunes.apple.com/verifyReceipt
APPSTORE_SHARED_SECRET=your_secret
APPSTORE_BUNDLE_ID=com.speakpal.app
APPSTORE_USE_SANDBOX=true

# Play Store
PLAYSTORE_AUTH_SCOPE=https://www.googleapis.com/auth/androidpublisher
PLAYSTORE_PACKAGE_NAME=com.speakpal.app
PLAYSTORE_SERVICE_ACCOUNT_EMAIL=your_email
PLAYSTORE_SERVICE_ACCOUNT_KEY=your_key_json

# Application
APP_URL=https://speakpal.app
CORS_ORIGINS=http://localhost:3000,https://app.speakpal.com
```

### Mobile (Flutter)

URLs are managed through `AppConfig` class which reads from:

- Development: `http://localhost:3000`
- Staging: `https://staging-api.speakpal.com`
- Production: `https://api.speakpal.com`

Can be overridden with `--dart-define=API_BASE_URL=...`

## Verification

### Backend

✅ **Lint**: Passed with 0 errors (104 warnings - pre-existing)
✅ **Build**: Successful compilation
✅ **Files Changed**: 8 files

### Mobile

✅ **Analyze**: No issues found in refactored files
✅ **Files Changed**: 5 files

## Benefits

1. **Maintainability**: Single source of truth for all URLs
2. **Flexibility**: Easy to change URLs per environment
3. **Security**: Sensitive URLs can be managed via environment variables
4. **Testability**: Easy to mock different service URLs in tests
5. **Documentation**: Clear configuration structure

## Migration Guide

### For Backend Developers

- Use `ConfigService` to get URLs: `this.configService.get<string>('externalServices.openai.baseUrl')`
- Never hardcode URLs in service files
- Add new external services to `external-services.config.ts`

### For Mobile Developers

- Use `apiConfigProvider` to get API config
- Use `dioProvider` for HTTP requests (already configured)
- Never create inline Dio instances with hardcoded URLs
- Add new endpoints to `ApiConfig` class

## Future Improvements

1. Add URL validation in config
2. Create type-safe config interfaces
3. Add health check endpoints for external services
4. Implement circuit breaker pattern for external API calls
5. Add monitoring for external service availability
