import "root:/";
import "root:/components";
import "root:/animations" as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Notifications;

MouseArea {
  id: root

  required property Notification n;
  required property real timeout;
  property bool popup: false;
  anchors.left: parent.left;
  anchors.right: parent.right;
  height: bg.height

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
              label: "close-symbolic";
              icon: true;
              bg: Globals.colours.red;
              bgHover: Globals.colours.redHover;
              bgPress: Globals.colours.redHover;
              labelColour: Globals.colours.bg;
              tlRadius: true; trRadius: true; blRadius: true; brRadius: true;
              padding: 0;
              implicitHeight: appName.height;
              implicitWidth: implicitHeight;
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
        id: countdownBar
        value: 1;
        Layout.fillWidth: true;
        implicitHeight: 5;
        bg: "transparent";
        fg: Globals.colours.accent;
        radius: Globals.vars.br;
        smoothing: false;
      }

      FrameAnimation {
        onTriggered: {
          if (countdownBar.value <= 0) stop()
          else countdownBar.value -= (countdownBar.width / (root.timeout / 1000) * frameTime) / countdownBar.width
          // Get how much the progress bar should recede then convert it into a decimal percentage
        }
        Component.onCompleted: start()
      }
    }
  }
}

