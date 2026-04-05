pragma ComponentBehavior: Bound

import qs.singletons
import qs.panels.notifications
import qs.animations as Anims
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

LazyLoader {
  activeAsync: Conf.notifications.showFlash;

  PanelWindow {
    id: root;

    WlrLayershell.layer: WlrLayer.Overlay;
    exclusionMode: ExclusionMode.Ignore;
    color: "transparent";

    anchors {
      top: true;
      bottom: true;
      right: true;
      left: true;
    }

    mask: Region {
      intersection: Intersection.Xor;
      width: root.width;
      height: root.height
    }

    Connections {
      target: NotifServer;

      function onIncoming(n) {
        if (n.lastGeneration || (!Conf.notifications.flashOnTransient && n.transient)) return;

        root.flashColor = n.urgency === NotificationUrgency.Critical ? Colors.c.red : Colors.c.accent;
        flashAnim.restart();
      }
    }

    readonly property int borderWidth: Conf.notifications.flashThickness;
    readonly property int cornerSize: borderWidth;

    property color flashColor;

    Repeater {
      model: 4;

      delegate: Shape {
        id: invertedCorner;
        required property int index;

        asynchronous: true;
        preferredRendererType: Shape.CurveRenderer;
        width: root.cornerSize;
        height: root.cornerSize;

        opacity: rect.opacity;

        anchors {
          left: index % 3 === 0 ? rect.left : undefined;
          right: index % 3 !== 0 ? rect.right : undefined;
          top: index <= 1 ? rect.top : undefined;
          bottom: index >= 2 ? rect.bottom : undefined;
          margins: root.borderWidth;
        }

        ShapePath {
          startX: 0;
          startY: 0;
          strokeWidth: -1;
          fillColor: root.flashColor;

          PathArc {
            x: root.cornerSize;
            y: root.cornerSize;
            radiusX: root.cornerSize;
            radiusY: root.cornerSize;
          }

          PathLine {
            x: root.cornerSize;
            y: 0;
          }
        }

        rotation: (index - 1) * 90;
      }
    }

    Rectangle {
      id: rect;

      anchors.fill: parent;

      opacity: 0;
      color: "transparent";

      border {
        color: root.flashColor;
        width: root.borderWidth;
      }

      SequentialAnimation {
        id: flashAnim;

        PropertyAction {
          target: rect;
          property: "opacity";
          value: 1;
        }

        PauseAnimation { duration: Conf.notifications.flashPauseDuration }

        Anims.NumberAnim {
          target: rect;
          property: "opacity";
          to: 0;
        }
      }
    }
  }
}
