pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Hyprland;

BarModule {
  id: root;
  icon: "node-symbolic";
  iconbgColour: Globals.colours.workspaces;

  onWheel: event => {
    const step = -Math.sign(event.angleDelta.y);
    const active = root.monitor.activeWorkspace.id;
    const target = step + active
    if (target >= 1 && target <= Globals.conf.bar.workspaceCount) {
      Hyprland.dispatch(`workspace ${target}`);
    }
  }

  required property var screen;
  readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen);

  signal workspaceAdded(ws: HyprlandWorkspace);

  // No row layout because it's provided by BarModule
  Repeater {
    model: Globals.conf.bar.workspaceCount;

    MouseArea {
      id: wsButton;
      Layout.fillHeight: true;
      implicitWidth: wsButtonRect.implicitWidth;

      required property int index;

      readonly property int wsIndex: index+1;  // Hyprland workspaces start at 1, index starts at 0
      property HyprlandWorkspace ws: null;
      property bool occupied: ws !== null;
      property bool focused: root.monitor.activeWorkspace === ws;

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

        state: wsButton.focused
          ? "focused"
          : wsButton.occupied
            ? "occupied"
            : "inactive";

        radius: wsButtonRect.implicitHeight / 2;  // Round caps
        implicitWidth: Globals.vars.wsSize;
        implicitHeight: Globals.vars.wsSize;

        states: [
          State {
            name: "focused";
            PropertyChanges { wsButtonRect {
              color: Globals.colours.accent;
              implicitWidth: Globals.vars.wsSize * 5;
              implicitHeight: Globals.vars.wsSize + 3;
          }}},

          State {
            name: "occupied";
            PropertyChanges { wsButtonRect.color: Globals.colours.grey }
          },

          State {
            name: "inactive";
            PropertyChanges { wsButtonRect.color: Globals.colours.wsInactive }
          }
        ]

        transitions: Transition {
          Anims.ColourAnim { property: "color" }
          Anims.NumberAnim { properties: "implicitWidth, implicitHeight" }
        }
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

