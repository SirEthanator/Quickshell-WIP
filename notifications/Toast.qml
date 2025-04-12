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

    height: content.height + Globals.vars.paddingNotif * 2;

    color: Globals.colours.bg;
    radius: Globals.vars.br;
    border {
      color: Globals.colours.bgAccent;
      width: Globals.vars.outlineSize
      pixelAligned: false;
    }

    ColumnLayout {
      id: content;
      spacing: Globals.vars.notifInnerSpacing;
      anchors {
        // verticalCenter: parent.verticalCenter;
        top: parent.top;
        left: parent.left;
        right: parent.right;
        margins: Globals.vars.paddingNotif;
      }

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
  }
}

