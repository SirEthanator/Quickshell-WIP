pragma Singleton

import qs.widgets.sidebar as Sidebar;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  property int currentIndex: 0;

  function select(item: string): void {
    Quickshell.execDetached(["sh", "-c", `cliphist decode '${item}' | wl-copy`]);
    Sidebar.Controller.deactivate("clipboard");
  }

  // function decode(item: string): void {
  //   decoder.currentItem = item;
  //   decoder.running = true;
  // }
  //
  // property string lastDecoded: "";
  //
  // Process {
  //   id: decoder;
  //
  //   property string currentItem: "";
  //
  //   command: ["sh", "-c", `cliphist decode '${currentItem}'`];
  //
  //   stdout: SplitParser {
  //     onRead: (data) => root.lastDecoded = data;
  //   }
  // }
}
