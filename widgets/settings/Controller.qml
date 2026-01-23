pragma Singleton

import qs.singletons
import Quickshell;
import QtQuick;

Singleton {
  property string currentPage: "global";
  property var changedProperties: ({});
  property int changeCount: 0;
  // Incremented on every change - for listening for changes
  property int dataVersion: 0;

  function getVal(category: string, opt: string): var {
    if (
      typeof changedProperties[category] !== "undefined" &&
      typeof changedProperties[category][opt] !== "undefined"
    ) {
      return changedProperties[category][opt]
    } else {
      return Conf[category][opt]
    }
  }

  function changeVal(category: string, prop: string, value: var): void {
    if (!changedProperties[category]) changedProperties[category] = {};
    changedProperties[category][prop] = value;

    if (value.toString() === Conf[category][prop].toString()) {
      delete changedProperties[category][prop];
    }
    changeCount = getChangeCount();
    dataVersion++;
  }

  function getChangeCount() {
    let result = 0;
    for (const c in changedProperties) {
      result += Object.keys(changedProperties[c]).length;
    }
    return result;
  }

  function resetChanges() {
    changedProperties = {};
    changeCount = 0;
  }

  function apply() {
    if (changedProperties.length !== 0) {
      for (const category in changedProperties) {
        for (const option in changedProperties[category]) {
          const newValue = changedProperties[category][option];
          const callback = Conf.getMetadata(category, option)?.callback;

          Conf[category][option] = newValue;

          if (typeof callback === "function") {
            callback(newValue)
          }
        }
      }
      resetChanges();
    }
  }
}
