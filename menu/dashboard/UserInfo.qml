import "root:/";
import "root:/utils" as Utils;
import "userinfo";
import QtQuick;
import QtQuick.Controls;
import QtQuick.Layouts;

DashItem {
  id: root;
  required property var shellroot;
  required property var screen;

  fullContentWidth: true;
  hoverEnabled: true;
  onContainsMouseChanged: { if (!containsMouse) stack.currentIndex = 0 }

  StackLayout {
    id: stack;
    //vertical: true;
    width: info.width;
    height: info.height;

    Info {
      id: info
      onPowerHoveredChanged: { if (powerHovered) stack.currentIndex = 1 }
    }
    Power { shellroot: root.shellroot; screen: root.screen }
  }
}

