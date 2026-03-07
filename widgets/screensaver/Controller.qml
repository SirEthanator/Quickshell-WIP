pragma Singleton

import Quickshell;
import Quickshell.Io;

Singleton {
  id: root;
  property bool open: false;

  IpcHandler {
    target: "screensaver";
    function open():  void { root.open = true }
    function close(): void { root.open = false }
  }
}
