#!/bin/zsh
# Đổi charge limit theo vị trí: ở yên 1 chỗ >=24h -> 80%, đổi chỗ -> 100%.
# Vân tay vị trí = MAC của router (default gateway). Cần 2 shortcut: "Charge 80", "Charge 100".
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
STATE="$HOME/.charge_loc"
LOG="$HOME/.charge_loc.log"
GW=$(route -n get default 2>/dev/null | awk '/gateway/{print $2}')
[[ -z "$GW" ]] && exit 0                                   # không có mạng: giữ nguyên
for i in 1 2 3; do                                         # ARP cache hết hạn nhanh: ping rồi đọc lại
  ping -c1 -t2 "$GW" >/dev/null 2>&1
  FP=$(arp -n "$GW" 2>/dev/null | awk '{print $4}')
  [[ "$FP" =~ '^[0-9a-f]{1,2}(:[0-9a-f]{1,2}){5}$' ]] && break
done
[[ "$FP" =~ '^[0-9a-f]{1,2}(:[0-9a-f]{1,2}){5}$' ]] || exit 0   # không ra MAC: giữ nguyên
NOW=$(date +%s)
LAST=""; SINCE=$NOW; MODE=""
[[ -f "$STATE" ]] && read -r LAST SINCE MODE < "$STATE"
[[ "$FP" != "$LAST" ]] && SINCE=$NOW
(( NOW - SINCE >= 86400 )) && WANT=80 || WANT=100
# shortcut fail (chưa tạo, lỗi...) thì giữ MODE cũ -> lần chạy sau thử lại
if [[ "$MODE" != "$WANT" ]] && shortcuts run "Charge $WANT"; then
  MODE=$WANT; echo "$(date) at $FP since $(date -r $SINCE) -> $WANT%" >> "$LOG"
fi
echo "$FP $SINCE $MODE" > "$STATE"
