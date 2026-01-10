# 🔧 /fix-tech-debt Workflow - Usage Guide

Workflow để fix technical debt issues một cách có hệ thống với production-ready quality.

---

## 🚀 Quick Start

### Cách 1: Fix issue cụ thể

```
/fix-tech-debt
Issue ID: WP-P1-001-T001
Phase: 1
```

### Cách 2: Auto-select next issue

```
/fix-tech-debt --next
```

### Cách 3: Validate state only (không fix)

```
/fix-tech-debt --verify-state
```

---

## 📋 Workflow Capabilities

### ✅ Automated Steps

1. **Pre-flight Checks**

   - Verify all tracking files exist
   - Collect baseline metrics
   - Check git status clean

2. **Issue Selection**

   - Load context from plan
   - Display DoD criteria
   - Confirm with user

3. **Execute Fix**

   - Run automated fixes (dart fix, etc.)
   - Create files from templates
   - Apply code changes

4. **Verification**

   - Compile & syntax check
   - Run full test suite
   - Compare metrics (before/after)
   - Validate DoD criteria

5. **CI/CD Validation**

   - Commit changes
   - Trigger CI pipeline
   - Wait for green status

6. **Status Update**

   - Update all tracking files:
     - TECH_DEBT_PROGRESS_DASHBOARD.md
     - TECHNICAL_DEBT_RESOLUTION_PLAN.md
     - TECHNICAL_DEBT_PHASE_2_TO_4.md
     - COMPLETION_LOG.md
   - Validate state consistency
   - Generate fix report

7. **Documentation**
   - Update CHANGELOG (if milestone)
   - Clean up temp files
   - Generate summary

### 🤔 Decision Handling

Workflow will **PAUSE and LOG** when encountering:

- Ambiguous requirements
- Multiple valid approaches
- Breaking changes needed
- External dependencies

Decision log location: `docs/decisions/TECH_DEBT_DECISIONS.md`

You will review and decide, then resume workflow.

---

## 📊 Files Managed by Workflow

### Input Files (Read-only)

- `docs/CODE_AUDIT_REPORT_2026-01-10.md` - Reference for findings
- `docs/implementation-plan/TECHNICAL_DEBT_RESOLUTION_PLAN.md` - Phase 1 tasks
- `docs/implementation-plan/TECHNICAL_DEBT_PHASE_2_TO_4.md` - Phases 2-4 tasks

### Output Files (Auto-updated)

- `docs/implementation-plan/TECH_DEBT_PROGRESS_DASHBOARD.md` - Metrics & progress
- `docs/implementation-plan/COMPLETION_LOG.md` - Fix history
- `docs/decisions/TECH_DEBT_DECISIONS.md` - Pending decisions (when needed)
- `docs/reports/FIX_REPORT_YYYYMMDD_HHMMSS.md` - Per-fix reports

### Code Files (Modified)

- `mobile/**/*.dart` - Source code changes
- `pubspec.yaml` - Dependencies
- `.github/workflows/*.yml` - CI config
- `analysis_options.yaml` - Lint config

---

## 🔍 Validation & Quality Gates

### Mandatory Checks (Will FAIL workflow if not met)

✅ **Code Quality:**

- Code compiles without errors
- All tests passing (100% pass rate maintained)
- No increase in errors or warnings
- All DoD criteria met

✅ **State Consistency:**

- All tracking files synchronized
- Checkbox counts match across files
- Metrics consistent

✅ **CI/CD:**

- CI pipeline green
- No new failures introduced

### Warning Checks (Will WARN but not fail)

⚠️ **Code Quality:**

- Slight increase in warnings (<5%)
- Minor documentation gaps

⚠️ **Process:**

- Uncommitted changes in tracking files
- Pending decisions logged

---

## 🎯 Definition of Done (DoD)

Every issue must meet these criteria before marked complete:

### Code Level

- [ ] Code compiles without errors
- [ ] All tests passing (100%)
- [ ] No regressions introduced
- [ ] Specific DoD from plan met

### Process Level

- [ ] Code reviewed (or auto-verified for simple fixes)
- [ ] All tracking files updated
- [ ] State consistency validated
- [ ] Commit created with proper message

### Quality Level

- [ ] CI pipeline green
- [ ] Metrics improved or stable
- [ ] Documentation updated (if applicable)
- [ ] Fix report generated

---

## 📝 Example Workflow Execution

### Scenario: Fix WP-P1-001-T001 (dart fix auto-fixes)

```bash
$ /fix-tech-debt
Issue ID: WP-P1-001-T001
Phase: 1

# Workflow runs:

[Step 0] Pre-flight checks...
✅ All tracking files found
✅ Working directory clean
✅ Baseline collected: 499 errors, 147 tests passing

[Step 1] Loading issue context...
📋 Issue: WP-P1-001-T001
    Task: Run dart fix --apply
    Expected: ~150 issues auto-fixed
    DoD: All auto-fixable resolved, no test regressions

Ready to proceed? y

[Step 2] Executing fix...
Running: dart fix --dry-run
Preview of changes:
[Shows 150+ fixes]

Apply these fixes? y

Running: dart fix --apply
Applied 152 fixes ✅

[Step 3] Verification...
Running: flutter pub get
Running: flutter analyze
Result: 349 errors (was 499) ✅
Running: flutter test
Result: 147/147 passing ✅

DoD Check:
✅ Auto-fixable issues resolved: 152 fixes
✅ No test regressions: 147/147 still passing

[Step 4] CI Validation...
Creating branch: tech-debt/fix-20260110-150401
Committing changes...
Pushing to origin...
CI triggered: https://github.com/.../actions/12345

Waiting for CI... ⏳
CI Result: GREEN ✅

[Step 5] Status Update...
Updating TECH_DEBT_PROGRESS_DASHBOARD.md ✅
Updating TECHNICAL_DEBT_RESOLUTION_PLAN.md ✅
Updating COMPLETION_LOG.md ✅

Validating state consistency...
✅ All files synchronized

[Step 6] Documentation...
Generating fix report... ✅
Report: docs/reports/FIX_REPORT_20260110_150401.md

[Step 7] Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Issue Fixed Successfully: WP-P1-001-T001

📊 Impact:
- Errors: 499 → 349 (-150) ✅
- Warnings: 499 → 450 (-49)
- Tests: 147/147 passing (100%) ✅

📝 Files Updated:
- TECH_DEBT_PROGRESS_DASHBOARD.md ✅
- TECHNICAL_DEBT_RESOLUTION_PLAN.md ✅
- COMPLETION_LOG.md ✅

✅ Verification:
- All tests passing
- No regressions
- CI pipeline green
- State consistency validated

🚀 Next Issue: WP-P1-001-T002
Estimated time: 30 minutes

Continue to next issue? y/n
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🤔 Decision Scenarios

### Scenario 1: Ambiguous Requirement

```
[Step 2] Executing fix...
⚠️  DECISION REQUIRED

The plan says "fix undefined AppTextStyles" but there are 2 options:
A) Import from existing theme/text_styles.dart
B) Create new lib/config/theme/text_styles.dart

🤖 AI Recommendation: Option B
Rationale: Creates centralized theme constants for future use

Decision logged to: docs/decisions/TECH_DEBT_DECISIONS.md

Please review and provide your decision:
1. View full decision log entry
2. Choose Option A
3. Choose Option B
4. Provide custom approach

Your choice: _
```

### Scenario 2: Test Failure

```
[Step 3] Verification...
Running: flutter test
❌ VERIFICATION FAILED

2 tests failed:
- test/features/progress/widgets/xp_chart_test.dart:45
- test/features/progress/widgets/xp_chart_test.dart:62

Error: AxisTitles constructor not found

🔧 Rollback performed ✅

Decision:
This failure suggests fl_chart version incompatibility.

Options:
A) Add fl_chart dependency first (WP-P1-001-T003)
B) Skip this task for now, return later
C) Investigate fl_chart version

🤖 AI Recommendation: Option A
Should fix dependency first, then retry this task.

Logged to: docs/decisions/TECH_DEBT_DECISIONS.md

Your decision: _
```

---

## 🛠️ Manual State Validation

If you want to check state consistency manually:

```bash
cd /d/temp/trial9/SpeakPal

# Run validation script
bash scripts/validate-state.sh

# Output:
# ✅ STATE CONSISTENT - All checks passed!
# or
# ❌ STATE INCONSISTENT - 2 errors, 1 warnings
```

---

## 📞 Support & Troubleshooting

### Issue: Workflow stuck or error

1. Check `docs/decisions/TECH_DEBT_DECISIONS.md` for pending decisions
2. Review latest `docs/reports/FIX_REPORT_*.md`
3. Run `scripts/validate-state.sh`
4. Check git status

### Issue: State inconsistency detected

```bash
# Workflow will stop and log error
# Review the inconsistency:
cat docs/decisions/TECH_DEBT_DECISIONS.md | grep "STATE INCONSISTENCY"

# Fix manually or re-run failed step
```

### Issue: CI pipeline always failing

```bash
# Check if environmental issue or code issue
# Review CI logs
# May need to fix CI configuration first (Phase 0)
```

---

## ✅ Best Practices

1. **Always use workflow for fixes** - Don't manually edit tracking files
2. **Review decisions promptly** - Blocked workflow delays progress
3. **Commit frequently** - Workflow creates commits per issue
4. **Run validation regularly** - `scripts/validate-state.sh`
5. **Read fix reports** - Learn from what worked/didn't work

---

## 🚫 What NOT to Do

❌ **Don't manually update checklists** - Let workflow do it
❌ **Don't skip verification steps** - Production quality requires validation
❌ **Don't fix multiple issues simultaneously** - Sequential is safer
❌ **Don't override DoD** - If not met, fix is not complete
❌ **Don't ignore warnings** - They indicate potential issues

---

**Workflow Version:** 1.0  
**Last Updated:** 2026-01-10  
**Maintained by:** Antigravity AI  
**For questions:** Review `.agent/workflows/fix-tech-debt.md`
