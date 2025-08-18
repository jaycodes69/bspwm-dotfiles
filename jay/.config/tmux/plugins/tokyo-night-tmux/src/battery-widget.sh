#!/usr/bin/env bash
# battery-widget.sh — Arch/Linux-friendly, auto-detecting version for tokyo-night-tmux

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
# keep existing compat import if present
if [[ -f "${ROOT_DIR}/lib/coreutils-compat.sh" ]]; then
  . "${ROOT_DIR}/lib/coreutils-compat.sh"
fi

# Only run if user enabled the widget in tmux
SHOW_BATTERY_WIDGET=$(tmux show-option -gv @tokyo-night-tmux_show_battery_widget 2>/dev/null || echo "")
if [[ "${SHOW_BATTERY_WIDGET}" != "1" ]]; then
  exit 0
fi

# Read tmux-configured values (if present)
TMUX_BAT_NAME=$(tmux show-option -gv @tokyo-night-tmux_battery_name 2>/dev/null || true)
TMUX_BAT_LOW=$(tmux show-option -gv @tokyo-night-tmux_battery_low_threshold 2>/dev/null || true)

RESET="#[fg=brightwhite,bg=default,nobold,noitalics,nounderscore,nodim]"

DISCHARGING_ICONS=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
CHARGING_ICONS=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
NOT_CHARGING_ICON="󰚥"   # plugged / full
NO_BATTERY_ICON="󱉝"
DEFAULT_BATTERY_LOW=21

# Determine battery name:
# Priority: tmux option -> common default BAT0 -> auto-detect any BAT* / battery*
BATTERY_NAME="${TMUX_BAT_NAME:-}"
if [[ -z "$BATTERY_NAME" ]]; then
  # prefer BAT0 if exists
  if [[ -d "/sys/class/power_supply/BAT0" ]]; then
    BATTERY_NAME="BAT0"
  elif [[ -d "/sys/class/power_supply/BAT1" ]]; then
    BATTERY_NAME="BAT1"
  else
    # fallback: first matching BAT* or *battery*
    for p in /sys/class/power_supply/BAT* /sys/class/power_supply/*battery*; do
      if [[ -d "$p" ]]; then
        BATTERY_NAME="$(basename "$p")"
        break
      fi
    done
  fi
fi

# If still empty, give up quietly
if [[ -z "$BATTERY_NAME" || ! -d "/sys/class/power_supply/$BATTERY_NAME" ]]; then
  exit 0
fi

BATTERY_LOW="${TMUX_BAT_LOW:-$DEFAULT_BATTERY_LOW}"

# Read status/capacity robustly (strip CR/newline/whitespace)
read_battery_file() {
  local file="$1"
  if [[ -r "$file" ]]; then
    # strip carriage returns and surrounding whitespace
    tr -d '\r' <"$file" | awk '{$1=$1;print}'
  else
    echo ""
  fi
}

BATTERY_STATUS=$(read_battery_file "/sys/class/power_supply/${BATTERY_NAME}/status")
BATTERY_PERCENTAGE=$(read_battery_file "/sys/class/power_supply/${BATTERY_NAME}/capacity")

# Normalize percentage to integer and clamp
if ! [[ "$BATTERY_PERCENTAGE" =~ ^[0-9]+$ ]]; then
  BATTERY_PERCENTAGE=0
fi
# guard against weird >100 values
if (( BATTERY_PERCENTAGE < 0 )); then BATTERY_PERCENTAGE=0; fi
if (( BATTERY_PERCENTAGE > 100 )); then BATTERY_PERCENTAGE=100; fi

# Normalize status to lowercase for comparisons
LSTATUS="$(echo "${BATTERY_STATUS:-}" | tr '[:upper:]' '[:lower:]' | awk '{$1=$1;print}')"

# calculate index safely 0..9
idx=$((BATTERY_PERCENTAGE / 10))
if (( idx < 0 )); then idx=0; fi
if (( idx > 9 )); then idx=9; fi

# Choose icon based on status
case "$LSTATUS" in
  *charging* )
    ICON="${CHARGING_ICONS[$idx]}"
    ;;
  *discharging* )
    ICON="${DISCHARGING_ICONS[$idx]}"
    ;;
  full|*full*|*charged*|*not\ charging*|*unknown*|*ac* )
    ICON="$NOT_CHARGING_ICON"
    ;;
  "" )
    ICON="$NO_BATTERY_ICON"
    BATTERY_PERCENTAGE=0
    ;;
  * )
    ICON="$NO_BATTERY_ICON"
    ;;
esac

# Color selection
if (( BATTERY_PERCENTAGE < BATTERY_LOW )); then
  color="#[fg=red,bg=default,bold]"
elif (( BATTERY_PERCENTAGE >= 100 )); then
  color="#[fg=green,bg=default]"
else
  color="#[fg=yellow,bg=default]"
fi

# Final output for tmux statusline
# small and minimal: icon + percent
printf '%s%s%s #[bg=default] %s%% ' "$color" "$ICON" "$RESET" "$BATTERY_PERCENTAGE"
