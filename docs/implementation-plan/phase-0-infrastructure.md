# Phase 0: Infrastructure Setup

## Overview

| Item          | Value                 |
| ------------- | --------------------- |
| Phase         | 0                     |
| Description   | Infrastructure Setup  |
| Work Packages | 5                     |
| Total Tasks   | 17                    |
| Est. Days     | 3.5                   |
| Dependencies  | None (Starting Phase) |

---

## WP-INF-001: PostgreSQL Database Setup

### Overview

- **ID**: WP-INF-001
- **Description**: Setup PostgreSQL, create database
- **Dependencies**: -
- **Estimated Days**: 1
- **Total Tasks**: 4
- **DD References**: `07-database-design.md`, `13-deployment-design.md`

### Tasks

#### Task 1: Install PostgreSQL

- **ID**: WP-INF-001-T001
- **Type**: setup
- **Description**: Cài đặt PostgreSQL 15.x cho local development sử dụng Docker
- **Commands**:
  ```bash
  docker pull postgres:15
  ```
- **Acceptance Criteria**:
  - [ ] PostgreSQL 15.x image đã được pull
  - [ ] Có thể chạy container test thành công
- **Estimated Hours**: 1

#### Task 2: Create Database

- **ID**: WP-INF-001-T002
- **Type**: setup
- **Description**: Tạo database cho development và test environments
- **Commands**:
  ```sql
  CREATE DATABASE speakpal_dev;
  CREATE DATABASE speakpal_test;
  ```
- **Acceptance Criteria**:
  - [ ] Database `speakpal_dev` đã được tạo
  - [ ] Database `speakpal_test` đã được tạo
- **Estimated Hours**: 0.5

#### Task 3: Configure Access

- **ID**: WP-INF-001-T003
- **Type**: setup
- **Description**: Tạo user và cấu hình quyền truy cập database
- **Commands**:
  ```sql
  CREATE USER speakpal_app WITH PASSWORD 'dev_password';
  GRANT ALL PRIVILEGES ON DATABASE speakpal_dev TO speakpal_app;
  GRANT ALL PRIVILEGES ON DATABASE speakpal_test TO speakpal_app;
  ```
- **Estimated Hours**: 0.5

#### Task 4: Add to Docker Compose

- **ID**: WP-INF-001-T004
- **Type**: setup
- **Description**: Thêm PostgreSQL service vào docker-compose.yml
- **Files to Create**:
  - `docker-compose.yml` - Docker Compose với postgres service
- **Code Template**:
  ```yaml
  services:
    postgres:
      image: postgres:15
      environment:
        POSTGRES_USER: speakpal_app
        POSTGRES_PASSWORD: dev_password
        POSTGRES_DB: speakpal_dev
      ports:
        - "5432:5432"
      volumes:
        - postgres_data:/var/lib/postgresql/data
  ```
- **Estimated Hours**: 1

---

## WP-INF-002: Redis Cache Setup

### Overview

- **ID**: WP-INF-002
- **Description**: Setup Redis for caching/sessions
- **Dependencies**: -
- **Estimated Days**: 0.5
- **Total Tasks**: 3
- **DD References**: `03-system-overview.md#tech-stack`, `13-deployment-design.md`

### Tasks

#### Task 1: Install Redis

- **ID**: WP-INF-002-T001
- **Type**: setup
- **Description**: Cài đặt Redis 7.x sử dụng Docker
- **Commands**:
  ```bash
  docker pull redis:7-alpine
  ```
- **Estimated Hours**: 0.5

#### Task 2: Configure Redis

- **ID**: WP-INF-002-T002
- **Type**: setup
- **Description**: Tạo Redis configuration file
- **Files to Create**:
  - `docker/redis/redis.conf` - Redis configuration
- **Config Template**:
  ```conf
  maxmemory 256mb
  maxmemory-policy allkeys-lru
  appendonly yes
  ```
- **Estimated Hours**: 0.5

#### Task 3: Add to Docker Compose

- **ID**: WP-INF-002-T003
- **Type**: setup
- **Description**: Thêm Redis service vào docker-compose.yml
- **Files to Modify**:
  - `docker-compose.yml` - Add redis service
- **Code Template**:
  ```yaml
  redis:
    image: redis:7-alpine
    command: redis-server /usr/local/etc/redis/redis.conf
    ports:
      - "6379:6379"
    volumes:
      - ./docker/redis/redis.conf:/usr/local/etc/redis/redis.conf
      - redis_data:/data
  ```
- **Estimated Hours**: 0.5

---

## WP-INF-003: AWS S3 Storage Setup

### Overview

- **ID**: WP-INF-003
- **Description**: Configure S3 bucket for audio files
- **Dependencies**: -
- **Estimated Days**: 0.5
- **Total Tasks**: 3
- **DD References**: `03-system-overview.md#external-services`, `13-deployment-design.md`

### Tasks

#### Task 1: Create S3 Bucket

- **ID**: WP-INF-003-T001
- **Type**: setup
- **Description**: Tạo S3 bucket cho audio storage trên AWS Console
- **Bucket Structure**:
  ```
  speakpal-audio-{env}/
  ├── conversations/
  │   └── {user_id}/{conversation_id}/
  ├── tts-cache/
  └── user-uploads/
  ```
- **Estimated Hours**: 0.5

#### Task 2: Configure CORS & Policies

- **ID**: WP-INF-003-T002
- **Type**: setup
- **Description**: Cấu hình CORS và bucket policies cho client access
- **CORS Template**:
  ```json
  {
    "CORSRules": [
      {
        "AllowedOrigins": ["*"],
        "AllowedMethods": ["GET", "PUT"],
        "AllowedHeaders": ["*"],
        "MaxAgeSeconds": 3600
      }
    ]
  }
  ```
- **Estimated Hours**: 1

#### Task 3: Setup MinIO for Local Dev

- **ID**: WP-INF-003-T003
- **Type**: setup
- **Description**: Setup MinIO (S3-compatible) cho local development
- **Files to Modify**:
  - `docker-compose.yml` - Add minio service
- **Code Template**:
  ```yaml
  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data
  ```
- **Estimated Hours**: 1

---

## WP-INF-004: Firebase Project Setup

### Overview

- **ID**: WP-INF-004
- **Description**: Configure Firebase for auth
- **Dependencies**: -
- **Estimated Days**: 0.5
- **Total Tasks**: 4
- **DD References**: `03-system-overview.md#external-services`, `10-security-design.md`

### Tasks

#### Task 1: Create Firebase Project

- **ID**: WP-INF-004-T001
- **Type**: setup
- **Description**: Tạo Firebase project trên Firebase Console
- **Steps**:
  1. Go to https://console.firebase.google.com
  2. Create new project "SpeakPal AI"
  3. Enable Google Analytics (optional)
- **Estimated Hours**: 0.5

#### Task 2: Enable Auth Providers

- **ID**: WP-INF-004-T002
- **Type**: setup
- **Description**: Enable authentication providers
- **Providers to Enable**:
  - Email/Password
  - Google Sign-in
  - Apple Sign-in
- **Estimated Hours**: 0.5

#### Task 3: Download Credentials

- **ID**: WP-INF-004-T003
- **Type**: setup
- **Description**: Tải service account key cho backend
- **Files to Create**:
  - `backend/.env` - Add Firebase credentials
- **Environment Variables**:
  ```env
  FIREBASE_PROJECT_ID=speakpal-ai
  FIREBASE_PRIVATE_KEY="..."
  FIREBASE_CLIENT_EMAIL=...
  ```
- **Estimated Hours**: 0.5

#### Task 4: Setup Flutter Firebase

- **ID**: WP-INF-004-T004
- **Type**: setup
- **Description**: Configure Firebase cho Flutter app
- **Commands**:
  ```bash
  flutterfire configure
  ```
- **Files Created**:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- **Estimated Hours**: 1

---

## WP-INF-005: CI/CD Pipeline Setup

### Overview

- **ID**: WP-INF-005
- **Description**: GitHub Actions for build/deploy
- **Dependencies**: -
- **Estimated Days**: 1
- **Total Tasks**: 3
- **DD References**: `13-deployment-design.md`

### Tasks

#### Task 1: Create Backend CI Workflow

- **ID**: WP-INF-005-T001
- **Type**: setup
- **Description**: CI pipeline cho NestJS backend
- **Files to Create**:
  - `.github/workflows/backend-ci.yml`
- **Workflow Template**:
  ```yaml
  name: Backend CI
  on:
    push:
      branches: [main, develop]
      paths: ["backend/**"]
    pull_request:
      branches: [main]
      paths: ["backend/**"]
  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-node@v4
          with:
            node-version: "20"
        - run: cd backend && npm ci
        - run: cd backend && npm run lint
        - run: cd backend && npm run test
        - run: cd backend && npm run build
  ```
- **Estimated Hours**: 2

#### Task 2: Create Flutter CI Workflow

- **ID**: WP-INF-005-T002
- **Type**: setup
- **Description**: CI pipeline cho Flutter app
- **Files to Create**:
  - `.github/workflows/flutter-ci.yml`
- **Workflow Template**:
  ```yaml
  name: Flutter CI
  on:
    push:
      branches: [main, develop]
      paths: ["mobile/**"]
    pull_request:
      branches: [main]
      paths: ["mobile/**"]
  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: subosito/flutter-action@v2
          with:
            flutter-version: "3.x"
        - run: cd mobile && flutter pub get
        - run: cd mobile && flutter analyze
        - run: cd mobile && flutter test
  ```
- **Estimated Hours**: 2

#### Task 3: Configure Branch Protection

- **ID**: WP-INF-005-T003
- **Type**: setup
- **Description**: Cấu hình branch protection rules và secrets
- **Settings**:
  - Require PR reviews before merging
  - Require status checks to pass
  - Add secrets for deployment
- **Estimated Hours**: 1

---

## Phase Summary

| Work Package | Name                   | Tasks  | Est. Hours | Status |
| ------------ | ---------------------- | ------ | ---------- | ------ |
| WP-INF-001   | PostgreSQL Setup       | 4      | 3          | ⬜     |
| WP-INF-002   | Redis Cache Setup      | 3      | 1.5        | ⬜     |
| WP-INF-003   | AWS S3 Storage Setup   | 3      | 2.5        | ⬜     |
| WP-INF-004   | Firebase Project Setup | 4      | 2.5        | ⬜     |
| WP-INF-005   | CI/CD Pipeline Setup   | 3      | 5          | ⬜     |
| **Total**    |                        | **17** | **14.5**   |        |

---

## Next Phase

→ [Phase 1: Foundation](./phase-1-foundation.md)

---

_DD References: 07-database-design.md, 13-deployment-design.md, 03-system-overview.md_
