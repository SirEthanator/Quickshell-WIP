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
    if (currentIndex < items.length) {
      root.replace(items[currentIndex]);
    } else {
      root.replace(items[0]);
      root.currentIndex = 0;
    }
  }

  Component.onCompleted: {
    console.log(root.depth)
    for (let i=0; i<items.length; i++) {
      console.log(items[i])
    }
  }
}
