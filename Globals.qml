pragma Singleton

import "components";
import "utils" as Utils;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  // =======================
  // ==== Configuration ====
  // =======================

  readonly property url confPath: Qt.resolvedUrl("./config.conf");

  property var conf: QtObject {
    function getCategories() {
      return Object.values(root.conf).filter((obj) =>
        !!obj && obj.toString().indexOf("Config_QMLTYPE") !== -1
      );
    }

    function getCategoryKeys() {
      let result = [];
      let allKeys = Object.keys(root.conf);
      for (let i=0; i < allKeys.length; i++) {
        if (root.conf[allKeys[i]].toString().indexOf("Config_QMLTYPE") !== -1) result.push(allKeys[i]);
      }
      return result
    }

    readonly property var metadata: ({
      "Global": {
        "colourScheme": {
          "title": "Colour Scheme",
          "description": "Defines what colour scheme should be used throughout the system.",
          "type": "string",
          "options": root.schemes,
          "callback": (val) => {
            root.switchTheme(val)
          }
        }
      },

      "Bar": {
        "left": {
          "title": "Left Modules",
          "description": "Defines what modules to show on the left of the bar (LTR).",
          "type": "list<string>",
          "options": root.vars.barModules
        },
        "centre": {
          "title": "Centre Modules",
          "description": "Defines what modules to show in the middle of the bar (LTR).",
          "type": "list<string>",
          "options": root.vars.barModules
        },
        "right": {
          "title": "Right Modules",
          "description": "Defines what modules to show on the right of the bar (LTR).",
          "type": "list<string>",
          "options": root.vars.barModules
        },
        "autohide": {
          "title": "Autohide",
          "description": "Defines whether the bar should automatically hide until the top edge of the screen is hovered.",
          "type": "bool"
        },
        "docked": {
          "title": "Docked",
          "description": "Defines whether the bar should touch the screen edges.",
          "type": "bool"
        },
        "floatingModules": {
          "title": "Floating Modules",
          "description": "Defines whether the bar's background should be shown.",
          "type": "bool"
        },
        "multiColourModules": {
          "title": "Multi-colour Modules",
          "description": "Defines whether the icons should have different coloured backgrounds.",
          "type": "bool"
        },
        "moduleOutlines": {
          "title": "Module Outlines",
          "description": "Defines whether modules should have an outline around them.",
          "type": "bool"
        },
        "backgroundOutline": {
          "title": "Background Outline",
          "description": "Defines whether the bar's background should have an outline around it.",
          "type": "bool"
        },
        "workspaceCount": {
          "title": "Workspace Count",
          "description": "Defines how many workspaces should be shown on the workspace module.",
          "type": "int",
          "max": 20,
          "min": 1
        },
        "truncationLength": {
          "title": "Truncation Length",
          "description": "Defines the maximum length for modules with long text.",
          "type": "int",
          "max": 1000,
          "min": 0
        }
      },

      "Menu": {
        "dashModules": {
          "title": "Dashboard Modules",
          "description": "Defines which modules should be shown on the dashboard.",
          "type": "list<string>",
          "options": root.vars.dashModules
        },
        "capitaliseUsername": {
          "title": "Capitalise Username",
          "description": "Defines whether the user's username should be capitalised.",
          "type": "bool"
        },
        "capitaliseHostname": {
          "title": "Capitalise Hostname",
          "description": "Defines whether the system's hostname should be capitalised.",
          "type": "bool"
        },
        "dimBackground": {
          "title": "Dim Background",
          "description": "Defines whether the background behind the menu should be dimmed.",
          "type": "bool"
        },
        "backgroundOutline": {
          "title": "Background Outline",
          "description": "Defines whether the menu's background should have an outline around it.",
          "type": "bool"
        },
        "moduleOutlines": {
          "title": "Module Outlines",
          "description": "Defines whether dashboard modules and launcher items should have outlines around them.",
          "type": "bool"
        },
        "width": {
          "title": "Width",
          "description": "Defines how wide the menu should be (px).",
          "type": "int",
          "max": 5000,
          "min": 450
        }
      },

      "Desktop": {
        "wallpaper": {
          "title": "Wallpaper",
          "description": "Defines the path to the wallpaper to show. Setting it to an empty string will use the default.",
          "type": "path",
          "allowEmpty": true
        },
        "videoWallpaper": {
          "title": "Video Wallpaper",
          "description": "Defines whether the wallpaper specified in the 'wallpaper' option is a video.",
          "type": "bool"
        },
        "fadeSpeed": {
          "title": "Fade Duration",
          "description": "Defines how long the wallpaper should fade in for when the shell is launched (ms). Set to 0 to disable.",
          "type": "int",
          "max": 60000,
          "min": 0
        },
        "shader": {
          "title": "Shader",
          "description": "Defines the path to the shader to show. This is displayed on top of the wallpaper. Set to an empty string to disable.",
          "type": "string"
        },
        "hideWallpaper": {
          "title": "Hide Wallpaper",
          "description": "Defines whether the wallpaper should be hidden.",
          "type": "bool"
        },
        "bgColour": {
          "title": "Background Colour",
          "description": "Defines the colour that should be shown behind everything. If 'hideWallpaper' is true, this colour will be displayed. It is also useful for shaders which look better with a solid colour behind them.",
          "type": "bool"
        },
        "clockWidget": {
          "title": "Clock Widget",
          "description": "Defines whether the clock widget should be shown.",
          "type": "bool"
        },
        "centreClockWidget": {
          "title": "Centre Clock Widget",
          "description": "Defines whether the clock widget should be vertically centred.",
          "type": "bool"
        },
        "autohideWidgets": {
          "title": "Autohide Widgets",
          "description": "Defines whether widgets should be hidden after a delay when there is no activity on the desktop.",
          "type": "bool"
        },
        "autohideBar": {
          "title": "Autohide Bar",
          "description": "Defines whether the bar should be hidden after a delay when there is no activity on the desktop. This will only hide the bar when the desktop has focus.",
          "type": "bool"
        },
        "autohideCursor": {
          "title": "Autohide Cursor",
          "description": "Defines whether the cursor should be hidden after a delay when there is no activity on the desktop. This will only hide the cursor when the desktop has focus.",
          "type": "bool"
        }
      },

      "Notifications": {
        "width": {
          "title": "Width",
          "description": "Defines the width of notifications (px).",
          "type": "int",
          "max": 5000,
          "min": 200
        },
        "defaultTimeout": {
          "title": "Default Timeout",
          "description": "Defines the default timeout for notifications when the sender does not specify one (ms).",
          "type": "int",
          "max": 60000,
          "min": 100
        },
        "defaultCriticalTimeout": {
          "title": "Default Critical Timeout",
          "description": "Defines the default timeout for critical notifications when the sender does not specify one (ms).",
          "type": "int",
          "max": 60000,
          "min": 100
        },
        "sounds": {
          "title": "Sounds",
          "description": "Defines whether to play a sound on incoming notifications.",
          "type": "bool"
        },
        "normalSound": {
          "title": "Normal Sound",
          "description": "Defines the path to the sound to play for non-critical notifications.",
          "type": "path"
        },
        "criticalSound": {
          "title": "Critical Sound",
          "description": "Defines the path to the sound to play for critical notifications.",
          "type": "path"
        },
        "dismissThreshold": {
          "title": "Dismiss Threshold",
          "description": "Defines what percentage of 'width' notifications must be dragged to dismiss them.",
          "type": "int",
          "max": 99,
          "min": 1
        }
      },

      "Lock": {
        "dimBackground": {
          "title": "Dim Background",
          "description": "Defines whether the background should be dimmed.",
          "type": "bool"
        },
        "contentOutline": {
          "title": "Content Outline",
          "description": "Defines whether the rectangle containing the clock, input, etc. should have an outline around it.",
          "type": "bool"
        }
      },

      "OSD": {
        "backlightName": {
          "title": "Backlight Name",
          "description": "Defines the name of the display's backlight. This is used to get the path of the backlight: `/sys/class/backlight/<backlightName>`",
          "type": "string"
        }
      }
    })

    property Config global: Config {
      category: "Global";

      property string colourScheme: "everforest";
    }

    property Config bar: Config {
      category: "Bar";

      property list<string> left: [
        "menu",
        "workspaces",
        "activeWindow"
      ];
      property list<string> centre: ["dateAndTime"];
      property list<string> right: [
        "tray",
        "network",
        "battery",
        "media",
        "volume"
      ];
      property bool autohide: false;
      property bool docked: false;
      property bool floatingModules: false;
      property bool multiColourModules: false;
      property bool moduleOutlines: true;
      property bool backgroundOutline: true;
      property int workspaceCount: 10;
      property int truncationLength: 60;
    }

    property Config menu: Config {
      category: "Menu";

      property list<string> dashModules: [
        "userInfo",
        "sysStats",
        "notifCentre"
      ];
      property bool capitaliseUsername: true;
      property bool capitaliseHostname: false;
      property bool dimBackground: true;
      property bool backgroundOutline: true;
      property bool moduleOutlines: true;
      property int width: 600;
    }

    property Config desktop: Config {
      category: "Desktop";

      property string wallpaper: "";
      property bool videoWallpaper: false;
      property int fadeSpeed: 2000;
      property string shader: "";
      property bool hideWallpaper: false;
      property color bgColour: "black";
      property bool clockWidget: false;
      property bool centreClockWidget: false;
      property bool autohideWidgets: false;
      property bool autohideBar: false;
      property bool autohideCursor: false;
    }

    property Config notifications: Config {
      category: "Notifications";

      property int width: 500;
      property int defaultTimeout: 5000;
      property int defaultCriticalTimeout: 8000;
      property bool sounds: true;
      property string normalSound: "/usr/share/sounds/ocean/stereo/message-new-instant.oga";
      property string criticalSound: "/usr/share/sounds/ocean/stereo/dialog-error-critical.oga";
      property int dismissThreshold: 30;
    }

    property Config lock: Config {
      category: "Lock";

      property bool dimBackground: false;
      property bool contentOutline: true;
    }

    property Config osd: Config {
      category: "OSD";

      property string backlightName: "";
    }
  }

  readonly property Scheme colours: schemes[conf.global.colourScheme];

  function setConf(property: list<string>, value, validate): string {
    const validationResult = (typeof validate === "function") ? validate() : undefined;
    if (validationResult) return validationResult;
    if (!property || property.length === 0) return "";

    let currentObj = conf;

    // Loop through the property
    for (let i=0; i < property.length; i++) {
      const propName = property[i];

      if (!currentObj.hasOwnProperty(propName)) {
        console.warn(`setConf: Invalid property: ${property.join(".")}`);
        return "";
      }

      if (i === property.length - 1) {  // Check if final property
        currentObj[propName] = value;
      } else {
        currentObj = currentObj[propName];
      }
    }
    return ""
  }

  function setColours(scheme: string): string {
    const validate = () => Utils.Validate.validateObjKey(scheme, schemes, "Failed to set colour scheme");
    return setConf(["global", "colourScheme"], scheme, validate);
  }

  function setWallpaper(path: string): void {
    setConf(['desktop', 'wallpaper'], path);
  }

  function switchTheme(scheme: string): string {
    const validationResult = Utils.Validate.validateObjKey(scheme, schemes, "Failed to set colour scheme");
    if (validationResult) return validationResult;
    states.themeSwitchInProgress = true;
    states.themeOverlayOpen = true;
    setTheme.scheme = scheme;
    setTheme.running = true;
    return "";
  }

  Process {
    id: setTheme;

    property string scheme: "";
    command: ["sh", "-c", `${Quickshell.env("HOME")}/Scripts/SetTheme ${scheme} --noconfirm --noqsreload`];
    stdout: SplitParser {
      onRead: data => root.states.themeSwitchingState = data;
    }
    onExited: {
      // Wait a little while before closing so completion message can be read
      Utils.Timeout.setTimeout(() => {
        root.states.themeSwitchInProgress = false;
      }, 1000);
    }
  }

  // ===================
  // ==== Variables ====
  // ===================

  readonly property var vars: QtObject {
    id: vars

    property var barModules: ({
      workspaces: {
        title: "Workspaces",
        url: "Workspaces.qml",
        props: ["screen"]
      },
      tray: {
        title: "System Tray",
        url: "SysTray.qml",
        props: ["window"]
      },
      menu: {
        title: "Menu Button",
        url: "MenuBtn.qml",
      },
      activeWindow: {
        title: "Active Window",
        url: "ActiveWindow.qml"
      },
      dateAndTime: {
        title: "Date & Time",
        url: "DateAndTime.qml"
      },
      network: {
        title: "Network",
        url: "Network.qml"
      },
      battery: {
        title: "Battery",
        url: "Battery.qml"
      },
      media: {
        title: "Media",
        url: "Media.qml"
      },
      volume: {
        title: "Volume",
        url: "Volume.qml"
      }
    });

    property var dashModules: ({
      userInfo: {
        title: "User Info & Power",
        url: "userinfo/Index.qml"
      },
      sysStats: {
        title: "System Stats",
        url: "sysstats/Index.qml"
      },
      notifCentre: {
        title: "Notification Centre",
        url: "NotifCentre.qml"
      },
      tray: {
        title: "System Tray",
        url: "SysTray.qml"
      }
    });

    property int gap: Utils.SysInfo.gap;  // Size of Hyprland gap
    property int gapLarge: vars.gap + 8;

    property int br: 6;  // Border Radius
    property int brSmall: 2;

    property real outlineSize: 1.5;

    property string fontFamily: "0xProto";
    property int mainFontSize: 16;
    property int largeFontSize: 64;
    property int xlFontSize: 150;
    property int headingFontSize: 34;
    property int smallHeadingFontSize: 22;
    property int mediumHeadingFontSize: 28;

    // This results in the modules' top and bottom padding matching paddingModule - relies on icons being the tallest items
    // Changes due to configuration are handled in Bar/Index
    property int barHeight: vars.moduleIconSize + vars.paddingModule + vars.paddingBar*2 + vars.outlineSize*2;
    property int paddingBar: 6;
    // Note that paddingModule will not directly affect the top and bottom padding. The top and bottom padding is based on the bar's height.
    property int paddingModule: 8;
    property int marginModule: 8;
    property int moduleIconSize: 22;
    property int wsSize: 7;

    property int paddingWindow: 24;

    property int paddingCard: 20;
    property int marginCardSmall: 6;
    property int marginCard: 10;

    property int paddingButton: 10;
    property int paddingButtonIcon: 8;
    property int spacingButtonGroup: 3;

    property int longAnimLen: 500;
    property int animLen: 350;
    property int transitionLen: 250;
    property int shortTransitionLen: 150;

    property int clockWidgetSpacing: 8;
    property int clockWidgetTopMargin: 100;

    property int notifPopupSpacing: 10;
    property int paddingNotif: paddingCard;
    property int notifInnerSpacing: 10;

    property int largeIconSize: 34;
    property int extraLargeIconSize: 90;

    property color bgDimmedColour: "#4D000000";
    property real disabledOpacity: 0.5;
  }

  // =================
  // ==== Schemes ====
  // =================

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine });

  readonly property Scheme everforest: Scheme {
    id: everforest

    title: "Everforest";

    accent: "#A7C080";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#D3C6AA";
    bg: "#272E33";
    bgLight: "#2E383C";
    bgHover: "#414B50";
    bgAccent: "#3C4841";
    bgRed: "#4C3743";
    outline: bgAccent;
    grey: "#7A8478";
    wsInactive: bgHover;
    red: "#E67E80";
    warning: "#DBBC7F";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

    workspaces: accent;
    activeWindow: "#7FBBB3";
    dateAndTime: "#DBBC7F";
    volume: "#E69875";
    network: "#D699B6";
    media: "#83C092";

    battery: "#A7C080";
    batteryCharging: "#A7C080";
    batteryMed: "#DBBC7F";
    batteryLow: red;
  }

  readonly property Scheme catMocha: Scheme {
    id: catMocha

    title: "Catppuccin Mocha";

    accent: "#B4BEFE";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#CDD6F4";
    bg: "#1E1E2E";
    bgLight: "#313244";
    bgHover: "#45475A";
    bgAccent: "#3F4359";
    bgRed: "#7A4654";
    outline: bgAccent;
    grey: "#6C7086";
    wsInactive: bgHover;
    red: "#F38BA8";
    warning: "#F9E2AF";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

    workspaces: accent;
    activeWindow: "#89B4FA";
    dateAndTime: "#F9E2AF";
    volume: "#FAB387";
    network: "#CBA6F7";
    media: "#94E2D5";

    battery: "#A6E3A1";
    batteryCharging: "#A6E3A1";
    batteryMed: "#F9E2AF";
    batteryLow: red;
  }

  readonly property Scheme rosePine: Scheme {
    id: rosePine

    title: "Rose Pine";

    accent: "#9CCFD8";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#E0DEF4";
    bg: "#1F1D2E";
    bgLight: "#26233A";
    bgHover: "#403D52";
    bgAccent: "#37484C";
    bgRed: "#763849";
    outline: bgAccent;
    grey: "#6E6A86";
    wsInactive: bgHover;
    red: "#EB6F92";
    warning: "#F6C177";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

    workspaces: accent;
    activeWindow: "#31748F";
    dateAndTime: "#F6C177";
    volume: "#C4A7E7";
    network: "#EBBCBA";
    media: "#EB6F92";

    battery: "#31748F";
    batteryCharging: "#31748F";
    batteryMed: "#F6C177";
    batteryLow: red;
  }

  function alpha(color: color, opacity: real): color {
    return Qt.rgba(color.r, color.b, color.g, opacity)
  }

  // ================
  // ==== States ====
  // ================

  signal launchConfMenu;

  PersistentProperties {
    id: persist

    property bool menuOpen: false;
    property bool barHidden: false;
    property bool screensaverActive: false;
    property bool themeSwitchInProgress: false;
    property bool themeOverlayOpen: false;
    property string themeSwitchingState: "";
  }

  property alias states: persist;
}

