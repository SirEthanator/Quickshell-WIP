# Quickshell WIP

My WIP quickshell config.

## Configuring

Configuration through the settings menu is preferred, but manual edits can be made. The configuration file is located at `$HOME/.config/quickshell/config.conf`

## Backlight

This shell supports changing the brightness of the internal displays. This includes changing it with the OSD and through ipc commands. To enable this:

1. Configure the backlight name in Settings > OSD
2. Add the following to `/etc/udev/rules.d/90-backlight.rules`:
  ```
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
  ```
3. Add yourself to the video group (if not already in it):
  ```sh
sudo usermod -aG video "$(whoami)"
```
4. Reboot.

Available IPC commands are:

- `quickshell ipc call backlight set <percentage>`
- `quickshell ipc call backlight increment <percentage>`
- `quickshell ipc call backlight decrement <percentage>`

Replace `percentage` with an integer 0 to 100.
