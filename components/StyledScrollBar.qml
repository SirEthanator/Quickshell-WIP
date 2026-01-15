import qs.singletons
import qs.animations as Anims;
import QtQuick;
import QtQuick.Controls;

ScrollBar {
  id: root;
  required property QtObject scrollView;
  parent: scrollView;
  anchors.top: parent.top;
  anchors.bottom: parent.bottom;
  anchors.right: parent.right;

  policy: scrollView.contentHeight > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

  contentItem: Rectangle {
    implicitWidth: 6;
    color: root.pressed ? Globals.colours.accent : Globals.colours.fg;
    opacity: scrollBarMouse.containsMouse || root.pressed ? 1 : !root.scrollView.hovered ? 0 : 0.3;
    radius: implicitWidth / 2;

    Anims.ColourTransition on color {}
    Anims.NumberTransition on opacity {}

    MouseArea {
      id: scrollBarMouse;
      anchors.fill: parent;
      hoverEnabled: true;
      acceptedButtons: Qt.NoButton;
    }
  }
}

