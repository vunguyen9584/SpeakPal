---
name: create-dd
description: Skill for creating Detailed Design Document (DD) from SRS and Basic Design. Use when the user wants to create/generate Detailed Design documentation that is implementation-ready. Triggers on requests like "create DD", "generate detailed design", "make DD from BD". For FULL DETAIL requirements, use create-dd-fulldetail skill.
---

# Create Detailed Design Document Skill

This skill provides comprehensive guidance for creating Detailed Design Document (DD) from SRS and Basic Design.

> **For enhanced version with FULL DETAIL content requirements and automatic subfolder splitting, see: [create-dd-fulldetail](../create-dd-fulldetail/SKILL.md)**

## Purpose

Transform BD into a complete Detailed Design Document with:
- Implementation-ready specifications
- 16 structured files (00-15)
- 100% coverage of all BD elements
- DDL for all tables, OpenAPI for all APIs
- Sequence diagrams and pseudocode for all use cases

## When to Use

- Creating Detailed Design from existing SRS and BD
- Generating implementation-ready specifications
- Converting basic design into detailed technical specifications

## Workflow Reference

Execute the workflow defined in `.agent/workflows/create-dd.md`.

## Key Steps

1. **Collect Parameters**: Ask for folder path containing SRS and BD
2. **Validate Files**: Confirm both SRS and BD exist
3. **Check Progress**: Load or create `dd-progress.md` for resume capability
4. **Load Documents**: Load SRS, BD, and instruction files
5. **Create BD-DD Mapping**: File `00-bd-dd-mapping.md` with 100% coverage
6. **Create DD Files**: 16 files from 00-15, check content requirements after each
7. **Run Validation**: Execute validation script
8. **Checklist Verification**: Check and save results
9. **Final Verification**: Check CRITICAL/REQUIRED items
10. **Summary**: Report results

## Instruction Files Reference

Load these files from `.ai-instructions/`:

| File | Purpose |
|------|---------|
| `detailed-design-instructions.md` | Main DD creation instructions |
| `dd-progress-template.md` | Progress tracking template |
| `dd-progress-guide.md` | Resume guide |
| `dd-chapter-input-dependencies.md` | Input dependencies per chapter |
| `dd-content-requirements.md` | **CRITICAL** Required content per file |
| `dd-element-coverage-requirements.md` | Coverage requirements |
| `dd-checklist-summary.md` | Checklist summary |
| `detailed-design-checklist.md` | Detailed checklist |

## File Structure (16 Files)

| File | Name | Critical Content |
|------|------|------------------|
| 00 | `00-bd-dd-mapping.md` | Coverage tables for UC/Screen/Table/API/Batch |
| 01 | `01-introduction.md` | Doc info, revision, scope |
| 02 | `02-references-terminology.md` | References, terminology |
| 03 | `03-system-overview.md` | **Architecture, Tech stack, Actors** |
| 04 | `04-design-considerations.md` | NFRs, assumptions |
| 05 | `05-module-design.md` | **Class diagrams, Package structure** |
| 06 | `06-component-design.md` | **Sequence diagrams, Pseudocode** |
| 07 | `07-database-design.md` | **DDL for ALL tables, PKs, FKs** |
| 08 | `08-api-design.md` | **OpenAPI for ALL APIs** |
| 09 | `09-ui-specifications.md` | States, interactions |
| 10 | `10-security-design.md` | Auth, RBAC, encryption |
| 11 | `11-error-handling.md` | Error codes, exceptions |
| 12 | `12-logging-monitoring.md` | Log levels, format |
| 13 | `13-deployment-design.md` | Env config, deployment |
| 14 | `14-appendices.md` | Optional content |
| 15 | `15-checklist-results.md` | Completion status |

## Creation Phases

```
Phase 1: 00-mapping → 01~04 (Foundation)
Phase 2: 05-module → 06-component (Core Logic)
Phase 3: 07-db → 08-api → 09-ui (Data & Interfaces)
Phase 4: 10~13 (Quality) → 14-appendix → 15-checklist
```

## Subfolder Structure (For Large Chapters)

Chapters 05-09 may use subfolder structure when content is large:

| Chapter | Index File | Subfolder | Trigger |
|---------|-----------|-----------|---------|
| 05 | `05-module-design.md` | `05-module-design/` | >500 lines or >5 modules |
| 06 | `06-component-design.md` | `06-component-design/` | >500 lines or >10 UCs |
| 07 | `07-database-design.md` | `07-database-design/` | >500 lines or >20 tables |
| 08 | `08-api-design.md` | `08-api-design/` | >500 lines or >15 APIs |
| 09 | `09-ui-specifications.md` | `09-ui-specifications/` | >500 lines or >10 screens |

### Index File Format

```markdown
# Chapter Title

> Index file for chapter content

## Contents

| Section | File | Content |
|---------|------|---------|
| X.1 | [Link](./folder/01-file.md) | Description |
| X.2 | [Link](./folder/02-file.md) | Description |

---
_Last updated: YYYY-MM-DD_
```

## Content Requirements Check (CRITICAL)

### After Creating Each File

1. Open `dd-content-requirements.md`
2. Find section for the file just created
3. Check each item:
   - **CRITICAL**: MUST have, missing = STOP and add
   - **REQUIRED**: MUST have, missing = WARNING, continue

### CRITICAL Items (17 Total - Must be 17/17)

| File | CRITICAL Items |
|------|----------------|
| 00-bd-dd-mapping | UC/Screen/Table/API/Batch coverage tables (5) |
| 03-system-overview | Doc info, Architecture diagram, Tech stack (3) |
| 05-module-design | Class diagrams, Package structure (2) |
| 06-component-design | Sequence diagrams, Pseudocode (2) |
| 07-database-design | DDL for ALL tables, PKs, FKs (3) |
| 08-api-design | OpenAPI for ALL APIs, Request/Response schemas (2) |

### REQUIRED Items (76 Total - Must be >=70%)

Target: >=53/76 items

## 03-system-overview Requirements (Example)

| ID | Content | Level |
|----|---------|-------|
| 03-C01 | Document Information Section | CRITICAL |
| 03-C02 | Architecture Diagram | CRITICAL |
| 03-C03 | Technology Stack Tables | CRITICAL |
| 03-R01 | Phase Scope with metrics | REQUIRED |
| 03-R02 | Milestones Table | REQUIRED |
| 03-R03 | Actor Definition Table | REQUIRED |
| 03-R04 | Actor → Service Mapping | REQUIRED |
| 03-R05 | Role → Permission Matrix | REQUIRED |
| 03-R06 | Technology Selection Rationale | REQUIRED |
| 03-R07 | Design Decisions Section | REQUIRED |
| 03-R08 | External Integration Table | REQUIRED |
| 03-R09 | Design Patterns Table | REQUIRED |
| 03-R10 | Cross-Reference Links | REQUIRED |
| 03-R11 | Assumptions & Constraints | REQUIRED |
| 03-R12 | Terminology Quick Reference | REQUIRED |

## Assessment Criteria

```
PASS        = CRITICAL 17/17 + REQUIRED >=70% (53/76)
COND. PASS  = CRITICAL 17/17 + REQUIRED 50-69% (needs additions)
FAIL        = CRITICAL <17 or REQUIRED <50%
```

## FAIL Conditions

| Condition | Action |
|-----------|--------|
| Missing any CRITICAL item | FAIL - Add immediately |
| Missing >30% REQUIRED items | FAIL - Add required |
| Coverage mapping <100% | FAIL - Check again |
| DDL not complete for all tables | FAIL - Add DDL |
| OpenAPI not complete for all APIs | FAIL - Add API specs |

## Progress Tracking

Always update `dd-progress.md` after each chapter:
- Mark completed chapters
- Note any issues
- Enable resume from last checkpoint

## Critical Rules

1. **Both SRS and BD required** - Must have both inputs
2. **00-Mapping first** - Most important file for traceability
3. **Content Requirements** - CRITICAL items cannot be missing
4. **Implementability** - DD must be detailed enough to code
5. **Validation Rules** - Must map clearly from Screen → API → DB
6. **Progress Tracking** - Always update after each chapter
7. **Subfolder structure** - Use for large chapters (05-09)
