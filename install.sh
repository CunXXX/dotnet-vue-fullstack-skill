#!/bin/bash
set -e

SKILL_SRC="$(cd "$(dirname "$0")/dotnet-vue-fullstack" && pwd)"
SKILL_DST="$HOME/.claude/skills/dotnet-vue-fullstack"

echo "Installing dotnet-vue-fullstack skill..."
mkdir -p "$HOME/.claude/skills"
rm -rf "$SKILL_DST"
cp -r "$SKILL_SRC" "$SKILL_DST"

echo "Installed: $SKILL_DST"
echo "Files:"
find "$SKILL_DST" -type f | sed "s|$SKILL_DST/|  |"
