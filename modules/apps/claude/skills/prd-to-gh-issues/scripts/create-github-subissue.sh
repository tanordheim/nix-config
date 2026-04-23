#!/usr/bin/env bash
set -euo pipefail

PARENT_NUMBER="$1"
TITLE="$2"
BODY=$(cat)

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')

ISSUE_URL=$(gh issue create --title "$TITLE" --body "$BODY")
ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -o '[0-9]*$')

ISSUE_ID=$(gh api "repos/$REPO/issues/$ISSUE_NUMBER" -q '.id')

gh api "repos/$REPO/issues/$PARENT_NUMBER/sub_issues" -F sub_issue_id="$ISSUE_ID" --silent

echo "$ISSUE_URL"
