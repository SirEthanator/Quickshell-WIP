import "root:/";
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
          font: Globals.vars.headingFont;
          color: Globals.colours.fg;
        }

        Text {
          text: `${root.percentage}%`;
          font: Globals.vars.headingFontSmall;
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

