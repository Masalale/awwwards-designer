#!/usr/bin/env bash
# Awwwards Designer — Unified Skill Installer
# Installs the single awwwards-designer skill into ~/.agents/skills/
# Usage: bash install.sh

set -e

SKILLS_DIR="$HOME/.agents/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Awwwards Designer skill to $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

src="$REPO_DIR/awwwards-designer"
dest="$SKILLS_DIR/awwwards-designer"

if [ -d "$dest" ]; then
  echo "  ↑  awwwards-designer (updating)"
  rm -rf "$dest"
else
  echo "  +  awwwards-designer"
fi

cp -r "$src" "$dest"

echo ""
echo "Done. Skill installed at $SKILLS_DIR/awwwards-designer"
echo ""
echo "Symlink to other harnesses (optional):"
echo "  ln -s $SKILLS_DIR/awwwards-designer ~/.claude/skills/awwwards-designer"
echo "  ln -s $SKILLS_DIR/awwwards-designer ~/.config/opencode/skills/awwwards-designer"
echo "  ln -s $SKILLS_DIR/awwwards-designer ~/.openclaw/skills/awwwards-designer"
echo "  ln -s $SKILLS_DIR/awwwards-designer ~/.hermes/skills/awwwards-designer"
