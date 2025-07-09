import "root:/";
import QtQuick;
import QtQuick.Controls;

StackView {
  id: root;
  readonly property var items: children;
  property int currentIndex: 0;
  property bool vertical: false;
  property bool loopOutOfRange: false;
  initialItem: items[currentIndex];

  readonly property Transition defaultEnterTransition: Transition {
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

  readonly property Transition defaultExitTransition: Transition {
    NumberAnimation {
      property: "opacity";
      from: 1;
      to: 0;
      duration: Globals.vars.animLen;
      easing.type: Easing.OutCubic;
    }
  }

  replaceEnter: defaultEnterTransition;
  replaceExit: defaultExitTransition;

  onCurrentIndexChanged: {
    if (root.loopOutOfRange) {
      if (currentIndex >= items.length) root.currentIndex = 0;
      if (currentIndex < 0) root.currentIndex = items.length-1;
    }
    const item = items[currentIndex];
    if (item !== undefined) {
      root.replace(item);
      items[currentIndex].visible = true;
    }
  }

  Component.onCompleted: {
    for (let i = 0; i<items.length; i++) {
      if (i !== currentIndex) {
        items[i].visible = false;
      }
    }
  }
}
