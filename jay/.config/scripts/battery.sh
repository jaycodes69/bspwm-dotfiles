#!/bin/sh

# Get battery info
BAT=$(acpi -b | awk -F', ' '{print $2}')
STATUS=$(acpi -b | awk '{print $3}' | tr -d ',')
PERCENT=${BAT%\%}

# Pick icon based on percentage
if [ "$STATUS" = "Charging" ]; then
    ICON="battery-charging"
elif [ "$PERCENT" -ge 80 ]; then
    ICON="battery-full"
elif [ "$PERCENT" -ge 50 ]; then
    ICON="battery-good"
elif [ "$PERCENT" -ge 20 ]; then
    ICON="battery-low"
else
    ICON="battery-empty"
fi

# Send notification
dunstify -i "$ICON" "Battery: $BAT" "Status: $STATUS"
