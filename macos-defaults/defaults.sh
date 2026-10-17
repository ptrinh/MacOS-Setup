#!/bin/zsh
# Opinionated macOS defaults, curated from the old macbook-setup/default-writes.sh
# and checked against macOS 27 (Apple Silicon). Safe to re-run.
# Usage: ./defaults.sh            # user-level settings only
#        ./defaults.sh --sudo     # also apply the system-level settings (asks for password)

# Close System Settings so it doesn't overwrite what we change
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Faster window resize and Quick Look animations
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain QLPanelAnimationDuration -float 0.2
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Don't reopen windows when logging back in / relaunching apps
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Quit the printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable smart quotes and dashes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###############################################################################
# Keyboard and trackpad                                                       #
###############################################################################

# Full keyboard access for all controls (e.g. Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Key repeat instead of the accent picker on press-and-hold
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Very fast key repeat (UI minimums: InitialKeyRepeat 15, KeyRepeat 2)
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain KeyRepeat -int 1

# Tap to click (this user and the login screen)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Ctrl + scroll to zoom, follow keyboard focus while zoomed
# (com.apple.universalaccess may need Full Disk Access for the terminal)
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true 2>/dev/null
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144 2>/dev/null
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true 2>/dev/null

###############################################################################
# Screenshots                                                                 #
###############################################################################

defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Allow quitting Finder with Cmd+Q; disable window and Get Info animations
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder DisableAllAnimations -bool true

# New Finder windows open the home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show drives, servers and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Open a Finder window when a volume or disk image is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# List view, hidden files, all extensions, status bar, path bar, full path in title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No warnings when changing an extension or emptying the Trash
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Spring-loaded folders with a shorter delay
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# No .DS_Store files on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show ~/Library
chflags nohidden ~/Library

# Expand the General, Open with and Sharing & Permissions panes in Get Info
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true OpenWith -bool true Privileges -bool true

###############################################################################
# Dock, Mission Control and hot corners                                       #
###############################################################################

defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mouse-over-hilite-stack -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corners: 0 none, 2 Mission Control, 3 app windows, 4 Desktop, 5 screen saver,
# 10 display sleep, 11 Launchpad, 12 Notification Center, 13 Lock Screen, 14 Quick Note
defaults write com.apple.dock wvous-tl-corner -int 2   # top left: Mission Control
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 4   # bottom left: Desktop
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Apps                                                                        #
###############################################################################

# Time Machine: don't offer new disks as backup volumes
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Terminal: UTF-8 only
defaults write com.apple.terminal StringEncodings -array 4

# iTerm2: no prompt when quitting
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Activity Monitor: open main window, CPU history in Dock icon, all processes, sort by CPU
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 6
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# TextEdit: plain text, UTF-8, tab width 4
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
defaults write com.apple.TextEdit TabWidth -int 4

###############################################################################
# System-level (sudo)                                                         #
###############################################################################

if [[ "$1" == "--sudo" ]]; then
  # No boot chime
  sudo nvram StartupMute=%01
  # Show IP, hostname, OS version when clicking the clock on the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
fi

###############################################################################
# Restart affected apps                                                       #
###############################################################################

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "SystemUIServer"; do
  killall "$app" >/dev/null 2>&1
done
echo "Done. Some changes need a logout/restart to take effect."
