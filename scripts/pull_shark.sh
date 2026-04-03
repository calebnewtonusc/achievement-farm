#!/bin/bash
# Earns: Pull Shark Gold (1,024 merged PRs)
# Usage: bash scripts/pull_shark.sh YOUR_USERNAME YOUR_REPO [START]
#   START is optional — use it to resume if the script stopped (e.g. bash pull_shark.sh user repo 571)
# Runtime: ~1 hour
set -e
USERNAME=${1:?Usage: bash pull_shark.sh USERNAME REPO [START]}
REPO=${2:?Usage: bash pull_shark.sh USERNAME REPO [START]}
START=${3:-1}
FULL_REPO="$USERNAME/$REPO"
TARGET=1024
echo "Pull Shark Gold — merging PRs $START–$TARGET. Takes ~1 hour."
for i in $(seq $START $TARGET); do
  BRANCH="shark/pr-$i"
  git checkout main 2>/dev/null
  git pull origin main --quiet 2>/dev/null
  git branch -D "$BRANCH" 2>/dev/null || true
  git push origin --delete "$BRANCH" 2>/dev/null || true
  git checkout -b "$BRANCH"
  echo "PR $i — $(date)" >> shark.md
  git add shark.md
  git commit -m "feat: shark $i" --quiet
  git push origin "$BRANCH" --quiet 2>/dev/null
  PR_NUM=$(gh pr create --repo "$FULL_REPO" --head "$BRANCH" --base main --title "shark: pr $i" --body "Pull Shark $i" 2>/dev/null | grep -oE '[0-9]+$')
  gh pr merge "$PR_NUM" --repo "$FULL_REPO" --squash 2>/dev/null
  echo "[$i/$TARGET] Merged PR #$PR_NUM"
  git checkout main && git pull origin main --quiet 2>/dev/null
done
echo "Done! Pull Shark Gold earned."
