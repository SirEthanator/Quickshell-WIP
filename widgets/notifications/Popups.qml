pragma ComponentBehavior: Bound

import qs
import qs.animations as Anims;
import qs.utils as Utils;
import Quickshell;
import Quickshell.Services.Notifications;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  id: root;

  WlrLayershell.namespace: "notifications";
  WlrLayershell.layer: WlrLayer.Overlay;
  exclusionMode: ExclusionMode.Normal;
  color: "transparent";
  implicitWidth: Globals.conf.notifications.width;

  mask: Region {  // Make clicks pass through unless on notifications
    intersection: Intersection.Combine
    height: popups.contentHeight + popups.y
    width: root.width
  }

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

    interactive: false;

    model: ListModel {
      id: data
      Component.onCompleted: () => {
        NotifServer.incoming.connect((n) => {
          if (!n.lastGeneration) {
            data.insert(0, {n: n});
            if (Globals.conf.notifications.sounds) {
              const sound = n.urgency === NotificationUrgency.Critical
              ? Globals.conf.notifications.criticalSound
              : Globals.conf.notifications.normalSound;
              Utils.Command.run(["sh", "-c", `play ${sound}`]);
            }
          }
        });

        NotifServer.dismissed.connect(id => {
          for (let i = 0; i < data.count; i++) {
            const e = data.get(i);
            if (e.n.id === id) { data.remove(i); return }
          }
        })
      }
    }

    displaced: Transition {
      Anims.NumberAnim { property: "y"; duration: Globals.vars.animLen }
    }
    add: Transition {
      Anims.NumberAnim {
        property: "x";
        from: popups.width;
        duration: Globals.vars.animLen;
        easing.type: Easing.OutExpo;
      }
    }
    remove: Transition {
      Anims.NumberAnim {
        property: "x";
        to: popups.width;
        duration: Globals.vars.animLen;
        easing.type: Easing.InExpo;
      }
    }

    delegate: Toast { popup: true }
  }
}

