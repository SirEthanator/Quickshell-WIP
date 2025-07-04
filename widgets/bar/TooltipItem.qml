import "root:/";
import QtQuick;

Item {
  id: root;
  default property QtObject child;

  onChildChanged: {
    child.parent = root
  }

  width: child.width;
  height: child.height;
}

