pragma Singleton

import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root

  property int    gap: 10        ;  // use 10 until command has been run
  property string username: ""   ;
  property string hostname: ""   ;
  property string network: ""    ;
  property int    networkStrength;
  property string dateAndTime: "";
  property int    cpuUsage       ;
  property int    memUsage       ;

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
    command: ["hyprctl", "getoption", "general:gaps_out", "-j"];
    running: true;
    stdout: SplitParser {
      onRead: (data) => {
        const json = JSON.parse(data);
        root.gap = json.custom.split(' ')[0]
      }
    }
  }

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
    command: ["sh", "-c", "top -b -n 1 | grep 'Cpu(s)' | awk '{print $2}'"];
    interval: 1000;
    parseOut: SplitParser {
      onRead: data => root.cpuUsage = parseFloat(data).toFixed(0);
    }
  }

  RepeatingProcess {
    command: ["sh", "-c", `free -m | awk 'NR==2{printf "%.2f\\n", $3*100/$2 }'`];
    interval: 1000;
    parseOut: SplitParser {
      onRead: data => root.memUsage = parseFloat(data).toFixed(0);
    }
  }

  RepeatingProcess {
    command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"];
    interval: 10000;
    parseOut: SplitParser {
      onRead: data => root.networkStrength = parseInt(data);
    }
  }
}

