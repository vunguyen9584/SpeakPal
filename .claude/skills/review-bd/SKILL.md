---
name: review-bd
description: Skill for reviewing Basic Design Document (BD) using standard checklists. Use when the user wants to review/validate/check Basic Design documentation for quality and completeness. Triggers on requests like "review BD", "check basic design", "validate BD quality".
---

# Review Basic Design Document Skill

This skill provides comprehensive guidance for reviewing Basic Design Document (BD) using standard checklists and validation criteria.

## Purpose

Review and validate BD documents ensuring:
- Correct file/folder structure (Main + Folder pattern)
- 100% coverage of all requirements
- Valid cross-references and links
- DFD completeness at all required levels
- Consistency with SRS

## When to Use

- Reviewing existing Basic Design for quality
- Validating BD before proceeding to Detailed Design
- Checking coverage and completeness of BD

## Workflow Reference

Execute the workflow defined in `.agent/workflows/review-bd.md`.

## Key Steps

1. **Collect Parameters**: Ask for BD folder path
2. **Validate Files**: Confirm BD folder exists at `[folder]/基本設計書/`
3. **Run Validation Script**: Execute `validate-bd-coverage.js` if available
4. **Load References**: Load checklists from `.ai-instructions/`
5. **Check Structure**: Verify Main + Folder structure for chapters 03-07
6. **Coverage Check**: Ensure 100% coverage (CRITICAL)
7. **Review Sections**: Check each section with checklists
8. **Cross-Reference Check**: Verify FR→UC, UC→Screen, UC→API mappings
9. **Generate Report**: Create `basic-design-review-report.md`
10. **Summary**: Display verdict and issues

## Instruction Files Reference

Load these files from `.ai-instructions/`:

| File | Purpose |
|------|---------|
| `bd-file-folder-structure.md` | **CRITICAL** Structure standard |
| `bd-checklist-summary.md` | Summary of all checklists |
| `bd-review-steps-guide.md` | Step-by-step review guide |
| `bd-detail-coverage-check.md` | Coverage verification |
| `bd-review-output-template.md` | Report template |

## Structure Check (Step 5)

### 5.1 Main + Folder Existence

| # | Check | Path |
|---|-------|------|
| 1 | Main file | `03-functional-design.md` |
| 2 | Detail folder | `03-functional-design/` |
| 3 | Main file | `04-screen-design.md` |
| 4 | Detail folder | `04-screen-design/` |
| 5 | Main file | `05-data-design.md` |
| 6 | Detail folder | `05-data-design/` |
| 7 | Main file | `06-api-design.md` |
| 8 | Detail folder | `06-api-design/` |
| 9 | Main file | `07-batch-design.md` |
| 10 | Detail folder | `07-batch-design/` |

### 5.2 Check _index.md in Each Folder

| Folder | Expected Content |
|--------|------------------|
| 03-functional-design/ | UC patterns, common flows |
| 04-screen-design/ | Screen layouts, components |
| 05-data-design/ | ER diagrams, common columns |
| 06-api-design/ | Auth, response format, errors |
| 07-batch-design/ | Exclusive control, Cron expressions |

### 5.3 Main File Sections

Each main file must have:
- Overview with statistics
- Document structure with links
- List with links to detail files
- Coverage Summary = 100%

## DFD Review Checklist

### DFD Level 0 & 1 (Required in 02-system-architecture)

| Check | Content |
|-------|---------|
| [ ] | Context Diagram (System as single process) |
| [ ] | External Entities (Users, External Systems) |
| [ ] | Data Flow List table (From/To/Content) |
| [ ] | System DFD (Core Processes) |
| [ ] | Data Stores matching 05-data-design |
| [ ] | Process Definition table |
| [ ] | Data Store Definition table |

### DFD Level 2 (By module type in 03-functional-design/)

| Module Type | Content Required | Priority |
|-------------|------------------|----------|
| Core Business | Sub-process diagram + definitions | Must |
| Transaction/Financial | Sub-process diagram + definitions | Must |
| Data Processing | Sub-process diagram + definitions | Must |
| Security/Compliance | Sub-process diagram + definitions | Must |
| User Management | Sub-process diagram (if complex) | Should |
| Reporting | Sub-process diagram (if complex) | Should |

## Coverage Check (CRITICAL - Step 6)

### Counting Method with File/Folder Structure

```
Main file: Count items in list section (一覧)
Detail files: Count "## [ID]:" sections in {module}-XX.md files
Coverage = Detail sections / List items × 100%
```

### Coverage Table

| Item | Main File | Detail Folder | In List | Detailed | Coverage | OK? |
|------|-----------|---------------|---------|----------|----------|-----|
| UC | 03-functional-design.md | 03-functional-design/ | ___ | ___ | ___% | [ ] |
| Screen | 04-screen-design.md | 04-screen-design/ | ___ | ___ | ___% | [ ] |
| Table | 05-data-design.md | 05-data-design/ | ___ | ___ | ___% | [ ] |
| API | 06-api-design.md | 06-api-design/ | ___ | ___ | ___% | [ ] |
| Batch | 07-batch-design.md | 07-batch-design/ | ___ | ___ | ___% | [ ] |

**WARNING**: Coverage < 100% = **FAIL** regardless of other criteria.

## Cross-Reference Check (Step 8)

| From → To | Check |
|-----------|-------|
| FR → UC | All FRs have UC |
| UC → Screen | All UCs with UI have Screen |
| UC → API | All UCs have API |
| Screen → Table | Input fields have column |
| FR → Batch | Background FRs have batch |

## Link Integrity Check

| Check | Description |
|-------|-------------|
| [ ] | Links in main file point to correct detail files |
| [ ] | Links in detail files point back to main file |
| [ ] | Links between detail files are valid |
| [ ] | No broken links |

## FAIL Conditions

| Condition | Verdict |
|-----------|---------|
| Structure not Main + Folder for 03-07 | FAIL |
| Missing _index.md in any folder | FAIL |
| Coverage < 100% for any item | FAIL |
| Missing DFD Level 0/1 in Architecture | FAIL |
| Missing DFD Level 2 in core modules | FAIL |
| Broken links | FAIL |
| Missing cross-references | FAIL |

## Report Output

Generate report at `[folder]/basic-design-review-report.md` using template from `bd-review-output-template.md`.

### Summary Format

```markdown
## BD Review Summary

### Structure Check
- Main Files: X/5
- Detail Folders: X/5
- _index.md files: X/5

### Coverage
| Item | List | Detail | Coverage | Status |
|------|------|--------|----------|--------|
| UC | X | X | 100% | PASS/FAIL |
| Screen | X | X | 100% | PASS/FAIL |
| Table | X | X | 100% | PASS/FAIL |
| API | X | X | 100% | PASS/FAIL |
| Batch | X | X | 100% | PASS/FAIL |

### DFD Check
| Level | Location | Status |
|-------|----------|--------|
| Level 0 | 02-system-architecture | PASS/FAIL |
| Level 1 | 02-system-architecture | PASS/FAIL |
| Level 2 | Core modules | PASS/FAIL |

### Issues Found
- [List issues if any]

### Verdict: PASS / FAIL
```

## Critical Rules

1. **Structure First** - Check file/folder structure BEFORE reviewing content
2. **Main + Folder** - Chapters 03-07 MUST use this structure
3. **_index.md Required** - Each detail folder MUST have _index.md
4. **Coverage 100%** - All items must have corresponding details
5. **Links Valid** - All links must be valid
6. **Naming Convention** - Detail files follow {module}-XX.md format
7. **DFD Required** - Must have DFD Level 0/1 in Architecture, Level 2 in core modules
