#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ -z "$file_path" ]]; then
  exit 0
fi

if [[ "$file_path" != *.nix ]]; then
  exit 0
fi

if ! command -v nixfmt &>/dev/null; then
  exit 0
fi

if ! output=$(nixfmt "$file_path" 2>&1); then
  echo "$output"
  exit 2
fi
