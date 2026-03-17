#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
if ! echo "$branch" | grep -qE "^(feature|fix|hotfix|chore|refactor|docs|test|release|dev|main)/.+|^(dev|main)$"; then
  echo "Bad branch: $branch"
  echo "Must match: type/description (e.g. feature/42-note-crud)"
  exit 1
fi
exit 0
