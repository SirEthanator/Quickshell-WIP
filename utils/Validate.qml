pragma Singleton

import "root:/"
import Quickshell;
import QtQuick;

Singleton {
  function exit() {
    Qt.callLater(Qt.quit);
  }
  function fatalError(msg: string) {
    Qt.callLater(() => {
      console.error(msg);
      Qt.quit();
    });
  }

  function validateInt(val, min: int, max: int, errMsg: string) {
    let reason;
    if (typeof val !== "number") reason = `Expected integer, found ${typeof val}: ${val}`;
    if (val % 1 !== 0) reason = `Expected integer, found real: ${val}`;
    if (val < min || val > max) reason = `Expected integer between ${min} and ${max}, found ${val}`;
    if (reason) return `${errMsg}: ${reason}`;
    return ""
  }

  function validateString(val, opts: list<string>, errMsg: string) {
    let valid = false;
    let reason;
    for (let i=0; i < opts.length; i++) {
      if (opts[i] === val) valid = true;
    }
    // If an empty array is passed, any string is valid.
    if (opts.length < 1 || !opts) valid = true;
    if (!valid) reason = `Invalid option: ${val}`;
    if (typeof val !== "string") reason = `Expected string, found ${typeof val}: ${val}`;
    if (reason) return `${errMsg}: ${reason}`;
    return ""
  }

  function validateColor(val, errMsg: string) {
    try { Qt.color(val) }
    catch (e) { return `${errMsg}: Expected color, found ${typeof val}: ${val}` }
    return ""
  }

  function validateObjKey(val, opts: QtObject, errMsg: string) {
    let reason;
    if (!(val in opts)) reason = `Invalid option: ${val}`;
    if (typeof val !== "string") reason = `Expected string, found ${typeof val}: ${val}`;
    if (reason) return `${errMsg}: ${reason}`;
    return ""
  }

  function validateBool(val, errMsg: string) {
    if (typeof val !== "boolean")
      return `${errMsg}: Expected boolean, found ${typeof val}: ${val}`;
    return ""
  }

  function validateStringArray(val, opts: list<string>, errMsg: string) {
    if (Array.isArray(val)) {
      for (let i=0; i < val.length; i++) {
        const result = validateString(val[i], opts, errMsg);
        if (result) return result
      }
      return ""
    }
  }

  function validateObjKeyArray(val, opts: QtObject, errMsg: string) {
    if (Array.isArray(val)) {
      for (let i=0; i < val.length; i++) {
        const result = validateObjKey(val[i], opts, errMsg);
        if (result) return result
      }
      return ""
    }
  }
}

