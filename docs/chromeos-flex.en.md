# ChromeOS Flex: Fedora 44 configuration

Confirmed on Intel N95: **QEMU/KVM, four vCPUs, 12 GiB RAM**. Local guest image `~/VMs/chromeos-flex.qcow2`; `virtio-vga-gl` with GTK GL; PipeWire with virtual `intel-hda` + `hda-duplex`; QEMU user networking plus SMB export of `~/Общедоступные`.

Run `bash scripts/run-chromeos-flex.sh` only after shutting down any existing Flex VM. The script **does not create or format a disk**. Override `CHROME_DISK` and `SHARE_DIR` if necessary.

Key QEMU flags:

```text
-enable-kvm -cpu host -smp 4 -m 12G
-nic user,model=e1000,smb=/home/USER/Общедоступные
-audiodev pipewire,id=snd0
-device intel-hda
-device hda-duplex,audiodev=snd0
-device virtio-vga-gl
-display gtk,gl=on,show-cursor=on
```

In ChromeOS Files, add SMB share **`\\10.0.2.4\qemu`**. Both host-to-guest file visibility and guest-to-host folder creation were tested. Some ChromeOS versions may need UNC syntax to enable the Add button.

Troubleshooting: an older desktop shortcut initially started Flex without sound or SMB. Verify the **running** QEMU arguments (not only the script contents): `ps -ww -eo args | grep '[q]emu-system-x86_64'`.

QEMU's user-mode `smb=` feature needs Samba available on the host; it does not require exposing LAN-facing host SMB ports in this setup.
