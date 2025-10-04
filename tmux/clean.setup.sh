#!/usr/bin/env bash
set -euo pipefail

# GitHub raw URL of your init.lua
RAW_URL="https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/tmux/.clean.tmux.conf"

# Target location
TARGET_FILE="$HOME/.tmux.conf"

echo "[*] Setting up Tmux config..."

# If .tmux.conf already exists, back it up with timestamp
if [ -f "$TARGET_FILE" ]; then
    BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d%H%M%S)"
    echo "[*] Found existing .tmux.conf, moving it to $BACKUP_FILE"
    mv "$TARGET_FILE" "$BACKUP_FILE"
fi

# Download init.lua
curl -fsSL "$RAW_URL" -o "$TARGET_FILE"

echo "[✓] Installed .tmux.conf to $TARGET_FILE"
