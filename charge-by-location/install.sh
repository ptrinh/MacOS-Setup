#!/bin/zsh
# Install the script + LaunchAgent (runs hourly and at login). Safe to re-run.
set -e
cd "${0:A:h}"
LABEL=com.phil.charge-by-location
mkdir -p ~/.local/bin ~/Library/LaunchAgents
install -m 755 charge-by-location.sh ~/.local/bin/
install -m 644 $LABEL.plist ~/Library/LaunchAgents/
launchctl bootout gui/$(id -u)/$LABEL 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/$LABEL.plist
shortcuts list | grep -qx 'Charge 80' && shortcuts list | grep -qx 'Charge 100' \
  || echo "⚠️  Shortcuts 'Charge 80' / 'Charge 100' not found. Create them in the Shortcuts app."
echo "Installed. Check: cat ~/.charge_loc ~/.charge_loc.log"
