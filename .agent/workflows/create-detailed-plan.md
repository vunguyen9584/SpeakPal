---
description: Tạo Detailed Plan - Chi tiết hóa các Work Package từ Master Plan thành task list
---

# Workflow: Create Detailed Plan

## Mục đích

Tạo Detailed Plan từ Master Plan. Workflow này phân tách từng **Work Package** thành các **tasks cụ thể** có thể implement được.

**Output structure:** Một thư mục `implementation-plan/` chứa các file plan chi tiết cho từng phase.

---

## Input

| Tham số       | Mô tả                                          | Bắt buộc |
| ------------- | ---------------------------------------------- | -------- |
| MASTER_PLAN   | Đường dẫn đến file MASTER-PLAN.md              | ✅       |
| DD_PATH       | Đường dẫn đến thư mục Detailed Design          | ✅       |
| OUTPUT_FOLDER | Thư mục output (default: cùng với MASTER_PLAN) | Optional |
| WORK_PACKAGES | Danh sách WP IDs cần chi tiết (default: all)   | Optional |

**Ví dụ:**

```
Tạo detailed plan từ:
- Master Plan: docs/SpeakPal/MASTER-PLAN.md
- DD: docs/SpeakPal/詳細設計書
```

---

## Output Structure

```
[OUTPUT_FOLDER]/
└── implementation-plan/
    ├── _index.md                    # Tổng quan và navigation
    ├── CHECKLIST.md                 # Checklist để track progress
    ├── phase-0-infrastructure/      # Nếu phase nhỏ, chỉ cần 1 file
    │   └── _phase-0.md              # Hoặc thư mục nếu phase lớn
    ├── phase-1-foundation.md        # File đơn cho phase nhỏ
    ├── phase-2-auth-user/           # Thư mục cho phase lớn
    │   ├── _phase-2.md              # Overview của phase
    │   ├── wp-be-004-auth-module.md # Chi tiết từng WP
    │   ├── wp-be-005-user-module.md
    │   └── ...
    ├── phase-3-conversation/
    │   ├── _phase-3.md
    │   ├── wp-be-007-conversation.md
    │   └── ...
    ├── phase-4-learning.md
    ├── phase-5-social.md
    ├── phase-6-integration/
    │   ├── _phase-6.md
    │   └── ...
    ├── phase-7-qa.md
    └── phase-8-deployment.md
```

### Quy tắc phân chia file:

| Điều kiện                  | Cách tổ chức                          |
| -------------------------- | ------------------------------------- |
| Phase có ≤ 5 Work Packages | 1 file cho cả phase: `phase-X-xxx.md` |
| Phase có > 5 Work Packages | Thư mục: `phase-X-xxx/`               |
| WP có > 10 tasks           | File riêng cho WP đó                  |

---

## Quy trình thực hiện

### Bước 1: Đọc và phân tích Master Plan

1. Đọc file `MASTER-PLAN.md` để lấy:

   - Project overview
   - Technology stack
   - Danh sách Work Packages với DD References
   - Phases và timeline

2. Xác định thứ tự implement dựa trên dependencies

3. **LƯU Ý QUAN TRỌNG**: Đếm số Work Packages trong mỗi phase để quyết định cấu trúc file

### Bước 2: Đọc Detailed Design Document

Với mỗi Work Package, đọc các file DD được liệt kê trong cột **DD References**:

| Work Package Type       | DD Files to Read                                                 |
| ----------------------- | ---------------------------------------------------------------- |
| WP-INF-\* (Infra)       | 13-deployment-design.md, 07-database-design.md                   |
| WP-BE-\* (Backend)      | 05-module-design/\*.md, 06-component-design.md, 08-api-design.md |
| WP-FE-\* (Frontend)     | 09-ui-specifications.md, 06-component-design.md                  |
| WP-INT-\* (Integration) | 03-system-overview.md (External Services)                        |
| WP-QA-\* (Testing)      | All modules, 11-error-handling.md                                |
| WP-DEP-\* (Deployment)  | 13-deployment-design.md, 12-logging-monitoring.md                |

### Bước 3: Tạo thư mục implementation-plan

```bash
mkdir -p [OUTPUT_FOLDER]/implementation-plan
```

### Bước 4: Tạo \_index.md

Tạo file `implementation-plan/_index.md` với nội dung:

```markdown
# Implementation Plan - [Project Name]

## Overview

| Item                | Value    |
| ------------------- | -------- |
| Project Name        | [Name]   |
| Master Plan         | [path]   |
| Total Phases        | [N]      |
| Total Work Packages | [M]      |
| Total Tasks         | [T]      |
| Estimated Duration  | [X days] |
| Created             | [Date]   |

---

## Phase Navigation

| Phase   | Description          | WPs | Tasks | File/Folder                                              |
| ------- | -------------------- | --- | ----- | -------------------------------------------------------- |
| Phase 0 | Infrastructure Setup | 5   | 17    | [phase-0-infrastructure.md](./phase-0-infrastructure.md) |
| Phase 1 | Foundation           | 6   | 35    | [phase-1-foundation.md](./phase-1-foundation.md)         |
| Phase 2 | Auth & User          | 6   | 41    | [phase-2-auth-user/](./phase-2-auth-user/)               |
| ...     | ...                  | ... | ...   | ...                                                      |

---

## Task Summary

| Phase     | Work Packages | Tasks  | Est. Hours | Est. Days |
| --------- | ------------- | ------ | ---------- | --------- |
| Phase 0   | 5             | 17     | 28         | 3.5       |
| Phase 1   | 6             | 35     | 88         | 11        |
| ...       | ...           | ...    | ...        | ...       |
| **Total** | **XX**        | **YY** | **ZZ**     | **WW**    |

---

## Quick Links

- [CHECKLIST.md](./CHECKLIST.md) - Implementation checklist
- [MASTER-PLAN.md](../MASTER-PLAN.md) - Master Plan
```

### Bước 5: Tạo file/thư mục cho từng Phase

#### 5.1. Với phase nhỏ (≤ 5 WPs): Tạo file đơn

Tạo file `implementation-plan/phase-X-[name].md`:

````markdown
# Phase X: [Phase Name]

## Overview

| Item          | Value       |
| ------------- | ----------- |
| Phase         | X           |
| Description   | [Desc]      |
| Work Packages | [N]         |
| Total Tasks   | [M]         |
| Est. Days     | [D]         |
| Dependencies  | Phase [X-1] |

---

## WP-XXX-001: [Work Package Name]

### Overview

- **Description**: [Mô tả từ Master Plan]
- **Dependencies**: [Danh sách WP dependencies]
- **Estimated Days**: [X days]
- **Total Tasks**: [N tasks]
- **DD References**: [Files]

### Tasks

#### Task 1: [Task Name]

- **ID**: WP-XXX-001-T001
- **Type**: [setup | feature | integration | test | docs]
- **Description**: [Mô tả chi tiết]
- **Files to Create/Modify**:
  - `path/to/file1.ts` - [mô tả]
  - `path/to/file2.ts` - [mô tả]
- **Commands** (nếu có):
  ```bash
  [command]
  ```
````

- **Acceptance Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2
- **Estimated Hours**: [X hours]
- **DD Reference**: [Link to DD section]

#### Task 2: [Task Name]

...

---

## WP-XXX-002: [Work Package Name]

...

---

## Phase Summary

| Work Package | Tasks | Est. Hours | Status |
| ------------ | ----- | ---------- | ------ |
| WP-XXX-001   | 5     | 8          | ⬜     |
| WP-XXX-002   | 4     | 6          | ⬜     |
| **Total**    | **9** | **14**     |        |

````

#### 5.2. Với phase lớn (> 5 WPs): Tạo thư mục

Tạo thư mục `implementation-plan/phase-X-[name]/`:

**File 1: `_phase-X.md` (Overview)**

```markdown
# Phase X: [Phase Name]

## Overview

| Item          | Value       |
| ------------- | ----------- |
| Phase         | X           |
| Description   | [Desc]      |
| Work Packages | [N]         |
| Total Tasks   | [M]         |
| Est. Days     | [D]         |

---

## Work Packages

| ID        | Name          | Tasks | Est. Hours | File                        |
| --------- | ------------- | ----- | ---------- | --------------------------- |
| WP-BE-004 | Auth Module   | 8     | 32         | [wp-be-004-auth.md](./wp-be-004-auth.md) |
| WP-BE-005 | User Module   | 6     | 24         | [wp-be-005-user.md](./wp-be-005-user.md) |
| ...       | ...           | ...   | ...        | ... |

---

## Dependency Graph

```mermaid
flowchart LR
    WP004[WP-BE-004] --> WP005[WP-BE-005]
    WP005 --> WP006[WP-BE-006]
````

---

## Phase Summary

| Category  | Work Packages | Tasks  | Est. Hours |
| --------- | ------------- | ------ | ---------- |
| Backend   | 3             | 19     | 72         |
| Frontend  | 3             | 17     | 56         |
| **Total** | **6**         | **36** | **128**    |

````

**File 2+: `wp-[id]-[name].md` (Chi tiết từng WP)**

```markdown
# WP-BE-004: Auth Module

## Overview

- **ID**: WP-BE-004
- **Description**: JWT, OAuth, guards, login/register
- **Dependencies**: WP-BE-003, WP-INF-004
- **Estimated Days**: 4
- **Total Tasks**: 8
- **DD References**:
  - `05-module-design/auth-module.md`
  - `08-api-design.md#auth`
  - `10-security-design.md`

---

## Tasks

### Task 1: Create Auth Module Structure

- **ID**: WP-BE-004-T001
- **Type**: setup
- **Description**: Khởi tạo module structure cho Auth
- **Commands**:
  ```bash
  nest g module modules/auth
  nest g controller modules/auth
  nest g service modules/auth
````

- **Files to Create**:
  - `backend/src/modules/auth/auth.module.ts`
  - `backend/src/modules/auth/auth.controller.ts`
  - `backend/src/modules/auth/auth.service.ts`
- **Estimated Hours**: 1

### Task 2: Create Auth DTOs

...

---

## Task Summary

| Task ID        | Name                    | Type    | Est. Hours | Status |
| -------------- | ----------------------- | ------- | ---------- | ------ |
| WP-BE-004-T001 | Create Module Structure | setup   | 1          | ⬜     |
| WP-BE-004-T002 | Create Auth DTOs        | feature | 1.5        | ⬜     |
| ...            | ...                     | ...     | ...        | ⬜     |
| **Total**      |                         |         | **32**     |        |

````

### Bước 6: Tạo CHECKLIST.md

Tạo file `implementation-plan/CHECKLIST.md`:

```markdown
# Implementation Checklist - [Project Name]

## How to Use

1. Run `/implement-next-task` to implement the next pending task
2. Mark task as `[x]` when completed
3. Update progress daily

## Progress

- **Total Tasks**: [N]
- **Completed**: 0
- **Progress**: 0%

---

## Phase 0: Infrastructure Setup

### WP-INF-001: PostgreSQL Database Setup (4 tasks)

- [ ] WP-INF-001-T001: Install PostgreSQL
- [ ] WP-INF-001-T002: Create Database
- [ ] WP-INF-001-T003: Configure Access
- [ ] WP-INF-001-T004: Add to Docker Compose

### WP-INF-002: Redis Cache Setup (3 tasks)

- [ ] WP-INF-002-T001: Install Redis
- [ ] WP-INF-002-T002: Configure Redis
- [ ] WP-INF-002-T003: Add to Docker Compose

[... tiếp tục cho tất cả WPs ...]

---

## Phase 1: Foundation

### WP-BE-001: Backend Project Init (6 tasks)

- [ ] WP-BE-001-T001: Initialize NestJS Project
- [ ] WP-BE-001-T002: Configure Project Structure
- [ ] WP-BE-001-T003: Setup Environment Config
- [ ] WP-BE-001-T004: Setup Database Connection
- [ ] WP-BE-001-T005: Setup Redis Connection
- [ ] WP-BE-001-T006: Setup Docker Compose

[... tiếp tục cho tất cả WPs và Phases ...]

---

_Last updated: [Date]_
````

### Bước 7: Verify Completeness

**QUAN TRỌNG**: Trước khi hoàn thành, verify:

- [ ] Tất cả phases từ Master Plan đã có file plan tương ứng
- [ ] Mỗi Work Package có ít nhất 3-10 tasks
- [ ] Mỗi task có ID unique theo format `WP-XXX-TXXX`
- [ ] Mỗi task có: description, files, estimated hours
- [ ] CHECKLIST.md chứa TẤT CẢ tasks từ tất cả phases
- [ ] Không có phase/WP/task nào bị thiếu

**Checklist cho từng loại Work Package:**

| WP Type   | Bắt buộc phải có                                               |
| --------- | -------------------------------------------------------------- |
| WP-INF-\* | Database setup, Cache setup, Storage, Auth provider, CI/CD     |
| WP-BE-\*  | Module structure, DTOs, Service, Controller, Repository, Tests |
| WP-FE-\*  | Feature structure, Models, Repository, Providers, Screens      |
| WP-INT-\* | Module, Client, Service methods, Error handling, Tests         |
| WP-QA-\*  | Test setup, Test cases, Coverage report                        |
| WP-DEP-\* | K8s manifests, CI/CD, Monitoring, Deployment steps             |

---

## Task Templates

### Template: Backend Module (WP-BE-\*)

Mỗi backend module PHẢI có các tasks sau:

| Task # | Task Name               | Type    | Hours |
| ------ | ----------------------- | ------- | ----- |
| T001   | Create Module Structure | setup   | 1     |
| T002   | Create DTOs             | feature | 1-2   |
| T003   | Implement Repository    | feature | 2     |
| T004   | Implement Service       | feature | 3-4   |
| T005   | Implement Controller    | feature | 2     |
| T006   | Add Validation          | feature | 1     |
| T007   | Add Unit Tests          | test    | 2-3   |
| T008   | Register in App Module  | setup   | 0.5   |

### Template: Frontend Feature (WP-FE-\*)

Mỗi frontend feature PHẢI có các tasks sau:

| Task # | Task Name                | Type    | Hours |
| ------ | ------------------------ | ------- | ----- |
| T001   | Create Feature Structure | setup   | 0.5   |
| T002   | Create Models            | feature | 1     |
| T003   | Create Repository        | feature | 1-2   |
| T004   | Create Providers         | feature | 1-2   |
| T005   | Implement Main Screen    | feature | 3-4   |
| T006   | Create Widgets           | feature | 2     |
| T007   | Add Route                | setup   | 0.5   |
| T008   | Add Widget Tests         | test    | 2     |

### Template: External Integration (WP-INT-\*)

| Task # | Task Name                 | Type    | Hours |
| ------ | ------------------------- | ------- | ----- |
| T001   | Create Integration Module | setup   | 1     |
| T002   | Configure API Client      | feature | 2     |
| T003   | Implement Service Methods | feature | 3-4   |
| T004   | Add Error Handling        | feature | 1     |
| T005   | Add Retry/Fallback        | feature | 1     |
| T006   | Add Integration Tests     | test    | 2     |

---

## Lưu ý quan trọng

1. **Không được bỏ sót bất kỳ phase/WP nào**

   - Đọc kỹ Master Plan để xác định tất cả phases
   - Cross-check với Detailed Design

2. **Task granularity**:

   - Mỗi task ~ 1-4 hours
   - Nếu > 4 hours, tách thành nhiều tasks

3. **Task types**:

   - `setup`: Cấu hình, khởi tạo
   - `feature`: Implement tính năng
   - `integration`: Tích hợp service
   - `test`: Unit/Integration tests
   - `docs`: Documentation

4. **DD Reference**:

   - Mỗi feature task PHẢI có reference đến DD
   - Copy chính xác từ cột DD References trong Master Plan

5. **File paths**:

   - Luôn dùng relative paths từ project root
   - Consistent với DD folder structure

6. **CHECKLIST.md phải đầy đủ**:
   - Liệt kê TẤT CẢ tasks từ TẤT CẢ phases
   - Format checkbox `- [ ]` cho mỗi task

---

## Ví dụ Usage

```bash
# Tạo detailed plan cho SpeakPal (tất cả phases)
/create-detailed-plan
- Master Plan: docs/SpeakPal/MASTER-PLAN.md
- DD: docs/SpeakPal/詳細設計書

# Output sẽ là:
# docs/SpeakPal/implementation-plan/
# ├── _index.md
# ├── CHECKLIST.md
# ├── phase-0-infrastructure.md
# ├── phase-1-foundation.md
# ├── phase-2-auth-user/
# │   ├── _phase-2.md
# │   ├── wp-be-004-auth.md
# │   ├── wp-be-005-user.md
# │   └── ...
# └── ...
```

---

## Execution Order

Khi thực hiện workflow này, thực hiện theo thứ tự:

1. **Đọc Master Plan** - Xác định tất cả phases và WPs
2. **Tạo thư mục** - `implementation-plan/`
3. **Tạo \_index.md** - Overview và navigation
4. **Với mỗi Phase (theo thứ tự từ 0 đến N)**:
   - Đọc DD References của các WPs trong phase
   - Quyết định: file đơn hay thư mục
   - Tạo tasks chi tiết cho TỪNG WP
   - Verify không thiếu WP nào
5. **Tạo CHECKLIST.md** - Tổng hợp tất cả tasks
6. **Verify** - Cross-check với Master Plan

---

_Workflow version: 2.0_
_Last updated: 2025-12-29_
