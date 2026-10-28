# Publication safety

**Do not upload** VM images, recovery images, installer ISOs, firmware, OVMF VARS, OpenCore images, Apple/Windows/ChromeOS executables, `~/Общедоступные`, SSH keys, tokens, cookies, passwords, personal screenshots, unreviewed `.desktop` files, actual libvirt XML or the output of `backup-local-config.sh`.

Only generic examples and operator-verified facts are included in the public project. Double-check every `git status` / `git diff --cached` before your first push. A `.gitignore` is not a substitute for review. Never run arbitrary scripts from untrusted forks.

The private archive is intentionally outside the git checkout by default, with mode `0600` and its directory `0700`.

macOS software is subject to Apple's license, including Apple-branded hardware requirements. No proprietary OS binaries or boot images are distributed here.
