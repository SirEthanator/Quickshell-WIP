import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;
  anchors.fill: parent;
  color: Globals.vars.bgDimmedColour;

  required property string title;
  property string description;
  default property alias data: buttons.data;

  visible: false;

  function open() { visible = true }
  function close() { visible = false }

  Rectangle {
    anchors.centerIn: parent;

    color: Globals.colours.bg;
    width: content.width + Globals.vars.paddingWindow*2;
    height: content.height + Globals.vars.paddingWindow*2;

    radius: Globals.vars.br;

    ColumnLayout {
      id: content;
      anchors.centerIn: parent;
      spacing: Globals.vars.paddingWindow;

      ColumnLayout {
        spacing: Globals.vars.marginCardSmall;
        Text {
          text: root.title;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.smallHeadingFontSize;
          }
          color: Globals.colours.fg;
          Layout.alignment: Qt.AlignHCenter;
        }

        Text {
          text: root.description;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.mainFontSize;
          }
          color: Globals.colours.grey;
          Layout.alignment: Qt.AlignHCenter;
        }
      }

      RowLayout {
        id: buttons;
        spacing: Globals.vars.spacingButtonGroup;
        Layout.alignment: Qt.AlignHCenter;
      }
    }
  }
}

