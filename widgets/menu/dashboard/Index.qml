import qs
import QtQuick;
import QtQuick.Layouts;

// sysstats and userinfo must be imported to avoid an odd error,
// where components in sysstats and userinfo are not recognised
// by components in the same dir. e.g. it says SysStatMonitor is not a type.
import "sysstats";
import "userinfo";

ColumnLayout {
  id: root;
  spacing: Globals.vars.paddingWindow;

  Component.onCompleted: () => {
    const modules = Conf.menu.dashModules;
    const allModules = Globals.vars.dashModules;

    for (let i=0; i < modules.length; i++) {
      const url = Qt.resolvedUrl(`./${allModules[modules[i]].url}`);
      const component = Qt.createComponent(url);

      if (component.status === Component.Ready) {
        finishCreation(component, url);
      } else if (component.status === Component.Error) {
        console.error(`Failed to load dashboard module from: ${url}: ${component.errorString()}`);
      } else {
        component.statusChanged.connect(() => finishCreation(component, url));
      }
    }
  }

  function finishCreation(component, url: string) {
    if (component.status === Component.Ready) {
      component.createObject(root, {});
    } else if (component.status === Component.Error) {
      console.error(`Failed to load dashboard module from: ${url}: ${component.errorString()}`);
    }
  }
}

