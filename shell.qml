//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import qs.singletons
import Quickshell;
import qs.panels.bar as Bar;
import qs.panels.sidebar as Sidebar;
import qs.panels.notifications as Notifications;
import qs.panels.lock as Lock;
import qs.panels.desktop as Desktop;
import qs.panels.osd as OSD;
import qs.panels.screensaver as Screensaver;
import qs.panels.settings as Settings;
import Quickshell.Io;
import QtQuick;

ShellRoot {
  settings.watchFiles: false;

  IpcHandler {
    target: "config";

    function theme(scheme: string): string {
      return Conf.switchTheme(scheme);
    }
    function colors(scheme: string): string {
      return Conf.setColors(scheme);
    }
    function wallpaper(path: string): void {
      Conf.setWallpaper(path)
    }
    function get(category: string, key: string): string {
      const val = Conf[category][key];
      if (Conf.getMetadata(category, key)?.type == 'path') {
        return val.replace('file://', '')
      }
      return val;
    }
    function reload(): void {
      Quickshell.reload(false);
    }
  }

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index { screen: scope.modelData }
      Desktop.BackdropWallpaper { screen: scope.modelData }
      Desktop.Index { screen: scope.modelData }
      Lock.Index {}
      Screensaver.Index { screen: scope.modelData; }
    }
	}

  // This needs to be created after the bar in order to
  // ensure exclusivity is handled correctly.
  // If created before the bar, it does not
  // respect the bar's exclusive zone in niri.
  Notifications.Popups {}

  // These can be created in any order because they use
  // lazy loaders - they are created after other windows
  Settings.Index {}
  Sidebar.Index {}
  OSD.Index {}
}

