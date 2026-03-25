#!/usr/bin/env bash
# Awwwards Skill Suite — Installer
# Installs all 5 skills into ~/.agents/skills/
# Usage: bash install.sh

set -e

SKILLS_DIR="$HOME/.agents/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS=(
  awwwards-designer
  awwwards-animation-standards
  awwwards-performance-standards
  awwwards-quality-gate
  awwwards-visual-standards
)

echo "Installing Awwwards Skill Suite to $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

for skill in "${SKILLS[@]}"; do
  src="$REPO_DIR/$skill"
  dest="$SKILLS_DIR/$skill"

  if [ -d "$dest" ]; then
    echo "  ↑  $skill (updating)"
    rm -rf "$dest"
  else
    echo "  +  $skill"
  fi

  cp -r "$src" "$dest"
done

echo ""
echo "Done. All 5 skills installed at $SKILLS_DIR"
echo ""
echo "Skills available:"
for skill in "${SKILLS[@]}"; do
  echo "  · $skill"
done
