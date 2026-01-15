pragma Singleton

import Quickshell;

Singleton {
  function stripMeta(obj) {
    if (typeof obj !== "object") return {};

    let result = {};
    Object.keys(obj).forEach(key => {
      if (typeof obj[key] !== "function" && key !== "objectName") {
        result[key] = obj[key];
      }
    });
    return result;
  }
}
