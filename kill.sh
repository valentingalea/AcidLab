#!/usr/bin/env bash
# Stop the background server started by ./start.sh --background
# Usage: ./kill.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/server.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "No PID file found at $PID_FILE"
    echo "If the server is running, stop it manually."
    exit 1
fi

PID="$(tr -d '[:space:]' < "$PID_FILE")"

if [[ ! "$PID" =~ ^[0-9]+$ ]]; then
    echo "Invalid PID '$PID' in $PID_FILE"
    exit 1
fi

if ! kill -0 "$PID" 2>/dev/null; then
    echo "Process $PID is not running. Cleaning up stale PID file."
    rm -f "$PID_FILE"
    exit 0
fi

# Kill the entire process group (bash wrapper + python child).
# start.sh uses setsid so the PID is also the PGID.
kill -- -"$PID" 2>/dev/null
sleep 0.2

if kill -0 "$PID" 2>/dev/null; then
    echo "Process $PID did not exit on SIGTERM; sending SIGKILL."
    kill -9 -- -"$PID" 2>/dev/null
fi

rm -f "$PID_FILE"
echo "Stopped server (PID $PID)."
