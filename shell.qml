//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import qs
import Quickshell;
import "widgets/bar" as Bar;
import "widgets/menu" as Menu;
import "widgets/notifications" as Notifications;
import "widgets/lock" as Lock;
import "widgets/polkit" as Polkit;
import "widgets/desktop" as Desktop;
import "widgets/osd" as OSD;
import "widgets/screensaver" as Screensaver;
import "widgets/config" as Config;
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
      return Globals.switchTheme(scheme);
    }
    function colours(scheme: string): string {
      return Globals.setColours(scheme);
    }
    function wallpaper(path: string): void {
      Globals.setWallpaper(path)
    }
    function get(category: string, key: string): string {
      const cat = Globals.conf[category]
      const val = cat[key]
      if (cat.getMetadata(key).type == 'path') {
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
      Desktop.BlurredWallpaper { screen: scope.modelData }
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
  // When created before the bar, it does not
  // respect the bar's exclusive zone when in niri.
  Notifications.Popups {}

  // These can be created in any order as they use
  // lazy loaders - they are created after other windows
  Config.Index {}
  Menu.Index {}
  OSD.Index {}
  Polkit.Index {}
}

