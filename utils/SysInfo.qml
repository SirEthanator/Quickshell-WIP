pragma Singleton

import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root

  property string username: "";
  property string hostname: "";
  property string network: "";
  property int networkStrength;

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

  Process {
    id: networkStrengthCmd;
    running: true;
    command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
    stdout: SplitParser {
      onRead: data => root.networkStrength = parseInt(data)
    }
  }

  Timer {
    running: true;
    triggeredOnStart: true;
    interval: 10000;  // Command is very slow so only run every 10 seconds
    repeat: true;
    onTriggered: {
      networkStrengthCmd.running = true;
    }
  }
}

