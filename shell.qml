//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "menu" as Menu;
import "notifications" as Notifications;
import "background" as Background;
import "osd" as OSD;
import Quickshell.Io;
import QtQuick;

ShellRoot {
  id: shellroot;
  Component.onCompleted: Menu.Controller.init()

  IpcHandler {
    target: "screensaver";
    function open():  void { Globals.states.screensaverActive = true  }
    function close(): void { Globals.states.screensaverActive = false }
  }

  Notifications.Popups {}
  OSD.Index {}

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index { screen: scope.modelData }
      Background.Index { screen: scope.modelData }
      Screensaver { screen: scope.modelData }
    }

	}
}

