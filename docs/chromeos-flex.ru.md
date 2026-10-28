# ChromeOS Flex: рабочая конфигурация Fedora 44

Тест на Intel N95: **QEMU/KVM, 4 vCPU, 12 ГиБ RAM**, локальный диск `~/VMs/chromeos-flex.qcow2`. Видео — `virtio-vga-gl`, GTK GL; звук — PipeWire с `intel-hda` и `hda-duplex`. Общий каталог Fedora: `~/Общедоступные`, QEMU user-mode SMB.

**Готовый пример:** `bash scripts/run-chromeos-flex.sh` (предварительно выключите другую копию Flex). Скрипт не создаёт, не скачивает и не форматирует диск гостя. Если пути иные, задайте `CHROME_DISK=... SHARE_DIR=...`.

Важные параметры QEMU:

```text
-enable-kvm -cpu host -smp 4 -m 12G
-nic user,model=e1000,smb=/home/USER/Общедоступные
-audiodev pipewire,id=snd0
-device intel-hda
-device hda-duplex,audiodev=snd0
-device virtio-vga-gl
-display gtk,gl=on,show-cursor=on
```

Из ChromeOS Flex в приложении «Файлы» добавить SMB ресурс **`\\10.0.2.4\qemu`**. Используйте имя `qemu` или любое удобное. Подключённая папка показала файл Fedora `test-fedora.txt`; папка, созданная из ChromeOS, появилась на Fedora. В некоторых версиях ChromeOS для активации кнопки «Добавить» нужен именно UNC-формат, а не `smb://`.

Если звука нет, сравните **фактическую командную строку** запущенного процесса с параметрами скрипта: старая иконка у оператора запускала QEMU **без** `smb=` и аудиоустройств. Проверяйте `ps -ww -eo args | grep '[q]emu-system-x86_64'`.

QEMU SMB внутри `-netdev user` использует Samba на хосте. На Fedora в тесте пакет Samba уже был установлен. Не открывайте ради этой конфигурации внешние SMB-порты.
