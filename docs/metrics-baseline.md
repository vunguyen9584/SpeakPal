# 📊 Technical Debt Baseline Metrics (W0)

**Date:** 2026-01-10
**Codebase Version:** main@b718af1
**Tooling:** Flutter 3.x, flutter analyze, flutter test

---

## 📋 Summary Table

| Metric                       | Value          | Target (Phase 4) | Status                |
| :--------------------------- | :------------- | :--------------- | :-------------------- |
| **Flutter Analyze Errors**   | 289            | 0                | 🔴 Critical           |
| **Flutter Analyze Warnings** | 20             | < 50             | 🟡 Good               |
| **Flutter Analyze Infos**    | 190            | < 100            | 🟡 Normal             |
| **Test Pass Rate**           | 100% (147/147) | 100%             | ✅ Excellent          |
| **Code Coverage**            | ~60%           | > 70%            | 🟡 Improvement needed |
| **TODO Markers**             | 80             | < 10             | 🔴 High debt          |
| **Print Statements**         | 19             | 0                | 🔴 Non-standard       |
| **Hardcoded URLs**           | ~3             | 0                | 🔴 Security risk      |

---

## 🔍 Detail breakdown

### 1. Analysis Findings

- **Errors:** Primarily due to deprecated member usage updated to values and unused imports that became errors in CI.
- **Warnings:** Unused variables and parameter mismatches.
- **Infos:** Design system inconsistencies (deprecated colors).

### 2. Testing State

- 147 tests verified and passing locally.
- Coverage report includes all feature directories.

### 3. Source Code Quality

- 80 TODO markers across 24 files.
- 19 print statements in critical service logic (Socket, AudioPlayer).
