#!/bin/zsh
# zsh + Starship prompt + autosuggestions/syntax highlighting, the Powerline font,
# and matching iTerm2 / Terminal profiles. Safe to re-run; replaced files are backed up.
set -e
cd "${0:A:h}"
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || { echo "Install Homebrew first (../install-apps)"; exit 1; }
STAMP=$(date +%Y%m%d-%H%M%S)

# Copy $1 to $2, backing up $2 if it exists and differs
put() {
  mkdir -p "${2:h}"
  if [[ -f "$2" ]] && ! cmp -s "$1" "$2"; then mv "$2" "$2.bak-$STAMP"; echo "Backed up $2 -> $2.bak-$STAMP"; fi
  cp "$1" "$2"
}

echo "Installing zsh plugins, Starship, fzf, zoxide..."
brew install starship zsh-autosuggestions zsh-syntax-highlighting fzf zoxide

echo "Installing font..."
FONT=~/Library/Fonts/SourceCodePro+Powerline+Awesome+Regular.ttf
if [[ ! -f $FONT ]]; then
  curl -fsSL -o $FONT "https://raw.githubusercontent.com/gabrielelana/awesome-terminal-fonts/patching-strategy/patched/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf"
  echo "44f51e4e61b171f070ad792ee61fb11c72e682be91d381b94ad9f314e4a5ba20  $FONT" | shasum -a 256 -c - >/dev/null \
    || { rm -f $FONT; echo "Font checksum mismatch"; exit 1; }
fi

echo "Installing zsh config..."
put zshrc ~/.zshrc
put starship.toml ~/.config/starship.toml
mkdir -p ~/.zsh/completions
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

echo "Installing iTerm2 profile..."
put iterm2-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/MacOS-Setup.json
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "7C1F3E2A-5B8D-4E6F-9A10-2D4C6B8E0F13"

echo "Installing Ghostty config..."
put ghostty/config ~/.config/ghostty/config
for t in ghostty/themes/*; do put "$t" ~/.config/ghostty/themes/"${t:t}"; done

echo "Installing Terminal profile..."
defaults write com.apple.Terminal "Window Settings" -dict-add "Clear Dark" "$(sed -n '/^<dict>/,$p' 'Clear Dark.terminal' | sed '$d')"
defaults write com.apple.Terminal "Default Window Settings" -string "Clear Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "Clear Dark"

cat <<'MSG'

Done. Open a new terminal window to use it.
  - Put machine-specific settings and secrets (API keys, tool PATHs) in ~/.zshrc.local
  - Restart iTerm2 / Terminal if they were open (quitting them may otherwise overwrite the new defaults)
MSG
