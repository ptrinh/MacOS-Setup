#!/bin/zsh
# Tooling for AI coding agents: Claude Code, cpu-gate, and resource rules in ~/.claude/CLAUDE.md. Safe to re-run.
set -e
cd "${0:A:h}"

if ! command -v claude >/dev/null && [[ ! -x ~/.local/bin/claude ]]; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

mkdir -p ~/.local/bin
install -m 755 cpu-gate.sh ~/.local/bin/cpu-gate.sh

# Add (or refresh) the resource rules in the global CLAUDE.md, between markers
mkdir -p ~/.claude; touch ~/.claude/CLAUDE.md
BEGIN='<!-- MacOS-Setup:local-resources -->'; END='<!-- /MacOS-Setup:local-resources -->'
python3 - "$BEGIN" "$END" <<'PY'
import os,re,sys
b,e=sys.argv[1],sys.argv[2]
p=os.path.expanduser('~/.claude/CLAUDE.md'); s=open(p).read()
block=f"{b}\n{open('local-resources.md').read().strip()}\n{e}"
s=re.sub(re.escape(b)+r'.*?'+re.escape(e),lambda m:block,s,flags=re.S) if b in s else (s.rstrip()+"\n\n"+block+"\n").lstrip()
open(p,'w').write(s)
PY
echo "Done: claude, ~/.local/bin/cpu-gate.sh, rules in ~/.claude/CLAUDE.md"
