---
name: create-bd
description: Skill for creating Basic Design Document (BD) from SRS. Use when the user wants to create/generate Basic Design documentation from System Requirement Specification. Triggers on requests like "create BD", "generate basic design", "make BD from SRS".
---

# Create Basic Design Document Skill

This skill provides comprehensive guidance for creating Basic Design Document (BD) from System Requirement Specification (SRS).

## Purpose

Transform SRS into a complete Basic Design Document following Japanese software development standards with:
- Structured file/folder organization (Main + Folder pattern for chapters 03-07)
- 100% coverage of all requirements
- Data Flow Diagrams (DFD) at multiple levels
- Traceability between FR, UC, Screen, API, Table, and Batch

## When to Use

- Creating new Basic Design from existing SRS
- Generating BD documentation for a project
- Converting requirements into design specifications

## Workflow Reference

Execute the workflow defined in `.agent/workflows/create-bd.md`.

## Key Steps

1. **Collect Parameters**: Ask for SRS folder path
2. **Validate SRS**: Confirm SRS folder exists at `[folder]/システム要件定義書/`
3. **Load References**: Load instruction files from `.ai-instructions/`
4. **Create Structure**: Create folder structure for BD at `[folder]/基本設計書/`
5. **Generate Content**: Create files following dependency order
6. **Coverage Check**: Ensure 100% coverage for all items
7. **Checklist Verification**: Verify with BD checklists
8. **Summary**: Update progress and report results

## Instruction Files Reference

Load these files from `.ai-instructions/` as needed:

| File | Purpose |
|------|---------|
| `basic-design-instructions.md` | Main BD creation instructions |
| `bd-file-folder-structure.md` | **CRITICAL** File/folder structure standard |
| `bd-progress-template.md` | Progress tracking template |
| `bd-chapter-input-dependencies.md` | Dependencies for each chapter |
| `bd-requirement-mapping-template.md` | FR to UC mapping template |
| `bd-detail-coverage-check.md` | Coverage verification guide |

## Checklist Files

For each design chapter, load the corresponding checklist:

| Chapter | Checklist File |
|---------|----------------|
| Functional Design | `bd-functional-design-checklist.md` |
| Screen Design | `bd-screen-design-checklist.md` |
| Data Design | `bd-data-design-checklist.md` |
| API Design | `bd-api-design-checklist.md` |
| Batch Design | `bd-batch-design-checklist.md` |

## File Creation Order

| # | File/Folder | Dependencies | Structure | DFD Required |
|---|-------------|--------------|-----------|--------------|
| 1 | `_index.md` | - | Single file | - |
| 2 | `01-system-overview.md` | SRS 01, 02 | Single file | - |
| 3 | `02-system-architecture.md` | SRS 03, NFR | Single file | **Level 0 & 1** |
| 4 | `03-functional-design.md` + folder | SRS FR-UC | Main + Folder | **Level 2** |
| 5 | `04-screen-design.md` + folder | 03 | Main + Folder | - |
| 6 | `05-data-design.md` + folder | 03, 04 | Main + Folder | - |
| 7 | `06-api-design.md` + folder | 03, 04, 05 | Main + Folder | - |
| 8 | `07-batch-design.md` + folder | 03, 05, 06 | Main + Folder | - |
| 9 | `08-non-functional.md` | SRS NFR | Single file | - |
| 10 | `09-error-handling.md` | 03, 06 | Single file | - |
| 11 | `10-appendix.md` | All | Single file | - |

## Main + Folder Structure (Chapters 03-07)

For chapters 03-07, use this pattern:

```
XX-design.md          <- Main file: Overview, list, links
XX-design/            <- Detail folder
  _index.md           <- Common specs for the chapter
  {module}-01.md      <- Detail file per module
  {module}-02.md
  ...
```

### Main File Requirements
- Overview section with statistics
- Document structure with links
- List section linking to detail files
- Coverage Summary = 100%

### Detail Folder Requirements
- `_index.md` with common specifications
- Detail files following `{module}-XX.md` naming
- Each item from main list has corresponding detail section

## DFD Requirements

### DFD Level 0 & 1 (In `02-system-architecture.md`)
- Context Diagram (system as single process)
- External Entities (Users, External Systems)
- Data Flow List table
- System DFD with Core Processes
- Data Stores corresponding to tables
- Process/Data Store Definitions

### DFD Level 2 (In `{module}-01.md` files)
Required for:
- Core Business Modules (Must)
- Transaction/Financial Modules (Must)
- Data Processing Modules (Must)
- Security/Compliance Modules (Must)
- User Management Modules (Should)
- Reporting Modules (Should)

## Coverage Check Requirements

| Item | Main File | Detail Folder | Target |
|------|-----------|---------------|--------|
| UC | 03-functional-design.md | 03-functional-design/ | 100% |
| Screen | 04-screen-design.md | 04-screen-design/ | 100% |
| Table | 05-data-design.md | 05-data-design/ | 100% |
| API | 06-api-design.md | 06-api-design/ | 100% |
| Batch | 07-batch-design.md | 07-batch-design/ | 100% |

**CRITICAL**: Coverage < 100% = Document incomplete. Stop and add missing items before continuing.

## Critical Rules

1. **SRS is mandatory** - Must exist before creating BD
2. **Main + Folder Structure** - Chapters 03-07 MUST use this structure
3. **Coverage 100%** - All items must have corresponding details
4. **_index.md in folders** - Each folder MUST have _index.md
5. **Detail File Naming** - Follow convention: {module}-XX.md
6. **Links Valid** - Main file links must point to correct detail files
7. **DFD Required** - MUST have DFD Level 0/1 in Architecture, Level 2 in core modules
