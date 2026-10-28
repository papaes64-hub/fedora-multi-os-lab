# Fedora Multi-OS Lab / «Зоопарк систем»

**English:** [Setup and verified results](README.en.md) · **Русский:** [Инструкция и проверенные результаты](README.ru.md)

Practical multi-OS virtualization on a low-power **Intel N95** host running **Fedora 44**. A hands-on, community-oriented case study with reproducible configuration notes. Verified on **2026-10-28**.

| Guest | Hypervisor / launcher | CPU / RAM | Audio | Display | Host ↔ guest files |
| --- | --- | --- | --- | --- | --- |
| ChromeOS Flex | QEMU/KVM, direct launcher | 4 vCPU / 12 GiB | Intel HDA + PipeWire ✔ | VirtIO VGA/GL ✔ | QEMU SMB ✔ |
| macOS Sonoma | OSX-KVM + OpenCore (existing local install) | 3 vCPU / 16 GiB | VirtIO Sound + PipeWire ✔ | VMware SVGA, fullscreen scaling ✔ | QEMU SMB ✔ |
| Windows 10 | libvirt/virt-manager, SPICE | 2 vCPU / ~12 GiB | ICH9 + SPICE ✔ | QXL + SPICE ✔ | SPICE WebDAV ✔ |
| Waydroid | Installed on Fedora | — | Not audited | Not audited | Not audited |

✔ means the specific function was tested by the project operator. This is **not** a benchmark or universal compatibility guarantee. Although the three guests can be configured, running all simultaneously on a four-core N95 is **not recommended**.

## Contents

- `README.ru.md` / `README.en.md` — complete notes in Russian and English.
- `docs/` — per-OS instructions and restoration notes.
- `scripts/run-chromeos-flex.sh` — host-side ChromeOS launcher with audio + SMB (edit disk path if necessary).
- `scripts/launch-sonoma-installed.sh` — launcher for **your existing local** OSX-KVM configuration; not an installer.
- `scripts/verify-host.sh` — read-only checks for expected files and components.
- `scripts/backup-local-config.sh` — **private**, configuration-only archive; never upload its output to GitHub.
- `.gitignore` / `SECURITY.md` — deliberately exclude VM images, credentials and private backups.

## Boundaries / legal

No Windows or ChromeOS images, Apple software, firmware, OpenCore disk images, credentials, or VM disks are included. macOS Sonoma's software license restricts its use to Apple-branded systems; the documented Intel N95 experiment does **not** constitute a license-compliant deployment recommendation. Consult your licenses and follow platform terms. Details: [Apple's Sonoma SLA](https://images.apple.com/legal/sla/docs/macOSSonoma.pdf).

Sources: [QEMU user networking / SMB](https://www.qemu.org/docs/master/system/qemu-manpage.html), [SPICE folder sharing](https://www.spice-space.org/spice-user-manual.html), [OSX-KVM upstream](https://github.com/kholia/OSX-KVM).

This repository is independent of the separately maintained Linux Tablet project.
