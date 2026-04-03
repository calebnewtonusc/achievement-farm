#!/bin/bash
# Earns: Pair Extraordinaire Gold (48 co-authored merged PRs)
# Usage: bash scripts/pair_extraordinaire.sh YOUR_USERNAME YOUR_REPO [START]
#   START is optional — use to resume or continue from a given number (e.g. bash pair_extraordinaire.sh user repo 51)
set -e
USERNAME=${1:?Usage: bash pair_extraordinaire.sh USERNAME REPO [START]}
REPO=${2:?Usage: bash pair_extraordinaire.sh USERNAME REPO [START]}
START=${3:-1}
FULL_REPO="$USERNAME/$REPO"
TARGET=$((START + 49))
echo "Pair Extraordinaire Gold — merging PRs $START–$TARGET co-authored PRs."
for i in $(seq $START $TARGET); do
  BRANCH="pair/pr-$i"
  git checkout main 2>/dev/null && git pull origin main --quiet 2>/dev/null
  git checkout -b "$BRANCH" 2>/dev/null
  echo "Pair $i — $(date)" >> pair.md
  git add pair.md
  git commit -m "feat: pair $i

Co-authored-by: github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>"
  git push origin "$BRANCH" --quiet 2>/dev/null
  PR_NUM=$(gh pr create --repo "$FULL_REPO" --head "$BRANCH" --base main --title "pair: pr $i" --body "Co-authored PR $i" 2>/dev/null | grep -oE '[0-9]+$')
  gh pr merge "$PR_NUM" --repo "$FULL_REPO" --merge 2>/dev/null
  echo "[$i/$TARGET] Merged pair PR #$PR_NUM"
  git checkout main && git pull origin main --quiet 2>/dev/null
done
echo "Done! Pair Extraordinaire Gold earned."
