#!/usr/bin/env bash
# Serve AcidLab from the repo root.
# Multi-page site: index.html plus lessons/*/index.html — open http://localhost:$PORT/ in a browser.
#
# Bound to 127.0.0.1 only — in production Caddy fronts this with TLS and an
# allowlist (see DEPLOY.md). The bind keeps the origin off the public internet
# even if firewall rules ever drift; the allowlist keeps dotfiles and .git/
# unreachable even on this host.
#
# Usage: ./start.sh [port] [--background|-b]

PORT=8083
BACKGROUND=false

for arg in "$@"; do
    case "$arg" in
        --background|-b)
            BACKGROUND=true
            ;;
        ''|*[!0-9]*)
            echo "Error: Unknown argument '$arg'"
            echo "Usage: ./start.sh [port] [--background|-b]"
            exit 1
            ;;
        *)
            PORT="$arg"
            ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting AcidLab server on port $PORT..."
echo "Local:    http://localhost:$PORT/"
echo "Network:  (intentionally not bound — see DEPLOY.md for the public path)"
echo ""

# Inline Python server with no-cache headers so browsers always fetch
# the latest index.html during development.
serve() {
    cd "$1"
    python3 -c "
import http.server, sys
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        super().end_headers()
http.server.ThreadingHTTPServer(('127.0.0.1', int(sys.argv[1])), H).serve_forever()
" "$2"
}

if [ "$BACKGROUND" = true ]; then
    LOG_FILE="$SCRIPT_DIR/server.log"
    PID_FILE="$SCRIPT_DIR/server.pid"

    setsid bash -c "$(declare -f serve); serve \"$SCRIPT_DIR\" $PORT" >"$LOG_FILE" 2>&1 </dev/null &
    SERVER_PID=$!
    echo "$SERVER_PID" >"$PID_FILE"

    echo "Running in background."
    echo "PID:      $SERVER_PID (saved to $PID_FILE)"
    echo "Log file: $LOG_FILE"
else
    echo "Press Ctrl+C to stop"
    echo ""
    serve "$SCRIPT_DIR" "$PORT"
fi
