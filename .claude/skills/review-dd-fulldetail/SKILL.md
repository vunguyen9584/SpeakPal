---
name: review-dd-fulldetail
description: Enhanced skill for reviewing Detailed Design Document (DD) to ensure FULL DETAIL content and proper subfolder structure. Use when validating DD for implementation readiness. Triggers on requests like "review DD full detail", "validate DD completeness", "kiểm tra DD đầy đủ chi tiết".
---

# Review Detailed Design Document - Full Detail Skill

This skill provides comprehensive review of DD documents focusing on CONTENT COMPLETENESS and proper organization for large documents.

## Purpose

Review and validate DD documents ensuring:
- **ALL content is FULL DETAIL** (not outlines or placeholders)
- **DDL is complete and executable**
- **OpenAPI specs are complete with schemas**
- **Pseudocode is implementable** (not high-level description)
- **Subfolders are properly structured** for large chapters
- **All links work correctly**

## When to Use

- Reviewing DD before starting implementation
- Validating DD quality for sign-off
- Checking that DD is truly implementation-ready

## Review Phases

### Phase 1: Structure Analysis

Before reviewing content, analyze the DD structure:

```
1. List all DD files in 詳細設計書 folder
2. Identify chapters using subfolders (05, 06, 07, 08, 09)
3. Verify subfolder structure:
   - Main file exists (XX-chapter.md)
   - Subfolder exists (XX-chapter/)
   - _index.md exists in subfolder
   - All links in main file work
4. Record structure in review report
```

#### Structure Recording Table

| Chapter | Expected | Actual | Subfolders | Links OK? |
|---------|----------|--------|------------|-----------|
| 05-module-design | Single/Folder | ? | List files | Y/N |
| 06-component-design | Single/Folder | ? | List files | Y/N |
| 07-database-design | Single/Folder | ? | List files | Y/N |
| 08-api-design | Single/Folder | ? | List files | Y/N |
| 09-ui-specifications | Single/Folder | ? | List files | Y/N |

### Phase 2: Content Requirements Check (PRIORITY 1)

Load `dd-content-requirements.md` and check:

#### CRITICAL Items (Must be 28/28)

| File | CRITICAL Items | Count | Check |
|------|----------------|-------|-------|
| _index.md | Doc info, Document structure | 2 | |
| 00-bd-dd-mapping | UC/Screen/Table/API/Batch coverage | 5 | |
| 03-system-overview | Doc info, Architecture, Tech stack | 3 | |
| 05-module-design | Class diagrams, Package structure, Module overview | 3 | |
| 06-component-design | Sequence diagrams, Pseudocode, Batch design | 3 | |
| 07-database-design | DDL for ALL, PKs, FKs | 3 | |
| 08-api-design | API overview, Action list, AJAX detail | 3 | |
| 09-ui-specifications | Layout, Wireframes, Component specs | 3 | |
| 11-error-handling | Error format, Error list, Exception hierarchy | 3 | |
| **TOTAL** | | **28** | |

**Evaluation:**
- 28/28 = PASS
- <28 = **FAIL immediately**

#### REQUIRED Items (Must be >=70%)

Target: >=109/155 items (see `dd-content-requirements.md` for full list)

### Phase 3: Detail Level Verification (PRIORITY 2)

This is the **key difference** from standard review. Check that content is FULL DETAIL, not outlines.

#### 3.1 DDL Detail Check (07-database-design)

**For each table DDL, verify:**

| Check | Required | Example |
|-------|----------|---------|
| All columns defined | Yes | Not just "..." or placeholder |
| Column data types | Yes | VARCHAR(100), DECIMAL(18,2) |
| NOT NULL constraints | Yes | column_name VARCHAR(50) NOT NULL |
| DEFAULT values | Yes | DEFAULT 'ACT', DEFAULT 0 |
| PRIMARY KEY | Yes | CONSTRAINT pk_table PRIMARY KEY (id) |
| FOREIGN KEYs | Yes | CONSTRAINT fk_... FOREIGN KEY ... REFERENCES |
| CHECK constraints | Yes | CONSTRAINT ck_... CHECK (status IN (...)) |
| Indexes | Yes | CREATE INDEX ix_... ON table (...) |
| Comments | Yes | COMMENT ON TABLE/COLUMN |

**FAIL if:**
- DDL has "-- TODO" or placeholder text
- Missing columns compared to BD entity definition
- No indexes defined
- No COMMENTs

**Sample Verification:**
```sql
-- ❌ FAIL: Incomplete DDL
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    -- other columns...
);

-- ✅ PASS: Complete DDL
CREATE TABLE fico.m_users (
    user_id             BIGSERIAL NOT NULL,
    user_code           VARCHAR(50) NOT NULL,
    email               VARCHAR(200) NOT NULL,
    display_name        VARCHAR(100) NOT NULL,
    status              VARCHAR(10) NOT NULL DEFAULT 'ACT',
    is_deleted          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by          VARCHAR(50) NOT NULL,
    CONSTRAINT pk_m_users PRIMARY KEY (user_id),
    CONSTRAINT uk_m_users_code UNIQUE (user_code),
    CONSTRAINT ck_m_users_status CHECK (status IN ('ACT', 'INA', 'DEL'))
);
CREATE INDEX ix_m_users_status ON fico.m_users (status);
COMMENT ON TABLE fico.m_users IS 'ユーザーマスタ';
```

#### 3.2 Sequence Diagram Detail Check (06-component-design)

**For each sequence diagram, verify:**

| Check | Required | Example |
|-------|----------|---------|
| All participants defined | Yes | Controller, Service, Repository, DB |
| Method calls with parameters | Yes | service.process(request) |
| SQL queries shown | Yes | SELECT/UPDATE/INSERT statements |
| Return values shown | Yes | return result, -->> notation |
| Error handling (alt) | Yes | alt exists / else not found |
| Loops when applicable | Yes | loop for batch processing |

**FAIL if:**
- Sequence only shows "Controller → Service → DB" without details
- No SQL queries visible
- No error handling paths

**Sample Verification:**
```mermaid
%% ❌ FAIL: Outline only
sequenceDiagram
    User->>Controller: request
    Controller->>Service: process
    Service->>DB: query
    DB-->>User: result

%% ✅ PASS: Full detail
sequenceDiagram
    participant U as ユーザー
    participant C as JournalController
    participant S as JournalService
    participant R as JournalRepository
    participant DB as PostgreSQL

    U->>C: POST /journals (JournalRequest)
    C->>C: validate(request)
    C->>S: createJournal(request)
    S->>S: validateDebitCreditBalance()
    S->>R: save(journal)
    R->>DB: INSERT INTO t_journals (...) VALUES (...)
    DB-->>R: journalId
    R->>DB: INSERT INTO t_journal_lines (...) VALUES (...)
    R-->>S: Journal entity
    S-->>C: JournalResponse
    C-->>U: 201 Created
```

#### 3.3 Pseudocode Detail Check (06-component-design)

**For each pseudocode, verify:**

| Check | Required | Example |
|-------|----------|---------|
| Input/Output defined | Yes | INPUT: request, OUTPUT: result |
| Variable declarations | Yes | entity = repository.findById() |
| Condition checks (IF/ELSE) | Yes | IF entity IS NULL |
| Loop constructs (FOR/WHILE) | Yes | FOR EACH item IN list |
| Exception handling (TRY/CATCH) | Yes | TRY: ... CATCH: ... |
| Function calls | Yes | service.method(params) |
| Comments for complex logic | Yes | // Business rule: ... |

**FAIL if:**
- Pseudocode is just numbered steps without logic
- No error handling
- No variable assignments

**Sample Verification:**
```
❌ FAIL: High-level description
1. Validate input
2. Check authorization
3. Process request
4. Save to database
5. Return result

✅ PASS: Implementable pseudocode
FUNCTION createJournal(request: JournalRequest): JournalResponse
    INPUT: request with header and lines
    OUTPUT: JournalResponse or Exception

    // 1. Input Validation
    IF request.lines IS EMPTY:
        THROW ValidationException("VAL-001", "Lines required")

    // 2. Debit/Credit Balance Check
    debitSum = SUM(line.amount WHERE line.type = 'DR')
    creditSum = SUM(line.amount WHERE line.type = 'CR')
    IF ABS(debitSum - creditSum) > 0.01:
        THROW BusinessException("BIZ-001", "Debit/Credit not balanced")

    // 3. Create Journal
    TRY:
        journal = new Journal()
        journal.journalDate = request.journalDate
        journal.status = 'DRAFT'

        FOR EACH lineRequest IN request.lines:
            line = new JournalLine()
            line.accountCode = lineRequest.accountCode
            line.amount = lineRequest.amount
            journal.lines.add(line)

        savedJournal = journalRepository.save(journal)
        RETURN JournalResponse.from(savedJournal)

    CATCH DatabaseException AS e:
        LOG.error("Database error", e)
        THROW SystemException("SYS-001", "Save failed")
```

#### 3.4 API Spec Detail Check (08-api-design)

**For each API, verify:**

| Check | Required | Example |
|-------|----------|---------|
| HTTP method and path | Yes | GET /api/v1/journals/{id} |
| Path parameters | Yes | id: integer, required |
| Query parameters | Yes | page, limit, sort |
| Request body schema | Yes | JSON with field types |
| Success response (200/201) | Yes | Full JSON example |
| Error responses | Yes | 400, 401, 403, 404, 500 |
| Processing steps | Yes | Numbered list with logic |
| SQL queries | Yes | SELECT/UPDATE statements |

**FAIL if:**
- Only endpoint path without parameters
- No request/response examples
- No error responses defined

### Phase 4: Coverage Verification

#### 4.1 BD Element Coverage

Check that ALL BD elements are covered in DD:

| Element | BD Count | DD Count | Coverage |
|---------|----------|----------|----------|
| Use Cases | ? | ? | 100%? |
| Screens | ? | ? | 100%? |
| Tables | ? | ? | 100%? |
| APIs | ? | ? | 100%? |
| Batch Jobs | ? | ? | 100%? |

**FAIL if any coverage < 100%**

#### 4.2 Subfolder Coverage

If chapter uses subfolders:
- Check all elements are in subfolder files
- Check index links to all subfolder files
- Check no orphaned files

### Phase 5: Cross-Reference Check

| Flow | Verify |
|------|--------|
| UC → Sequence | Every UC has sequence diagram (may be in subfolder) |
| UC → Pseudocode | Complex UCs have pseudocode |
| Table → DDL | Every BD table has complete DDL |
| API → Spec | Every BD API has full specification |
| Screen → Wireframe | Every screen has component specs |

### Phase 6: Link Verification

For chapters with subfolders:

```
1. Read main file (e.g., 07-database-design.md)
2. Extract all links to subfolder files
3. Verify each linked file exists
4. Verify content in linked file is not empty
5. Record broken links
```

## Assessment Criteria

### Detail Level Score

| Level | Score | Description |
|-------|-------|-------------|
| Full Detail | 100% | Complete, implementable content |
| Partial Detail | 50-99% | Some sections incomplete |
| Outline Only | 0-49% | High-level descriptions, placeholders |

### Overall Verdict

| Verdict | Criteria |
|---------|----------|
| **PASS** | CRITICAL 28/28 + REQUIRED >=70% + Detail >=80% + Coverage 100% |
| **CONDITIONAL PASS** | CRITICAL 28/28 + REQUIRED 50-69% + Detail 50-79% |
| **FAIL** | CRITICAL <28 OR REQUIRED <50% OR Detail <50% OR Coverage <100% |

## FAIL Conditions

| Condition | Verdict |
|-----------|---------|
| Missing any CRITICAL item | **FAIL** |
| DDL incomplete (missing columns, constraints) | **FAIL** |
| Sequence diagram outline only | **FAIL** |
| Pseudocode high-level only | **FAIL** |
| API spec missing schemas | **FAIL** |
| Coverage < 100% | **FAIL** |
| Broken links in subfolders | **FAIL** |
| Subfolder files missing | **FAIL** |

## Report Output

Generate report at `[folder]/詳細設計書/dd-review-report.md`:

```markdown
# DD Review Report

## Summary

| Category | Result |
|----------|--------|
| **Overall Verdict** | PASS / CONDITIONAL PASS / FAIL |
| CRITICAL Items | ?/28 |
| REQUIRED Items | ?/155 (?%) |
| Detail Level | ?% |
| Coverage | ?% |
| Structure | Valid / Issues Found |

## Structure Analysis

| Chapter | Structure | Sub-files | Links |
|---------|-----------|-----------|-------|
| 05-module-design | Folder | 4 files | OK |
| 06-component-design | Folder | 5 files | OK |
| 07-database-design | Folder | 4 files | OK |
| 08-api-design | Folder | 7 files | OK |
| 09-ui-specifications | Single | - | - |

## Content Requirements

### CRITICAL Items: ?/28

| File | Item | Status |
|------|------|--------|
| 00-bd-dd-mapping | UC Coverage | ✅ |
| ... | ... | ... |

### REQUIRED Items: ?/155 (?%)

[Summary table by file]

## Detail Level Verification

### DDL Detail: ?/?

| Table | Columns | Constraints | Indexes | Comments | Status |
|-------|---------|-------------|---------|----------|--------|
| m_users | 12/12 | 5/5 | 3/3 | Yes | ✅ |

### Sequence Detail: ?/?

| UC | Participants | SQL | Error Path | Status |
|----|--------------|-----|------------|--------|
| UC-001 | 5 | Yes | Yes | ✅ |

### Pseudocode Detail: ?/?

| UC | Input/Output | Logic | Error Handling | Status |
|----|--------------|-------|----------------|--------|
| UC-001 | Yes | Complete | TRY/CATCH | ✅ |

### API Detail: ?/?

| API | Params | Request | Response | Errors | Status |
|-----|--------|---------|----------|--------|--------|
| GET /journals | Yes | - | Yes | 4 | ✅ |

## Coverage Check

| Element | BD | DD | Coverage |
|---------|-----|-----|----------|
| Use Cases | 50 | 50 | 100% ✅ |
| Tables | 120 | 120 | 100% ✅ |
| APIs | 150 | 150 | 100% ✅ |

## Issues Found

### High Priority (Must Fix)
1. [Issue description with file location]

### Medium Priority (Should Fix)
1. [Issue description]

### Low Priority (Nice to Have)
1. [Issue description]

## Recommendations

1. [Actionable recommendation]

---
_Review Date: YYYY-MM-DD_
_Reviewer: AI Assistant_
```

## Critical Rules

1. **Detail level is key** - Outline-only content is FAIL
2. **DDL must be executable** - Not placeholders
3. **Pseudocode must be implementable** - Not numbered steps
4. **Check subfolder structure first** - Before reviewing content
5. **Verify all links** - Broken links are FAIL
6. **Coverage must be 100%** - All BD elements in DD
7. **Report specific issues** - With file paths and line numbers

---

_Last updated: 2025-12-29_
