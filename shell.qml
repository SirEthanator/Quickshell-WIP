//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "menu" as Menu;
import "notifications" as Notifications;
import "desktop" as Desktop;
import "osd" as OSD;
import "invalidConf" as InvalidConf;
import "utils" as Utils;
import Quickshell.Io;
import QtQuick;

ShellRoot {
  id: shellroot;

  Component.onCompleted: {
    Utils.Validate.validateConfig();
    Menu.Controller.init();
  }

  IpcHandler {
    target: "screensaver";
    function open():  void { Globals.states.screensaverActive = true  }
    function close(): void { Globals.states.screensaverActive = false }
  }

  IpcHandler {
    target: "config";

    function colours(scheme: string, reload: bool): string {
      return Globals.setColours(scheme, reload);
    }
    function wallpaper(path: string, reload: bool): void {
      Globals.setWallpaper(path, reload)
    }
    function reload(): void {
      Quickshell.reload(false);
    }
  }

  Notifications.Popups {}
  OSD.Index {}

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index { screen: scope.modelData }
      Desktop.Index { screen: scope.modelData }
      Screensaver { screen: scope.modelData; show: Globals.states.screensaverActive }
      InvalidConf.Index { screen: scope.modelData }
    }
	}
}

