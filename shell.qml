//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import qs.singletons
import Quickshell;
import qs.widgets.bar as Bar;
import qs.widgets.sidebar as Sidebar;
import qs.widgets.notifications as Notifications;
import qs.widgets.lock as Lock;
import qs.widgets.desktop as Desktop;
import qs.widgets.osd as OSD;
import qs.widgets.screensaver as Screensaver;
import qs.widgets.settings as Settings;
import Quickshell.Io;
import QtQuick;

ShellRoot {
  id: shellroot;

  settings.watchFiles: false;

  IpcHandler {
    target: "screensaver";
    function open():  void { Globals.states.screensaverActive = true  }
    function close(): void { Globals.states.screensaverActive = false }
  }

  IpcHandler {
    target: "config";

    function theme(scheme: string): string {
      return Conf.switchTheme(scheme);
    }
    function colours(scheme: string): string {
      return Conf.setColours(scheme);
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
      // Due to some issues with binding to Globals from screensaver and theme overlay, some properties are passed in here.
      Lock.Index {}
      Screensaver.Index {
        screen: scope.modelData;
        show: Globals.states.screensaverActive;
        onHide: Globals.states.screensaverActive = false;
      }
    }
	}

  // This needs to be created after the bar in order to
  // ensure exclusivity is handled correctly.
  // If created before the bar, it does not
  // respect the bar's exclusive zone when in niri.
  Notifications.Popups {}

  // These can be created in any order as they use
  // lazy loaders - they are created after other windows
  Settings.Index {}
  Sidebar.Index {}
  OSD.Index {}
}

