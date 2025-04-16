pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  id: root;

  function setTimeout(callback, delay: int) {

    if (typeof callback !== "function") return

    const timer = Qt.createQmlObject("import QtQuick; Timer {}", root);
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(() => {
      timer.destroy();
      callback()
    });
    timer.start();
    return timer;
  }
}

