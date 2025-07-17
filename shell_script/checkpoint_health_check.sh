#!/bin/bash

# Define output log file with timestamp
LOG_FILE="/var/log/checkpoint_health_$(date '+%Y%m%d_%H%M%S').log"

# Start logging
{
    echo "========== Check Point Health Check Report =========="
    echo "Timestamp: $(date)"
    echo "====================================================="

    echo -e "\n### CPVIEW Snapshot (10 sec timeout) ###"
    timeout 10 cpview -t

    echo -e "\n### TOP Output (First 20 lines) ###"
    top -b -n 1 | head -20

    echo -e "\n### Memory Usage (free -m) ###"
    free -m

    echo -e "\n### Disk Usage (df -kh) ###"
    df -kh

    echo -e "\n### Firewall Connections Table Summary ###"
    fw tab -t connections -s

    echo -e "\n### CPWD Admin Process List ###"
    cpwd_admin list

    echo -e "\n### System Environment Variables ###"
    show sysenv all

    echo -e "\n### Network Interfaces (netstat -ni) ###"
    netstat -ni

    echo -e "\n### Interface Configuration (ifconfig) ###"
    ifconfig

    echo -e "\n### NTP Current Status ###"
    show ntp current

    echo -e "\n### NTP Configured Servers ###"
    show ntp servers

    echo -e "\n### System Uptime ###"
    uptime

    echo -e "\n========== End of Report =========="

} >> "$LOG_FILE"

echo "✔️ Health check complete. Output saved to: $LOG_FILE"