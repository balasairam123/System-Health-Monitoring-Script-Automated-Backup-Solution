#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" |bc -l) )); then
    echo "ALERT: CPU usage is above threshold! Current usage: $CPU_USAGE%" >> /var/log/system_health.log
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" |bc -l) )); then
    echo "ALERT: Memory usage is above threshold! Current usage: $MEMORY_USAGE%" >> /var/log/system_health.log
fi

# Check disk space usage
DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "ALERT: Disk usage is above threshold! Current usage: $DISK_USAGE%" >> /var/log/system_health.log
fi

# Log running processes
echo "Current running processes:" >> /var/log/system_health.log
ps aux >> /var/log/system_health.log

echo "System health check completed at $(date)" >> /var/log/system_health.log
