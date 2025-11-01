#!/bin/bash

total_memory=$(grep MemTotal /proc/meminfo | awk '{print $2}')
available_memory=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
used_memory=$(awk -v tm="$total_memory" -v am="$available_memory" -v scale="$1" 'BEGIN { printf "%.*f", scale, (tm - am) / 1024 / 1024 }')
echo "$used_memory/$(($total_memory/1024/1024))"
