import qs.singletons
import qs.animations as Anims;
import QtQuick;
import QtQuick.Controls;

ScrollBar {
  id: root;
  required property var scrollView;
  parent: scrollView;
  anchors.top: parent.top;
  anchors.bottom: parent.bottom;
  anchors.right: parent.right;

  policy: scrollView.contentHeight > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

  contentItem: Rectangle {
    implicitWidth: 6;
    color: root.pressed ? Colors.c.accent : Colors.c.fg;
    opacity: scrollBarMouse.containsMouse || root.pressed ? 1 : !root.scrollView.hovered ? 0 : 0.3;
    radius: implicitWidth / 2;

    Anims.ColorTransition on color {}
    Anims.NumberTransition on opacity {}

    MouseArea {
      id: scrollBarMouse;
      anchors.fill: parent;
      hoverEnabled: true;
      acceptedButtons: Qt.NoButton;
    }
  }
}

