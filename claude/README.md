# Claude

## Sync settings

Deep-merge the preset (`settings.json`) into `~/.claude/settings.json`. Existing
fields you set are kept; the preset's values override matching keys and add new
ones. A timestamped `.bak` is created before any merge.

**macOS / Linux** (requires `jq`):

```sh
curl -LsSf https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/setup.sh | bash
```

**Windows** (PowerShell):

```powershell
irm https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/setup.ps1 | iex
```

## Status line

Link `./statusline.sh` to `~/.claude/statusline.sh` and set the `statusLine`
attribute in `~/.claude/settings.json` (already included in the preset):

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh"
}
```
