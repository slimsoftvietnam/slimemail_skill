#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:?Usage: ./install.sh /path/to/project}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$TARGET/.claude/skills/slimemail-ai-agent"
mkdir -p "$TARGET/.cursor/skills/slimemail-ai-agent"
mkdir -p "$TARGET/.cursor/rules"

cp -r "$ROOT/skills/slimemail-ai-agent/"* "$TARGET/.claude/skills/slimemail-ai-agent/"
cp -r "$ROOT/skills/slimemail-ai-agent/"* "$TARGET/.cursor/skills/slimemail-ai-agent/"
cp "$ROOT/rules/slimemail-ai-agent.mdc" "$TARGET/.cursor/rules/"

if [[ ! -f "$TARGET/.env" ]]; then
  cp "$ROOT/.env.example" "$TARGET/.env"
  echo "Created $TARGET/.env — dien SLIMEMAIL_API_KEY"
fi

if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  cp "$ROOT/templates/CLAUDE.md" "$TARGET/CLAUDE.md"
fi

echo "OK: skill -> .claude/skills + .cursor/skills"
echo "Sua .env roi test: curl .../api/agent/me"
