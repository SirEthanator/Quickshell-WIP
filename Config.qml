import QtCore;
import QtQuick;

Settings {
  id: root;

  required category;
  location: Globals.confPath;

  function getProperties() {
    const keys = Object.keys(root);

    // Get properties included in Settings
    const emptySettings = Qt.createQmlObject("import QtCore; Settings {}", root)
    const baseKeys = Object.keys(emptySettings);
    emptySettings.destroy();

    // Filter out properties included in Settings
    // This leaves us with only our own properties
    const res = keys.filter((key) =>
      baseKeys.indexOf(key) === -1
        && key.indexOf("Changed") === -1
        && typeof root[key] !== "function"
    );

    return res
  }

  function getMetadata(property: string): var {
    return Globals.conf.metadata[category][property]
  }
}

