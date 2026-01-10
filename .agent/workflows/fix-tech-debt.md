---
description: Fix Technical Debt Issues - Production-Ready với Automated Verification & Status Tracking
---

# /fix-tech-debt - Technical Debt Resolution Workflow

## Mục đích

Workflow này thực thi việc fix technical debt issues một cách có hệ thống:

- ✅ Production-ready fixes (không quick fix)
- ✅ Automated verification sau mỗi fix
- ✅ Consistent status updates across all tracking files
- ✅ Decision logging cho unresolved questions
- ✅ State consistency validation

---

## Input Required

User phải cung cấp:

```
/fix-tech-debt
Issue ID: [WP-P1-001-T001 hoặc Audit #X]
Phase: [0/1/2/3/4]
```

Hoặc để auto-select next issue:

```
/fix-tech-debt --next
```

---

## Workflow Steps

### Step 0: Pre-Flight Checks

**Role:** Senior Quality Engineer

Trước khi bắt đầu fix bất kỳ issue nào, verify:

1. **Read Current State:**

   ```bash
   # Check files exist
   docs/implementation-plan/TECH_DEBT_PROGRESS_DASHBOARD.md
   docs/implementation-plan/TECHNICAL_DEBT_RESOLUTION_PLAN.md
   docs/implementation-plan/TECHNICAL_DEBT_PHASE_2_TO_4.md
   docs/CODE_AUDIT_REPORT_2026-01-10.md
   ```

2. **Validate Baseline:**

   ```bash
   cd mobile
   flutter analyze > /tmp/current_analyze.txt
   flutter test > /tmp/current_test.txt

   # Extract metrics
   ERRORS=$(grep -c "error •" /tmp/current_analyze.txt || echo 0)
   WARNINGS=$(grep -c "warning •" /tmp/current_analyze.txt || echo 0)
   TESTS_PASSING=$(grep -oP "All tests passed!" /tmp/current_test.txt | wc -l)
   ```

3. **Check for Conflicts:**

   ```bash
   git status
   # Ensure working directory clean
   # Ensure on correct branch (e.g., tech-debt/phase-1)
   ```

4. **Create Decision Log if not exists:**
   ```bash
   mkdir -p docs/decisions
   touch docs/decisions/TECH_DEBT_DECISIONS.md
   ```

**Exit Criteria:**

- ✅ All tracking files exist and readable
- ✅ Working directory clean
- ✅ Baseline metrics collected
- ✅ Decision log ready

**If Failed:**

- ❌ STOP workflow
- ❌ Create error report in `docs/decisions/WORKFLOW_ERROR_$(date +%Y%m%d_%H%M%S).md`
- ❌ Notify user

---

### Step 1: Issue Selection & Context Loading

**Role:** Project Coordinator

1. **If user provided Issue ID:**

   - Extract from TECHNICAL_DEBT_RESOLUTION_PLAN.md hoặc PHASE_2_TO_4.md
   - Load full context (description, DoD, code examples)

2. **If --next flag:**

   - Read TECH_DEBT_PROGRESS_DASHBOARD.md
   - Find first unchecked task trong current active phase
   - Extract Issue ID

3. **Load Issue Details:**

   ```markdown
   ## Issue Context

   - **ID:** [WP-P1-001-T001]
   - **Phase:** [1]
   - **Work Package:** [WP-P1-001: Flutter Analyze Error Resolution]
   - **Task:** [Stage 1: Run dart fix]
   - **Owner:** [Senior Flutter Developer]
   - **Audit IDs:** [#1, #12, #13]
   - **Expected Outcome:** [~100-150 issues auto-fixed]
   - **DoD Criteria:**
     - [ ] All auto-fixable issues resolved
     - [ ] No test regressions
     - [ ] CI pipeline green
   ```

4. **Display to User:**

   ```
   🎯 Next Issue to Fix:
   ID: WP-P1-001-T001
   Task: Run dart fix --apply
   Phase: 1 (Critical Stability Fixes)

   Context loaded from plan.
   Ready to proceed? (y/n)
   ```

**Exit Criteria:**

- ✅ Issue context fully loaded
- ✅ User confirmed to proceed

---

### Step 2: Execute Fix

**Role:** Senior Software Engineer (role varies by issue type)

**Execute based on issue type:**

#### Type A: Automated Code Fix (e.g., dart fix)

```bash
cd mobile

# Step 2.1: Preview changes
dart fix --dry-run > /tmp/fix_preview_$(date +%Y%m%d_%H%M%S).txt

# Step 2.2: Show preview to user
echo "Preview of changes:"
head -50 /tmp/fix_preview_*.txt

# Step 2.3: Ask confirmation
read -p "Apply these fixes? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ]; then
  # Step 2.4: Apply fixes
  dart fix --apply

  # Step 2.5: Run pub get
  flutter pub get
fi
```

#### Type B: Manual Code Implementation (e.g., LoggerService)

```bash
# Step 2.1: Copy code template from plan
# (AI will extract code from TECHNICAL_DEBT_RESOLUTION_PLAN.md)

# Example: Create LoggerService
cat > lib/core/utils/logger_service.dart << 'EOF'
[Code from plan]
EOF

# Step 2.2: Show created file
echo "Created: lib/core/utils/logger_service.dart"
```

#### Type C: Dependency Addition

```bash
# Step 2.1: Modify pubspec.yaml
# Add dependency

# Step 2.2: Run pub get
flutter pub get
```

#### Type D: Configuration Change

```bash
# Modify config files
# Update .github/workflows/*, analysis_options.yaml, etc.
```

**Decision Point:**

```
If encountering ambiguity or unclear requirement:
1. STOP execution
2. Log to docs/decisions/TECH_DEBT_DECISIONS.md:
   ---
   Date: 2026-01-10 15:04
   Issue: WP-P1-001-T001
   Question: [Describe ambiguity]
   Options:
     A) [Option 1]
     B) [Option 2]
   Recommendation: [AI's recommendation with rationale]
   Status: PENDING_USER_DECISION
   ---
3. Return control to user
```

**Exit Criteria:**

- ✅ Code changes applied
- ✅ Files created/modified as per plan
- ✅ No ambiguities encountered OR logged in decision file

---

### Step 3: Verification & Testing

**Role:** QA Engineer

**Critical:** This step ensures production-ready quality.

#### 3.1: Syntax & Compilation Check

```bash
cd mobile

# Clean build
flutter clean
flutter pub get

# Check for compilation errors
flutter analyze --no-pub > /tmp/analyze_after_fix.txt 2>&1
ANALYZE_EXIT_CODE=$?

if [ $ANALYZE_EXIT_CODE -ne 0 ]; then
  echo "❌ VERIFICATION FAILED: Compilation errors"
  cat /tmp/analyze_after_fix.txt
  exit 1
fi
```

#### 3.2: Test Execution

```bash
# Run full test suite
flutter test --coverage > /tmp/test_after_fix.txt 2>&1
TEST_EXIT_CODE=$?

if [ $TEST_EXIT_CODE -ne 0 ]; then
  echo "❌ VERIFICATION FAILED: Test failures"
  cat /tmp/test_after_fix.txt
  exit 1
fi

# Check test count didn't decrease
TESTS_BEFORE=$(grep -oP '\d+(?= tests)' /tmp/current_test.txt | head -1)
TESTS_AFTER=$(grep -oP '\d+(?= tests)' /tmp/test_after_fix.txt | head -1)

if [ "$TESTS_AFTER" -lt "$TESTS_BEFORE" ]; then
  echo "⚠️  WARNING: Test count decreased ($TESTS_BEFORE → $TESTS_AFTER)"
  # Log to decision file
fi
```

#### 3.3: Metrics Comparison

```bash
# Compare analyze results
ERRORS_BEFORE=$(grep -c "error •" /tmp/current_analyze.txt || echo 0)
ERRORS_AFTER=$(grep -c "error •" /tmp/analyze_after_fix.txt || echo 0)

WARNINGS_BEFORE=$(grep -c "warning •" /tmp/current_analyze.txt || echo 0)
WARNINGS_AFTER=$(grep -c "warning •" /tmp/analyze_after_fix.txt || echo 0)

echo "📊 Metrics Change:"
echo "Errors: $ERRORS_BEFORE → $ERRORS_AFTER"
echo "Warnings: $WARNINGS_BEFORE → $WARNINGS_AFTER"
echo "Tests: $TESTS_BEFORE → $TESTS_AFTER"

# Validate improvement or no regression
if [ "$ERRORS_AFTER" -gt "$ERRORS_BEFORE" ]; then
  echo "❌ REGRESSION: Errors increased!"
  exit 1
fi
```

#### 3.4: Definition of Done Check

Load DoD criteria from plan và check each:

```markdown
DoD for WP-P1-001-T001:

- [ ] All auto-fixable issues resolved ← Check: errors decreased?
- [ ] No test regressions ← Check: all tests passing?
- [ ] CI pipeline green ← Will check in next step
```

**If any DoD criteria not met:**

```
1. ROLLBACK changes: git reset --hard HEAD
2. Log failure reason to docs/decisions/TECH_DEBT_DECISIONS.md
3. Return to user with failure report
```

**Exit Criteria:**

- ✅ Code compiles without errors
- ✅ All tests passing (100%)
- ✅ Metrics improved or stable (no regression)
- ✅ All DoD criteria met

---

### Step 4: CI/CD Validation (if applicable)

**Role:** DevOps Engineer

```bash
# Commit changes to temporary branch
git checkout -b tech-debt/fix-$(date +%Y%m%d-%H%M%S)
git add .
git commit -m "fix: [Issue ID] - [Brief description]

[Detailed commit message from plan]

Metrics:
- Errors: $ERRORS_BEFORE → $ERRORS_AFTER
- Warnings: $WARNINGS_BEFORE → $WARNINGS_AFTER
- Tests: $TESTS_BEFORE/$TESTS_AFTER passing

DoD: All criteria met ✅

Ref: TECHNICAL_DEBT_RESOLUTION_PLAN.md WP-[ID]"

# Push to trigger CI
git push origin tech-debt/fix-$(date +%Y%m%d-%H%M%S)

# Wait for CI result (or return URL for user to check)
echo "🚀 CI Pipeline triggered"
echo "Check: https://github.com/[repo]/actions"
```

**Decision Point:**

```
If CI fails:
1. Review CI logs
2. If fixable immediately → fix and re-run
3. If needs investigation:
   - Log to decision file
   - Mark issue as BLOCKED
   - Return to user
```

**Exit Criteria:**

- ✅ CI pipeline green (all checks passed)
- ✅ No new warnings introduced

---

### Step 5: Status Update & Synchronization

**Role:** Project Manager

**Critical:** Update ALL tracking files consistently.

#### 5.1: Update Progress Dashboard

```bash
# File: docs/implementation-plan/TECH_DEBT_PROGRESS_DASHBOARD.md

# Update metrics table
sed -i "s/| Analyze Errors.*| [0-9]* |/| Analyze Errors | $ERRORS_AFTER |/" TECH_DEBT_PROGRESS_DASHBOARD.md

# Update issue count
ISSUES_RESOLVED=$((ISSUES_RESOLVED + 1))
sed -i "s/Resolved | 0 | 148 | 0%/Resolved | $ISSUES_RESOLVED | 148 | $(($ISSUES_RESOLVED * 100 / 148))%/" TECH_DEBT_PROGRESS_DASHBOARD.md

# Update WP status to ✅
sed -i "s/- \[ \] T001: .*/- [x] T001: [Task name] ✅ Completed $(date +%Y-%m-%d)/" TECH_DEBT_PROGRESS_DASHBOARD.md
```

#### 5.2: Update Resolution Plan

```bash
# File: docs/implementation-plan/TECHNICAL_DEBT_RESOLUTION_PLAN.md

# Mark task as complete
sed -i "s/- \[ \] \*\*T001: .*/- [x] **T001: [Task name]** ✅ $(date +%Y-%m-%d)/" TECHNICAL_DEBT_RESOLUTION_PLAN.md

# Update progress counter
sed -i "s/\*\*Progress:\*\* 0\/4 tasks/\*\*Progress:\*\* 1\/4 tasks/" TECHNICAL_DEBT_RESOLUTION_PLAN.md
```

#### 5.3: Update Phase 2-4 File (if applicable)

```bash
# Similar updates to TECHNICAL_DEBT_PHASE_2_TO_4.md
```

#### 5.4: Create Completion Note

```bash
cat >> docs/implementation-plan/COMPLETION_LOG.md << EOF
---
## $(date +%Y-%m-%d\ %H:%M:%S) - [Issue ID] Completed

**Task:** [Task name]
**Phase:** [1]
**Owner:** [Developer name]

**Changes:**
- [List of files changed]
- [Key modifications]

**Metrics Impact:**
- Errors: $ERRORS_BEFORE → $ERRORS_AFTER (Δ: $(($ERRORS_BEFORE - $ERRORS_AFTER)))
- Warnings: $WARNINGS_BEFORE → $WARNINGS_AFTER
- Tests: $TESTS_AFTER passing ✅

**Verification:**
- ✅ All tests passing
- ✅ No regressions
- ✅ CI pipeline green
- ✅ DoD criteria met

**Commit:** $(git rev-parse --short HEAD)
**Branch:** $(git branch --show-current)

---
EOF
```

#### 5.5: State Consistency Validation

```bash
# Verify no conflicting states across files

# Count checkboxes in each file
DASHBOARD_CHECKED=$(grep -c "\[x\]" TECH_DEBT_PROGRESS_DASHBOARD.md || echo 0)
PLAN_CHECKED=$(grep -c "\[x\]" TECHNICAL_DEBT_RESOLUTION_PLAN.md || echo 0)

# They should match
if [ "$DASHBOARD_CHECKED" -ne "$PLAN_CHECKED" ]; then
  echo "⚠️  STATE INCONSISTENCY DETECTED!"
  echo "Dashboard: $DASHBOARD_CHECKED tasks completed"
  echo "Plan: $PLAN_CHECKED tasks completed"

  # Log to decision file
  cat >> docs/decisions/TECH_DEBT_DECISIONS.md << EOF
---
CRITICAL: State Inconsistency Detected
Date: $(date +%Y-%m-%d\ %H:%M:%S)
Dashboard completed tasks: $DASHBOARD_CHECKED
Plan completed tasks: $PLAN_CHECKED
Recommendation: Manual review required
Status: REQUIRES_USER_INTERVENTION
---
EOF

  exit 1
fi

echo "✅ State consistency validated"
```

**Exit Criteria:**

- ✅ All tracking files updated
- ✅ Metrics synchronized across all files
- ✅ No state inconsistencies detected
- ✅ Completion logged

---

### Step 6: Cleanup & Documentation

**Role:** Documentation Specialist

#### 6.1: Update README/CHANGELOG (if major milestone)

```bash
# If this completes a full Work Package:
if [ "$(grep '\[x\]' WP-section | wc -l)" -eq "$(grep -E '\[ \]|\[x\]' WP-section | wc -l)" ]; then
  echo "🎉 Work Package completed!"

  # Update CHANGELOG
  cat >> CHANGELOG.md << EOF
## [Unreleased]
### Fixed
- [WP-P1-001] Flutter Analyze Error Resolution
  - Resolved 150+ analyze errors via dart fix
  - Achieved 0 compilation errors
  - Maintained 100% test pass rate
EOF
fi
```

#### 6.2: Clean up temporary files

```bash
rm -f /tmp/current_analyze.txt
rm -f /tmp/current_test.txt
rm -f /tmp/analyze_after_fix.txt
rm -f /tmp/test_after_fix.txt
rm -f /tmp/fix_preview_*.txt
```

#### 6.3: Generate Summary Report

```bash
cat > docs/reports/FIX_REPORT_$(date +%Y%m%d_%H%M%S).md << EOF
# Fix Report: [Issue ID]

**Date:** $(date +%Y-%m-%d\ %H:%M:%S)
**Duration:** [calculated from start time]
**Status:** ✅ COMPLETED

## Changes Summary
- Files modified: [count]
- Lines added: [from git diff]
- Lines removed: [from git diff]

## Metrics Impact
| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Errors | $ERRORS_BEFORE | $ERRORS_AFTER | $(($ERRORS_BEFORE - $ERRORS_AFTER)) |
| Warnings | $WARNINGS_BEFORE | $WARNINGS_AFTER | $(($WARNINGS_BEFORE - $WARNINGS_AFTER)) |
| Tests | $TESTS_BEFORE | $TESTS_AFTER | 0 |

## Verification
- [x] Code compiles
- [x] Tests passing (100%)
- [x] No regressions
- [x] CI pipeline green
- [x] DoD criteria met
- [x] Tracking files updated

## Next Steps
- Next issue: [auto-calculated from dashboard]
- Estimated time: [from plan]
EOF
```

**Exit Criteria:**

- ✅ Documentation updated
- ✅ Temporary files cleaned
- ✅ Fix report generated

---

### Step 7: Final Report to User

**Display Summary:**

```
✅ Issue Fixed Successfully: WP-P1-001-T001

📊 Impact:
- Errors: 499 → 349 (-150) ✅
- Warnings: 499 → 450 (-49)
- Tests: 147/147 passing (100%) ✅

📝 Files Updated:
- ✅ TECH_DEBT_PROGRESS_DASHBOARD.md
- ✅ TECHNICAL_DEBT_RESOLUTION_PLAN.md
- ✅ COMPLETION_LOG.md

✅ Verification:
- All tests passing
- No regressions
- CI pipeline green
- State consistency validated

🚀 Next Issue: WP-P1-001-T002
Estimated time: 30 minutes

Continue to next issue? (y/n)
```

**Return artifacts:**

- Fix report path
- Commit hash
- CI pipeline URL
- Next issue details

---

## Error Handling & Decision Logging

### When to Log Decision

Log to `docs/decisions/TECH_DEBT_DECISIONS.md` when:

1. **Ambiguous Requirement:**

   - Plan says "fix error" but multiple approaches possible
   - No clear guidance in documentation

2. **Breaking Change Required:**

   - Fix requires API change
   - May affect other features

3. **External Dependency:**

   - Backend API not ready
   - Third-party service unavailable

4. **Unexpected Behavior:**

   - Tests fail unexpectedly
   - Metrics worsen instead of improve

5. **State Inconsistency:**
   - Tracking files out of sync
   - Git conflicts

### Decision Log Template

```markdown
---
## Decision Required: [Brief title]

**Date:** 2026-01-10 15:04:01
**Issue:** WP-P1-001-T001
**Phase:** 1
**Reporter:** Antigravity AI Workflow

### Context
[Detailed description of the situation]

### Question
[Specific question requiring user decision]

### Options
**Option A:** [Description]
- Pros: [list]
- Cons: [list]

**Option B:** [Description]
- Pros: [list]
- Cons: [list]

### AI Recommendation
[Recommended option with detailed rationale]

### Impact Assessment
- **Blocking:** [Yes/No]
- **Affected components:** [List]
- **Risk level:** [Low/Medium/High]

### Status
`PENDING_USER_DECISION`

### User Decision (to be filled)
- [ ] Option A
- [ ] Option B
- [ ] Other: ___________

**Decided on:** [Date/Time]
**Rationale:** [User's reasoning]

---
```

---

## Rollback Procedure

If verification fails at any step:

```bash
# 1. Rollback code changes
git reset --hard HEAD
git clean -fd

# 2. Restore working directory
flutter pub get
flutter clean

# 3. Log failure
cat >> docs/decisions/TECH_DEBT_DECISIONS.md << EOF
---
## Fix Failure: [Issue ID]
Date: $(date)
Reason: [Detailed failure reason]
Step failed: [Step number]
Rollback: Complete ✅
Status: REQUIRES_INVESTIGATION
---
EOF

# 4. Update tracking files to mark as failed
# Mark issue as ⚠️ BLOCKED

# 5. Generate failure report
[Create detailed failure report]
```

---

## Usage Examples

### Example 1: Fix specific issue

```bash
/fix-tech-debt
Issue ID: WP-P1-001-T001
Phase: 1
```

### Example 2: Auto-select next issue

```bash
/fix-tech-debt --next
```

### Example 3: Verify state consistency only

```bash
/fix-tech-debt --verify-state
```

---

## Quality Gates

**Workflow MUST NOT proceed if:**

- ❌ Tests fail
- ❌ Errors increase
- ❌ State inconsistency detected
- ❌ DoD criteria not met
- ❌ User decision pending

**Workflow CAN proceed with warning if:**

- ⚠️ Warnings increase slightly (<5%)
- ⚠️ Minor documentation incomplete
- ⚠️ CI pipeline not available (local validation passed)

---

## Post-Execution Checklist

After each issue fix:

- [x] Code changes committed
- [x] All tests passing
- [x] Metrics improved/stable
- [x] Tracking files updated (all of them)
- [x] State consistency verified
- [x] CI pipeline green
- [x] Documentation updated
- [x] Fix report generated
- [x] Next issue identified

---

**Workflow Owner:** Antigravity AI  
**Maintained by:** SpeakPal Mobile Team  
**Version:** 1.0  
**Last Updated:** 2026-01-10
