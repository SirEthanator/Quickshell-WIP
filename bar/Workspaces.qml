pragma ComponentBehavior: Bound;

import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Hyprland;

BarModule {
  id: root;
  icon: "node-symbolic";
  iconbgColour: Opts.colours.workspaces;

  onWheel: event => {
    const step = -Math.sign(event.angleDelta.y);
    const active = root.monitor.activeWorkspace.id;
    const target = step + active
    if (target >= 1 && target <= Opts.bar.workspaceCount) {
      Hyprland.dispatch(`workspace ${target}`);
    }
  }

  required property var screen;
  readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen);

  signal workspaceAdded(ws: HyprlandWorkspace);

  // No row layout because it's provided by BarModule
  Repeater {
    model: Opts.bar.workspaceCount;

    MouseArea {
      id: wsButton;
      Layout.fillHeight: true;
      implicitWidth: wsButtonRect.implicitWidth;

      required property int index;

      readonly property int wsIndex: index+1;  // Hyprland workspaces start at 1, not 0
      property HyprlandWorkspace ws: null;
      property bool occupied: ws != null;
      property bool focused: root.monitor.activeWorkspace == ws;

      onPressed: Hyprland.dispatch(`workspace ${wsIndex}`);

      Connections {
        target: root;

        function onWorkspaceAdded(ws: HyprlandWorkspace) {
          if (ws.id == wsButton.wsIndex) {
            wsButton.ws = ws;
          }
        }
      }

      Rectangle {
        id: wsButtonRect;
        anchors.centerIn: parent;

        radius: wsButtonRect.implicitHeight / 2;  // Round caps
        color: wsButton.focused
          ? Opts.colours.accent
          : wsButton.occupied
            ? Opts.colours.grey
            : Opts.colours.wsInactive;
        implicitWidth: wsButton.focused ? Opts.vars.wsSize * 5 : Opts.vars.wsSize;
        implicitHeight: wsButton.focused ? Opts.vars.wsSize + 3 : Opts.vars.wsSize;
      }
    }
  }

  Connections {
    target: Hyprland.workspaces;

    function onObjectInsertedPost(ws) {
      root.workspaceAdded(ws);
    }
  }

  Component.onCompleted: {
    Hyprland.workspaces.values.forEach(ws => {
      root.workspaceAdded(ws);
    })
  }
}

