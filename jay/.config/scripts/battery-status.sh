#!/bin/bash
# Battery status script for tmux status bar and dunstify notifications
# Tokyo Night themed battery indicator

# Check if acpi is available
if ! command -v acpi &> /dev/null; then
  echo "󱉝 N/A"
  exit 0
fi

# Get battery information
battery_info=$(acpi -b 2>/dev/null | head -n1)

# Check if battery info was retrieved
if [[ -z "$battery_info" ]]; then
  echo "󱉝 N/A"
  exit 0
fi

# Parse battery information
percentage=$(echo "$battery_info" | grep -oP '\d+(?=%)')
status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

# Validate percentage
if [[ ! "$percentage" =~ ^[0-9]+$ ]]; then
  echo "󱉝 N/A"
  exit 0
fi

# Clamp percentage to valid range
if (( percentage < 0 )); then percentage=0; fi
if (( percentage > 100 )); then percentage=100; fi

# Define battery icons and dunstify icon names based on status and level
if [[ "$status" == "Charging" ]]; then
  # Charging icons
  if (( percentage >= 90 )); then
    icon="󰂅"  # battery-charging-100
    dunst_icon="battery-charging"
  elif (( percentage >= 80 )); then
    icon="󰂋"  # battery-charging-90
    dunst_icon="battery-charging"
  elif (( percentage >= 70 )); then
    icon="󰂊"  # battery-charging-80
    dunst_icon="battery-charging"
  elif (( percentage >= 60 )); then
    icon="󰢞"  # battery-charging-70
    dunst_icon="battery-charging"
  elif (( percentage >= 50 )); then
    icon="󰂉"  # battery-charging-60
    dunst_icon="battery-charging"
  elif (( percentage >= 40 )); then
    icon="󰢝"  # battery-charging-50
    dunst_icon="battery-charging"
  elif (( percentage >= 30 )); then
    icon="󰂈"  # battery-charging-40
    dunst_icon="battery-charging"
  elif (( percentage >= 20 )); then
    icon="󰂇"  # battery-charging-30
    dunst_icon="battery-charging"
  elif (( percentage >= 10 )); then
    icon="󰂆"  # battery-charging-20
    dunst_icon="battery-charging"
  else
    icon="󰢜"  # battery-charging-10
    dunst_icon="battery-charging"
  fi
elif [[ "$status" == "Discharging" ]]; then
  # Discharging icons
  if (( percentage >= 90 )); then
    icon="󰁹"  # battery-full
    dunst_icon="battery-full"
  elif (( percentage >= 80 )); then
    icon="󰂂"  # battery-90
    dunst_icon="battery-full"
  elif (( percentage >= 70 )); then
    icon="󰂁"  # battery-80
    dunst_icon="battery-good"
  elif (( percentage >= 60 )); then
    icon="󰂀"  # battery-70
    dunst_icon="battery-good"
  elif (( percentage >= 50 )); then
    icon="󰁿"  # battery-60
    dunst_icon="battery-good"
  elif (( percentage >= 40 )); then
    icon="󰁾"  # battery-50
    dunst_icon="battery-good"
  elif (( percentage >= 30 )); then
    icon="󰁽"  # battery-40
    dunst_icon="battery-low"
  elif (( percentage >= 20 )); then
    icon="󰁼"  # battery-30
    dunst_icon="battery-low"
  elif (( percentage >= 10 )); then
    icon="󰁻"  # battery-20
    dunst_icon="battery-caution"
  else
    icon="󰁺"  # battery-10
    dunst_icon="battery-empty"
  fi
else
  # Full, Not charging, or Unknown status
  if (( percentage >= 95 )); then
    icon="󰚥"  # battery-not-charging (plugged)
    dunst_icon="battery-full"
  else
    icon="󰁹"  # battery-full
    dunst_icon="battery-full"
  fi
fi

# Check if called for notification
if [[ "$1" == "--notify" ]] || [[ "$1" == "-n" ]]; then
  if command -v dunstify &> /dev/null; then
    # Determine urgency based on battery level
    if (( percentage <= 10 )); then
      urgency="critical"
    elif (( percentage <= 20 )); then
      urgency="normal"
    else
      urgency="low"
    fi

        # Get time remaining if available
        time_info=$(echo "$battery_info" | grep -oP '\d{2}:\d{2}:\d{2}' | head -n1)
        if [[ -n "$time_info" ]]; then
          time_msg=" (${time_info} remaining)"
        else
          time_msg=""
        fi

        # Send notification
        dunstify -i "$dunst_icon" \
          -u "$urgency" \
          -r 9991 \
          "Battery: $percentage%" \
          "Status: $status$time_msg"
      else
        echo "dunstify not found"
        exit 1
  fi
else
  # Output for tmux status bar
  echo "$icon $percentage%"
fi
