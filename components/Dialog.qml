import qs.singletons
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;
  anchors.fill: parent;
  color: Consts.bgDimmedColor;

  required property string title;
  property string description;
  default property alias data: buttons.data;

  visible: false;

  function open() { visible = true }
  function close() { visible = false }

  Rectangle {
    anchors.centerIn: parent;

    color: Globals.colors.bg;
    width: content.width + Consts.paddingWindow*2;
    height: content.height + Consts.paddingWindow*2;

    radius: Consts.br;

    ColumnLayout {
      id: content;
      anchors.centerIn: parent;
      spacing: Consts.paddingWindow;

      ColumnLayout {
        spacing: Consts.marginCardSmall;
        Text {
          text: root.title;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.smallHeadingFontSize;
          }
          color: Globals.colors.fg;
          Layout.alignment: Qt.AlignHCenter;
        }

        Text {
          text: root.description;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }
          color: Globals.colors.grey;
          Layout.alignment: Qt.AlignHCenter;
        }
      }

      RowLayout {
        id: buttons;
        spacing: Consts.spacingButtonGroup;
        Layout.alignment: Qt.AlignHCenter;
      }
    }
  }
}

