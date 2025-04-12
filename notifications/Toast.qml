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
  readonly property real timeout: n.expireTimeout > 0 ? n.expireTimeout : Globals.conf.notifications.defaultTimeout;
  property bool popup: false;
  anchors.left: parent.left;
  anchors.right: parent.right;
  height: bg.height
  hoverEnabled: true;
  property var timer;

  Component.onCompleted: {
    if (!popup) return
    root.timer = Utils.Timeout.setTimeout(() => {
      NotifServer.dismissed(n.id)
    }, root.timeout)
  }

  onContainsMouseChanged: {
    if (!popup) return
    if (containsMouse) {
      root.timer.restart();
      root.timer.stop();

      progressController.stop();
      progressBar.smoothing = true;
      progressBar.value = 1;
      progressBar.smoothing = false;
    } else {
      root.timer.start();
      progressController.start();
    }
  }

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

    ColumnLayout {
      id: content;
      spacing: Globals.vars.paddingNotif;

      anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right;
      }

      Item {}  // Padding

      RowLayout {
        spacing: Globals.vars.paddingNotif;

        Item {}  // Padding

        ColumnLayout {
          spacing: Globals.vars.notifInnerSpacing;

          RowLayout {
            spacing: Globals.vars.notifInnerSpacing;
            Layout.fillWidth: true;

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
            }

            Item { Layout.fillWidth: true }

            Button {
              implicitHeight: appName.height;
              implicitWidth: implicitHeight;

              label: "close-symbolic";
              icon: true;
              opacity: root.containsMouse ? 1 : 0;
              Anims.NumberTransition on opacity {}

              bg: Globals.colours.red;
              bgHover: Globals.colours.redHover;
              bgPress: Globals.colours.redHover;
              labelColour: Globals.colours.bg;

              tlRadius: true; trRadius: true; blRadius: true; brRadius: true;
              padding: 0;

              onClicked: () => root.n.dismiss();
            }
          }

          Text {
            text: root.n.summary
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.smallHeadingFontSize;
            }
          }

          Text {
            text: root.n.body
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.mainFontSize;
            }
          }
        }

        Item {}  // Padding

      }

      ProgressBar {
        id: progressBar
        value: 1;
        Layout.fillWidth: true;
        implicitHeight: 5;
        bg: "transparent";
        fg: Globals.colours.accent;
        radius: Globals.vars.br;
        smoothing: false;
      }

      FrameAnimation {
        id: progressController
        running: true;
        onTriggered: {
          if (progressBar.value <= 0) stop()
          else progressBar.value -= (progressBar.width / (root.timeout / 1000) * frameTime) / progressBar.width
          // Get how much the progress bar should recede then convert it into a decimal percentage
        }
      }
    }
  }
}

