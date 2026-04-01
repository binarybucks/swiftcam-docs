#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/repo/mkdocs.yml"
OUTPUT_DIR="$SCRIPT_DIR/prod"
TMP_SITE_DIR="$SCRIPT_DIR/repo/site"

if ! command -v zensical >/dev/null 2>&1; then
  echo "Error: zensical is not installed. Install with: pip install zensical" >&2
  exit 1
fi

zensical build --clean --config-file "$CONFIG_FILE" "$@"
mkdir -p "$OUTPUT_DIR"
rsync -a --delete "$TMP_SITE_DIR/" "$OUTPUT_DIR/"
echo "Built docs to: $OUTPUT_DIR"
