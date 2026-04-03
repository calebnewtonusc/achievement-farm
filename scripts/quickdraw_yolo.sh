#!/bin/bash
# Earns: Quickdraw + YOLO
# Usage: bash scripts/quickdraw_yolo.sh YOUR_USERNAME YOUR_REPO
set -e
USERNAME=${1:?Usage: bash quickdraw_yolo.sh USERNAME REPO}
REPO=${2:?Usage: bash quickdraw_yolo.sh USERNAME REPO}
FULL_REPO="$USERNAME/$REPO"
echo "=== Quickdraw ==="
ISSUE_NUM=$(gh issue create --repo "$FULL_REPO" --title "Quickdraw test" --body "Opening and closing immediately." | grep -oE '[0-9]+$')
gh issue close "$ISSUE_NUM" --repo "$FULL_REPO"
echo "Quickdraw done — opened and closed issue #$ISSUE_NUM"
echo ""
echo "=== YOLO ==="
BRANCH="yolo/pr-$(date +%s)"
git checkout main && git pull origin main --quiet 2>/dev/null
git checkout -b "$BRANCH"
echo "YOLO $(date)" >> yolo.md
git add yolo.md && git commit -m "yolo: first pr" --quiet
git push origin "$BRANCH" --quiet
PR_NUM=$(gh pr create --repo "$FULL_REPO" --head "$BRANCH" --base main --title "yolo: merge without review" --body "YOLO" | grep -oE '[0-9]+$')
gh pr merge "$PR_NUM" --repo "$FULL_REPO" --squash
echo "YOLO done — merged PR #$PR_NUM without review"
git checkout main && git pull origin main --quiet 2>/dev/null
echo "Done! Quickdraw + YOLO earned."
