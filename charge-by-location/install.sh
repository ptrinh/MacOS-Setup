#!/bin/zsh
# Cài script + LaunchAgent (chạy mỗi giờ và khi đăng nhập). Chạy lại được nhiều lần.
set -e
cd "${0:A:h}"
LABEL=com.phil.charge-by-location
mkdir -p ~/.local/bin ~/Library/LaunchAgents
install -m 755 charge-by-location.sh ~/.local/bin/
install -m 644 $LABEL.plist ~/Library/LaunchAgents/
launchctl bootout gui/$(id -u)/$LABEL 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/$LABEL.plist
shortcuts list | grep -qx 'Charge 80' && shortcuts list | grep -qx 'Charge 100' \
  || echo "⚠️  Chưa có shortcut 'Charge 80' / 'Charge 100' — tạo trong app Shortcuts."
echo "Đã cài. Kiểm tra: cat ~/.charge_loc ~/.charge_loc.log"
