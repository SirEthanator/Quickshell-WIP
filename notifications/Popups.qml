pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import "root:/utils" as Utils;
import Quickshell;
import Quickshell.Io;
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

    Process {
      id: notifSound;
      command: ["sh", "-c", "play /usr/share/sounds/ocean/stereo/message-new-instant.oga"];
    }

    model: ListModel {
      id: data
      Component.onCompleted: () => {
        NotifServer.incoming.connect((n, timeout) => {
          if (!n.lastGeneration) {
            data.insert(0, {n: n, timeout: timeout});
            if (Globals.conf.notifications.sounds) notifSound.running = true
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
      ParallelAnimation {
        Anims.NumberAnim {
          property: "anchors.rightMargin";
          from: -popups.width; to: 0;
          duration: Globals.vars.animLen;
          easing.type: Easing.OutExpo;
        }
        Anims.NumberAnim {
          property: "anchors.leftMargin";
          from: popups.width; to: 0;
          duration: Globals.vars.animLen;
          easing.type: Easing.OutExpo;
        }
      }
    }
    remove: Transition {
      ParallelAnimation {
        Anims.NumberAnim {
          property: "anchors.rightMargin";
          from: 0; to: -popups.width;
          duration: Globals.vars.animLen;
          easing.type: Easing.InExpo;
        }
        Anims.NumberAnim {
          property: "anchors.leftMargin";
          from: 0; to: popups.width;
          duration: Globals.vars.animLen;
          easing.type: Easing.InExpo;
        }
      }
    }

    delegate: Toast { popup: true }
  }
}

