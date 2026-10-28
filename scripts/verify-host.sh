#!/usr/bin/env bash
# Read-only summary. Do not paste complete private XML or sensitive env vars online.
set -u
printf '=== Fedora / kernel ===\n'
cat /etc/fedora-release 2>/dev/null || true
uname -r
printf '\n=== CPU / memory ===\n'
lscpu | grep -E 'Model name:|Virtualization:' || true
free -h | head -2
printf '\n=== KVM ===\n'
ls -l /dev/kvm 2>/dev/null || true
printf '\n=== Commands ===\n'
for x in qemu-system-x86_64 qemu-img virsh virt-viewer git smbd; do
  printf '%-23s %s\n' "$x" "$(command -v "$x" || echo missing)"
done
printf '\n=== Local startup files (existence only) ===\n'
for f in "$HOME/VMs/chromeos-flex-sound-share.sh" "$HOME/OSX-KVM/OpenCore-Run-Plus.sh" "$HOME/VMs/chromeos-flex.qcow2" "$HOME/OSX-KVM/mac_hdd_ng.img"; do
  if [[ -e "$f" ]]; then printf 'present: %s\n' "${f/#$HOME/~}"; else printf 'missing: %s\n' "${f/#$HOME/~}"; fi
done
printf '\n=== Windows libvirt (no XML dump) ===\n'
virsh -c qemu:///system domstate win10 2>/dev/null || echo 'win10 VM not accessible'
