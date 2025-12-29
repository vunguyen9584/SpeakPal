---
name: review-dd
description: Skill for reviewing Detailed Design Document (DD) using standard checklists. Use when the user wants to review/validate/check Detailed Design documentation for implementation readiness. Triggers on requests like "review DD", "check detailed design", "validate DD quality". For FULL DETAIL validation, use review-dd-fulldetail skill.
---

# Review Detailed Design Document Skill

This skill provides comprehensive guidance for reviewing Detailed Design Document (DD) using standard checklists and content requirements.

> **For enhanced version with FULL DETAIL content verification and complete DDL/API/Pseudocode validation, see: [review-dd-fulldetail](../review-dd-fulldetail/SKILL.md)**

## Purpose

Review and validate DD documents ensuring:
- All CRITICAL content items present (17/17)
- REQUIRED items at >=70% (53/76)
- 100% coverage of BD elements
- Valid DDL for all tables
- Valid OpenAPI for all APIs
- Proper subfolder structure for large chapters

## When to Use

- Reviewing existing Detailed Design for quality
- Validating DD before implementation
- Checking implementation readiness of DD

## Workflow Reference

Execute the workflow defined in `.agent/workflows/review-dd.md`.

## Key Steps

1. **Collect Parameters**: Ask for DD folder path
2. **Validate Files**: Confirm `詳細設計書` folder exists
3. **Check Subfolder Structure**: Identify chapters using subfolders (05-09)
4. **Load References**: Load checklists from `.ai-instructions/`
5. **Content Requirements Check**: Check CRITICAL (17) and REQUIRED (76) items
6. **Traditional Review**: Foundation, Core Logic, Data & Interfaces, UI & Others
7. **Cross-Reference Check**: Verify Logic, Data, Interface, UI, E2E flows
8. **Generate Report**: Create `dd-review-report.md`
9. **Summary**: Display final verdict and action items

## Instruction Files Reference

Load these files from `.ai-instructions/`:

| File | Purpose | Required |
|------|---------|----------|
| `dd-content-requirements.md` | **CRITICAL** Required content per file | YES |
| `dd-checklist-summary.md` | Checklist summary | YES |
| `dd-review-steps-guide.md` | Step-by-step review guide | YES |
| `dd-chapter-input-dependencies.md` | Input dependencies check | YES |
| `detailed-design-checklist.md` | Detailed checklist | YES |
| `dd-element-coverage-requirements.md` | Coverage rules | YES |
| `dd-review-output-template.md` | Report template | YES |

## Subfolder Structure Check (Step 3)

### Chapters That May Use Subfolders

| Chapter | Index File | Subfolder |
|---------|-----------|-----------|
| 05 | `05-module-design.md` | `05-module-design/` |
| 06 | `06-component-design.md` | `06-component-design/` |
| 07 | `07-database-design.md` | `07-database-design/` |
| 08 | `08-api-design.md` | `08-api-design/` |
| 09 | `09-ui-specifications.md` | `09-ui-specifications/` |

### Check Process

```
1. Check if DD folder has subfolders
2. If HAS subfolders:
   - Verify index file exists
   - Verify all links in index work
   - Record list of sub-files to review
3. If NO subfolders:
   - Review single file as normal
```

### Structure Recording Table

| Chapter | Structure | Sub-files | Links OK? |
|---------|-----------|-----------|-----------|
| 05 | Single/Folder | ? | Y/N |
| 06 | Single/Folder | ? | Y/N |
| 07 | Single/Folder | ? | Y/N |
| 08 | Single/Folder | ? | Y/N |
| 09 | Single/Folder | ? | Y/N |

## Content Requirements Check (PRIORITY 1 - Step 5)

### CRITICAL Items (Must be 17/17)

| File | CRITICAL Items | Count |
|------|----------------|-------|
| 00-bd-dd-mapping | UC/Screen/Table/API/Batch coverage tables | 5 |
| 03-system-overview | Doc info, Architecture diagram, Tech stack | 3 |
| 05-module-design | Class diagrams, Package structure | 2 |
| 06-component-design | Sequence diagrams, Pseudocode | 2 |
| 07-database-design | DDL for ALL tables, PKs, FKs | 3 |
| 08-api-design | OpenAPI for ALL APIs, Request/Response schemas | 2 |

**Evaluation:**
- 17/17 CRITICAL = PASS
- <17 CRITICAL = **FAIL immediately** (no need to check further)

### REQUIRED Items (Must be >=70%)

| File | REQUIRED Items | Check | Missing | Structure |
|------|----------------|-------|---------|-----------|
| 00-bd-dd-mapping | 2 | | | Single |
| 01-introduction | 5 | | | Single |
| 02-references-terminology | 5 | | | Single |
| 03-system-overview | 12 | | | Single |
| 04-design-considerations | 5 | | | Single |
| 05-module-design | 4 | | | Single/Multi |
| 06-component-design | 4 | | | Single/Multi |
| 07-database-design | 5 | | | Single/Multi |
| 08-api-design | 5 | | | Single/Multi |
| 09-ui-specifications | 5 | | | Single/Multi |
| 10-security-design | 5 | | | Single |
| 11-error-handling | 5 | | | Single |
| 12-logging-monitoring | 5 | | | Single |
| 13-deployment-design | 5 | | | Single |
| 15-checklist-results | 4 | | | Single |
| **TOTAL** | **76** | | | |

**Evaluation:**
- >=53/76 (>=70%) = PASS
- 38-52/76 (50-69%) = WARNING, needs additions
- <38/76 (<50%) = **FAIL**

## 03-system-overview Detailed Check (Example)

| ID | Required Content | Present? | Notes |
|----|------------------|----------|-------|
| 03-C01 | Document Information Section | | |
| 03-C02 | Architecture Diagram | | |
| 03-C03 | Technology Stack Tables | | |
| 03-R01 | Phase Scope with metrics | | |
| 03-R02 | Milestones Table | | |
| 03-R03 | Actor Definition Table | | |
| 03-R04 | Actor → Service Mapping | | |
| 03-R05 | Role → Permission Matrix | | |
| 03-R06 | Technology Selection Rationale | | |
| 03-R07 | Design Decisions Section | | |
| 03-R08 | External Integration Table | | |
| 03-R09 | Design Patterns Table | | |
| 03-R10 | Cross-Reference Links | | |
| 03-R11 | Assumptions & Constraints | | |
| 03-R12 | Terminology Quick Reference | | |

## Traditional Review (Step 6)

### 6.1 Foundation (00-04)
- Mapping 00 links working? Coverage 100%?
- Intro and Overview match SRS/BD?

### 6.2 Core Logic (05-06)
- Module Design: Class diagrams, Dependencies
- Component Design: Pseudocode for complex logic
- **If subfolders**: Review each sub-file, check index links

### 6.3 Data & Interfaces (07-08)
- DB: DDL, Indexes, Constraints
- API: OpenAPI specs, Validation rules
- **If subfolders**: Ensure all tables/APIs covered in sub-files

### 6.4 UI & Others (09-14)
- UI: State, Interactions
- Quality: Security, Error, Log, Deploy
- **If subfolders (09)**: Check all screens covered

### 6.5 Subfolder Review Criteria

| Criteria | Check |
|----------|-------|
| Index file exists | Does `XX-chapter.md` have table of contents? |
| Links working | All links in index point to correct files? |
| Consistent numbering | Sub-files have prefix numbers (01-, 02-)? |
| Complete coverage | All BD elements covered in sub-files? |
| Cross-reference correct | Links from other files point to sub-files correctly? |

## Cross-Reference Verification (Step 7)

| Flow | Verify |
|------|--------|
| **Logic** | BD UC → DD Component Pseudocode (may be in sub-files) |
| **Data** | BD Table → DD DDL (may be in sub-files) |
| **Interface** | BD API → DD OpenAPI (may be in sub-files) |
| **UI** | BD Screen → DD UI Validation (may be in sub-files) |
| **E2E** | UI → API → DB consistency (cross-check between sub-files) |

## FAIL Conditions

| Condition | Verdict |
|-----------|---------|
| Missing any CRITICAL item (<17/17) | **FAIL** |
| Missing >50% REQUIRED items (<38/76) | **FAIL** |
| Coverage mapping <100% | **FAIL** |
| DDL not complete for all BD tables | **FAIL** |
| OpenAPI not complete for all BD APIs | **FAIL** |
| 03-system-overview missing Actor mapping | **FAIL** |
| 03-system-overview missing Design Decisions | **FAIL** |
| 03-system-overview missing Document Information | **FAIL** |
| Missing or broken index file links | **FAIL** |
| Sub-files referenced but missing | **FAIL** |

## Assessment Criteria

| Verdict | Condition |
|---------|-----------|
| **PASS** | CRITICAL 17/17 + REQUIRED >=70% + Coverage 100% |
| **CONDITIONAL PASS** | CRITICAL 17/17 + REQUIRED 50-69% (needs additions) |
| **FAIL** | CRITICAL <17 OR REQUIRED <50% OR Coverage <100% |

## Report Output

Generate report at `[folder]/詳細設計書/dd-review-report.md`.

### Summary Format

```
DD REVIEW RESULT
================================================
Status: [PASS / CONDITIONAL PASS / FAIL]

Content Requirements:
  - CRITICAL: [?]/17 [PASS/FAIL]
  - REQUIRED: [?]/76 ([?]%) [PASS/WARNING/FAIL]

Coverage:
  - Mapping Coverage: [100%/?%] [PASS/FAIL]

File Structure:
  - Chapters with subfolders: [05/06/07/08/09]
  - All links working: [PASS/FAIL]

Cross-Reference:
  - Consistency Check: [PASS/FAIL]

Files Reviewed: 16/16 (+ ? sub-files)

High Priority Issues: [count]
Medium Priority Issues: [count]
Low Priority Issues: [count]

Report saved to: [path]/dd-review-report.md
================================================
```

## Critical Rules

1. **Content Requirements First** - Always check `dd-content-requirements.md` BEFORE traditional review
2. **FAIL immediately if CRITICAL <17** - No need to check further
3. **Lazy loading** - Only load SRS/BD when verifying specific items
4. **Review all 16 chapters** - Don't skip intro, appendix, checklist results
5. **Pseudocode** - Must be detailed enough to code (if/else, loop, exception)
6. **Validation Rules** - Must be consistent from UI to DB
7. **Cross-Reference** - Important step to find logic errors
8. **Subfolder structure** - Check Step 3 before reviewing chapters 05-09
9. **Index links** - Must work and point to correct sub-files
