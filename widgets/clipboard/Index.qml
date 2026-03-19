pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.clipboard
import qs.widgets.sidebar as Sidebar
import qs.animations as Anims
import Quickshell;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

  focus: true;
  anchors.fill: parent;

  Keys.onPressed: (e) => {
    if (listView.model.length < 1) return;

    if (e.key === Qt.Key_Up && Controller.currentIndex > 0) {
      Controller.currentIndex--;
    } else if (e.key === Qt.Key_Down && Controller.currentIndex < listView.model.length - 1) {
      Controller.currentIndex++;
    } else if (e.key === Qt.Key_Enter || e.key === Qt.Key_Return) {
      Controller.select(listView.model[Controller.currentIndex])
    }
  }

  Connections {
    target: Sidebar.Controller;

    function onDeactivated(id) {
      if (id === "clipboard") {
        Controller.currentIndex = 0;
      }
    }
  }

  Process {
    id: cliphistList;
    command: ["sh", "-c", "cliphist list"];
    running: true;
    stdout: SplitParser {
      onRead: (data) => {
        listView.model.push(data);
      }
    }
  }

  ColumnLayout {
    id: emptyContent;
    anchors.centerIn: parent;

    spacing: Consts.paddingWindow;
    visible: listView.model.length < 1;

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
        family: Consts.fontFamilyChanged;
        pixelSize: Consts.smallHeadingFontSize;
      }
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }

  ListView {
    id: listView;
    anchors.fill: parent;

    model: [];

    spacing: Consts.marginModule;

    currentIndex: Controller.currentIndex;

    visible: model.length > 0;

    delegate: OutlinedRectangle {
      required property string modelData;
      required property int index;

      readonly property bool isCurrent: index === Controller.currentIndex;

      color: itemMouse.containsPress ? Colors.c.accent : itemMouse.containsMouse || isCurrent ? Colors.c.bgHover : Colors.c.bgLight;

      radius: Consts.br;
      anchors {
        left: parent.left;
        right: parent.right;
      }

      height: itemText.implicitHeight + Consts.paddingCard * 2;

      Anims.ColorTransition on color {}

      MouseArea {
        id: itemMouse
        anchors.fill: parent;
        hoverEnabled: true;

        onClicked: Controller.select(parent.modelData);
      }

      Text {
        id: itemText;
        text: parent.modelData;

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
