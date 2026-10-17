# ai-coding

Setup for running AI coding agents (Claude Code) on a shared Mac without overheating it or filling the disk.

```sh
./install.sh
```

- Installs **Claude Code** (native installer) if missing.
- Installs **[`cpu-gate.sh`](cpu-gate.sh)** to `~/.local/bin`: waits until CPU < 70% (default, max 15 min) before a heavy step. `cpu-gate.sh [max-percent] [max-wait-seconds]`.
- Adds **[`local-resources.md`](local-resources.md)** to `~/.claude/CLAUDE.md` (between markers, refreshed on re-run): rules for agents to throttle on CPU, share build folders, shut down simulators/emulators/containers, prefer light tests and check disk space.
