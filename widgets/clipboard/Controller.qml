pragma Singleton

import qs.panels.sidebar as Sidebar;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  property int currentIndex: 0;

  property list<string> model: [];

  Connections {
    target: Sidebar.Controller;

    function onDeactivated(id) {
      if (id === "clipboard") {
        root.currentIndex = 0;
        root.model = [];
      }
    }
  }

  function updateModel() {
    cliphistList.running = true;
  }

  Process {
    id: cliphistList;
    command: ["sh", "-c", "cliphist list"];
    stdout: SplitParser {
      onRead: (data) => {
        root.model.push(data);
      }
    }
  }

  function down(amount=1) {
    const len = model.length;
    currentIndex = (((currentIndex + amount) % len) + len) % len;
  }

  function up(amount=1) {
    down(-amount);
  }

  function select(item: string): void {
    Quickshell.execDetached(["sh", "-c", `cliphist decode '${item}' | wl-copy`]);
    Sidebar.Controller.deactivate("clipboard");
  }
}
