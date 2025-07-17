#!/bin/bash

# CPU usage threshold in percentage
THRESHOLD=70

# Log file for alerts
ALERT_LOG="/var/log/cpu_usage_alert.txt"

# Current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get average CPU usage over 1 second using mpstat (part of sysstat package)
CPU_IDLE=$(mpstat 1 1 | awk '/Average:/ { print 100 - $NF }')

# If mpstat is not available, use top as fallback
if [ -z "$CPU_IDLE" ]; then
  CPU_IDLE=$(top -b -n2 | grep "Cpu(s)" | tail -n1 | awk '{print $8}')  # idle
  CPU_IDLE=$(echo "100 - $CPU_IDLE" | bc)
fi

# Convert to integer
CPU_USAGE=$(printf "%.0f" "$CPU_IDLE")

# Check if CPU usage exceeds threshold
if [ "$CPU_USAGE" -ge "$THRESHOLD" ]; then
    echo "$TIMESTAMP - ALERT: CPU usage is at ${CPU_USAGE}% (Threshold: ${THRESHOLD}%)" >> "$ALERT_LOG"
fi


REMOTE_USER="username"
REMOTE_HOST="192.168.1.100"
REMOTE_PATH="/tmp/dmz-monitor"

scp "$LOG_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

