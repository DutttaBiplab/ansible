#!/bin/bash

# Disk usage alert threshold
THRESHOLD=70

# Alert log file path
ALERT_LOG="/var/log/disk_usage_alert.txt"

# Current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Header log entry
echo "====== Disk Usage Check: $TIMESTAMP ======" >> "$ALERT_LOG"

# Run df and check each mount point
df -hP | awk 'NR>1' | while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$line" | awk '{print $6}')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        echo "ALERT: $MOUNT is ${USAGE}% full (Threshold: ${THRESHOLD}%)" >> "$ALERT_LOG"
    fi
done

