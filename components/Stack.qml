import "root:/";
import QtQuick;
import QtQuick.Controls;

StackView {
  id: root;
  readonly property var items: children;
  property int currentIndex: 0;
  property bool vertical: false;
  initialItem: items[currentIndex];

  replaceEnter: Transition {
    NumberAnimation {
      property: "opacity";
      from: 0;
      to: 1;
      duration: Globals.vars.animLen;
      easing.type: Easing.OutCubic;
    }

    NumberAnimation {
      property: root.vertical ? "y" : "x";
      from: 200;
      to: 0;
      duration: Globals.vars.animLen;
      easing.type: Easing.OutCubic;
    }
  }

  replaceExit: Transition {
    NumberAnimation {
      property: "opacity";
      from: 1;
      to: 0;
      duration: Globals.vars.animLen;
      easing.type: Easing.OutCubic;
    }
  }

  onCurrentIndexChanged: {
    const loop = currentIndex >= items.length;
    const item = loop ? items[0] : items[currentIndex];
    if (item !== undefined) root.replace(item);
    if (loop) root.currentIndex = 0;
    items[currentIndex].visible = true;
  }

  Component.onCompleted: {
    for (let i = 0; i<items.length; i++) {
      if (i !== currentIndex) {
        items[i].visible = false;
      }
    }
  }
}
