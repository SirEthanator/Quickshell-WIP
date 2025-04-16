pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  id: root;

  function run(command, returnOut=false) {
    const proc = Qt.createQmlObject("import Quickshell.Io; Process {}", root);
    proc.command = command;
    proc.running = true;
    return proc;
  }
}

