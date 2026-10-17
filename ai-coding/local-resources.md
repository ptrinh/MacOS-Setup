## Local machine resources (CPU / RAM / disk)

This Mac is shared with other work. Simulators, emulators and containers left running heat the CPU, and per-agent build folders fill the disk.

- **No cap on parallel agents, but slow down when CPU ≥ 70%.** Before each heavy step (xcodebuild build/test/archive, gradle, large npm/cargo builds, booting a simulator/emulator, `docker` / `supabase start`, e2e tests) run `~/.local/bin/cpu-gate.sh`; it waits until CPU < 70% (max 15 min). When CPU is high: don't fan out more build agents, run heavy steps one at a time, reduce parallelism (`xcodebuild -jobs 2`, `gradle --max-workers=2`).
- **Share the project's build folder** (e.g. `ios/build`); don't create a DerivedData or `/tmp/<project>-<agent>` folder per agent. If you must, delete it when done.
- **Shut down what you started as soon as you're done**: simulators (only the UDID you booted), Android emulators (`adb emu kill`), `supabase stop` / docker containers, `./gradlew --stop`, background processes (servers, log streams, watchers).
- **Prefer light tests** (unit tests) first; UI tests, screenshots, E2E and emulators only when the task needs them or before a release.
- **Check disk** (`df -h ~`) before large builds; with < 15 GB free, clean up temporary build files you created first.
- zsh has a builtin `log`: use `/usr/bin/log` for `log show` / `log stream`.
