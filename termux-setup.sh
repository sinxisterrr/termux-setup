#!/bin/bash
# ============================================
#  termux-setup.sh — Sin's Termux Environment
#  Run: bash termux-setup.sh
# ============================================
#
#  NOTE ON CLAUDE CODE VERSION:
#  Pinned to 2.1.112 — the last version with a JS entry point.
#  v2.1.113+ ships a native glibc binary that does NOT run on
#  Android/Termux (process.platform reports 'android'). DO NOT
#  run `claude update` or it will pull a broken version.
#  Tracked at: github.com/anthropics/claude-code/issues/50270
# ============================================

CLAUDE_VERSION="2.1.112"

echo "🚀 Starting Termux setup..."

# --- Core packages ---
echo "📦 Installing core packages..."
pkg update -y && pkg upgrade -y
pkg install -y git nodejs python

# --- npm global prefix (keeps globals stable) ---
echo "⚙️  Configuring npm global prefix..."
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global

# --- Claude Code (pinned) ---
echo "🤖 Installing Claude Code v$CLAUDE_VERSION (pinned for Android compatibility)..."
npm install -g @anthropic-ai/claude-code@$CLAUDE_VERSION

# --- bashrc setup ---
echo "🔧 Configuring ~/.bashrc..."
BASHRC="$HOME/.bashrc"

# PATH for npm globals
if ! grep -q "npm-global" "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# npm global binaries' >> "$BASHRC"
  echo 'export PATH=$HOME/.npm-global/bin:$PREFIX/bin:$PATH' >> "$BASHRC"
fi

# Disable Claude Code auto-updater (protects the version pin)
if ! grep -q "DISABLE_AUTOUPDATER" "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# Keep Claude Code pinned — auto-update pulls a broken Android binary' >> "$BASHRC"
  echo 'export DISABLE_AUTOUPDATER=1' >> "$BASHRC"
fi

# --- Reload shell config ---
source "$BASHRC"

# --- Verify installs ---
echo ""
echo "✅ Setup complete! Verifying installs..."
echo "  node:    $(node --version 2>/dev/null || echo 'NOT FOUND')"
echo "  npm:     $(npm --version 2>/dev/null || echo 'NOT FOUND')"
echo "  git:     $(git --version 2>/dev/null || echo 'NOT FOUND')"
echo "  python:  $(python --version 2>/dev/null || echo 'NOT FOUND')"
echo "  claude:  $(claude --version 2>/dev/null || echo 'NOT FOUND')"