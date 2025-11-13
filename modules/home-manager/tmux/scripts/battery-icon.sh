#!/bin/bash
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
icon="󰂎󰢟"
if [[ $battery_level -eq 100 ]]; then
	icon="󰁹󰂅"
elif [[ $battery_level -gt 90 ]]; then
	icon="󰂂󰂋"
elif [[ $battery_level -gt 80 ]]; then
	icon="󰂁󰂊"
elif [[ $battery_level -gt 70 ]]; then
	icon="󰂀󰢞"
elif [[ $battery_level -gt 60 ]]; then
	icon="󰁿󰂉"
elif [[ $battery_level -gt 50 ]]; then
	icon="󰁾󰢝"
elif [[ $battery_level -gt 40 ]]; then
	icon="󰁽󰂈"
elif [[ $battery_level -gt 30 ]]; then
	icon="󰁼󰂇"
elif [[ $battery_level -gt 20 ]]; then
	icon="󰁻󰂆"
elif [[ $battery_level -gt 10 ]]; then
	icon="󰁺󰢜"
fi

case "$(cat /sys/class/power_supply/BAT0/status)" in
	"Discharging") echo ${icon:0:1} ;;
	"Charging") echo ${icon:1:1} ;;
	"Full" | "Not charging") echo 󰚥 ;;
	*) echo 󰂑 ;;
esac
