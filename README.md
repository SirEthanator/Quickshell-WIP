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

## IPC

Available IPC commands are:

- `menu`
  - `toggle` - Toggle the menu
- `lock`
  - `lock` - Lock the screen
- `config`
  - `colors <scheme: string>` - Set the color scheme to `scheme`
  - `reload` - Reload the config
  - `wallpaper <path: string>` - Set the wallpaper to `path`
  - `get <category: string> <key: string>` - Returns the value of option `key` from category `category`
  - `theme <scheme: string>` - Same as colors but also runs the SetTheme script
- `screensaver`
  - `open` - Open the screensaver
  - `close` - Close the screensaver
- `settings`
  - `open` - Open the settings menu
  - `close` - Close the settings menu
- `backlight`
  - `set <percentage: int>` - Set brightness to `percentage` (clamped 0-100)
  - `increment <percentage: int>` - Increment brightness by `percentage` (clamped)
  - `decrement <percentage: int>` - Decrement brightness by `percentage` (clamped)
