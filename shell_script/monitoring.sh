#!/bin/bash

LOG_FILE="/var/log/full_sys_monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get top 10 lines from top command
TOP_OUTPUT=$(top -b -n 1 | head -n 10)

# Extract CPU usage
CPU_LINE=$(echo "$TOP_OUTPUT" | grep "%Cpu(s)")
CPU_USER=$(echo "$CPU_LINE" | awk '{print $2}')
CPU_SYS=$(echo "$CPU_LINE" | awk '{print $4}')
CPU_IDLE=$(echo "$CPU_LINE" | awk '{print $8}')
CPU_IOWAIT=$(echo "$CPU_LINE" | awk '{print $6}')

# Extract memory info
MEM_LINE=$(echo "$TOP_OUTPUT" | grep "MiB Mem")
MEM_TOTAL=$(echo "$MEM_LINE" | awk '{print $2}')
MEM_FREE=$(echo "$MEM_LINE" | awk '{print $4}')
MEM_USED=$(echo "$MEM_LINE" | awk '{print $6}')
MEM_AVAIL=$(echo "$MEM_LINE" | awk '{print $8}')

# Extract swap info
SWAP_LINE=$(echo "$TOP_OUTPUT" | grep "MiB Swap")
SWAP_TOTAL=$(echo "$SWAP_LINE" | awk '{print $2}')
SWAP_USED=$(echo "$SWAP_LINE" | awk '{print $4}')
SWAP_FREE=$(echo "$SWAP_LINE" | awk '{print $6}')

# Extract tasks info
TASKS_LINE=$(echo "$TOP_OUTPUT" | grep "Tasks")
TASKS_TOTAL=$(echo "$TASKS_LINE" | awk '{print $2}')
TASKS_RUNNING=$(echo "$TASKS_LINE" | awk '{print $4}')
TASKS_SLEEPING=$(echo "$TASKS_LINE" | awk '{print $6}')
TASKS_ZOMBIE=$(echo "$TASKS_LINE" | awk '{print $10}')

# Disk usage (root partition)
DISK_LINE=$(df -h / | awk 'NR==2')
DISK_SIZE=$(echo "$DISK_LINE" | awk '{print $2}')
DISK_USED=$(echo "$DISK_LINE" | awk '{print $3}')
DISK_AVAIL=$(echo "$DISK_LINE" | awk '{print $4}')
DISK_USE_PERCENT=$(echo "$DISK_LINE" | awk '{print $5}')
# Save data to log file
{
  echo "=== $TIMESTAMP ==="
  echo "📌 CPU Usage:"
  echo "  - User: $CPU_USER%, System: $CPU_SYS%, IOWait: $CPU_IOWAIT%, Idle: $CPU_IDLE%"

  echo "📌 Memory Usage:"
  echo "  - Total: $MEM_TOTAL MiB, Used: $MEM_USED MiB, Free: $MEM_FREE MiB, Available: $MEM_AVAIL MiB"

  echo "📌 Swap Usage:"
  echo "  - Total: $SWAP_TOTAL MiB, Used: $SWAP_USED MiB, Free: $SWAP_FREE MiB"

  echo "📌 Task Summary:"
  echo "  - Total: $TASKS_TOTAL, Running: $TASKS_RUNNING, Sleeping: $TASKS_SLEEPING, Zombie: $TASKS_ZOMBIE"

  echo "📌 Disk Usage ($DISK_MOUNT):"
  echo "  - Size: $DISK_SIZE, Used: $DISK_USED, Available: $DISK_AVAIL, Usage: $DISK_USE_PERCENT"

  echo "----------------------------------------"
  echo ""
} >> "$LOG_FILE"

