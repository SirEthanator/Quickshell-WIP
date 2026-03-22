pragma Singleton

import qs.panels.sidebar as Sidebar;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  property int currentIndex: 0;

  readonly property alias model: listModel;

  ListModel {
    id: listModel;
  }

  Connections {
    target: Sidebar.Controller;

    function onDeactivated(id) {
      if (id === "clipboard") {
        root.currentIndex = 0;
      }
    }
  }

  function updateModel() {
    listModel.clear();
    cliphistList.running = true;
  }

  Process {
    id: cliphistList;
    command: ["sh", "-c", "cliphist list"];
    stdout: SplitParser {
      onRead: (data) => {
        listModel.append({ value: data });
      }
    }
  }

  function down(amount=1) {
    const len = listModel.count;
    currentIndex = (((currentIndex + amount) % len) + len) % len;
  }

  function up(amount=1) {
    down(-amount);
  }

  function shellSafeStr(str: string): string {
    return `'${str.replace(/\\/g, "\\\\").replace(/'/g, "'\\''")}'`;
  }

  function select(index: int): void {
    const item = listModel.get(index).value;
    Quickshell.execDetached(["sh", "-c", `printf '%s' ${shellSafeStr(item)} | cliphist decode | wl-copy --type text/plain`]);
    Sidebar.Controller.deactivate("clipboard");
  }

  function del(index: int): void {
    const item = listModel.get(index).value;
    Quickshell.execDetached(["sh", "-c", `printf '%s' ${shellSafeStr(item)} | cliphist delete`]);
    listModel.remove(index);
  }

  function clear(): void {
    Quickshell.execDetached(["sh", "-c", "cliphist wipe"]);
    listModel.clear();
  }
}
