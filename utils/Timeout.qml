pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  id: root;

  function setTimeout(callback, delay: int) {
    function Timer() {
      return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
    }

    if (typeof callback !== "function") return

    const timer = new Timer();
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

