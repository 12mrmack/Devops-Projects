#!/bin/bash

operation=$1
shift

case $operation in 
    topProcess)
    n=$1
    type=$2

    if [ $type == "memory" ]; then
        ps -eo pid,comm,%mem --sort=-%mem | head -n $((n+1))
    elif [ $type == "cpu" ]; then
        ps -eo pid,comm,%cpu --sort=-%cpu | head -n $((n+1))
    fi
    ;;
    killLeastPriorityProcess)
        kill -9 "$(ps -eo pid,ni --sort=-ni | awk 'NR==2 {print $1}')"
    ;;
    RunningDurationProcess)
        target=$1
        ps -eo pid,comm,etime | grep "$target"
    ;;
    listOrphanProcess)
        ps -eo pid,ppid,comm | awk '$2==1'
    ;;
    listZoombieProcess)
        ps -eo pid,stat,comm | awk '$2 ~ /^Z/'          # ~ here matches regex on right to field in left
    ;;
    killProcess)
        target=$1
        kill -9 "$(ps -eo pid,comm | grep "$target" | awk '{print $1}')"
    ;;
    ListWaitingProcess)
        ps -eo pid,stat,comm | awk '$2 ~ /^D/'          
        # D= processes waiting on kernel resources, uninterruptable by kill -9 
        # S= processes waiting for userinput/signals/events, interruptible
        # T= processes manually stopped like Ctrl+Z, just paused
    ;;
    *)
    echo "Invalid Operation"
    echo "Usage: $0 <operation>"
    ;;
esac
