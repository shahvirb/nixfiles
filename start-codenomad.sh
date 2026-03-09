#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${HOME}/.codenomad/codenomad.log"
PID_FILE="${HOME}/.codenomad/codenomad.pid"

mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stopping any existing codenomad instance..."
if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  kill "$(cat "$PID_FILE")" && echo "  Killed PID $(cat "$PID_FILE")"
fi
pkill -f "@neuralnomads/codenomad" 2>/dev/null && echo "  Killed remaining codenomad processes" || true

sleep 3

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting codenomad..."
echo "  Node:  $(node --version 2>/dev/null || echo 'not found')"
echo "  npm:   $(npm --version 2>/dev/null || echo 'not found')"
echo "  Host:  0.0.0.0"
echo "  Log:   $LOG_FILE"

cd ~/
npx @neuralnomads/codenomad --password test --host 0.0.0.0 >> "$LOG_FILE" 2>&1 &
CPID=$!
echo "$CPID" > "$PID_FILE"

sleep 2
if kill -0 "$CPID" 2>/dev/null; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] codenomad is running (PID $CPID)"
  echo "--- Listening ports ---"
  ss -tlnp 2>/dev/null | grep "$CPID" || \
    ss -tlnp 2>/dev/null | grep -E ':9898' || \
    echo "  (port not yet bound or ss unavailable)"
  echo "--- Last log lines ---"
  tail -n 10 "$LOG_FILE" 2>/dev/null || true
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: codenomad failed to start. Last log output:"
  tail -n 20 "$LOG_FILE" 2>/dev/null || true
  exit 1
fi
