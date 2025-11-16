pragma Singleton

import qs
import Quickshell;
import Quickshell.Io;
import Quickshell.Services.Pipewire;
import QtQuick;

Singleton {
  id: root

  function capitalise(text: string, capitalise=true): string {
    if (!capitalise) return text;
    return text[0].toUpperCase() + text.slice(1);
  }

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

  // TODO: Cleanup date and time stuff
  property alias clock: clock;
  property string time: Qt.formatDateTime(clock.date, 'hh:mm:ss ap');
  property string date: Qt.formatDateTime(clock.date, 'ddd dd/MM/yy');
  property string dateAndTime: `${date} | ${time}`;

  property string username: "";
  property string hostname: "";

  property string network: "";
  property int networkStrength ;

  property int brightness;
  property int maxBrightness: 0;

  // In GiB
  property real totalMemory;
  property real freeMemory;

  property int cpuUsage;
  property real cpuTemp;

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

  Process {
    command: ["cat", `/sys/class/backlight/${Globals.conf.osd.backlightName}/max_brightness`]
    running: true;
    stdout: SplitParser {
      onRead: data => root.maxBrightness = data
    }
  }

  Process {
    command: ["hostname"]
    running: true;
    stdout: SplitParser {
      onRead: data => root.hostname = root.capitalise(data, Globals.conf.menu.capitaliseHostname)
    }
  }

  // Gets the display name rather than the actual username
  // If getting the display name fails, the username is used instead
  Process {
    command: ["sh", "-c", `getent passwd "$USER" | cut -d ':' -f 5`];
    running: true;
    stdout: SplitParser {
      onRead: data => {
        const result = !!data
          ? data
          : Quickshell.env("USER");
        root.username = root.capitalise(result, Globals.conf.menu.capitaliseUsername);
      }
    }
  }

  Process {
    command: ["sh", "-c", "grep MemTotal /proc/meminfo | awk '{print $2}'"];
    running: true;
    stdout: SplitParser {
      onRead: data => root.totalMemory = (parseFloat(data) / 1024**2).toFixed(2);
    }
  }

  RepeatingProcess {
    command: ["sh", "-c", "grep MemAvailable /proc/meminfo | awk '{print $2}'"];
    interval: 3000;
    parseOut: SplitParser {
      onRead: data => root.freeMemory = (parseFloat(data) / 1024**2).toFixed(2);
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
    command: ["sh", "-c", "echo $(basename $(sensors | grep 'Package id 0' | awk '{print $4}') '°C')"];
    interval: 3000;
    parseOut: StdioCollector {
      onStreamFinished: root.cpuTemp = parseFloat(text).toFixed(1);
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

