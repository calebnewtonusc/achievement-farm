#!/bin/bash
# Earns: Galaxy Brain Gold (32 accepted Q&A answers)
# Usage: bash scripts/galaxy_brain.sh YOUR_USERNAME YOUR_REPO
set -e
USERNAME=${1:?Usage: bash galaxy_brain.sh USERNAME REPO}
REPO=${2:?Usage: bash galaxy_brain.sh USERNAME REPO}
TARGET=32
echo "Galaxy Brain Gold — creating $TARGET accepted Q&A discussions."
gh api "repos/$USERNAME/$REPO" -X PATCH -f has_discussions=true > /dev/null
REPO_ID=$(gh api "repos/$USERNAME/$REPO" --jq '.node_id')
QA_CATEGORY=$(gh api graphql -f query="{ repository(owner: \"$USERNAME\", name: \"$REPO\") { discussionCategories(first: 10) { nodes { id name } } } }" --jq '.data.repository.discussionCategories.nodes[] | select(.name == "Q&A") | .id')
for i in $(seq 1 $TARGET); do
  sleep 3
  DISC=$(gh api graphql -f query="mutation { createDiscussion(input: { repositoryId: \"$REPO_ID\", categoryId: \"$QA_CATEGORY\", title: \"Question $i\", body: \"How does this work? ($i)\" }) { discussion { id number } } }" --jq '.data.createDiscussion.discussion')
  DISC_ID=$(echo "$DISC" | jq -r '.id')
  DISC_NUM=$(echo "$DISC" | jq -r '.number')
  [ "$DISC_ID" = "null" ] && { echo "[$i] Rate limited, sleeping 15s..."; sleep 15; continue; }
  sleep 2
  COMMENT_ID=$(gh api graphql -f query="mutation { addDiscussionComment(input: { discussionId: \"$DISC_ID\", body: \"This repo automates GitHub achievement farming using gh CLI and git.\" }) { comment { id } } }" --jq '.data.addDiscussionComment.comment.id')
  sleep 2
  gh api graphql -f query="mutation { markDiscussionCommentAsAnswer(input: { id: \"$COMMENT_ID\" }) { discussion { id } } }" > /dev/null 2>&1
  echo "[$i/$TARGET] Discussion #$DISC_NUM answered and accepted"
done
echo "Done! Galaxy Brain Gold earned."
