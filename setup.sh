#!/bin/zsh
# Set up a new Mac in one go. Each step is safe to re-run.
# Usage: ./setup.sh [--sudo] [--hostname NAME] [--login-message TEXT]
#   Options are passed to macos-defaults; --sudo also applies the power settings in performance.
cd "${0:A:h}"
SUDO=; [[ " $* " == *" --sudo "* || " $* " == *" --hostname "* || " $* " == *" --login-message "* ]] && SUDO=--sudo
FAILED=()
step() {
  local title=$1; shift
  echo "\n==================== $title ===================="
  "$@" || FAILED+=("$title")
}
step "Apps (Rosetta, Homebrew, Brewfile)" ./install-apps/install.sh
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null
step "zsh, prompt, terminal profiles"     ./zsh-setup/install.sh
step "AI coding tools"                    ./ai-coding/install.sh
step "macOS defaults"                     ./macos-defaults/defaults.sh "$@"
step "Performance"                        ./performance/install.sh $SUDO
step "Charge limit by location"           ./charge-by-location/install.sh

echo
if (( ${#FAILED} )); then printf "Finished with errors in:\n"; printf "  - %s\n" "${FAILED[@]}"; exit 1; fi
echo "All done. Log out and back in (or restart) to apply everything."
