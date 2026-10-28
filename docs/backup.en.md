# Private baseline backup

On Fedora, run `bash scripts/backup-local-config.sh`. This creates a private archive of **selected local configuration files** and SHA-256. It does **not** include `.qcow2`, `.img`, `.iso`, EFI/OVMF binaries, OpenCore disks, guest OS data or the host share itself. It may still contain sensitive machine paths and libvirt identifiers. **Never commit or upload it to a public repository.**

Included when present: actual ChromeOS startup script, local OSX-KVM launch scripts, specifically named desktop shortcuts, **inactive** `win10` libvirt XML, and limited host package details. No recursive `~/VMs` or `~/OSX-KVM` copy is performed.

**Not included:** virtual machine storage. For disaster recovery, shut down guests and store disk images, NVRAM and guest-specific files separately in sufficiently large protected storage. Avoid copying a **live** qcow2 with plain `cp`/`tar` without a snapshot-aware backup strategy. Config archive alone cannot restore the guest OS.

For restoration: first set up compatible Fedora, QEMU and libvirt; verify that you have properly licensed guests and disk images; compare paths and permissions; run `bash -n` on launch scripts; apply config changes only while the target VM is **shut down**. Never blindly overwrite working libvirt XML or launchers.
