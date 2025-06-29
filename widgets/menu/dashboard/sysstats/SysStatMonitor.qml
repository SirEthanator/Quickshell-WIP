import "root:/";
import "root:/components";
import "..";
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;
  required property real percentage;
  required property string title;
  required property string icon;

  fullContentWidth: true;
  padding: false;

  ColumnLayout {
    spacing: Globals.vars.paddingCard;

    Item {}

    RowLayout {
      spacing: Globals.vars.paddingCard;

      Item {}

      Rectangle {
        implicitHeight: 100;
        implicitWidth: 100;
        radius: width / 2;
        color: Globals.colours.bg;

        Icon {
          anchors.centerIn: parent;

          icon: root.icon;
          colour: Globals.colours.fg;
          size: parent.width / 2;
        }
      }

      ColumnLayout {
        Text {
          text: root.title;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.headingFontSize;
          }
          color: Globals.colours.fg;
        }

        Text {
          text: `${root.percentage}%`;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.smallHeadingFontSize
          }
          color: Globals.colours.fg;
        }
      }
    }

    ProgressBar {
      Layout.fillWidth: true;
      implicitHeight: 6;
      radius: Globals.vars.br;
      value: root.percentage / 100;
      bg: "transparent";
      fg: Globals.colours.accent;
    }
  }
}

