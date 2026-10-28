#!/usr/bin/env bash
# Direct QEMU/KVM example, validated on Fedora 44 / Intel N95.
# Requires EXISTING guest disk. Never creates or formats guest storage.
set -euo pipefail
DISK="${CHROME_DISK:-$HOME/VMs/chromeos-flex.qcow2}"
SHARE="${SHARE_DIR:-$HOME/Общедоступные}"
for command in qemu-system-x86_64; do
  command -v "$command" >/dev/null || { echo "Missing: $command" >&2; exit 1; }
done
[[ -f "$DISK" ]] || { echo "Guest disk missing: $DISK" >&2; exit 1; }
[[ -d "$SHARE" ]] || { echo "Shared folder missing: $SHARE" >&2; exit 1; }
[[ -r /dev/kvm && -w /dev/kvm ]] || { echo "KVM not accessible" >&2; exit 1; }
if pgrep -u "$(id -u)" -af 'qemu-system-x86_64' | grep -Fq "$DISK"; then
  echo "ChromeOS Flex seems to be running already; refusing duplicate start" >&2
  exit 1
fi
printf 'ChromeOS Flex with PipeWire + SMB share: %s\n' "$SHARE"
exec qemu-system-x86_64 \
  -enable-kvm -cpu host -smp 4 -m 12G \
  -drive "file=$DISK,format=qcow2,if=ide" -boot c \
  -nic "user,model=e1000,smb=$SHARE" \
  -device virtio-vga-gl \
  -device qemu-xhci -device usb-tablet \
  -display gtk,gl=on,show-cursor=on \
  -audiodev pipewire,id=snd0 \
  -device intel-hda \
  -device hda-duplex,audiodev=snd0
