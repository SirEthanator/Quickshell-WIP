import qs.singletons
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;
  anchors.fill: parent;
  color: Colors.c.backdrop;

  required property string title;
  property string description;
  default property alias data: buttons.data;

  visible: false;

  function open() { visible = true }
  function close() { visible = false }

  Rectangle {
    anchors.centerIn: parent;

    color: Colors.c.bg;
    width: content.width + Consts.paddingWindow*2;
    height: content.height + Consts.paddingWindow*2;

    radius: Consts.br;

    ColumnLayout {
      id: content;
      anchors.centerIn: parent;
      spacing: Consts.paddingWindow;

      ColumnLayout {
        spacing: Consts.paddingXSmall;
        Text {
          text: root.title;
          font {
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeSmallLarge;
          }
          color: Colors.c.fg;
          Layout.alignment: Qt.AlignHCenter;
        }

        Text {
          text: root.description;
          font {
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeMain;
          }
          color: Colors.c.grey;
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

