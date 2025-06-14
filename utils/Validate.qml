pragma Singleton

import "root:/"
import Quickshell;
import QtQuick;

Singleton {
  function error(msg: string) {
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
    if (reason) error(`${errMsg}: ${reason}`);
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
    if (reason) error(`${errMsg}: ${reason}`);
  }

  function validateColor(val, errMsg: string) {
    try { Qt.color(val) }
    catch (e) { error(`${errMsg}: Expected color, found ${typeof val}: ${val}`) }
  }

  function validateObjKey(val, opts: QtObject, errMsg: string) {
    let reason;
    if (!(val in opts)) reason = `Invalid option: ${val}`;
    if (typeof val !== "string") reason = `Expected string, found ${typeof val}: ${val}`;
    if (reason) error(`${errMsg}: ${reason}`)
  }

  function validateBool(val, errMsg: string) {
    if (typeof val !== "boolean")
      error(`${errMsg}: Expected boolean, found ${typeof val}: ${val}`);
  }

  function validateStringArray(val, opts: list<string>, errMsg: string) {
    if (Array.isArray(val)) {
      for (let i=0; i < val.length; i++) {
        validateString(val[i], opts, errMsg)
      }
    }
  }

  function validateObjKeyArray(val, opts: QtObject, errMsg: string) {
    if (Array.isArray(val)) {
      for (let i=0; i < val.length; i++) {
        validateObjKey(val[i], opts, errMsg)
      }
    }
  }

  function validateConfig() {
    const defaultConf = Globals.defaultConf;
    const userConf = Globals.userConf;
    const conf = Globals.conf;
    if (!userConf) return;

    validateObjKey(conf.colourScheme, Globals.schemes, "colourScheme");

    validateObjKeyArray(conf.bar.left, Globals.vars.barModules, "bar.left");
    validateObjKeyArray(conf.bar.centre, Globals.vars.barModules, "bar.centre");
    validateObjKeyArray(conf.bar.right, Globals.vars.barModules, "bar.right");
    validateBool(conf.bar.autohide, "bar.autohide");
    validateBool(conf.bar.docked, "bar.docked");
    validateBool(conf.bar.floatingModules, "bar.floatingModules");
    validateBool(conf.bar.multiColourModules, "bar.multiColourModules");
    validateBool(conf.bar.moduleOutlines, "bar.moduleOutlines");
    validateBool(conf.bar.backgroundOutline, "bar.backgroundOutline");
    validateInt(conf.bar.workspaceCount, 1, 20, "bar.workspaceCount");
    validateInt(conf.bar.truncationLength, 0, 1000, "bar.truncationLength");

    validateInt(conf.menu.width, 450, 5000, "menu.width");
    validateBool(conf.menu.capitaliseUsername, "menu.capitaliseUsername");
    validateBool(conf.menu.capitaliseHostname, "menu.capitaliseHostname");

    validateString(conf.desktop.wallpaper, [], "desktop.wallpaper");
    validateBool(conf.desktop.videoWallpaper, "desktop.videoWallpaper");
    validateInt(conf.desktop.fadeSpeed, 0, 60000, "desktop.fadeSpeed");
    validateString(conf.desktop.shader, [], "desktop.shader");
    validateBool(conf.desktop.hideWallpaper, "desktop.hideWallpaper");
    validateColor(conf.desktop.bgColour, "desktop.bgColour");
    validateBool(conf.desktop.clockWidget, "desktop.clockWidget");
    validateBool(conf.desktop.centreClockWidget, "desktop.centreClockWidget");
    validateBool(conf.desktop.autohideWidgets, "desktop.autohideWidgets");
    validateBool(conf.desktop.autohideBar, "desktop.autohideBar");
    validateBool(conf.desktop.autohideCursor, "desktop.autohideCursor");

    validateInt(conf.notifications.width, 200, 5000, "notifications.width");
    validateInt(conf.notifications.defaultTimeout, 100, 60000, "notifications.defaultTimeout");
    validateInt(conf.notifications.defaultCriticalTimeout, 100, 60000, "notifications.defaultCriticalTimeout");
    validateBool(conf.notifications.sounds, "notifications.sounds");
    validateString(conf.notifications.normalSound, [], "notifications.normalSound");
    validateString(conf.notifications.criticalSound, [], "notifications.criticalSound");
    validateInt(conf.notifications.dismissThreshold, 1, 99, "notifications.dismissThreshold");
  }

}

