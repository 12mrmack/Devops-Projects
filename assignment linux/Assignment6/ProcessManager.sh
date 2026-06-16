#!/bin/bash

BASE_DIR="$(pwd)"
DB_FILE="$BASE_DIR/services.db"
PID_DIR="$BASE_DIR/pids"
LOG_DIR="$BASE_DIR/logs"

mkdir -p "$PID_DIR" "$LOG_DIR"
touch "$DB_FILE"

# ---------- Helper ----------
get_script_path() {
    grep "^$1:" "$DB_FILE" | cut -d ':' -f2
}

get_pid() {
    if [ -f "$PID_DIR/$1.pid" ]; then
        cat "$PID_DIR/$1.pid"    
    fi
}

register() {
    echo "$2:$1" >> "$DB_FILE"
    echo "Service '$2' registered."
}

start_service() {
    script=$(get_script_path "$1")
    if [ -z "$script" ]; then
        echo "Service not found!"
        exit 1
    fi

    nohup bash "$script" > "$LOG_DIR/$1.log" 2>&1 &         # stderr>stdout
    echo $! > "$PID_DIR/$1.pid"

    echo "Service '$1' started with PID $(cat "$PID_DIR/$1.pid")"
}

status_service() {
    pid=$(get_pid "$1")

    if [ -z "$pid" ]; then
        echo "Service not running"
        return
    fi

    if ps -p "$pid" > /dev/null; then
        echo "Service '$1' is RUNNING (PID: $pid)"
    else
        echo "Service '$1' is STOPPED"
    fi
}

kill_service() {
    pid=$(get_pid "$1")

    if [ -z "$pid" ]; then
        echo "No such running service"
        return
    fi

    kill "$pid"
    rm -f "$PID_DIR/$1.pid"

    echo "Service '$1' stopped"
}

set_priority() {
    pid=$(get_pid "$1")

    case "$2" in
        low) nice_val=10 ;;
        med) nice_val=0 ;;
        high) nice_val=-10 ;;
        *) echo "Invalid priority"; exit 1 ;;
    esac

    sudo renice $nice_val -p $pid
    echo "Priority updated"
}

list_services() {
    cut -d ':' -f1 "$DB_FILE"
}

top_service() {
    if [ -n "$1" ]; then
        pid=$(get_pid "$1")
        ps -p "$pid" -o pid,stat,ni,cmd
    else
        echo "Alias | PID | State | Priority | Script"
        while IFS=":" read alias script; do
            pid=$(get_pid "$alias")
            if [ -n "$pid" ]; then
                state=$(ps -p $pid -o stat=)
                pri=$(ps -p $pid -o ni=)
                echo "$alias | $pid | $state | $pri | $script"
            fi
        done < "$DB_FILE"
    fi
}

# Parse arguments ussing getopts
while getopts "o:s:a:p:" opt; do
    case $opt in
        o) operation=$OPTARG ;;
        s) script=$OPTARG ;;
        a) alias=$OPTARG ;;
        p) priority=$OPTARG ;;
    esac
done

case $operation in
    register) register "$script" "$alias" ;;
    start) start_service "$alias" ;;
    status) status_service "$alias" ;;
    kill) kill_service "$alias" ;;
    priority) set_priority "$alias" "$priority" ;;
    list) list_services ;;
    top) top_service "$alias" ;;
    *) echo "Invalid operation" ;;
esac

