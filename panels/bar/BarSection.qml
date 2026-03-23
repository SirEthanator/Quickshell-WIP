pragma ComponentBehavior: Bound

import qs.singletons
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root
  required property var modules;

  anchors {
    bottom: parent.bottom
    top: parent.top
  }
  spacing: Consts.paddingSmall;

  function creationError(component, url) {
    console.error(`Failed to load bar module from: ${url}: ${component.errorString()}`);
  }

  function finishCreation(component, url) {
    if (component.status === Component.Ready) {
      component.createObject(root, {});
    } else {
      creationError(component, url);
    }
  }

  Component.onCompleted: {
    const modules = root.modules;
    const allModules = Consts.barModules.toStripped();

    for (let i=0; i < modules.length; i++) {
      const m = allModules[modules[i]];
      const url = `./modules/${m.moduleName}.qml`;

      const component = Qt.createComponent(url);
      if (component.status === Component.Ready) {
        finishCreation(component, url);
      } else if (component.status === Component.Error || component.status === Component.Null) {
        creationError(component, url);
      } else {
        component.statusChanged.connect(() => finishCreation(component, url));
      }
    }
  }
}
