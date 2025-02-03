pragma ComponentBehavior: Bound;

import "root:/";
import QtQuick;
import QtQuick.Layouts;

StackLayout {
  id: root;
  property int previousIndex: 0;
  property var items: children;
  property Item previousItem: items[previousIndex];
  property Item currentItem: items[currentIndex];
  property bool animPlaying: false;

  Component.onCompleted: {
    previousIndex = currentIndex;
  }

  Component {
    id: animationWrap;

    ParallelAnimation {
      id: animation;
      property Item fadeOutTarget;
      property Item fadeInTarget;

      onStarted: {
        root.animPlaying = true
      }

      onStopped: {  // Includes the animation finishing
        root.animPlaying = false
      }

      SequentialAnimation {
        NumberAnimation {  // Not working since visible is false
          target: animation.fadeOutTarget;
          property: "opacity";
          from: 1;
          to: 0;
          duration: Globals.vars.animLen;
          easing.type: Easing.OutCubic;
        }
        PropertyAction { target: animation.fadeOutTarget; property: "visible"; value: false }
      }

      ParallelAnimation {
        NumberAnimation {
          target: animation.fadeInTarget;
          property: "opacity";
          from: 0;
          to: 1;
          duration: Globals.vars.animLen;
          easing.type: Easing.OutCubic;
        }

        NumberAnimation {
          target: animation.fadeInTarget;
          property: "x";
          from: 200;
          to: 0;
          duration: Globals.vars.animLen;
          easing.type: Easing.OutCubic;
        }
      }
    }
  }

  onCurrentIndexChanged: {
    items = root.children;
      if (previousItem && currentItem && (previousItem != currentItem)) {
        previousItem.visible = true;  // Will be set to false after animation
        currentItem.visible = true;
        var anim = animationWrap.createObject(root, {fadeOutTarget: previousItem, fadeInTarget: currentItem})
        anim.restart()
      }
      previousIndex = currentIndex
  }
}
