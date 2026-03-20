pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.clipboard
import qs.animations as Anims
import QtQuick;
import QtQuick.Controls;
import QtQuick.Layouts;

Item {
  id: root;

  focus: true;
  anchors.fill: parent;

  Keys.onPressed: (e) => {
    if (listView.model.length < 1) return;

    if (e.key === Qt.Key_Up) {
      Controller.up();
    } else if (e.key === Qt.Key_Down) {
      Controller.down();
    } else if (e.key === Qt.Key_Enter || e.key === Qt.Key_Return) {
      Controller.select(Controller.model[Controller.currentIndex]);
    }
  }

  Component.onCompleted: Controller.updateModel();

  ColumnLayout {
    id: emptyContent;
    anchors.centerIn: parent;

    spacing: Consts.paddingWindow;
    visible: Controller.model.length < 1;

    Icon {
      icon: "clipboard-outline-symbolic";
      color: Colors.c.grey;
      size: Consts.extraLargeIconSize;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "Clipboard empty";
      color: Colors.c.grey;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.smallHeadingFontSize;
      }
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }

  MouseArea {
    id: listMouse;
    hoverEnabled: true;
    anchors.fill: parent;

    ListView {
      id: listView;
      anchors.fill: parent;

      model: Controller.model;
      currentIndex: Controller.currentIndex;
      highlightMoveDuration: 300;
      highlightMoveVelocity: 0.8;

      spacing: Consts.marginModule;

      visible: model.length > 0;

      flickableDirection: Flickable.VerticalFlick;
      ScrollBar.vertical: StyledScrollBar { scrollView: listView }

      // For scrollbar
      readonly property alias hovered: listMouse.containsMouse;

      delegate: OutlinedRectangle {
        required property string modelData;
        required property int index;

        readonly property bool isCurrent: index === Controller.currentIndex;

        color: itemMouse.containsPress ? Colors.c.accent : itemMouse.containsMouse || isCurrent ? Colors.c.bgHover : Colors.c.bgLight;

        radius: Consts.br;

        height: itemText.implicitHeight + Consts.paddingCard * 2;
        width: parent.width;

        disableAllOutlines: !Conf.sidebar.moduleOutlines;

        Anims.ColorTransition on color {}

        MouseArea {
          id: itemMouse
          anchors.fill: parent;
          hoverEnabled: true;

          onClicked: Controller.select(parent.modelData);
        }

        Text {
          id: itemText;
          text: parent.modelData.replace(/^\d+\s+/, "");

          anchors {
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            right: parent.right;
            margins: Consts.paddingCard;
          }

          color: itemMouse.containsPress ? Colors.c.bgLight : Colors.c.fg;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }

          maximumLineCount: 1;
          clip: true;
        }
      }
    }
  }
}
