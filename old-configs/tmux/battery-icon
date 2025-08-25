#!/bin/bash
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
icon="󰂎󰢟"
if [ "$battery_level" -eq 100 ]; then
	icon="󰁹󰚥"
elif [ "$battery_level" -gt 90 ]; then
	icon="󰂂󰂋"
elif [ "$battery_level" -gt 80 ]; then
	icon="󰂁󰂊"
elif [ "$battery_level" -gt 70 ]; then
	icon="󰂀󰢞"
elif [ "$battery_level" -gt 60 ]; then
	icon="󰁿󰂉"
elif [ "$battery_level" -gt 50 ]; then
	icon="󰁾󰢝"
elif [ "$battery_level" -gt 40 ]; then
	icon="󰁽󰂈"
elif [ "$battery_level" -gt 30 ]; then
	icon="󰁼󰂇"
elif [ "$battery_level" -gt 20 ]; then
	icon="󰁻󰂆"
elif [ "$battery_level" -gt 10 ]; then
	icon="󰁺󰢜"
fi
battery_status=$(cat /sys/class/power_supply/BAT0/status)
if [ "$battery_status" = "Charging" ] || [ "$battery_status" = "Not charging" ]  || [ "$battery_status" = "Full" ]; then
	echo "${icon:1:1}"
else
	echo "${icon:0:1}"
fi