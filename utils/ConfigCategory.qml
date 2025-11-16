import qs
import QtCore;
import QtQuick;

Settings {
  id: root;

  required category;
  location: Conf.confPath;

  function getProperties() {
    const keys = Object.keys(root);

    // TODO: Only get base properties once

    // Get properties included in Settings
    const emptySettings = Qt.createQmlObject("import QtCore; Settings {}", root)
    const baseKeys = Object.keys(emptySettings);
    emptySettings.destroy();

    // Filter out properties included in Settings
    // This leaves us with only our own properties
    const res = keys.filter((key) =>
      baseKeys.indexOf(key) === -1
        && key.indexOf("Changed") === -1  // Remove xChanged signals
        && typeof root[key] !== "function"
    );

    return res
  }
}

