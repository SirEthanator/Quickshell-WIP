pragma Singleton

import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root

  property string windowTitle: "";
  property string appTitle: "";

  Socket {
    connected: true;
    onConnectedChanged: connected = true;
    path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket2.sock";

    parser: SplitParser {
      splitMarker: "";
      onRead: message => {
        const lines = message.split(/\n(?=.+>>|$)/);

        for (let i=0; i<lines.length; i++) {
          const line = lines[i];
          if (!line) continue;
          const [, type, body] = line.match(/(.+)>>([\s\S]*)/);
          const args = body.split(",")

          // ===== Part that does stuff =====
          switch (type) {
            case "activewindow": {
              windowTitle = args[1];
              appTitle = args[0];
              break
            }
          }
          // ================================
        }
      }
    }
  }

  property string tmp: "";
  Process {
    command: ["hyprctl", "activewindow", "-j"];
    running: true;
    stdout: SplitParser {
      onRead: (data) => {
        root.tmp += data+"\n"
      }
    }
    onRunningChanged: {
      if (!running) {
        const json = JSON.parse(root.tmp);
        root.windowTitle = json.title;
        root.appTitle = json.class;
        root.tmp = "";
      }
    }
  }

}

