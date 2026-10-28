# Waydroid on Fedora 44 — unverified scope

The operator confirmed **Waydroid was installed** on Fedora 44. In this project session, its exact shared folders, container setup, sound and graphics were **not audited**. Working configurations from earlier Linux distributions must not be represented as verified on Fedora.

Read-only inspection:

```bash
command -v waydroid || true
waydroid status || true
systemctl status waydroid-container --no-pager || true
```

A reproducible Waydroid section can be added once the installation and its export-safe settings are checked.
