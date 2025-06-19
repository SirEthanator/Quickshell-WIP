pragma Singleton

import "root:/";
import Quickshell;
import Quickshell.Io;
import Quickshell.Services.Pipewire;
import QtQuick;

Singleton {
  id: root

  readonly property PwNode audioNode: Pipewire.defaultAudioSink;
  PwObjectTracker { objects: [ root.audioNode ] }
  readonly property int volume: Math.round(audioNode?.audio.volume * 100);
  readonly property string volumeIcon: {
    if (root.audioNode?.audio.muted) { return "audio-volume-muted-panel-symbolic"  } else
    if (root?.volume >= 90         ) { return "audio-volume-high-danger-symbolic"  } else
    if (root?.volume >= 60         ) { return "audio-volume-high-panel-symbolic"   } else
    if (root?.volume >= 30         ) { return "audio-volume-medium-panel-symbolic" } else
    if (root?.volume >= 1          ) { return "audio-volume-low-panel-symbolic"    }
    else "audio-volume-muted-panel-symbolic";
  }
  readonly property string brightnessIcon: root.brightness >= 50
    ? "brightness-high-symbolic"
    : "brightness-low-symbolic";

  property string dateAndTime: Qt.formatDateTime(clock.date, "ddd dd/MM/yy | hh:mm:ss ap");
  property int    gap: 10         ;  // use 10 until command has been run
  property string username: ""    ;
  property string hostname: ""    ;
  property string network: ""     ;
  property int    networkStrength ;
  property int    cpuUsage        ;
  property int    memUsage        ;
  property int    brightness      ;
  property int    maxBrightness: 0;

  SystemClock { id: clock }

  FileView {
    id: brightnessFile;
    path: Qt.resolvedUrl(`/sys/class/backlight/${Globals.conf.osd.backlightName}/brightness`);
    blockLoading: true;
    watchChanges: true;
    onFileChanged: {
      brightnessFile.reload();
      brightnessFile.waitForJob();
      root.brightness = parseInt(brightnessFile.text()) / root.maxBrightness * 100;
    }
  }

  // TODO: Try to find a better way than manually making a process for every item - maybe a repeater?

  Process {
    command: ["cat", `/sys/class/backlight/${Globals.conf.osd.backlightName}/max_brightness`]
    running: true;
    stdout: SplitParser {
      onRead: data => root.maxBrightness = data
    }
  }

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
    command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
    interval: 10000;
    parseOut: SplitParser {
      onRead: data => root.network = data
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

