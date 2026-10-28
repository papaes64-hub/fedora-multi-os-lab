# Fedora 44 Multi-OS Lab — English guide

**Validated on October 28, 2026** on Intel N95 (four physical cores), 32 GiB RAM, 2 TB SSD, Fedora 44 host. These are operator-confirmed findings, **not** hardware-independent guarantees.

## Verified matrix

| Guest | Runtime | Guest memory / CPUs | Audio | Video | Shared folder |
| --- | --- | --- | --- | --- | --- |
| ChromeOS Flex | Direct QEMU/KVM | 12 GiB / 4 | PipeWire, Intel HDA ✔ | VirtIO VGA ✔ | QEMU SMB read/write ✔ |
| macOS Sonoma | OSX-KVM / OpenCore | 16 GiB / 3 | PipeWire, VirtIO Sound ✔ | VMware SVGA, fullscreen image scaling ✔ | QEMU SMB read/write ✔ |
| Windows 10 | libvirt / virt-manager | ~12 GiB / 2 | ICH9/SPICE ✔ | QXL/SPICE ✔ | SPICE WebDAV read/write ✔ |
| Waydroid | Installed | — | Not audited | Not audited | Not audited |

For Sonoma, **scaling an image** using `Zoom To Fit` and Fullscreen was verified, **not dynamic guest resolution**. Windows reconnected its WebDAV disk after reboot as **Z:** (previously Y:). Windows sharing depends on an active folder-sharing Virt-Viewer session.

> Resource advice: with a four-core N95, run one demanding VM at a time. Do not modify a running VM's disks or launch configuration.

## Quick start

```bash
bash scripts/verify-host.sh          # read-only inspection
bash scripts/backup-local-config.sh # PRIVATE local config archive; no OS images
```

The archive lands in `~/Fedora-Multi-OS-Lab-Archives/` and gets a SHA-256 checksum. **Never commit it**: it may contain real host paths, identifiers and machine configuration.

## Per-guest documentation

- [ChromeOS Flex audio + QEMU SMB](docs/chromeos-flex.en.md)
- [Sonoma / OSX-KVM](docs/sonoma.en.md)
- [Windows 10 / SPICE WebDAV](docs/windows10.en.md)
- [Waydroid scope](docs/waydroid.en.md)
- [Private backup and restoration](docs/backup.en.md)

## Publication boundaries

Do not publish guest disk images, proprietary operating-system installers, Apple firmware or OS files, OpenCore disk images, private configuration captures, host secrets, passwords or tokens. Sonoma's SLA limits virtualization to Apple-branded systems, so the Intel N95 experiment described here should **not** be taken as a license-compliant deployment recommendation. [Read the Sonoma SLA](https://images.apple.com/legal/sla/docs/macOSSonoma.pdf).

References: [QEMU manual](https://www.qemu.org/docs/master/system/qemu-manpage.html) · [SPICE user manual](https://www.spice-space.org/spice-user-manual.html) · [OSX-KVM](https://github.com/kholia/OSX-KVM).
