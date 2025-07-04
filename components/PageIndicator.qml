pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property Stack stack;
  readonly property int count: stack.children.length;
  readonly property int currentIndex: stack.currentIndex;
  property bool fullWidth: true;

  onCurrentIndexChanged: {
    if (currentIndex !== stack.currentIndex)
      stack.currentIndex = currentIndex
  }
  Layout.fillWidth: fullWidth;
  implicitHeight: Globals.vars.wsSize;

  Repeater {
    model: root.count;

    delegate: MouseArea {
      id: item;
      required property int index;
      readonly property bool selected: index === root.currentIndex;
      implicitHeight: Globals.vars.wsSize;
      Layout.preferredWidth: root.fullWidth ? item.selected ? 3 : 2 : implicitHeight;
      Layout.fillWidth: root.fullWidth;

      onPressed: root.stack.currentIndex = index;
      hoverEnabled: true;
      Anims.NumberTransition on Layout.preferredWidth {}

      Rectangle {
        color: item.selected ? Globals.colours.accent : item.containsMouse ? Globals.colours.bgHover : Globals.colours.bgLight;
        radius: height / 2;
        anchors.fill: parent;

        Anims.ColourTransition on color {}
      }
    }
  }
}
