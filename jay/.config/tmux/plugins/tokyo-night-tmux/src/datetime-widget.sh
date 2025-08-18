#!/usr/bin/env bash
# tokyo-night: datetime widget — prints formatted time (and optional date) for tmux statusline

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
# keep compat import if present
if [[ -f "${ROOT_DIR}/lib/coreutils-compat.sh" ]]; then
  . "${ROOT_DIR}/lib/coreutils-compat.sh"
fi

# If the datetime widget is explicitly disabled, exit quietly
SHOW_DATETIME=$(tmux show-option -gv @tokyo-night-tmux_show_datetime 2>/dev/null || echo "")
if [[ "$SHOW_DATETIME" == "0" ]]; then
  exit 0
fi

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# load theme (must define THEME associative array and optionally RESET)
if [[ -f "$CURRENT_DIR/themes.sh" ]]; then
  # shellcheck disable=SC1090
  source "$CURRENT_DIR/themes.sh"
fi

# safe defaults if themes didn't set them
RESET="${RESET:-#[fg=brightwhite,bg=#15161e,nobold,noitalics,nounderscore,nodim]}"
THEME_FG="${THEME[foreground]:-brightwhite}"
THEME_BBG="${THEME[bblack]:-#15161e}"

# read user config from tmux (may be empty)
date_format=$(tmux show-option -gv @tokyo-night-tmux_date_format 2>/dev/null || echo "")
time_format=$(tmux show-option -gv @tokyo-night-tmux_time_format 2>/dev/null || echo "")

# Decide strftime formats. Empty or "hide" => show nothing.
date_fmt_str=""
case "$date_format" in
  YMD) date_fmt_str="%Y-%m-%d" ;;
  MDY) date_fmt_str="%m-%d-%Y" ;;
  DMY) date_fmt_str="%d-%m-%Y" ;;
  hide|"") date_fmt_str="" ;;
  *) date_fmt_str="%Y-%m-%d" ;;  # fallback for unknown values
esac

time_fmt_str=""
case "$time_format" in
  12H) time_fmt_str="%I:%M %p" ;;
  24H|"") time_fmt_str="%H:%M" ;;   # default to 24H when empty
  hide) time_fmt_str="" ;;
  *) time_fmt_str="%H:%M" ;;
esac

# If user explicitly set date_format to empty string (""), treat as no date:
# (tmux passes empty as literal empty above)
if [[ -z "$date_format" ]]; then
  date_fmt_str=""
fi
# If user explicitly set time_format to empty string, treat as 24H (keeps previous behavior)
# (you can customize this if you prefer empty->hide)

# Render date/time using system date
date_string=""
time_string=""

if [[ -n "$date_fmt_str" ]]; then
  # Use env LC_TIME=C to keep consistent formatting across systems (optional)
  date_string="$(date +"$date_fmt_str")"
fi

if [[ -n "$time_fmt_str" ]]; then
  time_string="$(date +"$time_fmt_str")"
fi

# separator only when both present
separator=""
if [[ -n "$date_string" && -n "$time_string" ]]; then
  separator=" ❬ "
fi

# Print tmux-formatted result: reset + themed fg/bg + date/time
# Note: keep a trailing space so tmux statusline spacing is nicer
printf '%s#[fg=%s,bg=%s]%s%s%s ' \
  "$RESET" "$THEME_FG" "$THEME_BBG" \
  "${date_string:+$date_string}" "$separator" "${time_string}"
