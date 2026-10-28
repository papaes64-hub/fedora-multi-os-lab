# Windows 10: QXL, SPICE and folder sharing

Confirmed: libvirt guest **`win10`** on **`qemu:///system`**, two vCPUs, ~12 GiB RAM, QXL video, SPICE display and sound (ICH9), `com.redhat.spice.0` agent channel. Sound and display scaling were confirmed. SPICE Guest Tools and QEMU Guest Agent were installed.

### SPICE WebDAV folder sharing

1. **Shut down** Windows before adding hardware. Virt-Manager → Add Hardware → Channel → SPICE port (`spiceport`) → **`org.spice-space.webdav.0`**.
2. Install **SPICE WebDAV Proxy** in Windows from the [official SPICE site](https://www.spice-space.org/download.html); inspect the `Spice webdav proxy` service in `services.msc`.
3. From Fedora, attach to the *existing* guest: `virt-viewer -c qemu:///system win10`. In **Virt-Viewer's** Preferences enable folder sharing, select `/home/USER/Общедоступные`, clear read-only.
4. In **Windows PowerShell as administrator**:

```powershell
Get-Service WebClient,spice-webdavd
Start-Service spice-webdavd
Start-Service WebClient
Test-NetConnection 127.0.0.1 -Port 9843
```

5. When `TcpTestSucceeded : True`, map the share:

```powershell
net use * http://localhost:9843/
```

6. A Windows-created `Windows Test` directory appeared on Fedora. After reboot, the share came back as **Z:** (previously **Y:**). Drive letter can change. Sharing requires an active Virt-Viewer client session with the shared folder enabled.

For restart, `WebClient` and `spice-webdavd` were set to Automatic. Do not disable SELinux or firewall to implement this. Keep your actual libvirt XML **private**.

Reference: https://www.spice-space.org/spice-user-manual.html
