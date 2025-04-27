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
  anchors.left: parent.left;
  anchors.right: parent.right;
  height: bg.height;
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

          }

          Text {
            text: root.n.summary
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.smallHeadingFontSize;
            }
            wrapMode: Text.WordWrap;
            maximumLineCount: 2;
            elide: Text.ElideRight;
            Layout.fillWidth: true;
          }

          Text {
            text: root.n.body
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.mainFontSize;
            }
            wrapMode: Text.WordWrap;
            maximumLineCount: 3;
            elide: Text.ElideRight;
            Layout.fillWidth: true;
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
        value: 1;
        Layout.fillWidth: true;
        implicitHeight: 5;
        bg: root.n.urgency === NotificationUrgency.Critical ? Globals.colours.bgRed : Globals.colours.bgAccent;
        fg: root.n.urgency === NotificationUrgency.Critical ? Globals.colours.red : Globals.colours.accent;
        smoothing: false;

        radius: Globals.vars.br;
        topRightRadius: 0;
        topLeftRadius: 0;
        roundedFg: false;
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

    // Close button - displays on top of everything
    Button {
      anchors {
        right: parent.right;
        top: parent.top;
        rightMargin: Globals.vars.paddingNotif;
        topMargin: Globals.vars.paddingNotif;
      }
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

      onClicked: root.n.dismiss();
    }

  }
}

