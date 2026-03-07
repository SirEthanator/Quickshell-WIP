pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  id: root;

  signal launchConfMenu;

  PersistentProperties {
    id: persist

    property bool screensaverActive: false;
  }

  property alias states: persist;
}
