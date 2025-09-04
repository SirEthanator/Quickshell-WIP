import qs
import qs.components
import qs.utils as Utils;
import qs.animations as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Notifications;

MouseArea {
  id: root

  required property Notification n;
  readonly property real timeout: {
    const min = n.urgency === NotificationUrgency.Critical ? Globals.conf.notifications.minimumCriticalTimeout : Globals.conf.notifications.minimumTimeout;
    const def = n.urgency === NotificationUrgency.Critical ? Globals.conf.notifications.defaultCriticalTimeout : Globals.conf.notifications.defaultTimeout;
    return n.expireTimeout > 0 ? Math.max(n.expireTimeout, min) : def;
  }
  property real timeRemaining: timeout;
  property bool popup: false;
  width: parent.width;
  height: bg.height;

  hoverEnabled: true;
  acceptedButtons: Qt.LeftButton | Qt.MiddleButton;
  preventStealing: true;

  property bool expanded: false;

  NumberAnimation on timeRemaining {
    id: progressController;
    running: root.popup;
    to: 0;
    duration: root.timeout;
    onFinished: {
      if (root.n.transient) {
        root.n.expire();
      } else {
        NotifServer.dismissed(root.n.id);
      }
    }
  }

  onContainsMouseChanged: {
    if (!popup) return
    if (containsMouse) {
      progressController.pause();
    } else {
      progressController.resume();
    }
  }

  drag.target: root;
  drag.axis: Drag.XAxis;
  drag.minimumX: root.popup ? 0 : undefined;  // Only allow dragging right if popup

  onPressed: event => {
    if (event.button === Qt.MiddleButton) n.dismiss();
  }
  onReleased: event => {
    if (event.button !== Qt.LeftButton) return;
    if (Math.abs(x) < width * (Globals.conf.notifications.dismissThreshold / 100)) {
      x = 0;
    } else {
      x = width * (x < 0 ? -1 : 1);
      // Dismiss if popup, discard if not
      const dimissAction = popup && ! n.transient ? () => NotifServer.dismissed(n.id) : () => n.dismiss();
      Utils.Timeout.setTimeout(dimissAction, Globals.vars.transitionLen);
    }
  }
  onClicked: event => {
    if (event.button !== Qt.LeftButton || !popup) return;
    if (n?.actions?.length >= 1) n?.actions[0].invoke()
  }

  Anims.NumberTransition on x {}

  Rectangle {
    id: bg;
    anchors {
      left: parent.left;
      right: parent.right;
    }

    height: content.height;

    color: Globals.colours.bg;
    radius: Globals.vars.br;
    border {
      color: Globals.colours.outline;
      width: root.popup ? Globals.vars.outlineSize : 0;
      pixelAligned: false;
    }

    Anims.NumberTransition on height {}
    clip: true;

    RowLayout {
      id: content;
      spacing: 0;
      anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right;
      }

      Button {
        id: closeButton;
        icon: "close-symbolic";
        iconSize: Globals.vars.moduleIconSize;

        Layout.fillHeight: true;
        implicitWidth: root.containsMouse ? Globals.vars.moduleIconSize + padding * 2 : 0;
        visible: implicitWidth > 0;
        Anims.NumberTransition on implicitWidth {}

        tlRadius: true; blRadius: true;
        changeBrRadiusHover: !root.popup;

        bg: Globals.colours.red;
        bgHover: Globals.colours.redHover;
        bgPress: Globals.colours.redPress;
        invertTextOnPress: false;
        labelColour: Globals.colours.bg;

        onClicked: root.n.dismiss();
      }


      ColumnLayout {
        spacing: Globals.vars.paddingNotif;

        Item {}  // Padding

        RowLayout {
          spacing: Globals.vars.paddingNotif;

          Item {}  // Padding

          ColumnLayout {
            spacing: Globals.vars.notifInnerSpacing;

            RowLayout {
              spacing: Globals.vars.notifInnerSpacing;

              IconImage {
                visible: !!root.n.appIcon;
                source: !!root.n.appIcon ? Quickshell.iconPath(root.n.appIcon) : "";
                implicitSize: appName.height;
              }

              Text {
                id: appName;
                text: root.n.appName;
                color: Globals.colours.fg;
                font {
                  family: Globals.vars.fontFamily;
                  pixelSize: Globals.vars.mainFontSize;
                  italic: true;
                }
                elide: Text.ElideRight
                maximumLineCount: 1;
                Layout.fillWidth: true;
              }

              Button {
                visible: summary.multiline || body.multiline;
                icon: "notification-expand-symbolic";
                iconRotation: root.expanded ? 180 : 0;

                implicitHeight: appName.height;
                implicitWidth: implicitHeight;

                allRadius: true;
                padding: 2;

                onClicked: root.expanded = !root.expanded;
              }

            }

            Text {
              id: summary;
              readonly property bool multiline: implicitWidth > width;
              text: root.n.summary;
              color: Globals.colours.fg;
              font {
                family: Globals.vars.fontFamily;
                pixelSize: Globals.vars.smallHeadingFontSize;
              }
              wrapMode: Text.Wrap;
              maximumLineCount: root.expanded ? 5 : 1;
              elide: Text.ElideRight;
              Layout.fillWidth: true;

              Anims.OutIn on maximumLineCount { originalValue: 1; fadeDuration: 100 }
            }

            Text {
              id: body;
              readonly property bool multiline: implicitWidth > width;
              text: root.n.body
              color: Globals.colours.fg;
              font {
                family: Globals.vars.fontFamily;
                pixelSize: Globals.vars.mainFontSize;
              }
              wrapMode: Text.Wrap;
              maximumLineCount: root.expanded ? 8 : 1;
              elide: Text.ElideRight;
              Layout.fillWidth: true;

              Anims.OutIn on maximumLineCount { originalValue: 1; fadeDuration: 100 }
            }

            RowLayout {
              id: actions;
              visible: root.n.actions.length > 0;
              Layout.fillWidth: true;
              spacing: Globals.vars.spacingButtonGroup;

              Repeater {
                model: root.n?.actions;

                delegate: Button {
                  required property NotificationAction modelData;
                  required property int index;

                  Layout.fillWidth: true;

                  label: modelData.text;
                  onClicked: modelData.invoke();

                  tlRadius: index === 0;
                  blRadius: index === 0;
                  trRadius: index === root.n.actions.length - 1;
                  brRadius: index === root.n.actions.length - 1;
                  bg: Globals.colours.bgLight;
                }
              }
            }

          }

          Item {}  // Padding

        }

        Item { visible: !root.popup }  // Padding if progressBar is not visible

        ProgressBar {
          id: progressBar
          visible: root.popup;
          value: root.timeRemaining / root.timeout;
          Layout.fillWidth: true;
          implicitHeight: 5;
          bg: root.n.urgency === NotificationUrgency.Critical ? Globals.colours.bgRed : Globals.colours.bgAccent;
          fg: root.n.urgency === NotificationUrgency.Critical ? Globals.colours.red : Globals.colours.accent;
          smoothing: false;

          radius: Globals.vars.br;
          topRightRadius: 0;
          topLeftRadius: 0;
          bottomLeftRadius: root.containsMouse ? 0 : Globals.vars.br;
          roundedFg: false;
        }
      }
    }

  }
}

