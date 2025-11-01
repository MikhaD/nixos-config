#!/bin/bash

df -h / | awk 'NR>1 {gsub(/G/, "", $3); gsub(/G/, "", $2); print $3 "/" $2}'
