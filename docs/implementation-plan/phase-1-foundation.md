# Phase 1: Foundation

## Overview

| Item          | Value                      |
| ------------- | -------------------------- |
| Phase         | 1                          |
| Description   | Foundation - Project Setup |
| Work Packages | 6                          |
| Total Tasks   | 35                         |
| Est. Days     | 11                         |
| Dependencies  | Phase 0 (Infrastructure)   |

---

## WP-BE-001: Backend Project Init

### Overview

- **ID**: WP-BE-001
- **Description**: NestJS project, folder structure, config
- **Dependencies**: WP-INF-001
- **Estimated Days**: 1
- **Total Tasks**: 6
- **DD References**: `03-system-overview.md`, `05-module-design.md`

### Tasks

#### Task 1: Initialize NestJS Project

- **ID**: WP-BE-001-T001
- **Type**: setup
- **Description**: Khởi tạo NestJS project với TypeScript
- **Commands**:
  ```bash
  npx @nestjs/cli new backend --package-manager npm --strict
  cd backend
  npm install
  ```
- **Files Created**:
  - `backend/` - Root folder
  - `backend/src/main.ts` - Entry point
  - `backend/src/app.module.ts` - Root module
  - `backend/package.json` - Dependencies
  - `backend/tsconfig.json` - TypeScript config
- **Estimated Hours**: 1

#### Task 2: Configure Project Structure

- **ID**: WP-BE-001-T002
- **Type**: setup
- **Description**: Thiết lập folder structure theo DD
- **Files to Create**:
  - `backend/src/common/` - Common utilities, decorators, filters
  - `backend/src/config/` - Configuration module
  - `backend/src/modules/` - Business modules
  - `backend/src/integrations/` - External services (AI, Payment)
  - `backend/src/prisma/` - Prisma module
- **Folder Structure**:
  ```
  backend/src/
  ├── common/
  │   ├── decorators/
  │   ├── dto/
  │   ├── exceptions/
  │   ├── filters/
  │   ├── guards/
  │   ├── interceptors/
  │   └── utils/
  ├── config/
  ├── integrations/
  │   ├── deepgram/
  │   ├── openai/
  │   ├── elevenlabs/
  │   └── firebase/
  ├── modules/
  │   ├── auth/
  │   ├── user/
  │   ├── persona/
  │   ├── conversation/
  │   └── ...
  └── prisma/
  ```
- **DD Reference**: `05-module-design.md#package-structure`
- **Estimated Hours**: 1

#### Task 3: Setup Environment Config

- **ID**: WP-BE-001-T003
- **Type**: setup
- **Description**: Cấu hình @nestjs/config và environment variables
- **Commands**:
  ```bash
  npm install @nestjs/config class-validator class-transformer
  ```
- **Files to Create**:
  - `backend/.env.example` - Environment template
  - `backend/.env` - Local environment (gitignored)
  - `backend/src/config/configuration.ts` - Config loader
  - `backend/src/config/validation.ts` - Env validation schema
  - `backend/src/config/config.module.ts` - Config module
- **Environment Variables**:

  ```env
  # App
  NODE_ENV=development
  PORT=3000

  # Database
  DATABASE_URL=postgresql://speakpal_app:password@localhost:5432/speakpal_dev

  # Redis
  REDIS_URL=redis://localhost:6379

  # JWT
  JWT_SECRET=your-secret-key
  JWT_EXPIRES_IN=1h

  # Firebase
  FIREBASE_PROJECT_ID=
  FIREBASE_PRIVATE_KEY=
  FIREBASE_CLIENT_EMAIL=

  # AI Services
  DEEPGRAM_API_KEY=
  OPENAI_API_KEY=
  ELEVENLABS_API_KEY=

  # S3
  AWS_S3_BUCKET=
  AWS_ACCESS_KEY_ID=
  AWS_SECRET_ACCESS_KEY=
  ```

- **Estimated Hours**: 1.5

#### Task 4: Setup Database Connection (Prisma)

- **ID**: WP-BE-001-T004
- **Type**: setup
- **Description**: Cấu hình Prisma ORM và kết nối PostgreSQL
- **Commands**:
  ```bash
  npm install prisma @prisma/client
  npx prisma init
  ```
- **Files to Create**:
  - `backend/prisma/schema.prisma` - Prisma schema (basic)
  - `backend/src/prisma/prisma.module.ts` - Prisma NestJS module
  - `backend/src/prisma/prisma.service.ts` - Prisma service with lifecycle hooks
- **DD Reference**: `07-database-design.md`
- **Estimated Hours**: 2

#### Task 5: Setup Redis Connection

- **ID**: WP-BE-001-T005
- **Type**: setup
- **Description**: Cấu hình Redis client với @nestjs/cache-manager
- **Commands**:
  ```bash
  npm install @nestjs/cache-manager cache-manager cache-manager-redis-store redis
  npm install -D @types/cache-manager-redis-store
  ```
- **Files to Create**:
  - `backend/src/cache/cache.module.ts` - Cache module configuration
  - `backend/src/cache/cache.service.ts` - Cache service wrapper
- **Estimated Hours**: 1.5

#### Task 6: Setup Docker for Development

- **ID**: WP-BE-001-T006
- **Type**: setup
- **Description**: Docker configuration cho backend development
- **Files to Create**:
  - `backend/Dockerfile` - Production Dockerfile
  - `backend/Dockerfile.dev` - Development Dockerfile with hot-reload
  - `backend/.dockerignore` - Docker ignore file
- **Files to Modify**:
  - `docker-compose.yml` - Add backend service
- **Docker Compose Addition**:
  ```yaml
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    volumes:
      - ./backend:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://speakpal_app:password@postgres:5432/speakpal_dev
      - REDIS_URL=redis://redis:6379
  ```
- **Estimated Hours**: 1

---

## WP-BE-002: Database Schema & Migration

### Overview

- **ID**: WP-BE-002
- **Description**: Prisma schema, initial migrations
- **Dependencies**: WP-BE-001
- **Estimated Days**: 2
- **Total Tasks**: 7
- **DD References**: `07-database-design.md`, `07-database-design/*.md`

### Tasks

#### Task 1: Create User & Auth Schema

- **ID**: WP-BE-002-T001
- **Type**: feature
- **Description**: Định nghĩa schema cho bảng users, personas, subscriptions
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Models**:
  ```prisma
  model User {
    id              String   @id @default(uuid())
    email           String   @unique
    username        String?
    passwordHash    String?
    level           Level    @default(BEGINNER)
    totalXp         Int      @default(0)
    currentLevelXp  Int      @default(0)
    league          League   @default(BRONZE)
    aiSpeed         Float    @default(1.0)
    confirmationMode Boolean @default(true)
    isVerified      Boolean  @default(false)
    lastLoginAt     DateTime?
    createdAt       DateTime @default(now())
    updatedAt       DateTime @updatedAt

    personas        Persona[]
    subscription    Subscription?
    streak          Streak?
    conversations   Conversation[]
    // ... other relations
  }
  ```
- **DD Reference**: `07-database-design/user-tables.md`
- **Estimated Hours**: 2

#### Task 2: Create Conversation Schema

- **ID**: WP-BE-002-T002
- **Type**: feature
- **Description**: Định nghĩa schema cho conversations, turns, corrections
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Models**: Conversation, ConversationTurn, Correction
- **DD Reference**: `07-database-design/conversation-tables.md`
- **Estimated Hours**: 2

#### Task 3: Create Learning Schema

- **ID**: WP-BE-002-T003
- **Type**: feature
- **Description**: Định nghĩa schema cho vocabularies, scenarios, challenges
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Models**: Vocabulary, Scenario, Challenge, UserChallenge
- **DD Reference**: `07-database-design/learning-tables.md`
- **Estimated Hours**: 1.5

#### Task 4: Create Gamification Schema

- **ID**: WP-BE-002-T004
- **Type**: feature
- **Description**: Định nghĩa schema cho streaks, badges, user_badges
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Models**: Streak, Badge, UserBadge
- **DD Reference**: `07-database-design/gamification-tables.md`
- **Estimated Hours**: 1.5

#### Task 5: Create Social Schema

- **ID**: WP-BE-002-T005
- **Type**: feature
- **Description**: Định nghĩa schema cho invitations, groups
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Models**: Invitation, Group, GroupMember
- **DD Reference**: `07-database-design/social-tables.md`
- **Estimated Hours**: 1

#### Task 6: Define Enums

- **ID**: WP-BE-002-T006
- **Type**: feature
- **Description**: Định nghĩa tất cả enums cần thiết
- **Files to Modify**:
  - `backend/prisma/schema.prisma`
- **Enums**:
  ```prisma
  enum Level { BEGINNER, ELEMENTARY, INTERMEDIATE, UPPER_INTERMEDIATE, ADVANCED }
  enum League { BRONZE, SILVER, GOLD, PLATINUM, DIAMOND }
  enum ConversationMode { FREE_TALK, SCENARIO, ROLE_PLAY }
  enum Speaker { USER, AI }
  enum CorrectionType { GRAMMAR, VOCABULARY, PRONUNCIATION }
  enum Severity { LOW, MEDIUM, HIGH }
  enum SrsLevel { NEW, LEARNING, REVIEW, MASTERED }
  enum SubscriptionPlan { FREE, BASIC, PREMIUM }
  enum OAuthProvider { GOOGLE, APPLE, EMAIL }
  ```
- **Estimated Hours**: 1

#### Task 7: Run Initial Migration

- **ID**: WP-BE-002-T007
- **Type**: setup
- **Description**: Chạy migration ban đầu và generate Prisma Client
- **Commands**:
  ```bash
  cd backend
  npx prisma migrate dev --name init
  npx prisma generate
  ```
- **Acceptance Criteria**:
  - [ ] Migration file được tạo trong `prisma/migrations/`
  - [ ] Prisma Client được generate
  - [ ] Có thể kết nối DB thành công
- **Estimated Hours**: 0.5

---

## WP-BE-003: Common Module

### Overview

- **ID**: WP-BE-003
- **Description**: Base classes, utilities, exceptions
- **Dependencies**: WP-BE-001
- **Estimated Days**: 2
- **Total Tasks**: 6
- **DD References**: `05-module-design.md`, `11-error-handling.md`

### Tasks

#### Task 1: Create Base DTOs

- **ID**: WP-BE-003-T001
- **Type**: feature
- **Description**: Tạo base DTOs cho pagination, response wrapper
- **Files to Create**:
  - `backend/src/common/dto/pagination.dto.ts` - PaginationQueryDto, PaginatedResponseDto
  - `backend/src/common/dto/api-response.dto.ts` - ApiResponse wrapper
  - `backend/src/common/dto/base.dto.ts` - BaseDto with id, timestamps
- **DD Reference**: `08-api-design.md#response-format`
- **Estimated Hours**: 2

#### Task 2: Create Custom Exceptions

- **ID**: WP-BE-003-T002
- **Type**: feature
- **Description**: Tạo custom exceptions theo error codes từ DD
- **Files to Create**:
  - `backend/src/common/exceptions/app.exception.ts` - Base AppException
  - `backend/src/common/exceptions/validation.exception.ts`
  - `backend/src/common/exceptions/auth.exception.ts`
  - `backend/src/common/exceptions/business.exception.ts`
  - `backend/src/common/exceptions/error-codes.ts` - Error code constants
- **DD Reference**: `11-error-handling.md`
- **Estimated Hours**: 2

#### Task 3: Create Exception Filters

- **ID**: WP-BE-003-T003
- **Type**: feature
- **Description**: Tạo global exception filter để format errors
- **Files to Create**:
  - `backend/src/common/filters/http-exception.filter.ts`
  - `backend/src/common/filters/all-exceptions.filter.ts`
- **Estimated Hours**: 2

#### Task 4: Create Interceptors

- **ID**: WP-BE-003-T004
- **Type**: feature
- **Description**: Tạo response transform và logging interceptors
- **Files to Create**:
  - `backend/src/common/interceptors/transform.interceptor.ts` - Wrap responses
  - `backend/src/common/interceptors/logging.interceptor.ts` - Log requests
  - `backend/src/common/interceptors/timeout.interceptor.ts` - Request timeout
- **Estimated Hours**: 2

#### Task 5: Create Decorators

- **ID**: WP-BE-003-T005
- **Type**: feature
- **Description**: Tạo custom decorators cho user, roles, public routes
- **Files to Create**:
  - `backend/src/common/decorators/current-user.decorator.ts`
  - `backend/src/common/decorators/roles.decorator.ts`
  - `backend/src/common/decorators/public.decorator.ts`
  - `backend/src/common/decorators/api-paginated.decorator.ts`
- **Estimated Hours**: 1.5

#### Task 6: Create Utility Functions

- **ID**: WP-BE-003-T006
- **Type**: feature
- **Description**: Tạo utility functions cho common operations
- **Files to Create**:
  - `backend/src/common/utils/hash.util.ts` - Password hashing (bcrypt)
  - `backend/src/common/utils/date.util.ts` - Date formatting
  - `backend/src/common/utils/string.util.ts` - String utilities
  - `backend/src/common/utils/uuid.util.ts` - UUID validation
- **Estimated Hours**: 1.5

---

## WP-FE-001: Flutter Project Init

### Overview

- **ID**: WP-FE-001
- **Description**: Flutter project, folder structure
- **Dependencies**: -
- **Estimated Days**: 1
- **Total Tasks**: 5
- **DD References**: `03-system-overview.md#tech-stack`, `09-ui-specifications.md`

### Tasks

#### Task 1: Create Flutter Project

- **ID**: WP-FE-001-T001
- **Type**: setup
- **Description**: Khởi tạo Flutter project
- **Commands**:
  ```bash
  flutter create --org com.speakpal --platforms=android,ios speakpal_app
  cd speakpal_app
  flutter pub get
  ```
- **Files Created**:
  - `mobile/` - Flutter project root
  - `mobile/lib/main.dart` - Entry point
  - `mobile/pubspec.yaml` - Dependencies
- **Estimated Hours**: 1

#### Task 2: Setup Project Structure

- **ID**: WP-FE-001-T002
- **Type**: setup
- **Description**: Thiết lập folder structure theo feature-first pattern
- **Files to Create**:
  - `mobile/lib/core/` - Core utilities, constants, extensions
  - `mobile/lib/config/` - App configuration, routing, theme
  - `mobile/lib/features/` - Feature modules
  - `mobile/lib/shared/` - Shared widgets
  - `mobile/lib/l10n/` - Localization
- **Folder Structure**:
  ```
  mobile/lib/
  ├── core/
  │   ├── constants/
  │   ├── extensions/
  │   ├── network/
  │   ├── storage/
  │   └── utils/
  ├── config/
  │   ├── env/
  │   ├── router/
  │   └── theme/
  ├── features/
  │   ├── auth/
  │   ├── home/
  │   ├── conversation/
  │   └── ...
  ├── shared/
  │   └── widgets/
  └── l10n/
  ```
- **Estimated Hours**: 1

#### Task 3: Add Dependencies

- **ID**: WP-FE-001-T003
- **Type**: setup
- **Description**: Thêm các dependencies cần thiết
- **Files to Modify**:
  - `mobile/pubspec.yaml`
- **Commands**:
  ```bash
  flutter pub add flutter_riverpod go_router dio socket_io_client
  flutter pub add shared_preferences flutter_secure_storage
  flutter pub add freezed_annotation json_annotation
  flutter pub add --dev freezed build_runner json_serializable
  flutter pub add --dev flutter_lints
  ```
- **Estimated Hours**: 1

#### Task 4: Setup Riverpod

- **ID**: WP-FE-001-T004
- **Type**: setup
- **Description**: Cấu hình Riverpod state management
- **Files to Modify**:
  - `mobile/lib/main.dart` - Wrap with ProviderScope
- **Files to Create**:
  - `mobile/lib/core/providers/providers.dart` - Core providers
- **Estimated Hours**: 1

#### Task 5: Setup Go Router

- **ID**: WP-FE-001-T005
- **Type**: setup
- **Description**: Cấu hình navigation với Go Router
- **Files to Create**:
  - `mobile/lib/config/router/app_router.dart` - Router configuration
  - `mobile/lib/config/router/routes.dart` - Route constants
- **Estimated Hours**: 1

---

## WP-FE-002: Design System & Theme

### Overview

- **ID**: WP-FE-002
- **Description**: Colors, typography, base components
- **Dependencies**: WP-FE-001
- **Estimated Days**: 3
- **Total Tasks**: 6
- **DD References**: `09-ui-specifications.md#design-system`

### Tasks

#### Task 1: Create Color Theme

- **ID**: WP-FE-002-T001
- **Type**: feature
- **Description**: Định nghĩa color palette theo DD
- **Files to Create**:
  - `mobile/lib/config/theme/colors.dart`
  - `mobile/lib/config/theme/app_theme.dart`
- **Colors (from DD)**:
  ```dart
  // Light Mode
  static const primary = Color(0xFF6366F1);      // Indigo
  static const secondary = Color(0xFFEC4899);    // Pink
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF9FAFB);
  static const text = Color(0xFF111827);
  ```
- **DD Reference**: `09-ui-specifications.md#color-palette`
- **Estimated Hours**: 2

#### Task 2: Create Typography

- **ID**: WP-FE-002-T002
- **Type**: feature
- **Description**: Định nghĩa typography với Inter font
- **Files to Create**:
  - `mobile/lib/config/theme/typography.dart`
- **DD Reference**: `09-ui-specifications.md#typography`
- **Estimated Hours**: 1.5

#### Task 3: Create Spacing & Dimensions

- **ID**: WP-FE-002-T003
- **Type**: feature
- **Description**: Định nghĩa spacing system
- **Files to Create**:
  - `mobile/lib/config/theme/spacing.dart`
  - `mobile/lib/config/theme/dimensions.dart`
- **DD Reference**: `09-ui-specifications.md#spacing`
- **Estimated Hours**: 1

#### Task 4: Create Base Components

- **ID**: WP-FE-002-T004
- **Type**: feature
- **Description**: Tạo base UI components
- **Files to Create**:
  - `mobile/lib/shared/widgets/app_button.dart`
  - `mobile/lib/shared/widgets/app_text_field.dart`
  - `mobile/lib/shared/widgets/app_card.dart`
  - `mobile/lib/shared/widgets/app_loading.dart`
  - `mobile/lib/shared/widgets/app_dialog.dart`
  - `mobile/lib/shared/widgets/app_snackbar.dart`
- **Estimated Hours**: 4

#### Task 5: Create Icon Set

- **ID**: WP-FE-002-T005
- **Type**: feature
- **Description**: Setup custom icons và assets
- **Files to Create**:
  - `mobile/lib/config/theme/icons.dart`
  - `mobile/assets/icons/` - SVG icons folder
  - `mobile/assets/images/` - Image assets
- **Estimated Hours**: 2

#### Task 6: Create Dark Mode Support

- **ID**: WP-FE-002-T006
- **Type**: feature
- **Description**: Implement dark mode theme
- **Files to Modify**:
  - `mobile/lib/config/theme/app_theme.dart` - Add dark theme
- **Estimated Hours**: 2

---

## WP-FE-003: Core Services Setup

### Overview

- **ID**: WP-FE-003
- **Description**: API client, socket client, storage
- **Dependencies**: WP-FE-001
- **Estimated Days**: 2
- **Total Tasks**: 5
- **DD References**: `08-api-design.md`, `03-system-overview.md`

### Tasks

#### Task 1: Create API Client

- **ID**: WP-FE-003-T001
- **Type**: feature
- **Description**: Dio HTTP client với interceptors
- **Files to Create**:
  - `mobile/lib/core/network/api_client.dart`
  - `mobile/lib/core/network/interceptors/auth_interceptor.dart`
  - `mobile/lib/core/network/interceptors/error_interceptor.dart`
  - `mobile/lib/core/network/interceptors/logging_interceptor.dart`
  - `mobile/lib/core/network/api_endpoints.dart`
- **DD Reference**: `08-api-design.md`
- **Estimated Hours**: 3

#### Task 2: Create WebSocket Client

- **ID**: WP-FE-003-T002
- **Type**: feature
- **Description**: Socket.io client cho real-time communication
- **Files to Create**:
  - `mobile/lib/core/network/socket_client.dart`
  - `mobile/lib/core/network/socket_events.dart`
- **DD Reference**: `08-api-design.md#websocket`
- **Estimated Hours**: 3

#### Task 3: Create Storage Service

- **ID**: WP-FE-003-T003
- **Type**: feature
- **Description**: Local storage abstraction
- **Files to Create**:
  - `mobile/lib/core/storage/local_storage.dart`
  - `mobile/lib/core/storage/secure_storage.dart`
  - `mobile/lib/core/storage/storage_keys.dart`
- **Estimated Hours**: 2

#### Task 4: Create Auth Token Manager

- **ID**: WP-FE-003-T004
- **Type**: feature
- **Description**: JWT token storage và refresh logic
- **Files to Create**:
  - `mobile/lib/core/auth/token_manager.dart`
  - `mobile/lib/core/auth/auth_state.dart`
- **Estimated Hours**: 3

#### Task 5: Create Environment Config

- **ID**: WP-FE-003-T005
- **Type**: feature
- **Description**: Environment-based configuration
- **Files to Create**:
  - `mobile/lib/config/env/environment.dart`
  - `mobile/lib/config/env/app_config.dart`
- **Estimated Hours**: 1

---

## Phase Summary

| Work Package | Name                  | Tasks  | Est. Hours | Status |
| ------------ | --------------------- | ------ | ---------- | ------ |
| WP-BE-001    | Backend Project Init  | 6      | 8          | ⬜     |
| WP-BE-002    | Database Schema       | 7      | 9.5        | ⬜     |
| WP-BE-003    | Common Module         | 6      | 11         | ⬜     |
| WP-FE-001    | Flutter Project Init  | 5      | 5          | ⬜     |
| WP-FE-002    | Design System & Theme | 6      | 12.5       | ⬜     |
| WP-FE-003    | Core Services Setup   | 5      | 12         | ⬜     |
| **Total**    |                       | **35** | **58**     |        |

---

## Next Phase

→ [Phase 2: Auth & User](./phase-2-auth-user/)

---

_DD References: 03-system-overview.md, 05-module-design.md, 07-database-design.md, 08-api-design.md, 09-ui-specifications.md_
