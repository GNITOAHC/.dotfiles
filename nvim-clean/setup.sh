#!/usr/bin/env bash
set -euo pipefail

# GitHub raw URL of your init.lua
RAW_URL="https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/nvim-clean/init.lua"

# Target location
CONFIG_DIR="$HOME/.config/nvim"
TARGET_FILE="$CONFIG_DIR/init.lua"

echo "[*] Setting up Neovim config..."

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# If init.lua already exists, back it up with timestamp
if [ -f "$TARGET_FILE" ]; then
    BACKUP_FILE="$CONFIG_DIR/init.lua.backup.$(date +%Y%m%d%H%M%S)"
    echo "[*] Found existing init.lua, moving it to $BACKUP_FILE"
    mv "$TARGET_FILE" "$BACKUP_FILE"
fi

# Download init.lua
curl -fsSL "$RAW_URL" -o "$TARGET_FILE"

echo "[✓] Installed init.lua to $TARGET_FILE"
