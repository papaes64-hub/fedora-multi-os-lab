# macOS Sonoma: documented OSX-KVM experiment

**License note:** the macOS Sonoma SLA requires Apple-branded systems. The Intel N95 experiment does **not** satisfy that condition. This project shares no Apple OS content, OpenCore disks, firmware or guest disk images. [SLA](https://images.apple.com/legal/sla/docs/macOSSonoma.pdf).

The previously installed Sonoma `qcow2` was **copied** from Quickemu into an OSX-KVM working directory; its original image was preserved. No VM disks are distributed.

Observed working configuration:

- QEMU/KVM, **16 GiB RAM, three guest CPUs**; four-core Intel N95 host.
- `taskset -c 1-3` to leave host CPU 0 free; a local `Skylake-Client` CPU profile with specific flags.
- `vmware-svga`, GTK `zoom-to-fit=on,gl=off`. QEMU's View → Zoom To Fit and Fullscreen visually scaled the image to nearly fill the screen. **This does not dynamically change guest resolution**.
- `-audiodev pipewire,id=snd0` and `-device virtio-sound-pci,audiodev=snd0` — sound tested.
- `-netdev user,id=net0,smb=/home/USER/Общедоступные` with VirtIO network; Finder connected to `smb://10.0.2.4/qemu` as Guest. Bidirectional file creation confirmed by a `sonoma-test` folder.
- Guest resolution during the test: **1280×800**.

The operator's complete local working launcher was `~/OSX-KVM/OpenCore-Run-Plus.sh`. We deliberately **do not distribute** private real-machine files or the necessary proprietary / boot images. `scripts/launch-sonoma-installed.sh` only delegates to a **pre-existing local configuration**. It is not a macOS installer.

For supported hardware refer to [upstream OSX-KVM](https://github.com/kholia/OSX-KVM). Shut down a guest and back up its image before experimental modifications.
