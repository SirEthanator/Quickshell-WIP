import "root:/";
import "root:/components";
import "root:/utils" as Utils;
import "root:/animations" as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Notifications;

MouseArea {
  id: root

  required property Notification n;
  readonly property real timeout: n.expireTimeout > 0
    ? n.expireTimeout
    : n.urgency === NotificationUrgency.Critical
      ? Globals.conf.notifications.defaultCriticalTimeout
      : Globals.conf.notifications.defaultTimeout;
  property bool popup: false;
  width: parent.width;
  height: bg.height;

  hoverEnabled: true;
  acceptedButtons: Qt.LeftButton | Qt.MiddleButton;
  preventStealing: true;

  property bool expanded: false;
  property var timer;

  Component.onCompleted: {
    if (!popup) return
    timer = Utils.Timeout.setTimeout(() => {
      NotifServer.dismissed(n.id)
    }, timeout)
  }

  onContainsMouseChanged: {
    if (!popup) return
    if (containsMouse) {
      timer.restart();
      timer.stop();

      progressController.stop();
      progressBar.smoothing = true;
      progressBar.value = 1;
      progressBar.smoothing = false;
    } else {
      timer.start();
      progressController.start();
    }
  }

  drag.target: root;
  drag.axis: Drag.XAxis;
  drag.minimumX: 0;  // Only allow dragging right

  onPressed: event => {
    if (event.button === Qt.MiddleButton) n.dismiss();
  }
  onReleased: event => {
    if (event.button !== Qt.LeftButton) return;
    if (Math.abs(x) < width * 0.3) {
      x = 0;
    } else {
      x = width;
      Utils.Timeout.setTimeout(() => NotifServer.dismissed(n.id), Globals.vars.transitionLen);
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
      color: Globals.colours.bgAccent;
      width: Globals.vars.outlineSize
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
        label: "close-symbolic";
        icon: true;
        iconSize: Globals.vars.moduleIconSize;

        Layout.fillHeight: true;
        implicitWidth: root.containsMouse ? Globals.vars.moduleIconSize + padding * 2 : 0;
        Anims.NumberTransition on implicitWidth {}

        tlRadius: true; blRadius: true;
        changeBrRadiusHover: false;

        bg: Globals.colours.red;
        bgHover: Globals.colours.redHover;
        bgPress: Globals.colours.redHover;  // TEMP
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
                implicitSize: appName.height
              }

              Text {
                id: appName
                text: root.n.appName
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
                label: root.expanded ? "arrow-up-symbolic" : "arrow-down-symbolic";
                icon: true;

                implicitHeight: appName.height;
                implicitWidth: implicitHeight;

                tlRadius: true; trRadius: true; blRadius: true; brRadius: true;
                padding: 2;

                onClicked: root.expanded = !root.expanded;
              }

            }

            Text {
              id: summary;
              readonly property bool multiline: implicitWidth > width;
              text: root.n.summary
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
              visible: root.popup && root.n.actions.length > 0;
              Layout.fillWidth: true;
              spacing: Globals.vars.spacingButtonGroup;

              Repeater {
                model: root.n?.actions;

                delegate: Button {
                  required property NotificationAction modelData;
                  required property int index;

                  Layout.fillWidth: true;
                  autoHeight: true;

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

        ProgressBar {
          id: progressBar
          visible: root.popup;
          value: 1;
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

        FrameAnimation {
          id: progressController
          running: root.popup;
          onTriggered: {
            if (progressBar.value <= 0) stop()
            else progressBar.value -= (progressBar.width / (root.timeout / 1000) * frameTime) / progressBar.width
            // Get how much the progress bar should recede then convert it into a decimal percentage
            // Multiplying by frameTime can be thought of as per second eg 3 * frameTime = 3 per second
          }
        }
      }
    }

  }
}

