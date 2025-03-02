import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;
  default property alias data: content.data;
  property bool fullContentWidth: false;
  property bool padding: true;

  color: Globals.colours.bgLight;
  radius: Globals.vars.br;
  Layout.fillWidth: true;
  implicitHeight: content.implicitHeight + (padding ? Globals.vars.paddingCard*2 : 0);

  signal clicked(event: MouseEvent);
  property alias mouseArea: mouseArea;
  property alias hoverEnabled: mouseArea.hoverEnabled;
  property alias containsMouse: mouseArea.containsMouse;
  property alias isPressed: mouseArea.pressed;

  MouseArea {
    id: mouseArea;
    anchors.fill: parent;

    onClicked: event => root.clicked(event);

    RowLayout {
      id: content;
      clip: true;
      anchors {
        top: parent.top;
        bottom: parent.bottom;
        left: parent.left;
        right: root.fullContentWidth ? parent.right : undefined
        margins: root.padding ? Globals.vars.paddingCard : 0;
      }
      spacing: Globals.vars.paddingCard;
    }
  }
}

