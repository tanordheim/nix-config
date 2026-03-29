#!/usr/bin/env bash
set -euo pipefail

HOSTNAME=$(hostname -s)
FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if ! output=$(nix eval "${FLAKE_DIR}#darwinConfigurations.${HOSTNAME}.system" 2>&1); then
  echo "$output"
  exit 2
fi
