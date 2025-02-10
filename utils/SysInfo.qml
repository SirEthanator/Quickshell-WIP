pragma Singleton

import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root

  property string username: "";
  property string hostname: "";

  // TODO: Try to find a better way than manually making a process for every item - maybe a repeater?
  Process {
    command: ["whoami"]
    running: true;
    stdout: SplitParser {
      onRead: data => root.username = data
    }
  }

  Process {
    command: ["hostname"]
    running: true;
    stdout: SplitParser {
      onRead: data => root.hostname = data
    }
  }
}

