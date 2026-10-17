#!/bin/bash
# Wait until total CPU usage is below a threshold before starting heavy work.
# Usage: tools/cpu-gate.sh [max-percent=70] [max-wait-seconds=900]
# Prints current usage; returns 0 when under the limit (or after max-wait, with a warning).
LIMIT="${1:-70}"; MAXWAIT="${2:-900}"; waited=0
usage() { top -l 2 -n 0 -s 2 | awk '/CPU usage/ {gsub("%","",$7); v=100-$7} END {printf "%d", v}'; }
while :; do
  u=$(usage)
  if [ "$u" -lt "$LIMIT" ]; then echo "cpu-gate: CPU ${u}% < ${LIMIT}% → go"; exit 0; fi
  if [ "$waited" -ge "$MAXWAIT" ]; then echo "cpu-gate: CPU still ${u}% after ${MAXWAIT}s → proceeding anyway (report this)"; exit 0; fi
  echo "cpu-gate: CPU ${u}% ≥ ${LIMIT}% → waiting 30s"; sleep 30; waited=$((waited+30))
done
