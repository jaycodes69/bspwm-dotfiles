#!/bin/bash
# Battery notification script - wrapper for battery-status.sh
# This maintains compatibility with your original battery.sh while using the new unified script

# Call the unified battery script with notification flag
~/.config/scripts/battery-status.sh --notify
