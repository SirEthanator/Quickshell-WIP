import QtQuick;

Flickable {
  id: root;
  default property alias data: stack.data;
  property alias currentIndex: stack.currentIndex;
  property alias vertical: stack.vertical;
  property alias loopOutOfRange: stack.loopOutOfRange;

  property int flickThreshold: width * 0.1;

  flickableDirection: Flickable.HorizontalFlick;

  onFlickStarted: {
    const velocity = horizontalVelocity;
    const distance = contentX;

    if (distance >= flickThreshold) {
      root.currentIndex++;
    } else if (distance <= -flickThreshold) {
      root.currentIndex--;
    }
  }

  Stack {
    id: stack;
    anchors.fill: parent;

    readonly property Transition flickingEnterTransition: Transition {
      PropertyAction { property: "opacity"; value: 1 }
      NumberAnimation {
        property: root.vertical ? "y" : "x";
        from: (root.vertical ? stack.height : stack.width) * (root.contentX >= 0 ? 1 : -1);
        to: 0;
        duration: Consts.longAnimLen;
        easing.type: Easing.OutCubic;
      }
    }

    readonly property Transition flickingExitTransition: Transition {
      NumberAnimation {
        property: root.vertical ? "y" : "x";
        from: 0;
        to: (root.vertical ? -stack.height : -stack.width) * (root.contentX >= 0 ? 1 : -1);
        duration: Consts.longAnimLen;
        easing.type: Easing.OutCubic;
      }
    }


    replaceEnter: root.contentX !== 0 ? flickingEnterTransition : defaultEnterTransition;
    replaceExit: root.contentX !== 0 ? flickingExitTransition : defaultExitTransition;
  }
}
