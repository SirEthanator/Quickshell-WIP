pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.clipboard
import qs.animations as Anims
import QtQuick;
import QtQuick.Controls as Ctrls;
import QtQuick.Layouts;

Item {
  id: root;

  focus: true;
  anchors.fill: parent;

  Keys.onPressed: (e) => {
    if (listView.model.count < 1) return;

    if (e.key === Qt.Key_Up) {
      Controller.up();
    } else if (e.key === Qt.Key_Down) {
      Controller.down();
    } else if (e.key === Qt.Key_Enter || e.key === Qt.Key_Return) {
      Controller.select(Controller.currentIndex);
    }
  }

  Component.onCompleted: Controller.updateModel();

  ColumnLayout {
    id: emptyContent;
    anchors.centerIn: parent;

    spacing: Consts.paddingWindow;
    opacity: Controller.model.count < 1 ? 1 : 0;

    Icon {
      icon: "clipboard-outline-symbolic";
      color: Colors.c.grey;
      size: Consts.iconSizeXLarge;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "Clipboard empty";
      color: Colors.c.grey;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeSmallLarge;
      }
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }

  ColumnLayout {
    anchors.fill: parent;
    spacing: Consts.paddingMedium;

    visible: Controller.model.count > 0;

    Button {
      label: "Clear all";
      allRadius: true;

      bg: Colors.c.bgLight;

      onClicked: {
        Controller.clear();
      }
    }

    MouseArea {
      id: listMouse;
      hoverEnabled: true;
      Layout.fillHeight: true;
      Layout.fillWidth: true;

      ListView {
        id: listView;
        anchors.fill: parent;
        clip: true;

        model: Controller.model;
        currentIndex: Controller.currentIndex;
        highlightMoveDuration: 300;
        highlightMoveVelocity: 0.8;

        spacing: Consts.paddingXSmall;

        flickableDirection: Flickable.VerticalFlick;
        Ctrls.ScrollBar.vertical: StyledScrollBar { scrollView: listView }

        // For scrollbar
        readonly property alias hovered: listMouse.containsMouse;

        displaced: Transition {
          Anims.NumberAnim { property: "y" }
        }
        move: displaced;

        delegate: ClipboardItem {}
      }
    }
  }
}
