# SpeakPal AI - Intelligent English Conversation Practice

[![NestJS](https://img.shields.io/badge/Backend-NestJS-E0234E?style=flat&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2015-336791?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Cache-Redis%207-DC382D?style=flat&logo=redis&logoColor=white)](https://redis.io/)
[![Prisma](https://img.shields.io/badge/ORM-Prisma-2D3748?style=flat&logo=prisma&logoColor=white)](https://www.prisma.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

SpeakPal AI is an interactive, AI-powered English conversation practice platform designed to help learners develop fluency, natural pronunciation, and conversational confidence. The system provides real-time voice conversations with AI personas, instant grammar corrections, interactive shadowing exercises, and structured learning modules.

---

## 📑 Table of Contents

- [Overview & Key Features](#-overview--key-features)
- [System Architecture & Tech Stack](#-system-architecture--tech-stack)
- [Directory Structure](#-directory-structure)
- [Prerequisites](#-prerequisites)
- [Quick Start: Step-by-Step Development Setup](#-quick-start-step-by-step-development-setup)
  - [1. Clone Repository](#1-clone-repository)
  - [2. Start Infrastructure Services (Docker)](#2-start-infrastructure-services-docker)
  - [3. Backend Setup & Run](#3-backend-setup--run)
  - [4. Mobile App Setup & Run (Flutter)](#4-mobile-app-setup--run-flutter)
- [Alternative: Running Backend via Docker Compose](#-alternative-running-backend-via-docker-compose)
- [Available Scripts & Testing](#-available-scripts--testing)
- [Additional Documentation](#-additional-documentation)

---

## 🌟 Overview & Key Features

- **Real-Time Voice Conversations**: Low-latency, bidirectional audio streaming over WebSockets powered by Speech-to-Text (STT) and Text-to-Speech (TTS).
- **Persona-Based Practice**: Choose from diverse AI personas with different conversational styles, tones, and cultural backgrounds.
- **Instant Linguistic Feedback**: Live grammatical analysis, vocabulary enrichment suggestions, and fluency metrics.
- **Targeted Learning Modes**:
  - **Shadowing**: Listen, repeat, and match AI speech cadence.
  - **Quick Response**: Rapid-fire verbal prompts to build reflex speed.
  - **Sentence Translation**: Context-based bilingual drills.
- **Gamification & Progress Tracking**: Daily streaks, XP, level progression, and comprehensive speaking history.

---

## 🛠 System Architecture & Tech Stack

### Frontend (Mobile)
- **Framework**: [Flutter](https://flutter.dev/) (Dart 3.x)
- **State Management**: [Riverpod 2.x](https://riverpod.dev/)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Networking**: [Dio](https://pub.dev/packages/dio) (HTTP REST) & [Socket.io Client](https://pub.dev/packages/socket_io_client) (WebSocket)
- **Audio Handling**: `just_audio`, `record`, and `audio_waveforms`

### Backend (API & WebSocket Server)
- **Framework**: [NestJS 11.x](https://nestjs.com/) (Node.js & TypeScript)
- **Database ORM**: [Prisma ORM](https://www.prisma.io/)
- **Real-Time Gateway**: `@nestjs/websockets` with [Socket.io](https://socket.io/)
- **Authentication**: JWT & Firebase Admin Authentication

### Data & Infrastructure
- **Relational Database**: PostgreSQL 15
- **In-Memory Cache & Sessions**: Redis 7
- **Object Storage**: MinIO (local S3-compatible) / AWS S3
- **Containerization**: Docker & Docker Compose

### AI & External Services
- **Speech-to-Text (STT)**: Deepgram (`nova-2`)
- **Large Language Model (LLM)**: OpenAI GPT-4o
- **Text-to-Speech (TTS)**: TTSOpenAI (recommended), OpenAI TTS, ElevenLabs, or built-in **Mock TTS** (ideal for local testing without paid API keys)

---

## 📁 Directory Structure

```text
SpeakPal/
├── backend/               # NestJS API & WebSocket Server
│   ├── prisma/            # Database schema & migrations
│   ├── src/               # Application modules (auth, persona, conversation, etc.)
│   ├── test/              # Unit & E2E tests
│   ├── Dockerfile.dev     # Docker development build file
│   └── package.json
├── mobile/                # Flutter Cross-Platform Client
│   ├── lib/               # Dart source code (screens, widgets, providers, config)
│   ├── test/              # Widget and unit tests
│   └── pubspec.yaml
├── docker/                # Database & Redis configuration files
│   ├── postgres/          # Initial SQL schema scripts
│   └── redis/             # Redis configuration
├── docs/                  # Architecture, master plan, and API specs
├── scripts/               # Helper utilities & state verification scripts
├── docker-compose.yml     # Docker services definition (PostgreSQL, Redis, MinIO, Backend)
└── README.md
```

---

## 📋 Prerequisites

Ensure the following tools are installed on your workstation:

- **Git**
- **Docker & Docker Compose** (v2.0+)
- **Node.js** (v18.x or v20.x LTS) & **npm**
- **Flutter SDK** (v3.10.x or higher) & **Dart SDK**
- **Mobile Development Environment**:
  - **Android**: Android Studio with Android SDK & Emulator.
  - **iOS (macOS only)**: Xcode with iOS Simulator & CocoaPods.

---

## 🚀 Quick Start: Step-by-Step Development Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd SpeakPal
```

---

### 2. Start Infrastructure Services (Docker)

Start PostgreSQL, Redis, and MinIO in the background:

```bash
docker compose up -d postgres redis minio
```

To verify that the services are healthy:

```bash
docker compose ps
```

- **PostgreSQL**: `localhost:5432` (User: `speakpal_app`, Database: `speakpal_dev`)
- **Redis**: `localhost:6379`
- **MinIO**: `localhost:9000` (Console UI at `http://localhost:9001`, Credentials: `minioadmin` / `minioadmin`)

---

### 3. Backend Setup & Run

1. **Navigate to the backend directory**:
   ```bash
   cd backend
   ```

2. **Configure environment variables**:
   Create a `.env` file based on `.env.example`:
   ```bash
   cp .env.example .env
   ```
   > **Note on AI Keys**: If you do not have external API keys (OpenAI, Deepgram, TTSOpenAI) configured in `.env`, the backend will automatically fallback to **Mock TTS**, allowing complete offline/dev-mode operation.

3. **Install dependencies**:
   ```bash
   npm install
   ```

4. **Initialize Database & Run Migrations**:
   Run Prisma migrations and seed initial persona data:
   ```bash
   npx prisma migrate dev
   npx prisma db seed
   ```

5. **Start Backend in Development Mode**:
   ```bash
   npm run start:dev
   ```
   The backend server will start with hot-reload at **`http://localhost:3000`**.

---

### 4. Mobile App Setup & Run (Flutter)

1. **Navigate to the mobile directory**:
   ```bash
   cd ../mobile
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Run Code Generation**:
   Generate code for models, Freezed classes, and Riverpod providers:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   *(Alternatively, run the automated setup script from the root: `./scripts/dev-setup.sh`)*

4. **Launch the Mobile App**:
   
   - **For iOS Simulator or Web / macOS Desktop**:
     ```bash
     flutter run
     ```
   
   - **For Android Emulator**:
     > 💡 **Important Android Networking Note**: Android emulators map the host's `localhost` to `10.0.2.2`. Pass compile-time environment variables so the app points to the host backend:
     ```bash
     flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000 --dart-define=WS_URL=ws://10.0.2.2:3000
     ```

   - **For Physical Devices**:
     Use your machine's local LAN IP address (e.g. `http://192.168.1.X:3000`):
     ```bash
     flutter run --dart-define=API_BASE_URL=http://<YOUR_LAN_IP>:3000 --dart-define=WS_URL=ws://<YOUR_LAN_IP>:3000
     ```

---

## 🐳 Alternative: Running Backend via Docker Compose

If you prefer running the backend containerized alongside databases without running local Node.js:

```bash
docker compose up --build
```

This launches PostgreSQL, Redis, MinIO, and the NestJS backend container listening on port `3000`.

---

## 🧪 Available Scripts & Testing

### Backend Commands (`/backend`)

| Command | Description |
| :--- | :--- |
| `npm run start:dev` | Start NestJS in development watch mode |
| `npm run build` | Build production artifacts to `/dist` |
| `npm test` | Run Jest unit tests |
| `npm run test:watch` | Run Jest in interactive watch mode |
| `npm run test:cov` | Generate unit test coverage report |
| `npm run test:e2e` | Run end-to-end integration tests |
| `npm run lint` | Run ESLint with auto-fix |
| `npx prisma studio` | Open Prisma GUI browser to inspect database |

### Mobile Commands (`/mobile`)

| Command | Description |
| :--- | :--- |
| `flutter pub get` | Fetch and update Flutter dependencies |
| `flutter pub run build_runner build -d` | Run code generator (Freezed, JSON Serialization) |
| `flutter run` | Launch app on connected device/simulator |
| `flutter analyze` | Run static code analysis |
| `flutter test` | Run Flutter unit and widget tests |

---

## 📚 Additional Documentation

Detailed technical design documents are available in the [`docs/`](./docs) directory:

- [Master Plan & Roadmap](./docs/MASTER-PLAN.md)
- [Backend Integration Checklist](./docs/BACKEND_INTEGRATION_CHECKLIST.md)
- [Backend Testing Guide](./docs/BACKEND_TESTING_GUIDE.md)
- [TTSOpenAI Integration Guide](./docs/TTSOPENAI_INTEGRATION_GUIDE.md)
- [Security Guide](./docs/SECURITY_GUIDE.md)
- [CI/CD Pipeline Guide](./docs/CI_CD_GUIDE.md)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
