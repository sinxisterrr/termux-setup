#!/bin/bash
# ============================================
#  termux-setup.sh — Sin's Termux Environment
#  Run: bash termux-setup.sh
# ============================================

echo "🚀 Starting Termux setup..."

# --- Core packages ---
echo "📦 Installing core packages..."
pkg update -y && pkg upgrade -y
pkg install -y git nodejs python

# --- npm global prefix (keeps globals stable) ---
echo "⚙️  Configuring npm global prefix..."
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global

# --- Claude Code ---
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# --- PATH setup in ~/.bashrc ---
echo "🔧 Configuring PATH in ~/.bashrc..."

BASHRC="$HOME/.bashrc"

# Avoid duplicate entries
if ! grep -q "npm-global" "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# npm global binaries' >> "$BASHRC"
  echo 'export PATH=$HOME/.npm-global/bin:$PREFIX/bin:$PATH' >> "$BASHRC"
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

echo ""
echo "🔑 Don't forget to log in to Claude Code:"
echo "   claude login"
echo ""
echo "💾 Save this script somewhere safe (GitHub, Google Drive)"
echo "   so you can re-run it anytime with: bash termux-setup.sh"
