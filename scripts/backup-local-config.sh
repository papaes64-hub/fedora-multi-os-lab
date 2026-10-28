#!/usr/bin/env bash
# PRIVATE CONFIG ONLY. Excludes VM disks/OS images. No auto-upload or git integration.
set -euo pipefail
umask 077
DEST="${LAB_BACKUP_DIR:-$HOME/Fedora-Multi-OS-Lab-Archives}"
mkdir -p -- "$DEST"
chmod 700 -- "$DEST"
STAMP="$(date +%Y%m%d-%H%M%S)"
WORK="$(mktemp -d "$DEST/.snapshot-XXXXXXXX")"
trap 'rm -rf -- "$WORK"' EXIT
mkdir -p "$WORK/config/VMs" "$WORK/config/OSX-KVM" "$WORK/config/desktop" "$WORK/config/libvirt" "$WORK/config/host"

copy_small_file() {
    local src="$1" rel="$2" max_size=131072 n
    [[ -f "$src" && ! -L "$src" ]] || return 0
    n=$(stat -c %s -- "$src")
    if (( n > max_size )); then
      echo "Skipping unexpectedly large config file: $src ($n bytes)" >&2
      return 0
    fi
    install -m 600 -- "$src" "$WORK/$rel"
    printf 'Saved: %s\n' "$rel"
}
copy_small_file "$HOME/VMs/chromeos-flex-sound-share.sh" 'config/VMs/chromeos-flex-sound-share.sh'
copy_small_file "$HOME/OSX-KVM/OpenCore-Run.sh" 'config/OSX-KVM/OpenCore-Run.sh'
copy_small_file "$HOME/OSX-KVM/OpenCore-Run-Plus.sh" 'config/OSX-KVM/OpenCore-Run-Plus.sh'
copy_small_file "$HOME/.local/share/applications/macos-sonoma.desktop" 'config/desktop/macos-sonoma.desktop'
copy_small_file "$HOME/.local/share/applications/chromeos-flex.desktop" 'config/desktop/chromeos-flex.desktop'

if command -v virsh >/dev/null 2>&1; then
    if virsh -c qemu:///system dumpxml --inactive win10 > "$WORK/config/libvirt/win10.private.xml" 2>/dev/null; then
        chmod 600 "$WORK/config/libvirt/win10.private.xml"
        echo 'Saved: config/libvirt/win10.private.xml (PRIVATE, contains identifiers)'
    else
        rm -f "$WORK/config/libvirt/win10.private.xml"
        echo 'Skipping libvirt XML: not available' >&2
    fi
fi
{
    date -Iseconds
    uname -srv
    cat /etc/fedora-release 2>/dev/null || true
    for pkg in qemu-system-x86-core qemu-audio-pipewire virt-viewer samba virt-manager libvirt; do
      rpm -q "$pkg" 2>/dev/null || true
    done
} > "$WORK/config/host/package-and-kernel.txt"
cat > "$WORK/PRIVATE-DO-NOT-PUBLISH.txt" <<'EOF'
This archive contains real local VM configurations. Do NOT publish, commit,
email or attach it without reviewing/removing all sensitive identifiers.
No guest VM disk images or proprietary OS/firmware binaries are included.
To restore guests you ALSO need separate, consistent offline disk backups.
EOF
OUT="$DEST/Fedora-Multi-OS-Lab-config-$STAMP.tar.gz"
tar -C "$WORK" -czf "$OUT" .
chmod 600 "$OUT"
( cd "$DEST" && sha256sum "$(basename "$OUT")" > "$(basename "$OUT").sha256" )
chmod 600 "$OUT.sha256"
printf '\nPRIVATE backup saved: %s\nSHA-256: %s.sha256\n' "$OUT" "$OUT"
