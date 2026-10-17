#!/bin/zsh
# Set the charge limit by location: stayed in one place >=24h -> 80%, moved -> 100%.
# Location fingerprint = MAC of the router (default gateway). Needs 2 shortcuts: "Charge 80", "Charge 100".
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
STATE="$HOME/.charge_loc"
LOG="$HOME/.charge_loc.log"
GW=$(route -n get default 2>/dev/null | awk '/gateway/{print $2}')
[[ -z "$GW" ]] && exit 0                                   # no network: leave as is
for i in 1 2 3; do                                         # ARP entries expire quickly: ping, then re-read
  ping -c1 -t2 "$GW" >/dev/null 2>&1
  FP=$(arp -n "$GW" 2>/dev/null | awk '{print $4}')
  [[ "$FP" =~ '^[0-9a-f]{1,2}(:[0-9a-f]{1,2}){5}$' ]] && break
done
[[ "$FP" =~ '^[0-9a-f]{1,2}(:[0-9a-f]{1,2}){5}$' ]] || exit 0   # no MAC found: leave as is
NOW=$(date +%s)
LAST=""; SINCE=$NOW; MODE=""
[[ -f "$STATE" ]] && read -r LAST SINCE MODE < "$STATE"
[[ "$FP" != "$LAST" ]] && SINCE=$NOW
(( NOW - SINCE >= 86400 )) && WANT=80 || WANT=100
# if the shortcut fails (missing, error...) keep the old MODE -> retry on the next run
if [[ "$MODE" != "$WANT" ]] && shortcuts run "Charge $WANT"; then
  MODE=$WANT; echo "$(date) at $FP since $(date -r $SINCE) -> $WANT%" >> "$LOG"
fi
echo "$FP $SINCE $MODE" > "$STATE"
