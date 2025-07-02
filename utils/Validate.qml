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

  function invalidConf(reason: string) {
    Globals.configValid = Globals.ConfigState.Invalid;
    Globals.configInvalidReasons.push(reason);
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

  function v(result) {
    if (result) invalidConf(result);
  }

  function validateConfig() {
    const defaultConf = Globals.defaultConf;
    const userConf = Globals.userConf;
    const conf = Globals.conf;
    if (!userConf) {
      Globals.configValid = Globals.ConfigState.Valid
      return
    }

    v(validateObjKey(conf.colourScheme, Globals.schemes, "colourScheme"));

    v(validateObjKeyArray(conf.bar.left, Globals.vars.barModules, "bar.left"));
    v(validateObjKeyArray(conf.bar.centre, Globals.vars.barModules, "bar.centre"));
    v(validateObjKeyArray(conf.bar.right, Globals.vars.barModules, "bar.right"));
    v(validateBool(conf.bar.autohide, "bar.autohide"));
    v(validateBool(conf.bar.docked, "bar.docked"));
    v(validateBool(conf.bar.floatingModules, "bar.floatingModules"));
    v(validateBool(conf.bar.multiColourModules, "bar.multiColourModules"));
    v(validateBool(conf.bar.moduleOutlines, "bar.moduleOutlines"));
    v(validateBool(conf.bar.backgroundOutline, "bar.backgroundOutline"));
    v(validateInt(conf.bar.workspaceCount, 1, 20, "bar.workspaceCount"));
    v(validateInt(conf.bar.truncationLength, 0, 1000, "bar.truncationLength"));

    v(validateInt(conf.menu.width, 450, 5000, "menu.width"));
    v(validateBool(conf.menu.capitaliseUsername, "menu.capitaliseUsername"));
    v(validateBool(conf.menu.capitaliseHostname, "menu.capitaliseHostname"));
    v(validateBool(conf.menu.dimBackground, "menu.dimBackground"));
    v(validateBool(conf.menu.backgroundOutline, "menu.backgroundOutline"));
    v(validateBool(conf.menu.moduleOutlines, "menu.moduleOutlines"));

    v(validateString(conf.desktop.wallpaper, [], "desktop.wallpaper"));
    v(validateBool(conf.desktop.videoWallpaper, "desktop.videoWallpaper"));
    v(validateInt(conf.desktop.fadeSpeed, 0, 60000, "desktop.fadeSpeed"));
    v(validateString(conf.desktop.shader, [], "desktop.shader"));
    v(validateBool(conf.desktop.hideWallpaper, "desktop.hideWallpaper"));
    v(validateColor(conf.desktop.bgColour, "desktop.bgColour"));
    v(validateBool(conf.desktop.clockWidget, "desktop.clockWidget"));
    v(validateBool(conf.desktop.centreClockWidget, "desktop.centreClockWidget"));
    v(validateBool(conf.desktop.autohideWidgets, "desktop.autohideWidgets"));
    v(validateBool(conf.desktop.autohideBar, "desktop.autohideBar"));
    v(validateBool(conf.desktop.autohideCursor, "desktop.autohideCursor"));

    v(validateInt(conf.notifications.width, 200, 5000, "notifications.width"));
    v(validateInt(conf.notifications.defaultTimeout, 100, 60000, "notifications.defaultTimeout"));
    v(validateInt(conf.notifications.defaultCriticalTimeout, 100, 60000, "notifications.defaultCriticalTimeout"));
    v(validateBool(conf.notifications.sounds, "notifications.sounds"));
    v(validateString(conf.notifications.normalSound, [], "notifications.normalSound"));
    v(validateString(conf.notifications.criticalSound, [], "notifications.criticalSound"));
    v(validateInt(conf.notifications.dismissThreshold, 1, 99, "notifications.dismissThreshold"));

    v(validateString(conf.osd.backlightName, [], "osd.backlightName"));

    if (Globals.configValid !== Globals.ConfigState.Invalid) Globals.configValid = Globals.ConfigState.Valid;
  }

}

