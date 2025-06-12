pragma ComponentBehavior: Bound
import "root:/";
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root
  required property var barModules;
  required property var modules;

  anchors {
    bottom: parent.bottom
    top: parent.top
  }
  spacing: Globals.vars.marginModule;

  Repeater {
    model: root.modules;
    delegate: Loader {
      id: loader
      required property string modelData;

      Layout.fillHeight: true;
      visible: item?.show ?? false;

      Component.onCompleted: {
        setSource(root.barModules[modelData].url, root.barModules[modelData].props);
      }
    }
  }
}
