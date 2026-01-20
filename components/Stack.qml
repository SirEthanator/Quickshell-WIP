import qs.singletons
import qs.animations as Anims;
import QtQuick;

Item {
  id: root;
  default property alias data: container.data;

  property int currentIndex: 0;
  property bool vertical: false;
  property bool wrapAround: false;
  property bool changeFocus: false;

  property var directionOverride: null;

  QtObject {
    id: internal;

    property int previousIndex: { previousIndex = root.currentIndex; }
    property var currentItem: container.children[root.wrapAround ? root.currentIndex % container.children.length : root.currentIndex];
    property bool ready: false;
  }

  Component.onCompleted: internal.ready = true;

  implicitHeight: internal.currentItem.implicitHeight;

  Item {
    id: container;
    anchors.fill: parent;

    onChildrenChanged: {
      for (let i=0; i < children.length; i++) {
        const item = children[i];
        const isCurrent = (i === root.currentIndex);

        item.visible = isCurrent;
        item.focus = isCurrent;
        item.width = Qt.binding(() => container.width)
        item.height = Qt.binding(() => container.height)
      }
    }
  }

  onCurrentIndexChanged: {
    if (!internal.ready) return;

    const itemCount = container.children.length;

    if (wrapAround) {
      // These need to return because they change currentIndex,
      // so onCurrentIndexChanged will fire again.
      if (currentIndex >= itemCount) {
        currentIndex = currentIndex % itemCount;
        return;
      } else if (currentIndex < 0) {
        currentIndex = (currentIndex * -1) % itemCount;
        return;
      }
    } else if (currentIndex >= itemCount || currentIndex < 0) {
      console.warn(`Stack: currentIndex out of range: ${currentIndex}`);
      return;
    }

    const animDirection = typeof root.directionOverride === "number"
      ? root.directionOverride
      : root.vertical
        ? (currentIndex > internal.previousIndex ? Anims.Slide.Direction.Up : Anims.Slide.Direction.Down)
        : (currentIndex > internal.previousIndex ? Anims.Slide.Direction.Left : Anims.Slide.Direction.Right);

    const exitTarget = container.children[internal.previousIndex];
    exitAnim.target = exitTarget;
    exitAnim.restart();

    const target = container.children[currentIndex];
    target.visible = true;
    if (root.changeFocus) target.forceActiveFocus();

    enterAnim.target = target;
    enterAnim.direction = animDirection;
    enterAnim.restart();

    internal.previousIndex = currentIndex;
  }

  Anims.Slide {
    id: enterAnim;
    target: null;
  }

  NumberAnimation {
    id: exitAnim;
    property: "opacity";
    easing.type: Easing.OutCubic;
    duration: Consts.transitionLen;
    from: 1;
    to: 0;

    onStopped: {
      target.visible = false;
    }
  }
}
