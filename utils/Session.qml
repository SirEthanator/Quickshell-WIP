pragma Singleton

// import qs
import Quickshell;
import Quickshell.Io;
import Quickshell.Hyprland;
import QtQuick;

Singleton {
  id: root;

  property string session: Quickshell.env("XDG_CURRENT_DESKTOP");

  property list<var> workspaces: session === "niri"
    ? []
    : Hyprland.workspaces.values.map((ws) => {
      return { id: ws.id, idx: ws.id, active: ws.active, display: ws.monitor.name }
    });

  property int gap: 10;  // Use 10 until value is fetched

  Process {
    running: true;
    command: root.session === "niri"
      ? ["sh", "-c", `grep -E '^\\s*gaps\\s+' ~/.config/niri/config.kdl | awk '{print $2}'`]
      : ["hyprctl", "getoption", "general:gaps_out", "-j"];
    stdout: SplitParser {
      onRead: (data) => {
        if (root.session === "niri") {
          root.gap = parseInt(data.trim());
        } else {
          const json = JSON.parse(data);
          root.gap = json.custom.split(" ")[0];
        }
      }
    }
  }

  Process {
    running: root.session === "niri";
    command: ["sh", "-c", "niri msg --json event-stream"];

    stdout: SplitParser {
      onRead: (rawData) => {
        const msg = JSON.parse(rawData.trim());

        const tmp = Object.keys(msg);
        if (tmp.length !== 1) { return }
        const msgTitle = tmp[0];

        switch (msgTitle) {
        case "WorkspacesChanged":
          const newWSVal = msg[msgTitle].workspaces.map((ws) => {
            return { id: ws.id, idx: ws.idx, active: ws.is_active, display: ws.output }
          });
          root.workspaces = newWSVal;
        break;

        case "WorkspaceActivated":
          root.workspaces.find(ws => ws.active === true).active = false;
          root.workspaces.find(ws => ws.id === msg[msgTitle].id).active = true;
        break;
        }
      }
    }
  }

  function setActiveWorkspace(idx: int) {
    if (root.session === "niri") {
      Quickshell.execDetached(["sh", "-c", `niri msg action focus-workspace ${idx}`])
    } else {
      Hyprland.dispatch(`workspace ${idx}`)
    }
  }
}

