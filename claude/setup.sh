#!/usr/bin/env bash
#
# Expand ~/.claude/settings.json with a preset of personal defaults.
#
# Usage:
#   curl -LsSf https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/setup.sh | bash
#
# Behavior:
#   - If ~/.claude/settings.json does not exist, it is created from the preset.
#   - If it exists, the preset is deep-merged in: preset values override existing
#     fields, and fields not yet present are added. Anything you have that the
#     preset doesn't mention is left untouched.

set -euo pipefail

PRESET_URL="${CLAUDE_SETTINGS_PRESET_URL:-https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/settings.json}"
SETTINGS_DIR="${HOME}/.claude"
SETTINGS_FILE="${SETTINGS_DIR}/settings.json"

err() { printf 'error: %s\n' "$*" >&2; exit 1; }
info() { printf '%s\n' "$*" >&2; }

# --- dependencies ----------------------------------------------------------
command -v jq >/dev/null 2>&1 || err "jq is required but not installed (try: brew install jq)"

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -LsSf "$1"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -qO- "$1"; }
else
  err "neither curl nor wget is available"
fi

# --- fetch preset ----------------------------------------------------------
preset="$(fetch "${PRESET_URL}")" || err "failed to download preset from ${PRESET_URL}"
echo "${preset}" | jq empty 2>/dev/null || err "downloaded preset is not valid JSON"

mkdir -p "${SETTINGS_DIR}"

# --- write or merge --------------------------------------------------------
if [ ! -f "${SETTINGS_FILE}" ]; then
  info "No existing settings found; writing preset to ${SETTINGS_FILE}"
  echo "${preset}" | jq '.' > "${SETTINGS_FILE}"
  info "Done."
  exit 0
fi

# Validate the existing file before touching it.
jq empty "${SETTINGS_FILE}" 2>/dev/null || err "${SETTINGS_FILE} exists but is not valid JSON; aborting"

# Back up, then deep-merge (preset wins on conflicts, new keys are added).
backup="${SETTINGS_FILE}.bak.$(date +%Y%m%d%H%M%S)"
cp "${SETTINGS_FILE}" "${backup}"
info "Backed up existing settings to ${backup}"

merged="$(jq -s '.[0] * .[1]' "${SETTINGS_FILE}" <(echo "${preset}"))" \
  || err "merge failed"

echo "${merged}" > "${SETTINGS_FILE}"
info "Merged preset into ${SETTINGS_FILE}"
