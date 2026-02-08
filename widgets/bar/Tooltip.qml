import QtQuick;

Item {
  id: root;
  parent: null;

  default property QtObject data;
  property bool isMenu: false;

  width: data.width;
  height: data.height;

  Item {
    data: [root.data];
  }
}
