pragma ComponentBehavior: Bound

import qs.singletons
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root
  required property var window;
  required property var screen;
  readonly property var allModules: Consts.barModules;
  required property var modules;

  anchors {
    bottom: parent.bottom
    top: parent.top
  }
  spacing: Consts.marginModule;

  Repeater {
    model: root.modules;
    delegate: Loader {
      id: loader
      required property string modelData;
      readonly property string url: `./modules/${root.allModules[modelData].moduleName}.qml`;
      readonly property list<string> passedProps: root.allModules[modelData].props;
      readonly property var props: {
        let result = {};
        if (passedProps.indexOf("screen") !== -1) {
          result.screen = root.screen
        }
        if (passedProps.indexOf("window") !== -1) {
          result.window = root.window
        }
        return result
      };

      Layout.fillHeight: true;
      visible: item?.show ?? false;

      Component.onCompleted: {
        setSource(url, props);
      }

      onStatusChanged: {
        if (status === Loader.Error) {
          active = false;
          console.error(`Failed to load bar module from: "${url}"`)
        }
      }
    }
  }
}
