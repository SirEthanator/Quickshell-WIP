pragma ComponentBehavior: Bound
import "root:/";
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root
  required property var allModules;
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
      readonly property string url: root.allModules[modelData].url;
      readonly property var props: root.allModules[modelData].props;

      Layout.fillHeight: true;
      visible: item?.show ?? false;

      Component.onCompleted: {
        setSource(url, props ?? {});
      }

      onStatusChanged: {
        if (status === Loader.Error) {
          active = false;
          throw new Error(`Failed to load bar module from: "${url}"`)
        }
      }
    }
  }
}
