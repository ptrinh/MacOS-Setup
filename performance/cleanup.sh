#!/bin/zsh
# Free SSD space: build products, caches and unused simulator data that are rebuilt or
# re-downloaded on demand. Shows what it would remove; pass --yes to actually delete.
# Usage: ./cleanup.sh [--yes]
setopt null_glob
YES=; [[ "$1" == "--yes" ]] && YES=1
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null

size() { du -sh "$@" 2>/dev/null | awk '{print $1}' | paste -sd+ - ; }
run() { if [[ -n $YES ]]; then echo "  → $*"; eval "$@"; else echo "  would run: $*"; fi }

echo "Free before: $(df -h ~ | awk 'NR==2{print $4}')"

echo "\nXcode DerivedData ($(size ~/Library/Developer/Xcode/DerivedData)) — rebuilt on next build"
run 'rm -rf ~/Library/Developer/Xcode/DerivedData/*'

if command -v xcrun >/dev/null; then
  echo "\nSimulators ($(size ~/Library/Developer/CoreSimulator/Devices)): delete devices of removed runtimes, unusable runtimes and runtimes unused for 90 days"
  run 'xcrun simctl delete unavailable'   # booted simulators are left alone
  run 'xcrun simctl runtime delete --unusable 2>&1 | grep -v "No matching"'
  run 'xcrun simctl runtime delete --notUsedSinceDays 90 2>&1 | grep -v "No matching"'
  echo "  Simulator caches ($(size ~/Library/Developer/CoreSimulator/Caches))"
  run 'rm -rf ~/Library/Developer/CoreSimulator/Caches/*'
fi

if command -v brew >/dev/null; then
  echo "\nHomebrew ($(size "$(brew --cache)")): old versions, downloads, unused dependencies"
  run 'brew cleanup --prune=all -s; brew autoremove'
fi

if command -v npm >/dev/null; then
  echo "\nnpm cache ($(size ~/.npm/_cacache))"
  run 'npm cache clean --force 2>/dev/null'
fi

if [[ -d ~/.gradle ]]; then
  echo "\nGradle build cache and old distributions ($(size ~/.gradle/caches/build-cache-1 ~/.gradle/wrapper/dists))"
  run 'command -v gradle >/dev/null && gradle --stop >/dev/null 2>&1; rm -rf ~/.gradle/caches/build-cache-1'
  # keep only the newest wrapper distribution
  run 'ls -dt ~/.gradle/wrapper/dists/*/ 2>/dev/null | tail -n +2 | xargs rm -rf'
fi

if command -v docker >/dev/null && docker info >/dev/null 2>&1; then
  echo "\nDocker: dangling images and build cache (running/stopped containers and tagged images are kept)"
  run 'docker image prune -f; docker builder prune -f'
fi

echo "\nNot touched (review by hand): Xcode Archives ($(size ~/Library/Developer/Xcode/Archives), needed to symbolicate crash reports), ~/.gradle/caches ($(size ~/.gradle/caches)), Downloads ($(size ~/Downloads))"
[[ -n $YES ]] && echo "\nFree after: $(df -h ~ | awk 'NR==2{print $4}')" || echo "\nDry run. Run ./cleanup.sh --yes to delete."
