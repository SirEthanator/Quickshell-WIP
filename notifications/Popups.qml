pragma ComponentBehavior: Bound

import "root:/";
import "root:/utils" as Utils;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  id: root;

  WlrLayershell.namespace: "notifications";
  exclusionMode: ExclusionMode.Normal;
  color: "transparent";
  width: Globals.conf.notifications.width;

  mask: Region {  // Make clicks pass through unless on notifications
    intersection: Intersection.Combine
    height: popups.contentHeight + popups.y
    width: root.width
  }

  // visible: data.count > 0

  anchors {
    top: true;
    right: true;
    bottom: true;
  }

  margins {
    top: Globals.vars.gapLarge;
    right: Globals.vars.gapLarge;
    bottom: Globals.vars.gapLarge;
  }

  ListView {
    id: popups
    anchors.fill: parent;
    spacing: Globals.vars.notifPopupSpacing;

    model: ListModel {
      id: data
      Component.onCompleted: () => {
        NotifServer.incoming.connect(n => {
          data.insert(0, {n: n})
        });

        NotifServer.dismissed.connect(id => {
          for (let i = 0; i < data.count; i++) {
            const e = data.get(i);
            if (e.n.id === id) { data.remove(i); return }
          }
        })
      }
    }

    delegate: Popup {}
  }
}

