pragma Singleton

import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root

  property string username: "";
  property string hostname: "";
  property string network: "";
  property int    networkStrength;
  property string dateAndTime: "";

  Timer {
    running: true;
    triggeredOnStart: true;
    interval: 1000;
    repeat: true;
    onTriggered: {
      root.dateAndTime = new Date().toLocaleString(Qt.locale(), "ddd dd/MM/yy | hh:mm:ss ap")
    }
  }

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

  Process {
    command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
    running: true;
    stdout: SplitParser {
      onRead: data => root.network = data
    }
  }

  RepeatingProcess {
    command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"];
    interval: 1000;
    parseOut: SplitParser {
      onRead: data => root.networkStrength = parseInt(data);
    }
  }
}

