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

  // Hyprctl stuff taken from https://github.com/pterror/config-quickshell/blob/master/io/HyprlandIpc.qml (thanks)
	property var currentExec: null

  Socket {
    id: hyprctl
    onConnectedChanged: {
      if (connected) {
        if (root.currentExec) {
          write(root.currentExec.cmd)
          flush()
        }
      } else {
        currentExec?.onSuccess?.(currentExec.ret)
        if (currentExec) {
          currentExec = currentExec.next
        }
        if (currentExec) {
          hyprctl.connected = true
        }
      }
    }
    path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket.sock"
    parser: SplitParser {
      splitMarker: ""
      onRead: data => {
        if (root.currentExec) {
          root.currentExec.ret = data
        }
        hyprctl.connected = false
      }
    }
  }

  function exec(flags, args, onSuccess) {
    const cmd = (flags ?? "") + "/" + args.join(" ")
    const exec = { cmd, onSuccess, ret: "", next: null }
      currentExec = exec
      hyprctl.connected = true
  }


  Component.onCompleted: {
		exec("j", ["activewindow"], json => {
			const data = JSON.parse(json)
			windowTitle = data.title
			appTitle = data.class
		})
  }
}

