#!/bin/zsh
# Set up a new Mac: Rosetta, Homebrew, then the apps in Brewfile. Safe to re-run.
set -e
cd "${0:A:h}"

if [[ "$(uname -m)" == arm64 ]] && ! /usr/bin/arch -x86_64 /usr/bin/true 2>/dev/null; then
  echo "Installing Rosetta..."
  sudo softwareupdate --install-rosetta --agree-to-license
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null \
  || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

echo "Installing apps..."
brew update
brew bundle --file Brewfile

# ArtCraft Launcher (Craft App Suite) is not in Homebrew: install the latest notarized DMG from GitHub
if [[ ! -d "/Applications/ArtCraft Launcher.app" ]]; then
  echo "Installing ArtCraft Launcher..."
  TMP=$(mktemp -d)
  BASE=https://github.com/storytold/craft-launcher/releases/latest/download
  TAG=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/storytold/craft-launcher/releases/latest)
  DMG="artcraft-launcher-${TAG##*/v}-macos-universal.dmg"
  curl -fsSL -o "$TMP/$DMG" "$BASE/$DMG"
  curl -fsSL -o "$TMP/SHA256SUMS.txt" "$BASE/SHA256SUMS.txt"
  (cd "$TMP" && grep " $DMG\$" SHA256SUMS.txt | shasum -a 256 -c -)
  MNT=$(hdiutil attach -nobrowse -readonly "$TMP/$DMG" 2>/dev/null | awk -F'\t' '/\/Volumes\//{print $NF}')
  spctl -a -vv -t exec "$MNT/ArtCraft Launcher.app" 2>&1 | grep -q 'DJ6XS33FX8' \
    && ditto "$MNT/ArtCraft Launcher.app" "/Applications/ArtCraft Launcher.app" \
    || echo "ArtCraft Launcher: signature check failed, skipped"
  hdiutil detach -quiet "$MNT"; rm -rf "$TMP"
fi

cat <<'MSG'

Done. Manual steps:
  - Little Snitch, BlackHole: approve in System Settings > General > Login Items & Extensions
  - Not in Homebrew, download from the vendor if needed:
      OpenEmu  https://openemu.org  (cask disabled: fails Gatekeeper)
      VipRiser https://www.vipriser.com
MSG
