#!/bin/zsh
# Lighter login and background load. Safe to re-run.
# Usage: ./install.sh [--sudo]   (--sudo also applies the power settings)
cd "${0:A:h}"
UID_=$(id -u)

###############################################################################
# Staggered app launch: open heavy apps in the background some seconds after  #
# login instead of all at once. Format: label:App Name:delay-seconds          #
###############################################################################
DELAYED=(
  "discord:Discord:20"
  "lark:Lark:30"
  "chrome:Google Chrome:50"
  "dropbox:Dropbox:60"
)
mkdir -p ~/Library/LaunchAgents
for entry in $DELAYED; do
  IFS=: read -r label app delay <<< "$entry"
  [[ -d "/Applications/$app.app" ]] || { echo "Skip delayed launch: $app not installed"; continue; }
  plist=~/Library/LaunchAgents/com.phil.delay.$label.plist
  cat > $plist <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.phil.delay.$label</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>-c</string>
        <string>sleep $delay &amp;&amp; open -a "$app" -j</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST
  echo "Delayed launch: $app after ${delay}s (from next login)"
done
echo "Remove these apps from System Settings > General > Login Items so they don't also start immediately."

###############################################################################
# Background services that aren't needed                                      #
###############################################################################
for svc in \
  com.apple.Siri.agent \
  com.apple.FolderActionsDispatcher \
  com.apple.ScriptMenuApp \
  com.apple.ManagedClientAgent.enrollagent \
  com.apple.appleseed.seedusaged.postinstall; do
  launchctl disable gui/$UID_/$svc
done
# Siri off, no menu bar icon
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

###############################################################################
# Lower RAM / GPU load                                                        #
###############################################################################
# Less WindowServer/GPU work: no transparency, no motion effects
# (com.apple.universalaccess may need Full Disk Access for the terminal)
defaults write com.apple.universalaccess reduceTransparency -bool true 2>/dev/null
defaults write com.apple.universalaccess reduceMotion -bool true 2>/dev/null

# Chrome: Memory Saver on (discards inactive tabs). Set as a "recommended" policy,
# so it can still be changed in chrome://settings/performance
defaults write com.google.Chrome HighEfficiencyModeEnabled -bool true

# OrbStack: don't start the Linux VM at login (start it when needed)
command -v orb >/dev/null && orb config set app.start_at_login false

# Gradle: stop idle daemons after 15 minutes instead of 3 hours (each holds 0.5-2 GB)
mkdir -p ~/.gradle; touch ~/.gradle/gradle.properties
grep -q '^org.gradle.daemon.idletimeout=' ~/.gradle/gradle.properties \
  || echo 'org.gradle.daemon.idletimeout=900000' >> ~/.gradle/gradle.properties

###############################################################################
# Power (sudo)                                                                #
###############################################################################
if [[ "$1" == "--sudo" ]]; then
  sudo pmset -c sleep 0          # on charger: never sleep, so long agent runs and builds finish
  sudo pmset -c displaysleep 5
  sudo pmset -b displaysleep 2
fi
echo "Done. Background service changes take effect after a logout."
