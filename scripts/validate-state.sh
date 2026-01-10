#!/bin/bash

# State Consistency Validator
# Ensures all tracking files are in sync

set -e

echo "🔍 Validating State Consistency..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# File paths
DASHBOARD="docs/implementation-plan/TECH_DEBT_PROGRESS_DASHBOARD.md"
PLAN_P1="docs/implementation-plan/TECHNICAL_DEBT_RESOLUTION_PLAN.md"
PLAN_P2_4="docs/implementation-plan/TECHNICAL_DEBT_PHASE_2_TO_4.md"
COMPLETION_LOG="docs/implementation-plan/COMPLETION_LOG.md"
DECISIONS="docs/decisions/TECH_DEBT_DECISIONS.md"

# Counters
ERRORS=0
WARNINGS=0

# Check files exist
echo "📁 Checking files exist..."
for file in "$DASHBOARD" "$PLAN_P1" "$PLAN_P2_4" "$COMPLETION_LOG"; do
  if [ ! -f "$file" ]; then
    echo -e "${RED}❌ Missing file: $file${NC}"
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}✅ Found: $file${NC}"
  fi
done

# Count completed tasks in each file
echo ""
echo "📊 Counting completed tasks..."

# Using awk or simple grep pipe to ensure we only get the number
DASHBOARD_COMPLETED=$(grep -c "\- \[x\]" "$DASHBOARD" | awk '{print $NF}' || echo 0)
PLAN_P1_COMPLETED=$(grep -c "\- \[x\]" "$PLAN_P1" | awk '{print $NF}' || echo 0)
PLAN_P2_4_COMPLETED=$(grep -c "\- \[x\]" "$PLAN_P2_4" | awk '{print $NF}' || echo 0)

# Remove any Carriage Return or extra characters
DASHBOARD_COMPLETED=$(echo $DASHBOARD_COMPLETED | tr -d '\r')
PLAN_P1_COMPLETED=$(echo $PLAN_P1_COMPLETED | tr -d '\r')
PLAN_P2_4_COMPLETED=$(echo $PLAN_P2_4_COMPLETED | tr -d '\r')

echo "Dashboard: $DASHBOARD_COMPLETED"
echo "Plan Phase 1: $PLAN_P1_COMPLETED"
echo "Plan Phase 2-4: $PLAN_P2_4_COMPLETED"

# Validate consistency
echo ""
echo "🔐 Validating consistency..."

# Total completed should match across files
TOTAL_PLAN_COMPLETED=$((PLAN_P1_COMPLETED + PLAN_P2_4_COMPLETED))

if [ "$DASHBOARD_COMPLETED" -ne "$TOTAL_PLAN_COMPLETED" ]; then
  echo -e "${RED}❌ INCONSISTENCY DETECTED!${NC}"
  echo "Dashboard shows $DASHBOARD_COMPLETED completed"
  echo "Plans show $TOTAL_PLAN_COMPLETED completed"
  echo "Difference: $((DASHBOARD_COMPLETED - TOTAL_PLAN_COMPLETED))"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✅ Task counts consistent${NC}"
fi

# Check metrics synchronization
echo ""
echo "📈 Checking metrics synchronization..."

# Extract metrics from dashboard - using grep | sed for more portability
DASH_ERRORS=$(grep "Analyze Errors" "$DASHBOARD" | sed -n 's/.*| \([0-9]\+\) |.*/\1/p' || echo "N/A")
DASH_WARNINGS=$(grep "Analyze Warnings" "$DASHBOARD" | sed -n 's/.*| \([0-9]\+\) |.*/\1/p' || echo "N/A")
DASH_TESTS=$(grep "Test Pass Rate" "$DASHBOARD" | sed -n 's/.*| \([0-9]\+%\) |.*/\1/p' || echo "N/A")

echo "Dashboard metrics:"
echo "  - Errors: $DASH_ERRORS"
echo "  - Warnings: $DASH_WARNINGS"
echo "  - Tests: $DASH_TESTS"

# Check completion log has correct entry count
echo ""
echo "📝 Validating completion log..."

COMPLETION_ENTRIES=$(grep -c "^## 202" "$COMPLETION_LOG" | awk '{print $NF}' || echo 0)
COMPLETION_ENTRIES=$(echo $COMPLETION_ENTRIES | tr -d '\r')
echo "Completion log entries: $COMPLETION_ENTRIES"

if [ "$COMPLETION_ENTRIES" -ne "$DASHBOARD_COMPLETED" ]; then
  echo -e "${YELLOW}⚠️  Warning: Completion log entries ($COMPLETION_ENTRIES) don't match dashboard ($DASHBOARD_COMPLETED)${NC}"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for pending decisions
echo ""
echo "🤔 Checking for pending decisions..."

if [ -f "$DECISIONS" ]; then
  PENDING=$(grep -c "Status: PENDING_USER_DECISION" "$DECISIONS" | awk '{print $NF}' || echo 0)
  PENDING=$(echo $PENDING | tr -d '\r')
  if [ "$PENDING" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $PENDING pending decisions require attention${NC}"
    echo "See: $DECISIONS"
    WARNINGS=$((WARNINGS + 1))
  else
    echo -e "${GREEN}✅ No pending decisions${NC}"
  fi
fi

# Check git status
echo ""
echo "🔄 Checking git status..."

if ! git diff --quiet "$DASHBOARD" "$PLAN_P1" "$PLAN_P2_4" "$COMPLETION_LOG"; then
  echo -e "${YELLOW}⚠️  Uncommitted changes in tracking files${NC}"
  git status --short "$DASHBOARD" "$PLAN_P1" "$PLAN_P2_4" "$COMPLETION_LOG"
  WARNINGS=$((WARNINGS + 1))
else
  echo -e "${GREEN}✅ All tracking files committed${NC}"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VALIDATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✅ STATE CONSISTENT - All checks passed!${NC}"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠️  STATE CONSISTENT - $WARNINGS warnings${NC}"
  exit 0
else
  echo -e "${RED}❌ STATE INCONSISTENT - $ERRORS errors, $WARNINGS warnings${NC}"
  echo ""
  echo "Action required:"
  echo "1. Review error messages above"
  echo "2. Manually sync tracking files if needed"
  echo "3. Re-run validation"
  exit 1
fi
