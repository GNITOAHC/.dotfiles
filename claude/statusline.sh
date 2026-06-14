#!/bin/sh
input=$(cat)

# ── Icons ──
ICON_CTX="ctx"
ICON_COST="cost"
ICON_GIT="branch"

# ── Parse JSON input ──
model=$(echo "$input" | jq -r '.model.display_name // ""')
ctx_remain=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_h_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Git branch (detected from working directory, not JSON)
git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# ── Color by remaining percentage ──
# Blue >= 50% | Yellow 21-49% | Red <= 20% (for rate limits)
color_by_remain() {
    if [ "$1" -le 20 ]; then
        printf '\033[31m' # Red — critical
    elif [ "$1" -le 49 ]; then
        printf '\033[33m' # Yellow — caution
    else
        printf '\033[34m' # Blue — healthy
    fi
}

# ── Mini progress bar (10 chars wide) ──
mini_bar() {
    local pct=$1 width=10
    local filled=$((pct * width / 100))
    local i=0
    while [ $i -lt $width ]; do
        if [ $i -lt $filled ]; then printf '━'; else printf '┄'; fi
        i=$((i + 1))
    done
}

# ── Separator (dim pipe) ──
SEP=$(printf '\033[2m │ \033[0m')

# ── Build output ──
parts=""

# Model name (bold magenta to stand out)
if [ -n "$model" ]; then
    parts=$(printf '\033[1;35m%s\033[0m' "$model")
fi

# Git branch (cyan)
if [ -n "$git_branch" ]; then
    parts="$parts$SEP$(printf '\033[36m%s %s\033[0m' "$ICON_GIT" "$git_branch")"
fi

# Context window remaining (bar + percentage)
if [ -n "$ctx_remain" ]; then
    val=$(printf '%.0f' "$ctx_remain")
    color=$(color_by_remain "$val")
    bar=$(mini_bar "$val")
    parts="$parts$SEP$(printf '%s%s %s %s%%\033[0m' "$color" "$ICON_CTX" "$bar" "$val")"
fi

# 5-hour rate limit (show remaining %)
if [ -n "$five_h_used" ]; then
    val=$((100 - $(printf '%.0f' "$five_h_used")))
    color=$(color_by_remain "$val")
    parts="$parts$SEP$(printf '%s5h:%s%%\033[0m' "$color" "$val")"
fi

# 7-day rate limit (show remaining %)
if [ -n "$seven_d_used" ]; then
    val=$((100 - $(printf '%.0f' "$seven_d_used")))
    color=$(color_by_remain "$val")
    parts="$parts$SEP$(printf '%s7d:%s%%\033[0m' "$color" "$val")"
fi

# Session cost (dim so it doesn't dominate)
if [ -n "$cost" ] && [ "$cost" != "0" ] && [ "$cost" != "null" ]; then
    parts="$parts$SEP$(printf '\033[2m%s $%s\033[0m' "$ICON_COST" "$cost")"
fi

printf '%s' "$parts"
