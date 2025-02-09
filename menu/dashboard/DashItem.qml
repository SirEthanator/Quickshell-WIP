import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;
  default property alias data: content.data;

  color: Globals.colours.bgLight;
  radius: Globals.vars.br;
  Layout.fillWidth: true;
  implicitHeight: content.implicitHeight + Globals.vars.paddingCard*2;

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
        fill: parent;
        margins: Globals.vars.paddingCard;
      }
      spacing: Globals.vars.paddingCard;
    }
  }
}

