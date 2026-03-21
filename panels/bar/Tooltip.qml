import qs.singletons
import QtQuick;

Item {
  id: root;
  parent: null;

  required default property QtObject data;
  property bool isMenu: false;

  property bool disableOutline: false;
  property int padding: Consts.paddingModule;

  width: data.width;
  height: data.height;

  Item {
    data: [root.data];
  }
}
