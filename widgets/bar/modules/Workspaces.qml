pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.bar
import qs.utils as Utils;
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;
  icon: "node-symbolic";
  iconbgColour: Globals.colours.workspaces;

  onWheel: event => {
    const step = -Math.sign(event.angleDelta.y);
    const activeIdx = workspaces.find(ws => ws.active === true).idx;
    const target = step + activeIdx;
    if (target >= 1 && target <= Conf.bar.workspaceCount) {
      Utils.Session.setActiveWorkspace(target)
    }
  }

  required property var screen;
  // readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen);
  readonly property string monitor: screen.name;

  readonly property list<var> workspaces: Utils.Session.workspaces.filter((ws) =>
    ws.display === root.monitor
  )

  // No row layout because it's provided by BarModule
  Repeater {
    model: Conf.bar.workspaceCount;

    MouseArea {
      id: wsButton;
      Layout.fillHeight: true;
      implicitWidth: wsButtonRect.implicitWidth;

      required property int index;

      readonly property int wsIndex: index+1;  // Hyprland and Niri workspaces start at 1, index starts at 0
      property var ws: root.workspaces.find(ws => ws.idx === wsIndex);
      property bool occupied: ws !== undefined;
      property bool focused: ws && ws.active ? ws.active : false;

      onPressed: Utils.Session.setActiveWorkspace(wsIndex);

      Rectangle {
        id: wsButtonRect;
        anchors.centerIn: parent;

        state: wsButton.focused
          ? "focused"
          : wsButton.occupied
            ? "occupied"
            : "inactive";

        radius: wsButtonRect.implicitHeight / 2;  // Round caps
        implicitWidth: Consts.wsSize;
        implicitHeight: Consts.wsSize;

        states: [
          State {
            name: "focused";
            PropertyChanges { wsButtonRect {
              color: Globals.colours.accent;
              implicitWidth: Consts.wsSize * 5;
              implicitHeight: Consts.wsSize + 3;
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
}

