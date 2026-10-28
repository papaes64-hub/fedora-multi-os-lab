# Windows 10: QXL, SPICE и общая папка

Подтверждено: виртуальная машина `win10` в **`qemu:///system`** на Fedora 44, 2 vCPU, ~12 ГиБ RAM. Используются QXL, SPICE, канал `com.redhat.spice.0`, звуковая карта ICH9 и SPICE-аудио. Звук и изображение с масштабированием проверены пользователем. SPICE Guest Tools / QEMU Guest Agent присутствовали.

### Передача папки (SPICE WebDAV)

1. **Выключите** Windows перед изменением конфигурации оборудования. В Virt-Manager → Добавить оборудование → Канал → `Порт SPICE (spiceport)` → имя **`org.spice-space.webdav.0`**.
2. В Windows установите **SPICE WebDAV Proxy** с [официального сайта](https://www.spice-space.org/download.html) и проверьте в `services.msc` службу `Spice webdav proxy`.
3. На Fedora подключитесь к *уже запущенной* VM через `virt-viewer -c qemu:///system win10`; в **настройках Virt-Viewer, не Windows** включите «Общая папка», выберите `/home/USER/Общедоступные`, отключите «Только для чтения».
4. В **PowerShell Windows с правами администратора** можно проверить и запустить службы:

```powershell
Get-Service WebClient,spice-webdavd
Start-Service spice-webdavd
Start-Service WebClient
Test-NetConnection 127.0.0.1 -Port 9843
```

5. **Только после** `TcpTestSucceeded : True` подключите диск командой:

```powershell
net use * http://localhost:9843/
```

6. Пользователь создал на сетевом диске `Windows Test` — папка появилась на Fedora. После перезагрузки диск восстановился автоматически как **Z:** (в предыдущей сессии назывался **Y:**). Буква не фиксирована. Для повторного подключения может понадобиться активная сессия Virt-Viewer с включённым общим доступом.

В завершённой конфигурации службы `WebClient` и `spice-webdavd` переведены в автоматический запуск. Не отключайте SELinux, UFW или брандмауэр ради этой процедуры. XML виртуальной машины с реальными идентификаторами сохраняйте только в локальный личный архив.

Справка: https://www.spice-space.org/spice-user-manual.html
