//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import qs
import Quickshell;
import "widgets/bar" as Bar;
import "widgets/menu" as Menu;
import "widgets/notifications" as Notifications;
import "widgets/lock" as Lock;
import "widgets/desktop" as Desktop;
import "widgets/osd" as OSD;
import "widgets/screensaver" as Screensaver;
import "widgets/themeOverlay" as ThemeOverlay;
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

  Config.Index {}
  Menu.Index {}
  Notifications.Popups {}
  OSD.Index {}
  Lock.Index {}

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index { screen: scope.modelData }
      Desktop.BlurredWallpaper { screen: scope.modelData }
      Desktop.Index { screen: scope.modelData }
      // Due to some issues with binding to Globals from screensaver and theme overlay, some properties are passed in here.
      Screensaver.Index {
        screen: scope.modelData;
        show: Globals.states.screensaverActive;
        onHide: Globals.states.screensaverActive = false;
      }
      ThemeOverlay.Index {
        screen: scope.modelData;
        switchInProgress: Globals.states.themeSwitchInProgress;
        overlayOpen: Globals.states.themeOverlayOpen;
        currentAction: Globals.states.themeSwitchingState;
        onClose: Globals.states.themeOverlayOpen = false;
      }
    }
	}
}

